-- Set the database context to 'pizzahut'.
USE pizzahut;

-- PRELIMINARY DATA RETRIEVAL
-- These SELECT statements are presumably for debugging or preliminary data checks.
SELECT 
    *
FROM
    pizza_types;
SELECT 
    *
FROM
    pizzas;
SELECT 
    *
FROM
    orders;
SELECT 
    *
FROM
    order_details;

-- DETAILED ANALYSIS OF PIZZA SALES
-- Join tables to see the connection between pizza types, pizzas, and order details.
SELECT 
    *
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id;

-- CALCULATE TOTAL SALES PER PIZZA TYPE
-- Summarizes the total sales per pizza type.
SELECT 
    pt.pizza_type_id AS pizza_type,
    SUM(p.price * od.quantity) AS Total_Sales
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pizza_type;

-- ANALYSIS USING COMMON TABLE EXPRESSIONS (CTEs)
-- These CTEs are used to calculate the total and category-wise sales and then calculate the percentage contribution of each category to the total sales.
WITH cte AS (
    SELECT SUM(p.price * od.quantity) AS total_price
    FROM pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od ON od.pizza_id = p.pizza_id
),
cte1 AS (
    SELECT pt.category, SUM(p.price * od.quantity) AS type_price
    FROM pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od ON od.pizza_id = p.pizza_id
    GROUP BY pt.category
)
SELECT cte1.category, cte1.type_price / cte.total_price * 100 AS price_ratio
FROM cte1
CROSS JOIN cte;  -- Using CROSS JOIN since cte contains only one row, simplifying the join condition.

-- TIME-SERIES ANALYSIS OF REVENUE
-- This section calculates the cumulative revenue over time, providing insights into revenue trends.
WITH cte AS (
    SELECT o.order_date AS order_date, SUM(p.price * od.quantity) AS revenue
    FROM pizzas p
    JOIN order_details od ON p.pizza_id = od.pizza_id
    JOIN orders o ON o.order_id = od.order_id
    GROUP BY order_date
)
SELECT order_date, revenue, SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM cte
ORDER BY order_date ASC;

-- RANKING OF PIZZA TYPES WITHIN EACH CATEGORY BASED ON REVENUE
-- This complex subquery uses window functions to rank pizza types within each category based on revenue.
SELECT category, name, revenue FROM (
    SELECT category, name, revenue, RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT pt.category, pt.name, SUM(p.price * od.quantity) AS revenue
        FROM pizzas p
        JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN order_details od ON od.pizza_id = p.pizza_id
        GROUP BY pt.category, pt.name
    ) AS a
) AS b
WHERE rn <= 3;  -- Filters to show only the top 3 ranked pizza types in each category based on revenue.
