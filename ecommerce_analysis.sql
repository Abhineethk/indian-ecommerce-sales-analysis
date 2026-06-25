-- =====================================
-- Indian E-Commerce Sales Analysis
-- Business SQL Analysis Queries
-- =====================================
/*
Project : Indian E-Commerce Sales Analysis
Tools   : MySQL
Dataset : Public E-Commerce Dataset adapted for an Indian business scenario
Author  : Abhineeth K

Description:
This SQL script contains business analysis queries used to generate KPIs,
sales trends, category performance, regional revenue analysis,
and order status insights for an Indian E-Commerce Sales Dashboard.
*/

USE ecommerce_project;

-- =====================================
-- Dashboard KPI 1: Total Revenue
-- =====================================
SELECT ROUND(SUM(price),2) AS total_revenue
FROM order_items;

-- =====================================
-- Dashboard KPI 2: Total Orders
-- =====================================
SELECT COUNT(*) AS total_orders
FROM orders;

-- =====================================
-- Dashboard KPI 3: Average Order Value
-- =====================================
SELECT ROUND(SUM(price)/COUNT(DISTINCT order_id),2) AS average_order_value
FROM order_items;

-- =====================================
-- Analysis 1 : Top Categories by Revenue
-- =====================================
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- =====================================
-- Analysis 2 : Top Products by Revenue
-- =====================================
SELECT
    product_id,
    ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY SUM(price) DESC
LIMIT 10;

-- =====================================
-- Analysis 3 : Monthly Order Trend
-- =====================================
SELECT
DATE_FORMAT(
STR_TO_DATE(order_purchase_timestamp,'%d-%m-%Y %H:%i'),
'%Y-%m'
) AS month,
COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- =====================================
-- Analysis 3 : Regional Revenue Analysis
-- =====================================
WITH rev AS (
    SELECT
        c.customer_state,
        ROUND(SUM(oi.price),2) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_state
)
SELECT *
FROM rev
ORDER BY revenue DESC;

-- =====================================
-- Analysis 5 : Order Status Distribution
-- =====================================
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- =====================================
-- End of SQL Analysis
-- =====================================