-- Q1 
-- What is the average price of each commodity over the entire dataset?
CREATE VIEW view_avg_commodity_price AS
SELECT commodities.commodity_name, ROUND(AVG(daily_prices.avg_price)::numeric, 2) AS avg_price
FROM daily_prices
LEFT JOIN commodities
	ON daily_prices.commodity_id = commodities.commodity_id
GROUP BY commodities.commodity_name
ORDER BY avg_price DESC


-- Q2
-- What is the average price of each commodity for each month?
CREATE VIEW view_monthly_avg_prices AS
WITH table1 AS (
	SELECT commodities.commodity_name, 
			EXTRACT(MONTH FROM daily_prices.report_date) AS month_num, 
			ROUND(AVG(daily_prices.avg_price)::numeric, 2) AS avg_price
	FROM daily_prices
	LEFT JOIN commodities
		ON daily_prices.commodity_id = commodities.commodity_id
	GROUP BY commodities.commodity_name, EXTRACT(MONTH FROM daily_prices.report_date)
	ORDER BY commodities.commodity_name, month_num DESC
)

SELECT commodity_name, avg_price,
		CASE
			WHEN month_num = 12 THEN 'Dec'
			WHEN month_num = 11 THEN 'Nov'
			WHEN month_num = 10 THEN 'Oct'
			WHEN month_num = 9 THEN 'Sept'
			WHEN month_num = 8 THEN 'Aug'
			WHEN month_num = 7 THEN 'July'
			WHEN month_num = 6 THEN 'June'
			WHEN month_num = 5 THEN 'May'
			WHEN month_num = 4 THEN 'April'
			WHEN month_num = 3 THEN 'March'
			WHEN month_num = 2 THEN 'Feb'
			WHEN month_num = 1 THEN 'Jan'
		END AS month_name
FROM table1


-- Q3
-- What is the price swing for each commodity?
CREATE VIEW view_price_swing AS
WITH table1 AS (
	SELECT commodities.commodity_name, 
			EXTRACT(MONTH FROM daily_prices.report_date) AS month_num, 
			ROUND(AVG(daily_prices.avg_price)::numeric, 2) AS avg_price
	FROM daily_prices
	LEFT JOIN commodities
		ON daily_prices.commodity_id = commodities.commodity_id
	GROUP BY commodities.commodity_name, EXTRACT(MONTH FROM daily_prices.report_date)
	ORDER BY commodities.commodity_name, month_num DESC
), table2 AS (
	SELECT *,
		MAX(avg_price) OVER(PARTITION BY commodity_name) AS max_price,
		MIN(avg_price) OVER(PARTITION BY commodity_name) AS min_price,
		CASE
			WHEN month_num = 12 THEN 'Dec'
			WHEN month_num = 11 THEN 'Nov'
			WHEN month_num = 10 THEN 'Oct'
			WHEN month_num = 9 THEN 'Sept'
			WHEN month_num = 8 THEN 'Aug'
			WHEN month_num = 7 THEN 'July'
			WHEN month_num = 6 THEN 'June'
			WHEN month_num = 5 THEN 'May'
			WHEN month_num = 4 THEN 'April'
			WHEN month_num = 3 THEN 'March'
			WHEN month_num = 2 THEN 'Feb'
			WHEN month_num = 1 THEN 'Jan'
		END AS month_name
	FROM table1
), table3 AS (
	SELECT commodity_name, max_price, min_price
	FROM table2
	GROUP BY commodity_name, max_price, min_price
)

SELECT *, 
		ROUND(((((max_price) - (min_price)) / min_price) * 100)::numeric, 2) AS percent_swing
FROM table3

