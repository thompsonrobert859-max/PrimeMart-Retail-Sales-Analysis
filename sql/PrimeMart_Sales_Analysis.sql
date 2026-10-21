use primemart
-- =====================================================
-- PROJECT: PrimeMart Retail Ltd.
-- ANALYST: Orem Robert Thompson
-- PURPOSE: Analyze sales performance and support decisions
-- TOOL: MySQL Workbench
-- =====================================================

--  QUESTION 1: What is the company's total revenue? 
;
SELECT
SUM(quantity * selling_price) AS TotalRevenue
FROM order_items;

-- QUESTION 2: Which products generate the most revenue?

SELECT
p.product_name,
SUM(oi.quantity) AS UnitsSold,
SUM(oi.quantity * oi.selling_price) AS TotalRevenue
FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY TotalRevenue DESC;

-- QUESTION 3: Which branches perform best?

SELECT
o.branch,
SUM(oi.quantity * oi.selling_price) AS TotalRevenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY o.branch
ORDER BY TotalRevenue DESC;

-- QUESTION 4A: Which products sell the most units?

SELECT
p.product_name,
SUM(oi.quantity) AS UnitsSold,
SUM(oi.quantity * oi.selling_price) AS TotalRevenue
FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY UnitsSold DESC;

-- QUESTION 4B: Which products perform best in each branch?

SELECT
o.branch,
p.product_name,
SUM(oi.quantity) AS UnitsSold,
SUM(oi.quantity * oi.selling_price) AS TotalRevenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY o.branch, p.product_id, p.product_name
ORDER BY o.branch, UnitsSold DESC;

-- QUESTION 5A: How many orders and units does each branch have?

SELECT
o.branch,
COUNT(DISTINCT o.order_id) AS TotalOrders,
SUM(oi.quantity) AS TotalUnitsSold,
SUM(oi.quantity * oi.selling_price) AS TotalRevenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY o.branch
ORDER BY TotalRevenue DESC;

-- QUESTION 5B: What is the average revenue per order?

SELECT
o.branch,
COUNT(DISTINCT o.order_id) AS TotalOrders,
ROUND(
SUM(oi.quantity * oi.selling_price) /
COUNT(DISTINCT o.order_id),
2
) AS AverageRevenuePerOrder
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY o.branch
ORDER BY AverageRevenuePerOrder DESC;

-- QUESTION 6: What percentage of revenue comes from each branch?

SELECT
o.branch,
SUM(oi.quantity * oi.selling_price) AS TotalRevenue,
ROUND(
SUM(oi.quantity * oi.selling_price) * 100.0 /
(SELECT SUM(quantity * selling_price)
FROM order_items),
2
) AS RevenuePercentage
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY o.branch
ORDER BY TotalRevenue DESC;
