-- 1) Data Cleaning
-- Purpose: Ensure data quality by removing incomplete or redundant information.

-- Remove Rows with Missing Values:
-- This step deletes any rows where critical stock data is missing (like price or volume).
DELETE FROM dbo.combined_stock_data
WHERE [Open] IS NULL
   OR [High] IS NULL
   OR [Low] IS NULL
   OR [Close] IS NULL
   OR [Adj_Close] IS NULL
   OR [Volume] IS NULL
   OR [Ticker] IS NULL
   OR [Date] IS NULL;

-- Check for Duplicate Entries:
-- This step identifies and deletes duplicate rows, ensuring there are no redundant records for the same stock on the same day.
WITH DuplicateRows AS (
    SELECT Date, Ticker
    FROM dbo.combined_stock_data
    GROUP BY Date, Ticker
    HAVING COUNT(*) > 1
)
DELETE c
FROM dbo.combined_stock_data c
JOIN DuplicateRows d
ON c.Date = d.Date
AND c.Ticker = d.Ticker;

-- Merge Close Data Based on Date:
-- Consolidate the closing prices from different stocks (AMEX, VISA, and Mastercard) into a temporary table for easier comparison.
DROP TABLE IF EXISTS #TempStockData
DROP TABLE IF EXISTS #TempStockData
SELECT 
    a.Date,
    a.Adj_Close AS AMEX_Close,
    v.Adj_Close AS VISA_Close,
    m.Adj_Close AS MA_Close
INTO #TempStockData
FROM AXP_Stock_Data a
JOIN V_Stock_Data v ON a.Date = v.Date
JOIN MA_Stock_Data m ON a.Date = m.Date
ORDER BY a.Date;

SELECT *
FROM #TempStockData


-- 2) Feature Engineering
-- Purpose: Create new insights from existing data, such as daily stock returns and price differences.

-- Calculate Daily Return:
-- Adds a new column to track daily return for each stock, which is the percentage change in stock price from the previous day.
ALTER TABLE dbo.combined_stock_data
ADD DailyReturn FLOAT;

WITH PreviousData AS (
    SELECT 
        [Date],
        Ticker,
        [Close] AS Current_Close,
        LAG([Close], 1) OVER (PARTITION BY Ticker ORDER BY [Date]) AS Prev_Close
    FROM dbo.combined_stock_data
)
UPDATE c
SET c.DailyReturn = ((p.Current_Close - p.Prev_Close) / p.Prev_Close)
FROM dbo.combined_stock_data c
JOIN PreviousData p
ON c.Date = p.Date AND c.Ticker = p.Ticker;

-- Calculate Cumulative Returns:
-- Adds a column that tracks the cumulative return, which is the sum of daily returns over time for each stock.
ALTER TABLE dbo.combined_stock_data
ADD CumulativeReturn FLOAT;

WITH DailyReturns AS (
    SELECT 
        [Date],
        Ticker,
        DailyReturn,
        SUM(DailyReturn) OVER (PARTITION BY Ticker ORDER BY [Date]) AS CumulativeReturn
    FROM dbo.combined_stock_data
)
UPDATE c
SET c.CumulativeReturn = d.CumulativeReturn
FROM dbo.combined_stock_data c
JOIN DailyReturns d
ON c.Date = d.Date AND c.Ticker = d.Ticker;

-- Calculate Monthly and Yearly Returns:
-- Summarizes stock returns by month and year for each stock, useful for longer-term performance analysis.
-- Monthly Return
SELECT 
    Ticker,
    YEAR([Date]) AS Year,
    MONTH([Date]) AS Month,
    SUM(DailyReturn) * 100 AS Monthly_Return_Percentage,
    CONCAT(YEAR([Date]), '-', RIGHT(CONCAT('0', MONTH([Date])), 2), '-01') AS [Date]
FROM dbo.combined_stock_data
GROUP BY Ticker, YEAR([Date]), MONTH([Date])
ORDER BY Ticker, Year, Month;

-- Yearly Return
SELECT 
    Ticker,
    YEAR([Date]) AS Year,
    SUM(DailyReturn) * 100 AS Yearly_Return_Percentage
FROM dbo.combined_stock_data
GROUP BY Ticker, YEAR([Date])
ORDER BY Ticker, Year;

-- Calculate Price Differences:
-- Tracks the daily difference in stock price, which can help spot significant price changes (spikes or drops).
ALTER TABLE dbo.combined_stock_data
ADD PriceDiff FLOAT;

WITH PreviousData AS (
    SELECT 
        [Date],
        Ticker,
        [Close],
        LAG([Close], 1) OVER (PARTITION BY Ticker ORDER BY [Date] DESC) AS Prev_Close
    FROM dbo.combined_stock_data
)
UPDATE c
SET c.PriceDiff = (p.[Close] - p.Prev_Close)
FROM dbo.combined_stock_data c
JOIN PreviousData p
ON c.Date = p.Date AND c.Ticker = p.Ticker;


-- 3) Moving Averages
-- Purpose: Calculate key moving averages (SMA) to identify stock trends.

-- Calculate Simple Moving Averages (SMA 20, 50, 200):
-- Moving averages are used to smooth out price data and reveal long-term trends.
DROP TABLE IF EXISTS Stock_SMA_Calculations
CREATE TABLE dbo.Stock_SMA_Calculations (
    [Date] DATE,
    Ticker VARCHAR(10),
    Adj_Close FLOAT,
    SMA_20 FLOAT,
    SMA_50 FLOAT,
    SMA_200 FLOAT
);

WITH SMA_Calculation AS (
    SELECT 
        [Date],
        Ticker,
        [Adj_Close],
        AVG([Adj_Close]) OVER (PARTITION BY Ticker ORDER BY [Date] 
                           ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS SMA_20,
        AVG([Adj_Close]) OVER (PARTITION BY Ticker ORDER BY [Date] 
                           ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS SMA_50,
        AVG([Adj_Close]) OVER (PARTITION BY Ticker ORDER BY [Date] 
                           ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS SMA_200
    FROM dbo.combined_stock_data
)
INSERT INTO dbo.Stock_SMA_Calculations ([Date], Ticker, Adj_Close, SMA_20, SMA_50, SMA_200)
SELECT 
    [Date],
    Ticker,
    [Adj_Close],
    SMA_20,
    SMA_50,
    SMA_200
FROM SMA_Calculation
ORDER BY [Date], Ticker;

SELECT *
FROM dbo.Stock_SMA_Calculations

-- Trend Analysis with SMA:
-- Identifies important crossovers between short-term (SMA 50) and long-term (SMA 200) averages to signal trends:
-- Golden Cross: Indicates a potential bullish trend.
-- Death Cross: Indicates a potential bearish trend.
WITH Trend_Analysis AS (
    SELECT 
        [Date],
        Ticker,
        SMA_50,
        SMA_200,
        LAG(SMA_50, 1) OVER (PARTITION BY Ticker ORDER BY [Date]) AS Prev_SMA_50,
        LAG(SMA_200, 1) OVER (PARTITION BY Ticker ORDER BY [Date]) AS Prev_SMA_200
    FROM dbo.Stock_SMA_Calculations
)
SELECT 
    [Date],
    Ticker,
    CASE 
        WHEN Prev_SMA_50 <= Prev_SMA_200 AND SMA_50 > SMA_200 THEN 'Golden Cross' -- Indicates Bullish Trend
        WHEN Prev_SMA_50 >= Prev_SMA_200 AND SMA_50 < SMA_200 THEN 'Death Cross'  -- Indicates Bearish Trend
        ELSE 'No Cross'
    END AS Trend_Signal
FROM Trend_Analysis
ORDER BY Ticker, [Date];


-- 4) Stock Performance Comparison
-- Purpose: Measure and compare key risk-return metrics for the stocks.

-- Calculate Volatility:
-- Determines the level of risk (volatility) for each stock by calculating the standard deviation of daily returns.
DROP TABLE IF EXISTS #TempAnnualizedVolatility;

WITH Volatility AS (
    SELECT
        Ticker,
        STDEV(DailyReturn) * SQRT(252) AS Annualized_Volatility  -- 252 trading days per year
    FROM dbo.combined_stock_data
    GROUP BY Ticker
)
SELECT * INTO #TempAnnualizedVolatility FROM Volatility;

SELECT * 
FROM #TempAnnualizedVolatility

-- Calculate Sharpe Ratio:
-- Measures risk-adjusted return by comparing returns to the level of volatility (higher is better).
DROP TABLE IF EXISTS #TempAnnualizedSharpe;

WITH SharpeRatio AS (
    SELECT
        Ticker,
        AVG(DailyReturn) - (0.0374 / 252) AS Excess_Return,
        STDEV(DailyReturn) AS Daily_Volatility
    FROM combined_stock_data
    GROUP BY Ticker
),
AnnualizedSharpe AS (
    SELECT
        Ticker,
        (Excess_Return / Daily_Volatility) * SQRT(252) AS Sharpe_Ratio
    FROM SharpeRatio
)

SELECT * INTO #TempAnnualizedSharpe FROM AnnualizedSharpe;

SELECT * 
FROM #TempAnnualizedSharpe

-- Calculate Sortino Ratio:
-- Similar to Sharpe but focuses on downside risk, making it more sensitive to losses.
DROP TABLE IF EXISTS #TempAnnualizedSortino;

WITH SortinoMetrics AS (
    SELECT 
        Ticker,
        AVG(DailyReturn) AS Average_Return,
        STDEV(CASE WHEN DailyReturn < 0 THEN DailyReturn END) AS Downside_Deviation
    FROM combined_stock_data
    GROUP BY Ticker
),
AnnualizedSortino AS (
    SELECT 
        Ticker,
        (Average_Return - (0.0374 / 252)) / NULLIF(Downside_Deviation, 0) AS Sortino_Ratio
    FROM SortinoMetrics
)
SELECT * INTO #TempAnnualizedSortino FROM AnnualizedSortino;

SELECT *
FROM #TempAnnualizedSortino

-- Calculate Value at Risk (VaR):
-- Measures the maximum expected loss at a given confidence level (e.g., 95%).
DROP TABLE IF EXISTS #TempVaR;

WITH VaRMetrics AS (
    SELECT 
        Ticker,
        PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY DailyReturn) OVER (PARTITION BY Ticker) AS VaR_95  -- 5th percentile for 95% confidence level
    FROM combined_stock_data
)

SELECT DISTINCT Ticker, VaR_95 INTO #TempVaR FROM VaRMetrics;

SELECT * 
FROM #TempVaR;

-- 5) Identify Anomalies
-- Purpose: Detect irregular trading activities by identifying volume spikes and price outliers.

-- Volume Spikes:
-- The goal is to identify days where the trading volume significantly exceeded the 20-day moving average volume, 
-- which might indicate unusual market activity (e.g., large buy/sell orders or news events).
WITH VolumeAnalysis AS (
    SELECT 
        Date,
        Ticker,
        Volume,
        AVG(Volume) OVER (PARTITION BY Ticker ORDER BY Date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS Avg_Volume,
        CASE 
            WHEN Volume > (1.5 * AVG(Volume) OVER (PARTITION BY Ticker ORDER BY Date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW)) 
            THEN 'Spike' 
            ELSE 'Normal' 
        END AS Volume_Status
    FROM 
        combined_stock_data
)
-- This query returns only the days where a spike in volume occurred.
SELECT 
    Date, 
    Ticker, 
    Volume, 
    Avg_Volume, 
    Volume_Status
FROM 
    VolumeAnalysis
WHERE 
    Volume_Status = 'Spike'
ORDER BY 
    Date, Ticker;

-- Outlier Detection:
-- This query detects unusual price movements by calculating Z-scores for daily returns. 
-- If the Z-score exceeds a threshold (e.g., 2), it is flagged as an outlier, which could signal significant events or market anomalies.
WITH DailyPriceChange AS (
    SELECT 
        [Date],
        Ticker,
        Adj_Close,
        -- Use LAG to calculate the price change from the previous day.        
        LAG(Adj_Close) OVER (PARTITION BY Ticker ORDER BY Date) AS Prev_Close,
        -- Calculate the daily return as the percentage change from the previous day's closing price.
        (Adj_Close - LAG(Adj_Close) OVER (PARTITION BY Ticker ORDER BY Date)) / LAG(Adj_Close) OVER (PARTITION BY Ticker ORDER BY Date) AS Daily_Return
    FROM 
        combined_stock_data
),
ZScoreCalculation AS (
    SELECT
        [Date],
        Ticker,
        Daily_Return * 100 AS Daily_Return_Percentage,
        -- Calculate the average return and standard deviation for each stock.
        AVG(Daily_Return) OVER (PARTITION BY Ticker) AS Avg_Return,
        STDEV(Daily_Return) OVER (PARTITION BY Ticker) AS Std_Dev,
        -- Z-score formula: (current return - mean return) / standard deviation
        (Daily_Return - AVG(Daily_Return) OVER (PARTITION BY Ticker)) / 
        NULLIF(STDEV(Daily_Return) OVER (PARTITION BY Ticker), 0) AS Z_Score
    FROM 
        DailyPriceChange
)
-- This query returns only the days with a Z-score greater than 2, which are considered outliers.
SELECT 
    [Date],
    Ticker,
    Daily_Return_Percentage,
    Z_Score
FROM 
    ZScoreCalculation
WHERE 
    ABS(Z_Score) > 2  -- Threshold for identifying outliers (Z-scores greater than 2)
ORDER BY 
    Ticker, Z_Score desc;


-- 6) Investment Recommendation
-- Purpose: Provide investment recommendations based on performance metrics, including return, volatility, and risk.
WITH PerformanceMetrics AS (
    SELECT 
        Ticker,
        -- Calculate annualized average return for each stock.
        AVG(DailyReturn) * 252 AS Annualized_Average_Return,
        -- Calculate the average return over the last year (252 trading days).
        AVG(CASE WHEN Date >= DATEADD(YEAR, -1, GETDATE()) THEN DailyReturn END) * 252 AS Last_Year_Avg_Return,
        -- Calculate the average return over the last 3 months (roughly 63 trading days).
        AVG(CASE WHEN Date >= DATEADD(MONTH, -3, GETDATE()) THEN DailyReturn END) * 252 AS Last_3_Months_Avg_Return 
    FROM combined_stock_data
    GROUP BY Ticker
)
-- The final query calculates key performance metrics and suggests an investment recommendation.
SELECT 
    p.Ticker,
    -- Round the annualized return to two decimal places for readability.
    ROUND(p.Annualized_Average_Return * 100, 2) AS Annualized_Average_Return_Percentage,
    -- Round the volatility to show as a percentage.
    ROUND(v.Annualized_Volatility * 100, 2) AS Annualized_Volatility_Percentage,
    -- Include the Sharpe Ratio to assess risk-adjusted return.
    ROUND(s.Sharpe_Ratio, 2) AS Rounded_Sharpe_Ratio,
    -- Include the Value at Risk (VaR) at 95% confidence level.
    ROUND(r.VaR_95 * 100, 2) AS VaR_95_Percentage,
    -- Include recent performance metrics (last year and last 3 months).
    ROUND(p.Last_Year_Avg_Return * 100, 2) AS Last_Year_Avg_Return_Percentage,
    ROUND(p.Last_3_Months_Avg_Return * 100, 2) AS Last_3_Months_Avg_Return_Percentage,
    -- Investment recommendation logic based on long-term and short-term returns:
    CASE 
        WHEN p.Annualized_Average_Return > 0.20 THEN 'Good Long-term Investment'
        WHEN p.Last_3_Months_Avg_Return > 0.075 THEN 'Short-term Opportunity'
        ELSE 'Needs Further Analysis' -- Stocks with less clear signals.
    END AS Investment_Recommendation
FROM PerformanceMetrics p
JOIN #TempAnnualizedSharpe s ON p.Ticker = s.Ticker
JOIN #TempAnnualizedVolatility v ON p.Ticker = v.Ticker
JOIN #TempVaR r ON p.Ticker = r.Ticker
ORDER BY p.Annualized_Average_Return DESC;