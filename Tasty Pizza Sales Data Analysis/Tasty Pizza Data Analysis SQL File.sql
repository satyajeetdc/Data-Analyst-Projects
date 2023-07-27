
/* -------------------- KPIs -------------------- */


/* Total Revenue */
SELECT ROUND(SUM(total_price), 2) AS Total_Revenue
FROM pizza_sales

/* Average Order Value */
SELECT ROUND(SUM(total_price)/COUNT(DISTINCT(order_id)) ,2) AS Average_order_value
FROM pizza_sales

/* Total Pizzas Sold */
SELECT SUM(quantity) AS Total_pizzas_sold
FROM pizza_sales

/* Total Orders */
SELECT COUNT(DISTINCT(order_id)) AS Total_orders 
FROM pizza_sales

/* Average number of Pizzas per order */
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2))/
CAST(COUNT(DISTINCT(order_id)) AS DECIMAL(10,2)) AS DECIMAL(10,2)) 
AS Average_Pizzas_Per_Order
FROM pizza_sales


/* -------------------- Daily Trend for Total orders -------------------- */

SELECT DATENAME(DW, order_date) AS Order_day,
COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)


/* -------------------- Monthly Trend for Total orders -------------------- */

SELECT DATENAME(MONTH, order_date) AS Months,
COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)


/* -------------------- Revenue by Pizza Category -------------------- */

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as Revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS pct_share_in_revenue
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pct_share_in_revenue DESC


/* -------------------- Revenue by Pizza Size -------------------- */

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as Revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS pct_share_in_revenue
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pct_share_in_revenue DESC


/* -------------------- Number of pizzas sold by Pizza Category -------------------- */

SELECT pizza_category, SUM(quantity) as Total_Units_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Units_Sold DESC


/* -------------------- Top 5 pizzas by Revenue -------------------- */

SELECT TOP 5 pizza_name, SUM(total_price) AS Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Revenue DESC


/* -------------------- Bottom 5 pizzas by Revenue -------------------- */

SELECT TOP 5 pizza_name, SUM(total_price) AS Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Revenue ASC


/* -------------------- Top 5 pizzas by units sold -------------------- */

SELECT TOP 5 pizza_name, SUM(quantity) AS Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Orders DESC


/* -------------------- Bottom 5 pizzas by units sold -------------------- */

SELECT TOP 5 pizza_name, SUM(quantity) AS Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Orders ASC


/* -------------------- Top 5 pizzas by Total order-------------------- */

SELECT TOP 5 pizza_name, COUNT(DISTINCT(order_id)) AS Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Orders DESC


/* -------------------- Bottom 5 pizzas by Total order-------------------- */

SELECT TOP 5 pizza_name, COUNT(DISTINCT(order_id)) AS Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Orders ASC
