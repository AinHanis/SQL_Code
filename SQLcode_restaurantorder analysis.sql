USE restaurant_db;
-- OBJECTIVE 1 TASK:
-- 1. View the menu_items table
SELECT * FROM menu_items;
-- 2. write a query to find the number of items on the menu
SELECT COUNT(*)
FROM menu_items;
-- 3. What are the least and most expensive items on the menu
SELECT * FROM menu_items
ORDER by price DESC;
-- Answer: Most expensive: Shrimp Scampi (Italian) - 19.95  Least Expensive: Edamame (Asian) - 5.00
-- 4. How many Italian dishes are on the menu?
SELECT COUNT(*)
FROM menu_items
WHERE category='ITALIAN';
-- 5. What are the least and most expensive Italian dishes on the menu?
SELECT *
FROM menu_items
WHERE category='ITALIAN'
ORDER BY price; -- For least expensive

SELECT *
FROM menu_items
WHERE category='ITALIAN'
ORDER BY price DESC; -- For most expensive
-- 6. How many dishes are in each category?
SELECT category, COUNT(menu_item_id) AS number_dishes
FROM menu_items
GROUP BY category;

-- 7. What is the average dish price within each category?
SELECT category, AVG(price) AS average_price
FROM menu_items
GROUP BY category;

-- OBJECTIVE 2 TASK:
-- 1. View the order_details table
SELECT * FROM order_details;
-- 2. What is the date range of the table?
SELECT * FROM order_details
ORDER BY order_date;
-- or use other way use MIN and MAX
SELECT MIN(order_date), MAX(order_date) FROM order_details;
-- 3. How many orders were made within this date range? 
SELECT COUNT(DISTINCT order_id) FROM order_details;
-- 4. How many items were ordered within date range
SELECT COUNT(*) FROM order_details;
-- 5. Which orders had the most number of items?
SELECT order_id , COUNT(item_id) AS number_items
FROM order_details
GROUP BY order_id
ORDER BY number_items DESC;
-- 6. How many orders had more than 12 items?
-- SELECT COUNT(*) FROM
SELECT order_id, COUNT(item_id) AS number_items
FROM order_details
GROUP BY order_id
HAVING number_items > 12;  -- AS number_orders; -- SUBQUERY TO IDENTIFY NUMBER ORDERS BASED ON TOTAL ROW

-- OBJECTIVE 3 TASK (ANALYZE CUSTOMER BEHAVIOUR);

-- 1. Combine the menu_items and order_details into a single table
SELECT * -- typically when joining table, start with table yg ada transaction baru lookup table which contain detail
FROM menu_items mi
JOIN order_details od -- INNER JOIN
 ON mi.menu_item_id = od.item_id;
SELECT *
FROM order_details od
LEFT JOIN menu_items mi -- LEFT JOIN will include all record from left table termasuk yg contains NULL
 ON od.item_id = mi.menu_item_id;

 
-- 2. What were the least and most ordered items?
SELECT item_name, COUNT(order_id) AS number_purchases
FROM order_details od
LEFT JOIN menu_items mi -- LEFT JOIN will include all record from left table termasuk yg contains NULL
 ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY number_purchases DESC; 
-- ANSWER: Most ordered: Hamburger, Least ordered: Chicken Tacos

-- 3. What categories were they in?
SELECT mi.item_name, mi.category, COUNT(od.order_id) AS number_purchases
FROM order_details od
LEFT JOIN menu_items mi -- LEFT JOIN will include all record from left table termasuk yg contains NULL
 ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.category
ORDER BY number_purchases;

-- 4. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spend
FROM order_details od
LEFT JOIN menu_items mi -- LEFT JOIN will include all record from left table termasuk yg contains NULL
 ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend desc
LIMIT 5;

-- 5. View the details of the highest spend order. What insight can you gather from the results?
SELECT category, COUNT(item_id) AS number_items
FROM order_details od
LEFT JOIN menu_items mi -- LEFT JOIN will include all record from left table termasuk yg contains NULL
 ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category;

-- 6. BONUS: View the details of the top 5 highest spend orders. What insight can you gather from the result

SELECT order_id,category, COUNT(item_id) AS number_items
FROM order_details od
LEFT JOIN menu_items mi -- LEFT JOIN will include all record from left table termasuk yg contains NULL
 ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075,1957,330,2675)
GROUP BY order_id,category;
-- ANSWER: Most customer love Italian food which record highest number of order
-- output for top 5 highest spent order for my reference
-- (440,	192.15, ,2075,	191.05 ,1957,	190.10 ,330, 189.70 ,2675,	185.10)


SELECT order_id, COUNT(item_id) AS numb_items

