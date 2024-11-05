-- CREATING DATABASE
-- This statement creates a new database named 'pizzahut'.
CREATE DATABASE pizzahut;

-- Set the database context to 'pizzahut'.
USE pizzahut;

-- TABLE CREATION
-- Creating the 'orders' table with order_id, order_date, and order_time.
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

-- Creating the 'order_details' table with order_details_id, order_id, pizza_id, and quantity.
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- QUERY TO FETCH DATA
-- Retrieves all entries from the 'order_details' table.
SELECT 
    *
FROM
    order_details;

-- Retrieves all entries from the 'orders' table.
SELECT 
    *
FROM
    orders;

-- AGGREGATE QUERIES
-- Counts the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_Order
FROM
    orders;

-- REVENUE CALCULATION
-- Calculates total revenue generated from pizza sales.
SELECT 
    SUM(od.quantity * p.price) AS Total_Revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

-- PRICE AND SIZE ANALYSIS
-- Fetching the highest-priced pizza by joining 'pizzas' and 'pizza_types' and ordering by price.
SELECT 
    pt.`name`, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identifies the most common pizza size ordered by counting each size and ordering by count.
SELECT 
    p.size, COUNT(p.size) AS ordered_total
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY 2 DESC;

-- ORDER STATISTICS
-- Lists the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.`name` AS name,
    p.pizza_type_id AS pizza_type,
    SUM(od.quantity) AS Quantity
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY `name` , pizza_type
ORDER BY quantity DESC
LIMIT 5;
