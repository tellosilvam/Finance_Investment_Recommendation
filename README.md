# Comparing Stock Performance of Amex, Visa, and Mastercard Through Data Analysis

## Links

- [**Medium Blog**](https://medium.com/@tellosilvam/comparing-stock-performance-of-amex-visa-and-mastercard-through-data-analysis-491e7acef3fb): Blog explaining the whole project process, assuming a financial analysis posture.
- [**SQL Code**](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/SQLQuery.sql): Detailed SQL Code.
- [**Python API Code**](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/API_Financial.ipynb): Yahoo Finance API.
- [**Tableau Dashboard**](https://public.tableau.com/app/profile/miguel.tello/viz/FinanceProject_17289421123420/Dashboard): Interactive visualizations.
- [**Project Portfolio**](https://www.datascienceportfol.io/migueltello): Portfolio web.

![FinancialThumb](thumbnail.png)

## Introduction

Payment processors such as American Express (AXP), Visa (V), and Mastercard (MA) have experienced significant expansion in the dynamic financial industry, particularly with the increase in cashless transactions. Even though their stocks have had differing degrees of success, knowing their past performance might provide important clues about their potential in the future. These three companies represent a fairly accepted oligopoly in the finance industry, one of the most stable through a crisis or recession. It is a known consensus that to diversify your portfolio, you must seek to invest in at least one of these businesses.

In contrast to Visa and Mastercard, which essentially serve as payment networks, American Express has a credit card-focused business strategy. V and MA function as transaction processors, excluding the exposure to credit risk that AXP has as they issue their cards directly. This peculiar company approach shapes Amex’s singular stock performance and financial profile.

Through this blog, I’ll walk you through the process of using Tableau, SQL and Python to examine and display the stock performance of these three finance giants.

## SQL Code Explanation

The first stage involved using Python to scrape the Yahoo Finance API data; the notebook may be viewed at this [**link**](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/API_Financial.ipynb). The newly downloaded concatenated file was then scrubbed to initiate the use of SQL. New columns, such as daily and cumulative returns, were also included. After that, the yearly and monthly returns were entered into a table that would be useful for future study.

The moving average calculation is then performed, taking into account the Simple Moving Average (SMA) for the previous 20, 50, and 200 days. These data allowed the identification of the Golden and Death crosses listed in this file. The following stage also involved locating abnormalities, such as outliers and volume spikes.

Finally, some performance annualized metrics per ticker (Volatility, Sharpe, Sortino ratio and Value at Risk) were calculated. These measures and the returns over the previous year and the previous three months were used to establish the investment recommendation. V and MA were deemed "good long-term investments", while AXP was considered a "short-term opportunity."

[**Detailed SQL Code**](https://github.com/tellosilvam/Finance_Investment_Recommendation/blob/77fe6d126cf9c34f4f1fa26f047a2faf384ab0d5/SQLQuery.sql)

## Tableau Dashboard

<div class='tableauPlaceholder' id='viz1729761535233' style='position: relative'><noscript><a href='#'><img alt='Dashboard ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Fi&#47;FinanceProject_17289421123420&#47;Dashboard&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='FinanceProject_17289421123420&#47;Dashboard' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Fi&#47;FinanceProject_17289421123420&#47;Dashboard&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='language' value='es-ES' /></object></div>                <script type='text/javascript'>                    var divElement = document.getElementById('viz1729761535233');                    var vizElement = divElement.getElementsByTagName('object')[0];                    if ( divElement.offsetWidth > 800 ) { vizElement.style.width='1240px';vizElement.style.height='867px';} else if ( divElement.offsetWidth > 500 ) { vizElement.style.width='1240px';vizElement.style.height='867px';} else { vizElement.style.width='100%';vizElement.style.height='1977px';}                     var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                </script>

Explore the interactive dashboard on [Tableau Public](https://public.tableau.com/app/profile/miguel.tello/viz/FinanceProject_17289421123420/Dashboard). The dashboard includes various charts from this project and an interactive map where you can choose different metrics to evaluate. All charts are interconnected, enhancing the user experience.

The first conclusion we reach is that American Express outperformed last year, although this type of performance is extraordinary and does not follow the trend of the last ten years where the stock has underperformed compared to Visa and Mastercard. These stocks follow similar trends; although V has a higher return percentage, both are considered good long-term investments. Up next is the respective stock comparison using key financial parameters.

## Key Parameters

1. **Price-to-Earnings (P/E) Ratio:** According to Yahoo Finance, Visa’s P/E ratio is approximately 30, which indicates a strong level of market confidence; Mastercard’s P/E ratio is marginally higher at 39, and American Express’s P/E ratio is lower at 20, making this an indicator towards a more value-oriented company.
2. **Price-to-Book (P/B) Ratio:** V and MA have premium market positions with P/B ratios of 16 and 64, respectively, while AXP may be undervalued with a ratio of 6.4.
3. **Analyst Ratings:** All three have generally positive analyst ratings; V and MA are consistently rated as “Buy” or “Strong Buy,” while AXP has more erratic but positive ratings.
4. **Price targets:** The market’s confidence in the future growth of all three stocks is indicated by the average prices of V, MA, and AXP, which are roughly $311, $530, and $275, respectively (V anticipates faster growth on average).

## Recommendation

With their higher valuations and price targets, Visa and Mastercard seem more appropriate for long-term growth-oriented investors based on these indicators, which coincides with the results given by the previous SQL analysis. Value investors looking for potential growth with less premium pricing may find American Express appealing due to its lower P/E and P/B ratios, making this a short-term opportunity with potential for long-term growth as well. Therefore, even if V and MA offer a well-balanced combination of growth and value, investors should think about their risk tolerance and reconsider their investment options regarding AXP.

## Bibliography

### Data Source:
- Yahoo Finance. (October, 2024). Visa Inc. (V) stock price, news, quote & history. Yahoo! Finance. Retrieved October 11, 2024, from https://finance.yahoo.com/quote/V
- Yahoo Finance. (October, 2024). Mastercard Incorporated (MA) stock price, news, quote & history. Yahoo! Finance. Retrieved October 11, 2024, from https://finance.yahoo.com/quote/MA
- Yahoo Finance. (October, 2024). American Express Company (AXP) stock price, news, quote & history. Yahoo! Finance. Retrieved October 11, 2024, from https://finance.yahoo.com/quote/AXP
