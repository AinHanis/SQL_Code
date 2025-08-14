-- Practice Data Cleaning 2 (12/8/2025-Selasa)
USE custorder;

CREATE TABLE custorder_copy
LIKE `customer_orders - sheet1`;

SELECT product_name
FROM custorder_copy;


INSERT custorder_copy
SELECT *
FROM `customer_orders - sheet1`;

-- Standardise order_status 

SELECT order_status,
(CASE
	WHEN LOWER(order_status) LIKE '%deliver%' THEN 'Delivered'
    WHEN LOWER(order_status) LIKE '%return%' THEN 'Returned'
	WHEN LOWER(order_status) LIKE '%shipped%' THEN 'Shipped'
	WHEN LOWER(order_status) LIKE '%pending%' THEN 'Pending'
	WHEN LOWER(order_status) LIKE '%refund%' THEN 'Refunded'
	ELSE 'Other'
END) AS cleaned_order_status
FROM custorder_copy;

UPDATE custorder_copy 
SET 
    order_status = (CASE
        WHEN LOWER(order_status) LIKE '%deliver%' THEN 'Delivered'
        WHEN LOWER(order_status) LIKE '%return%' THEN 'Returned'
        WHEN LOWER(order_status) LIKE '%shipped%' THEN 'Shipped'
        WHEN LOWER(order_status) LIKE '%pending%' THEN 'Pending'
        WHEN LOWER(order_status) LIKE '%refund%' THEN 'Refunded'
        ELSE 'Other'
    END);
-- Standardise order_status 


SELECT product_name,
(CASE
	WHEN LOWER(product_name) LIKE '%apple watch%' THEN 'Apple Watch'
    WHEN LOWER(product_name) LIKE '%samsung galaxy s22%' THEN 'Samsung Galaxy S22'
	WHEN LOWER(product_name) LIKE '%google pixel%' THEN 'Google Pixel'
	WHEN LOWER(product_name) LIKE '%macbook pro%' THEN 'MacBook Pro'
	WHEN LOWER(product_name) LIKE '%iphone 14%' THEN 'iPhone 14'
	ELSE 'Other'
END) AS cleaned_product_name
FROM custorder_copy;

UPDATE custorder_copy 
SET 
    product_name = (CASE
	WHEN LOWER(product_name) LIKE '%apple watch%' THEN 'Apple Watch'
    WHEN LOWER(product_name) LIKE '%samsung galaxy s22%' THEN 'Samsung Galaxy S22'
	WHEN LOWER(product_name) LIKE '%google pixel%' THEN 'Google Pixel'
	WHEN LOWER(product_name) LIKE '%macbook pro%' THEN 'MacBook Pro'
	WHEN LOWER(product_name) LIKE '%iphone 14%' THEN 'iPhone 14'
	ELSE 'Other'
END);

-- Clean quantity field
-- FROM VIDEO
SELECT *,
	CASE
		WHEN LOWER(quantity) = 'two' THEN 2
		ELSE CAST(quantity AS INT 64)
	END AS cleaned_quantity
FROM custorder_copy;

-- UPDATING A SINGLE ROW
UPDATE custorder_copy
SET quantity = 2
WHERE order_id = 1003; -- identify record yg need to be updated

-- CLEAN COUNTRY NAME

SELECT country
FROM custorder_copy;

SELECT  DISTINCT country
FROM custorder_copy;

SELECT DISTINCT country
FROM custorder_copy
WHERE country REGEXP '^u|s$';

UPDATE custorder_copy
SET country = 'USA'
WHERE country IN ('usa', 'US', 'United States');


UPDATE custorder_copy
SET country = 'UK'
WHERE country IN ('UK', 'uk', 'United Kingdom');

UPDATE custorder_copy
SET country = 'Canada'
WHERE country IN ('canada', 'CANADA');

UPDATE custorder_copy
SET country = 'Spain'
WHERE country LIKE 'spain';

UPDATE custorder_copy
SET country = 'India'
WHERE country IN ('india');

-- REMOVE DUPLICATE

SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY LOWER(email), LOWER(product_name)
ORDER BY order_id) AS rownum
FROM custorder_copy;


-- TO ADD NEW COLUMN KAT CUSTORDER_COPY 
CREATE TABLE `custorder_copy` (
  `order_id` int DEFAULT NULL,
  `customer_name` text,
  `email` text,
  `order_date` text,
  `product_name` text,
  `quantity` text,
  `price` text,
  `country` text,
  `order_status` text,
  `notes` text,
  `rownum` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ADD NEW COLUMN 2ND METHOD
ALTER TABLE custorder_copy
ADD rownum INT;

SELECT *
FROM custorder_copy;

UPDATE custorder_copy
SET rownum = 1 -- (1,2,1,2,1,1,1,1,1,2,1,2,1,10)
WHERE order_id = 1001; -- (,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015);

UPDATE custorder_copy
SET rownum = 1 -- (2,1,2,1,1,1,1,1,2,1,2,1,10)
WHERE order_id = 1002;

UPDATE custorder_copy
SET rownum = 2 -- (1,2,1,1,1,1,1,2,1,2,1,10)
WHERE order_id = 1003;

UPDATE custorder_copy
SET rownum = 1 -- (2,1,1,1,1,1,2,1,2,1,10)
WHERE order_id = 1004;

UPDATE custorder_copy
SET rownum = 2 -- (1,1,1,1,1,2,1,2,1,10)
WHERE order_id = 1005;

UPDATE custorder_copy
SET rownum = 1 -- (1,1,1,1,2,1,2,1,10)
WHERE order_id = 1006;

UPDATE custorder_copy
SET rownum = 1 -- (1,1,1,2,1,2,1,10)
WHERE order_id = 1007;

UPDATE custorder_copy
SET rownum = 1 -- (1,1,2,1,2,1,10)
WHERE order_id = 1008;

UPDATE custorder_copy
SET rownum = 1 -- (1,2,1,2,1,10)
WHERE order_id = 1009;

UPDATE custorder_copy
SET rownum = 1 -- (2,1,2,1,10)
WHERE order_id = 1010;

UPDATE custorder_copy
SET rownum = 2 -- (1,2,1,10)
WHERE order_id = 1011;

UPDATE custorder_copy
SET rownum = 1 -- (2,1,10)
WHERE order_id = 1012;

UPDATE custorder_copy
SET rownum = 2 -- (1,10)
WHERE order_id = 1013;

UPDATE custorder_copy
SET rownum = 1 -- (1,2,1,2,1,1,1,1,1,2,1,2,1,10)
WHERE order_id = 1014;

UPDATE custorder_copy
SET rownum = 1 -- (1,2,1,2,1,1,1,1,1,2,1,2,1,10)
WHERE order_id = 1015;


SELECT * -- to remove duplicate frm vid tuto but it give error
FROM 
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY LOWER(email), LOWER(product_name)
ORDER BY order_id) AS row_num
FROM custorder_copy)
WHERE row_num = 1;

SELECT * , -- 2nd attempt
(ROW_NUMBER() OVER(
PARTITION BY LOWER(email), LOWER(product_name)
ORDER BY order_id) 
FROM custorder_copy
)
WHERE row_num > 1; 


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2),
    customer_id INT,
    order_date DATE
);

INSERT INTO transactions
VALUES  (1000, 4.99, 3, "2023-01-01"),
  (1001, 2.89, 2, "2023-01-01"),
  (1002, 3.38, 3, "2023-01-02"),
  (1003, 4.99, 1, "2023-01-02"),
  (1004, 1.00, NULL, "2023-01-03"),
  (1005, 2.49, 4, "2023-01-03"),
  (1006, 5.48, NULL, "2023-01-03");
        
SELECT * FROM transactions;

-- GROUP BY Practice 
SELECT COUNT(amount), order_date -- count how many transaction were made on each date
FROM transactions
GROUP BY order_date;

SELECT COUNT(amount), customer_id
FROM transactions
GROUP BY customer_id
HAVING COUNT(amount) >1 AND customer_id IS NOT NULL ;  -- CHECK CUSTOMER DATANG BERAPA KALI


SELECT SUM(amount), customer_id
FROM transactions
GROUP BY customer_id WITH ROLLUP; -- ROLL UP UTK TENGOK TOTAL ALL OUTPUT

SELECT * FROM transactions;

SELECT count(transaction_id), order_date
FROM transactions
GROUP BY order_date WITH ROLLUP;

SELECT DISTINCT order_date
FROM transactions
WHERE customer_id = 1;

SELECT amount, order_date
FROM transactions
WHERE order_date > '2023-01-02';

