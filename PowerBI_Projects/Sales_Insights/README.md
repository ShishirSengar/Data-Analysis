# 📊 Sales Insights Data Analysis Project

## 📁 Project Overview

This project focuses on analyzing sales data using **MySQL** to extract meaningful business insights such as revenue trends, customer distribution, and market performance.

* Dataset used: **`db_data`**

---

## 🛠️ Tools & Technologies

* MySQL
* SQL (Joins, Aggregations, Filtering)

---

## 📌 Data Analysis Queries

### 1. Show all customer records

```sql
SELECT * FROM customers;
```

---

### 2. Show total number of customers

```sql
SELECT COUNT(*) FROM customers;
```

---

### 3. Show transactions for Chennai market

```sql
SELECT * 
FROM transactions 
WHERE market_code = 'Mark001';
```

---

### 4. Show distinct product codes sold in Chennai

```sql
SELECT DISTINCT product_code 
FROM transactions 
WHERE market_code = 'Mark001';
```

---

### 5. Show transactions where currency is US Dollars

```sql
SELECT * 
FROM transactions 
WHERE currency = 'USD';
```

---

### 6. Show transactions in the year 2020

```sql
SELECT * 
FROM transactions t
INNER JOIN date d 
ON t.order_date = d.date
WHERE d.year = 2020;
```

---

### 7. Show total revenue in the year 2020

```sql
SELECT SUM(t.sales_amount) AS total_revenue
FROM transactions t
INNER JOIN date d 
ON t.order_date = d.date
WHERE d.year = 2020 
AND (t.currency = 'INR' OR t.currency = 'USD');
```

---

### 8. Show total revenue in January 2020

```sql
SELECT SUM(t.sales_amount) AS january_revenue
FROM transactions t
INNER JOIN date d 
ON t.order_date = d.date
WHERE d.year = 2020 
AND d.month_name = 'January'
AND (t.currency = 'INR' OR t.currency = 'USD');
```

---

### 9. Show total revenue in Chennai (2020)

```sql
SELECT SUM(t.sales_amount) AS chennai_revenue
FROM transactions t
INNER JOIN date d 
ON t.order_date = d.date
WHERE d.year = 2020 
AND t.market_code = 'Mark001';
```

---

## 📈 Key Insights

* Revenue trends across different markets
* Monthly sales performance
* Customer distribution
* Product demand analysis

---

## 🚀 How to Use

1. Import the dataset (`db_data`) into MySQL
2. Run the above queries in MySQL Workbench
3. Analyze the outputs for insights

Feel free to connect for feedback or collaboration.
