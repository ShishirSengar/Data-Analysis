-- SQL Retail sales analysis - P1

create database mysql_project_p1;

use mysql_project_p1;

-- Create Tables
create table retail_sales(
	transactions_id	int primary key,
    sale_date DATE,
    sale_time time,
    customer_id	int,
    gender varchar(15),
    age	int,
    category varchar(15),	
    quantiy	int,
    price_per_unit float,	
    cogs float,
    total_sale float
);

alter table retail_sales
rename column quantiy to quantity;

-- Data Cleaning
delete from retail_sales where 
transactions_id is null
or 
sale_time is null
or
sale_date is null
or
customer_id is null
or
gender is null 
or
age is null
or 
category is null
or 
quantity is null 
or 
price_per_unit is null 
or
cogs is null 
or 
total_sale is null;

select count(*) from retail_sales;

-- Data Exploration
-- How many sales we have ?
select count(*) as total_sale from retail_sales;

-- How many unique customers we have ?
select count(distinct(customer_id)) as no_of_customers from retail_sales;

-- How many unique category we have ?
select count(distinct(category)) as no_of_category from retail_sales;

select distinct category from retail_sales;

-- Data Analysis & Business key problems and answers 

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date = '2022-11-05';
-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales where category = 'Clothing' and quantity >= 4 and date_format(sale_date, '%Y-%m') = '2022-11';
-- Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sales from retail_sales group by category;
-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as average_age from retail_sales where category = 'Beauty';
-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale > 1000;
-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(*) as total_transaction from retail_sales
group by category, gender
order by total_transaction;
-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select Year, Month, average_sale from 
(
select year(sale_date) as Year, month(sale_date) as Month , round(avg(total_sale),2) as average_sale,
rank() over(partition by year(sale_date) order by round(avg(total_sale),2) desc) as rnk
from retail_sales
group by year(sale_date) , month(sale_date)
) t 
where rnk = 1;
-- Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sale) total_sales from retail_sales
group by customer_id 
order by total_sales desc 
limit 5;
-- Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct(customer_id)) as customer_count from retail_sales
group by category;
-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
with hourly_sales as 
(
select *,
case 
	when hour(sale_time) < 12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'Afternoon'
    else 'Evening'
end as shift
from retail_sales
)
select shift, count(*) as num_of_orders from hourly_sales
group by shift;



