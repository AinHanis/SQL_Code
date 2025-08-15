SELECT * FROM custorder.custorder_copy;

CREATE TABLE `custorder_copy` (
  `order_id` int DEFAULT NULL,
  `customer_name` text,
  `email` text,
  `order_date` text,
  `product_name` text,
  `quantity` text,
  `price` text DEFAULT NULL,
  `country` text,
  `order_status` text,
  `notes` text,
  `rownum` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE custorder_copy
DROP rownum;



/* UPDATE custorder_copy
SET customer_name = TRIM(customer_name); -- to try

UPDATE custorder_copy
SET customer_name = UPPER(customer_name);  -- to try

SELECT INITCAP(customer_name)
from custorder_copy;-- not working no INITCAP command */

-- Standardise the Data

UPDATE custorder_copy
SET `order_date` = str_to_date(`order_date`, '%Y/%m/%d')
WHERE order_id = 1003;

SELECT *
FROM custorder_copy;

UPDATE custorder_copy
SET `order_date`= str_to_date(`order_date`,'%Y-%m-%d');

ALTER TABLE custorder_copy -- change date format from text to DATE
MODIFY COLUMN order_date DATE;

UPDATE custorder_copy  -- update single row
SET email = 'tom.obrien@gmail.com'
WHERE order_id = 1004;

UPDATE custorder_copy
SET customer_name = 'Jessica'
WHERE order_id = 1009;

-- standardise name format
-- 1. From AI generated code
SELECT 
    customer_name,
    CONCAT(
        UPPER(LEFT(customer_name, 1)), -- Capitalize first letter
        LOWER(SUBSTRING(customer_name, 2, LOCATE(' ', customer_name) - 1)), -- Lowercase first word
        ' ',
        UPPER(SUBSTRING(customer_name, LOCATE(' ',customer_name ) + 1, 1)), -- Capitalize second word
        LOWER(SUBSTRING(customer_name, LOCATE(' ', customer_name) + 2)) -- Lowercase rest
    ) AS formatted_name
FROM custorder_copy
WHERE customer_name IS NOT NULL AND customer_name != '';


-- 2. From SQL code
SELECT DISTINCT customer_name
FROM custorder_copy;

SELECT customer_name,
(CASE
	WHEN LOWER(customer_name) LIKE '%john smith%' THEN 'John Smith'
    WHEN LOWER(customer_name) LIKE '%sarah thompson%' THEN 'Sarah Thompson'
	WHEN LOWER(customer_name) LIKE '%tom o\'brien' THEN 'Tom O\'brien'
	WHEN LOWER(customer_name) LIKE '%mary johnson%' THEN 'Mary Johnson'
	WHEN LOWER(customer_name) LIKE '%ankit patel%' THEN 'Ankit Patel'
	WHEN LOWER(customer_name) LIKE '%carlos hernã¡ndez%' THEN 'Carlos Hernã¡ndez'
	WHEN LOWER(customer_name) LIKE '%jessica%' THEN 'Jessica'
	WHEN LOWER(customer_name) LIKE '%aisha khan%' THEN 'Aisha Khan'
	ELSE 'Other'
END) AS cleaned_name
FROM custorder_copy;


UPDATE custorder_copy
SET customer_name = (CASE
	WHEN LOWER(customer_name) LIKE '%john smith%' THEN 'John Smith'
    WHEN LOWER(customer_name) LIKE '%sarah thompson%' THEN 'Sarah Thompson'
	WHEN LOWER(customer_name) LIKE '%tom o\'brien' THEN 'Tom O\'brien'
	WHEN LOWER(customer_name) LIKE '%mary johnson%' THEN 'Mary Johnson'
	WHEN LOWER(customer_name) LIKE '%ankit patel%' THEN 'Ankit Patel'
	WHEN LOWER(customer_name) LIKE '%carlos hernã¡ndez%' THEN 'Carlos Hernã¡ndez'
	WHEN LOWER(customer_name) LIKE '%jessica%' THEN 'Jessica'
	WHEN LOWER(customer_name) LIKE '%aisha khan%' THEN 'Aisha Khan'
	ELSE 'Other'
END);

SELECT *
from custorder_copy;

SELECT order_id,price
FROM custorder_copy;

UPDATE custorder_copy
SET price = 399.99
WHERE order_id = 1002;

UPDATE custorder_copy
SET price = default
WHERE order_id = 1014;

UPDATE custorder_copy
SET price = 1099
WHERE order_id = 1008;

/* SELECT FORMAT(399.99, 'C', 'en-US') AS formatp, price
FROM custorder_copy; */

/* SELECT order_id, CONCAT('$', price) AS formatp, price
FROM custorder_copy; */

-- Check and remove duplicates

SELECT *,
	ROW_NUMBER() OVER(PARTITION BY customer_name, order_date, product_name, quantity, price, country, order_status) AS row_num
	FROM custorder_copy;


ALTER TABLE custorder_copy
DROP row_num;

CREATE TABLE `custorder_copy2` (
  `order_id` int DEFAULT NULL,
  `customer_name` text,
  `email` text,
  `order_date` date DEFAULT NULL,
  `product_name` text,
  `quantity` text,
  `price` text,
  `country` text,
  `order_status` text,
  `notes` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT custorder_copy2
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY customer_name, order_date, product_name, quantity, price, country, order_status) AS row_num
	FROM custorder_copy;

SELECT *
FROM custorder_copy2
WHERE row_num > 1;

WITH duplicate_cte AS 
(
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY customer_name, order_date, product_name, quantity, price, country, order_status) AS row_num
	FROM custorder_copy2
)
DELETE 
FROM custorder_copy2
WHERE row_num > 1;


SELECT*
FROM custorder_copy2;

