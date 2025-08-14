-- Date 18/7/2025 Exercise1 - return all product
SELECT name, unit_price, unit_price*1.1 AS new_price
FROM products;

-- WHERE Clause = To filter data
-- Comparison Operators = >, >=, <, <=,=, Not Equal Operator (!= or <>)
-- Can use comparison operator with date value
SELECT *
FROM customers
WHERE birth_date > '1990-01-01';
-- Date 18/7/2025 Exercise2 - get orders placed this year
SELECT *
FROM orders
WHERE order_date >= '2019-01-01';

-- How to combine multiple search condition when filtering data use AND operator (BOTH CONDITION ARE TRUE). OR operator (Either one condition is true but compliment result)
-- NOT operator to nagate (batalkan/nafikan/Inverse cond) condition?? cth = if >50, nagate </<=
SELECT *
FROM customers
WHERE birth_date <= '1990-01-01' AND points <= 1000; -- NOT operator tapi versi terus terbalikkan simbol
   -- WHERE NOT (birth_date > '1990-01-01' OR points > 1000)
   -- in bracket n on new line for clarity (points > 1000 AND state = 'va')
-- Date 18/7/2025 Exercise3 - from the order_items table, get the items for order #6 where total prices greater than 30
SELECT *
FROM order_items
WHERE order_id=6 AND unit_price*quantity > 30;

-- IN operator (to Combine and shorten condition)
-- Without IN operator;
SELECT *
FROM customers
WHERE state='VA' OR state='GA' OR state='FL';

-- With IN operator;
SELECT *
FROM customers
WHERE state NOT IN ('VA', 'FL', 'GA');

-- Date 18/7/2025 Exercise 4 - Return products with quantity in stock equal to 49,38,72
SELECT *
FROM products
WHERE quantity_in_stock IN(49,38,72);

-- BETWEEN Operator (Use whenever i compare attribute with a range of values)
-- Without BETWEEN operator
SELECT *
FROM customers
WHERE points>= 1000 AND points<=3000;

-- With BETWEEN operator
SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;

-- Date 18/7/2025 Exercise 5 - Return customer born between 1/1/1990 and 1/1/2000
SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- LIKE Operator (return row that match specific string pattern)
SELECT *
FROM customers
-- WHERE last_name LIKE '%y' -- this pattern means we have any number of character before and after 'b'.
-- % sign can be anywhere depends kita nak cari criteria perkataan tu cane
WHERE last_name LIKE 'B____Y'; -- Underscore utk berapa huruf kita nak depan huruf tertentu
-- % Any number of character
-- _ single character

-- Date 18/7/2025 Exercise 6 - Get customer whose 1. addresses contain TRAIL or AVENUE 2. phone numbers end with 9
-- address contains trail or avenue
SELECT *
FROM customers
WHERE address LIKE '%Trail%' OR 
      address LIKE '%Avenue%';
      
-- phone num end with 9
SELECT *
FROM customers
WHERE phone LIKE '%9'; 

-- REGEXP Operator (Alternative to LIKE)
SELECT *
FROM customers
-- WHERE last_name LIKE '%field%'
-- WHERE last_name REGEXP 'field|mac|rose' -- use multiple bar to find multiple search pattern
WHERE last_name REGEXP '[a-h]e'; -- square bracket use with hyphens (-) to represents a range 

-- Date 23/7/2025 Exercise 7 - Get customers whos
-- 1. first name are ELKA or AMBUR
-- 2. last name end with EY or ON
-- 3. last name start MY or contains SE
-- 4. last name contains B follow by R or U

-- 1 
SELECT *
FROM customers
WHERE first_name REGEXP 'elka|ambur';

-- 2
SELECT *
FROM customers
WHERE last_name REGEXP 'EY$|ON$';

-- 3
SELECT * 
FROM customers
WHERE last_name REGEXP '^MY|SE';

-- 4 
SELECT *
FROM customers
WHERE last_name REGEXP 'b[ru]'; -- 'br|bu'

-- IS NULL Operator - select data that is contain null or vice versa using NOT
SELECT *
FROM  customers
WHERE phone IS NOT NULL;

-- Date 23/7/2025 Exercise 8 - Get the orders that not shipped yet
SELECT *
FROM orders
WHERE shipped_date IS NULL;
-- or WHERE status = 1

-- ORDER BY Clause
SELECT *
FROM customers
ORDER BY last_name DESC, state DESC;

-- Date 23/7/2025 Exercise 9
SELECT *, quantity*unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

-- LIMIT Clause - Limit number of records returned from query
SELECT *
FROM customers
-- LIMIT 10 - keluarkan 10 record customer
-- case: 1-3, 4-6,7-9 - records punya group tapi nak keluarkan 7-9 je..so how?
LIMIT 6,3; -- Limitkan 6 record dari atas and keluarkan 3 je

-- Date 23/7/2025 Exercise 9 - Get top 3 loyal customers (has more points)
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3; -- PICK MOST LOYAL CUST

-- INNER JOINS
SELECT order_id, orders.customer_id, first_name, last_name
FROM orders 
JOIN customers 
	ON orders.customer_id = customers.customer_id;
    
-- Date 24/7/2025 Exercise 10 
-- Join table orders item n products, for each order return product id from each table as well as product name, follow by quantity and unitprice
-- use alias to simplify code
SELECT order_id, o.product_id, p.name, quantity, o.unit_price
FROM order_items o
JOIN products p
	ON o.product_id = p.product_id;
    
-- JOIN ACROSS Databases
-- USE sql_inventory; (LET SAY WE USE THIS DATABASE)
SELECT *
FROM sql_store.order_items o -- put prefix kat order items since it from different database(prefix can be different depend on current database)
JOIN products p 
	ON o.product_id = p.product_id;
    
-- SELF JOINS(2 table)
USE sql_hr;

SELECT 
   e.employee_id, -- put prefix kt each column kita nak
   e.first_name,
   m.first_name AS manager
FROM employees e
JOIN employees m -- JOIN table itself to get manager
	ON e.reports_to = m.employee_id;
    
-- SELF JOIN (more than two table)
USE sql_store;
-- we will combine orders table, order status table and customers table
SELECT 
     orders.order_id,
     orders.order_date,
     customers.first_name,
     customers.last_name,
     order_statuses.name AS status
FROM orders -- main table
JOIN customers -- second table untuk dijoin
  ON orders.customer_id = customers.customer_id
JOIN order_statuses	-- join untuk table ketiga
  ON orders.status = order_statuses.order_status_id;

-- Date 25/7/2025 Exercise 11
-- write query to join clients table with payment table and payment methods table
-- produce payment report with more detail info consists of name of client and payment method
USE sql_invoicing;
SELECT payments.date, payments.invoice_id, payments.amount, clients.name, payment_methods.name
FROM clients
JOIN payments 
	ON clients.client_id = payments.client_id
JOIN payment_methods 
	ON payment_methods.payment_method_id = payments.payment_method;
    
-- COMPOUND JOINS CONDITIONS
-- gabungkan 2 primary key column to uniquely indentify sebab each ada repetitive value.
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
ON oi.order_id = oin.order_Id
AND oi.product_id = oin.product_id;   -- compound join condition

-- IMPLICIT JOIN
-- Example before using implicit join;
SELECT *
FROM orders 
JOIN customers
ON orders.customer_id = customers.customer_id;

-- Example implicit join (instead of using JOIN & ON kita guna WHERE clause)
-- if forgot WHERE clause lead to cross join (result banyak and berulang)
-- Better use explicit syntax JOIN & ON
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id; 

-- **INNER JOIN (previous examples are for inner join)
-- **INNER JOIN can be write with just JOIN clause
SELECT -- this is example of query INNER JOIN biasa
	customers.customer_id,
    customers.first_name,
    orders.order_id
FROM customers
JOIN orders
	ON customers.customer_id = orders.customer_id
ORDER BY customers.customer_id; 
-- result only shows customer id with order je. yg lain takde

-- OUTER JOIN (LEFT OUTER & RIGHT OUTER)
-- Will include values yg tak ada
-- RIGHT outer can be same with INNER but can change position to give all results
-- Cara tulis  RIGHT JOIN / RIGHT OUTER JOIN - both still sama
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o -- When we use LEFT JOIN all records from left table 'customer' will be return wheter the condition is right/wrong'
RIGHT OUTER JOIN customers c
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id ;

-- Date 28/7/2025 Exercise 12
-- Combine product table dgn order item table. Produce 3 colums (product_id, productname, quantity)
-- Use OUTER JOIN

SELECT p.product_id, p.name, oi.quantity
FROM order_items oi 
RIGHT JOIN products p 
	ON p.product_id = oi.product_id; -- THESE ARE JOIN CONDITION

-- OUTER JOINS Between Multiple Table
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c -- When we use LEFT JOIN all records from left table 'customer' will be return wheter the condition is right/wrong'
LEFT JOIN  orders o -- OUTER JOIN
	ON c.customer_id = o.customer_id
JOIN shippers sh -- INNER join
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;
-- **result doesnt show all records which not include unshipped orders

SELECT -- query to include all records of shipping even if its NULL
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c -- When we use LEFT JOIN all records from left table 'customer' will be return wheter the condition is right/wrong'
LEFT JOIN  orders o -- OUTER JOIN
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh -- INNER join
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;


-- Date 29/7/2025 Exercise 13
-- write query that has order_date, order_id, first_name, shippers(name), status
SELECT o.order_date, o.order_id, c.first_name AS customer, s.name AS shipper, os.name AS status
FROM orders o
JOIN customers c -- use inner join bcs every order does have customer
	ON o.customer_id = c.customer_id
LEFT JOIN shippers s
	ON o.shipper_id = s.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id;
    
-- SELF OUTER joins (combine record dari table yg sama)
USE sql_hr;

SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;
    
-- USING clause
USE sql_store;
-- Example1
SELECT o.order_id, c.first_name, sh.name AS shipper
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer_id -- Use USING clause to simplify this ON query
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);

-- Example2
-- Guna table order_items & order_items_notes
-- table order_items ada 2 primary key. how kita nak combine? guna USING clause
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	-- ON oi.order_id = oin.order_id AND
	--   oi.product_id = oin.product_id -- these condition is MESSY
    USING(order_id,product_id); -- much more simple
    
-- Date 29/7/2025 Exercise 14
-- use sql invoicing then write query for payment table to product; date,client,amount,payment method

USE sql_invoicing;
SELECT p.date, c.name AS client, p.amount, pm.name AS payment_method
FROM payments p
JOIN clients c
	USING(client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;
    
-- NATURAL JOIN
USE sql_store;
SELECT o.order_id, c.first_name
FROM orders o
NATURAL JOIN customers c;
 -- tak digalak guna sebab system define sendiri primary key can lead to error

-- CROSS JOIN
SELECT c.first_name AS customer, p.name AS product
FROM customers c -- implicit syntax: FROM customers c, product p
CROSS JOIN products p -- Bentuk explicit sytanx, tulis cross join
ORDER BY c.first_name;

-- Date 29/7/2025 Exercise 14
-- Do a cross join between shippers and products
-- using the IMPLICIT syntax
-- and then using the EXPLICIT syntax
SELECT s.name as shipper, p.name as product -- define column just for clarity je
FROM shippers s, products p; -- IMPLICIT SYNTAX

SELECT *
FROM shippers s
CROSS JOIN products p; -- EXPLICIT SYNTAX

-- UNIONS(COMBINE RECORD FROM MULTIPLE QUERY)
-- Example1 (combine query from same table)
SELECT order_id, order_date, 'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'-- not the ideal way to get order in current year
UNION
SELECT order_id, order_date, 'Archive' AS status
FROM orders
WHERE order_date < '2019-01-01';

-- Example2 (combine query from different table)
SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers;

-- Date 29/7/2025 Exercise 15
-- Write query to produce report contains: customer_id,first_name,points,type(bronze, silver,gold)
-- if p<2000 = bronze, 2000<=p<=3000 = silver, p>3000 = gold
-- Sort result by first name

SELECT customer_id, first_name, points, 'Bronze' AS type
FROM customers
WHERE points<2000
UNION
SELECT customer_id, first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id, first_name, points, 'Gold' AS type
FROM customers
WHERE points>3000
ORDER BY first_name;-- letak kat last sekali

-- COLUMN ATTRIBUTES
-- How to insert,update,delete data

-- INSERT INTO Statement
INSERT INTO customers (last_name,first_name,birth_date,address,city,state)
VALUES ('John', 'Smith','1990-01-01', 'address', 'city', 'CA');

-- INSERTING MULTIPLE ROWS
INSERT INTO shippers (name) -- specify name of column in parenthesis ()
VALUES ('Shipper1'),('Shipper2'),('Shipper3');

-- Date 29/7/2025 Exercise 15
-- Insert three rows in products table

INSERT INTO products (name, quantity_in_stock,unit_price) -- only fill value for non auto increment column(AI) sbb by default sistem isi)
VALUES ('Caramel Cloud9',50,2.50);

-- INSERTING HIERARCHICAL ROWS
-- refer to table orders & order items
-- parent table: orders , child table: order items
INSERT INTO orders (customer_id,order_date,status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES (last_insert_id(),1,1,2.95), 
	   (last_insert_id(),2,1,3.95);
-- SELECT last_insert_id() -- return new latest id for the record

-- CREATE A COPY OF A TABLE
CREATE TABLE orders_archived AS
SELECT * FROM orders; -- result utk ni dah truncate so takde data kat table orders_archived

-- SUBQUERY
INSERT INTO orders_archived
SELECT * -- select statement ni is subquery untuk insert into
FROM orders
WHERE order_date < '2019-01-01';

-- Date 29/7/2025 Exercise 16
-- Back to sql_invoicing database
-- create a copy of invoices table and name it invoices_archived
-- Join table with clients table to insert client name instead of client id
-- use that JOIN query as subquery in create table statement
-- copy ONLY invoices yang ada payment date je

USE sql_invoicing;

CREATE TABLE invoices_archived AS
SELECT  i.invoice_id,i.number,c.name AS client,i.invoice_total,i.payment_total,i.invoice_date,i.due_date,i.payment_date
FROM invoices i
JOIN clients c
	USING (client_id)
WHERE payment_date IS NOT NULL;

-- UPDATING A SINGLE ROW
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice_id = 1; -- identify record yg need to be updated

-- CASE if nak restore record asal untuk invoice id 1
UPDATE invoices
SET payment_total = default, payment_date = NULL
WHERE invoice_id = 1; 

-- UPDATE record for invoice id 3
UPDATE invoices
SET 
	payment_total = invoice_total*0.5,
	payment_date = due_date
WHERE invoice_id = 3; 

-- UPDATING MULTIPLE ROWS
UPDATE invoices
SET 
	payment_total = invoice_total*0.5,
	payment_date = due_date
WHERE client_id = 3; 
-- WHERE client_id IN (3,4)

-- Date 29/7/2025 Exercise 17
-- Use sql store
-- give any customer born before 1990 with 50 extra points

USE sql_store;
UPDATE customers
	SET points = points + 50
WHERE birth_date <'1990-01-01';

-- USE SUBQUERIES IN UPDATES

USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total*0.5,
	payment_date = due_date
WHERE client_id = 
			(SELECT client_id 
			FROM clients
			WHERE state IN ('CA','NY')); -- ERROR TAK DAPATTT
            
-- Date 29/7/2025 Exercise 18
-- SQL store data base, refer orders
-- write query to update comments for customer with >3000 points
-- update comments column and set it to "gold customer"

USE sql_store;
UPDATE orders
SET
	comments = 'Gold Customer'
WHERE customer_id IN
					(SELECT customer_id
					FROM customers
					WHERE points >3000); -- THESE ARE SUBQUERY

-- DELETING ROWS
USE sql_invoicing;

DELETE FROM invoices
WHERE client_id   -- to identify apa kita nak delete if tak it will delete all
				(SELECT *
				FROM clients
				WHERE name = 'Myworks');
                
-- RESTORING THE DATABASES
-- Data semua exercise kat sini dalam file SQL exercise at desktop&dl