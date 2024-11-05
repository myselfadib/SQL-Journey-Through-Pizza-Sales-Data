-- Set the database context to 'pizzahut'.
USE pizzahut;

-- QUERIES FOR ANALYTICS
-- Query to retrieve and display all rows from the 'pizza_types' table.
SELECT 
    *
FROM
    pizza_types;
-- Query to retrieve and display all rows from the 'pizzas' table.
SELECT 
    *
FROM
    pizzas;
-- Query to retrieve and display all rows from the 'orders' table.
SELECT 
    *
FROM
    orders;
-- Query to retrieve and display all rows from the 'order_details' table.
SELECT 
    *
FROM
    order_details;

-- ANALYSIS OF PIZZA ORDERS BY CATEGORY
-- This query finds the total quantity of each pizza category ordered.
SELECT 
    pt.category AS Category, SUM(od.quantity) AS total_ordered
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY Category;

-- ORDER DISTRIBUTION BY HOUR
-- This query determines the distribution of orders by the hour of the day.
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS num_of_orders
FROM
    orders
GROUP BY hour;

-- CATEGORY-WISE DISTRIBUTION OF PIZZAS
-- This query finds the category-wise distribution of pizzas, counting the number of pizza names per category.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- GROUP ORDERS BY DATE
-- This section calculates the average number of pizzas ordered per day.
-- Fetch all entries from the related tables for debugging or verification purposes.
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

-- Join orders and order details to view combined data.
SELECT 
    *
FROM
    orders o
        JOIN
    order_details od ON o.order_id = od.order_id;

-- Display distinct order dates for understanding the data distribution.
SELECT DISTINCT
    order_date
FROM
    orders;

-- Calculate the average quantity of pizzas ordered per day.
SELECT 
    AVG(sum_quantity)
FROM
    (SELECT 
        o.order_date AS date, SUM(od.quantity) AS sum_quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY date) AS order_quantity;

-- This query provides the same average but rounds the result to the nearest whole number.
SELECT 
    ROUND(AVG(sum_quantity), 0)
FROM
    (SELECT 
        o.order_date AS date, SUM(od.quantity) AS sum_quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY date) AS order_quantity;

-- TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE
-- This section aims to determine the top 3 most ordered pizza types based on total revenue.
SELECT 
    pt.name,
    pt.pizza_type_id AS pizza_type,
    SUM(p.price * od.quantity) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name , pizza_type
ORDER BY revenue DESC
LIMIT 3;
