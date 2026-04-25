# **Sales Insights Data Analysis Project**

-- Data for the project is provided by the name "db_data".

-- Data Analysis using mysql

1. Show all customer records.
select * from customers;

2. Show total number of customers.
select count(*) from customers;

3. Show transactions for chennai market.
select * from transactions where market_code = "Mark001";

4. Show distinct product codes that were sold in chennai.
select distinct product_code from transactions where market_code = "Mark001";

5. Show transactions where currency is US dollars.
select * from transactions where currency = "USD";

6. Show transactions in 2020 join by date table.
select * from transactions t 
inner join date d 
on t.order_date = d.date
where d.year = 2020;

7. Show total revenue in year 2020.
select sum(t.sales_amount) from transactions t 
inner join date d
on t.order_date = d.date
where d.year = 2020 and t.currency = "INR\r" or t.currency = "USD\r";

8. Show total revenue in year 2020, January Month.
SELECT sum(t.sales_amount) from transactions t 
inner join date d on t.order_date = d.date 
where d.year=2020 and d.month_name="January" and (t.currency="INR\r" or t.currency="USD\r");

9. Show total revenue in year 2020 in Chennai.
SELECT sum(t.sales_amount) from transactions t 
inner join date d on t.order_date = d.date 
where d.year=2020 and t.market_code="Mark001";
