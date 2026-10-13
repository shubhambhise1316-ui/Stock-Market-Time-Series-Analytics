



drop table stock_prices;

CREATE TABLE stock_prices (
    stock_date DATE PRIMARY KEY, 
    open DECIMAL(15, 5),
    high DECIMAL(15, 5),
    low DECIMAL(15, 5),
    close DECIMAL(15, 5),
    adj_close DECIMAL(15, 5),
    volume BIGINT
);

select * from stock_prices ;


---Average closing price per year (this needs the Date split into Year first):

WITH LiquidityMetrics AS (
    SELECT 
        trade_date,
        volume,
        (high_price - low_price) AS intraday_range,
        AVG(volume) OVER() AS overall_avg_volume
    FROM stock_analytics
)

--Calculate the overall baseline health and lifetime volatility of the stock.
SELECT 
    MIN(low ) AS lifetime_low,
    MAX(high ) AS lifetime_max,
    AVG(close ) AS average_close_price,
    AVG(volume) AS average_daily_volume
FROM stock_prices
;

--Calculate the overall baseline health and lifetime volatility of the stock.
SELECT 
    MIN(low_price) AS lifetime_low,
    MAX(high_price) AS lifetime_max,
    AVG(close_price) AS average_close_price,
    AVG(volume) AS average_daily_volume
FROM stock_prices;

--Group the stock data by year to analyze how the asset grew over time.

SELECT 
    EXTRACT(YEAR FROM trade_date) AS trade_year,
    AVG(close_price) AS yearly_avg_close,
    SUM(volume) AS total_yearly_volume
FROM stock_prices
GROUP BY EXTRACT(YEAR FROM trade_date)
ORDER BY trade_year;


--Use a Window Function to calculate a 30-day moving average, a highly sought-after metric in data analytics portfolios.
SELECT 
    trade_date,
    close_price,
    AVG(close_price) OVER(
        ORDER BY trade_date 
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS rolling_30_day_avg
FROM stock_prices;

