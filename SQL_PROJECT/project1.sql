SELECT * FROM sql_project_p2.retail_sales;

SELECT 
    COUNT(*) 
FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?    
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    sale_date LIKE '2022-11%'
    AND
    quantity >= 4;
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) as total_sales FROM retail_sales
	GROUP BY category;
    
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, AVG(age) as average_age_of_customersn FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender,COUNT(transaction_id) as total_number_of_transactions FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * 
FROM(
	SELECT YEAR(sale_date), 
    MONTH(sale_date) , 
    AVG(total_sale), 
    rank() OVER (partition by YEAR(sale_date) order by AVG(total_sale) DESC) as bruh 
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
) as OHNO
WHERE bruh = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT(customer_id)) as num FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;