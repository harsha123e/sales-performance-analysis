-- Business Question 1
-- How have sales and profit changed over time?

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY
    year,
    month
ORDER BY
    year,
    month;

-- Business Question 2
-- Which product categories and sub-categories generate the
-- highest revenue and profit?

SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY
    category,
    sub_category
ORDER BY
    category,
    total_profit DESC,
    total_sales DESC;

-- Business Question 3
-- How does business performance compare across regions?

SELECT
    region,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY
    region
ORDER BY
    total_profit DESC;

-- Business Question 4
-- How do customer segments differ in revenue,
-- profitability, and purchasing activity?

SELECT
    segment,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY
    segment
ORDER BY
    total_profit DESC;

-- Business Question 5
-- How do discounts impact profitability?

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN '0-10%'
        WHEN discount <= 0.20 THEN '10-20%'
        WHEN discount <= 0.30 THEN '20-30%'
        ELSE 'Above 30%'
    END AS discount_range,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(profit), 2) AS average_profit,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY
    discount_range
ORDER BY
    total_profit DESC;

-- Business Question 6
-- Which products generate high sales but low or negative profit?

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY
    product_name
HAVING
    SUM(profit) < 0
ORDER BY
    total_profit
LIMIT 10;