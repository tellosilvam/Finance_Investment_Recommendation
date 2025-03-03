# 📊 Comparing Stock Performance of Amex, Visa, and Mastercard Through Data Analysis

## 🔗 Links

- [![Medium](https://img.shields.io/badge/Medium-Blog-white?logo=medium&logoColor=white)](https://medium.com/@tellosilvam/comparing-stock-performance-of-amex-visa-and-mastercard-through-data-analysis-491e7acef3fb): 📝 Blog explaining the whole project process, assuming a financial analysis posture.  
- [![SQL](https://img.shields.io/badge/SQL-Code-orange?logo=sqlite&logoColor=white)](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/SQLQuery.sql): 🗄️ Detailed SQL Code.  
- [![Python API](https://img.shields.io/badge/Python-API-yellow?logo=python&logoColor=white)](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/API_Financial.ipynb): 📡 Yahoo Finance API integration.  
- [![Tableau](https://img.shields.io/badge/Tableau-Dashboard-blue?)](https://public.tableau.com/app/profile/miguel.tello/viz/FinanceProject_17289421123420/Dashboard): 📊 Interactive visualizations.  
- [![Portfolio](https://img.shields.io/badge/Portfolio-Website-purple?)](https://www.datascienceportfol.io/migueltello): 🌐 Portfolio web.  

![FinancialThumb](thumbnail.png)

## Introduction  

Payment processors such as **American Express (AXP)**, **Visa (V)**, and **Mastercard (MA)** have experienced significant expansion in the dynamic financial industry, particularly with the rise of **cashless transactions 📈**. Even though their stocks have had varying degrees of success, **analyzing their past performance** can provide valuable insights into their future potential. These three companies form a well-established **oligopoly** in the finance industry, known for its **stability during economic crises and recessions**. It is widely accepted that to **diversify your portfolio**, investing in at least one of these businesses is a smart strategy.  

However, there are key differences between them:  

- **💳 Visa (V) & Mastercard (MA)** act primarily as **payment networks**, processing transactions while avoiding direct exposure to **credit risk**.  
- **🏦 American Express (AXP)**, on the other hand, **issues its own credit cards**, taking on more **credit risk but also higher potential rewards** through interest and fees.  

This unique business approach gives **Amex a distinctive financial profile** and stock performance compared to its competitors.  

🚀 **In this blog, I'll guide you through the process of using** `Tableau 📊`, `SQL 🗄️`, and `Python 🐍` **to analyze and visualize the stock performance of these three financial giants.**

## 🗄️ SQL Code Explanation  

The first stage involved using **Python 🐍** to **scrape financial data** from the **Yahoo Finance API 📊**. You can check out the notebook at this [**link**](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/API_Financial.ipynb). After gathering the data, it was **cleaned and structured** to prepare it for SQL analysis.  

### 🔍 Key Steps in SQL Processing:  

- **Data Cleaning & Transformation**:  
  - The **concatenated file** was scrubbed to ensure consistency.  
  - New columns, such as **daily and cumulative returns 📈**, were added for better insights.  
  - Yearly and monthly returns were stored in a table for future analysis.  

- **📊 Moving Averages Calculation**:  
  - The **Simple Moving Average (SMA)** was computed for **20, 50, and 200 days**.  
  - This helped identify key trading signals, such as **Golden Crosses & Death Crosses ⚡**.  

- **📌 Identifying Market Abnormalities**:  
  - Detection of **outliers** and **volume spikes** to spot unusual market activity.  

- **📈 Performance Metrics Calculation**:  
  - **Annualized performance metrics** were computed per stock, including:  
    - **Volatility**  
    - **Sharpe Ratio**  
    - **Sortino Ratio**  
    - **⚠Value at Risk (VaR)**  
  - These indicators, along with **returns over the past year and the last 3 months**, were used to establish an **investment recommendation**:  
    - **✅ Visa (V) & Mastercard (MA):** Considered **good long-term investments**.  
    - **⚡ American Express (AXP):** Identified as a **short-term opportunity**.  

🔗 **Check out the full SQL Code here:** [**Detailed SQL Code**](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/SQLQuery.sql)  

## Tableau Dashboard  

🚀 **Explore the interactive dashboard on** [**Tableau Public**](https://public.tableau.com/app/profile/miguel.tello/viz/FinanceProject_17289421123420/Dashboard).  

🔍 **What’s included?**  
- 📈 **Various financial charts** to analyze stock performance.  
- 🗺️ **Interactive map** allowing you to select different metrics for evaluation.  
- 🔄 **Interconnected visualizations** for a seamless and enhanced user experience.  

### 📌 Key Insights:  
✅ **American Express (AXP) outperformed** last year, but this was an **exceptional performance**.  
📉 Over the past **10 years**, AXP has **underperformed** compared to **Visa (V) & Mastercard (MA)**.  
📊 **Visa (V) & Mastercard (MA) show similar trends**, but **V has a slightly higher return percentage**.  
💡 Both **Visa and Mastercard** are considered **strong long-term investments**.  

## 📊 Key Parameters  

### 1️⃣ **Price-to-Earnings (P/E) Ratio**  
- **Visa (V)** → **~30** (Indicates strong market confidence ✅)  
- **Mastercard (MA)** → **~39** (Reflects a higher market valuation 🔼)  
- **American Express (AXP)** → **~20** (Represents a more value-oriented stock 🔽)  

### 2️⃣ **Price-to-Book (P/B) Ratio**  
- **Visa (V)** → **16** (Signifies a premium market position 🌟)  
- **Mastercard (MA)** → **64** (Indicates a high valuation 🚀)  
- **American Express (AXP)** → **6.4** (Potentially undervalued, presenting an opportunity 💰)  

### 3️⃣ **Analyst Ratings**  
- **Visa (V) & Mastercard (MA)** → Consistently rated as **"Buy"** or **"Strong Buy"** 🟢  
- **American Express (AXP)** → Shows more **erratic** ratings, but still largely **positive** 🟡  

### 4️⃣ **Price Targets**  
- **Visa (V)** → **$311** (Reflects expectations of **faster growth** 🚀)  
- **Mastercard (MA)** → **$530** (Strong market confidence and stability 📈)  
- **American Express (AXP)** → **$275** (Represents steady, but less aggressive growth 📊)   

## ✅ Recommendation  

📈 **For Long-Term Growth Investors:**  
- **Visa (V)** & **Mastercard (MA)** stand out as the **best options** based on **higher valuations and price targets**.  
- These findings align with the **SQL analysis**, reinforcing their **strong long-term growth potential 🚀**.  

💰 **For Value-Oriented Investors:**  
- **American Express (AXP)** offers **lower P/E and P/B ratios**, making it an **appealing choice for value investors**.  
- It presents a **short-term opportunity ⚡** with potential **long-term growth** if market conditions remain favorable.  

⚖️ **Final Consideration:**  
- While **V & MA provide a balanced mix of growth & value**, investors should **assess their risk tolerance** before deciding on AXP.  
- Diversification and a well-thought-out **investment strategy** are key to maximizing returns.  

📊 **Choose wisely based on your investment goals!** 🚀  

## 📚 Data Source:  

- **Yahoo Finance**. (October, 2024). **Visa Inc. (V)** stock price, news, quote & history.  
  Yahoo! Finance. Retrieved October 11, 2024, from [**https://finance.yahoo.com/quote/V**](https://finance.yahoo.com/quote/V)  

- **Yahoo Finance**. (October, 2024). **Mastercard Incorporated (MA)** stock price, news, quote & history.  
  Yahoo! Finance. Retrieved October 11, 2024, from [**https://finance.yahoo.com/quote/MA**](https://finance.yahoo.com/quote/MA)  

- **Yahoo Finance**. (October, 2024). **American Express Company (AXP)** stock price, news, quote & history.  
  Yahoo! Finance. Retrieved October 11, 2024, from [**https://finance.yahoo.com/quote/AXP**](https://finance.yahoo.com/quote/AXP)  
