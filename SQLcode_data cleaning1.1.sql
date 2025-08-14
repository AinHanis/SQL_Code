-- Data Cleaning 2nd Attempt on Remove Duplicates  (11/8/2025-Isnin)
SELECT *
FROM layoffs;

-- REMOVE DUPLICATES
-- CREATE COPY OF ORIGINAL DATA

CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT INTO layoffs_copy
SELECT *
FROM layoffs;

SELECT * FROM layoffs_copy; -- TO SEE NEW TABLE

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,date,stage,country,funds_raised_millions) AS row_num
FROM layoffs_copy;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,date,stage,country,funds_raised_millions) AS row_num
FROM layoffs_copy
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_copy
WHERE company = 'Yahoo';

CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_copy2
WHERE row_num > 1;

INSERT INTO layoffs_copy2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,date,stage,country,funds_raised_millions) AS row_num
FROM layoffs_copy;

DELETE
FROM layoffs_copy2
WHERE row_num > 1;

SELECT *
FROM layoffs_copy2;



