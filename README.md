# Sakila Database — SQL Practice & Business Analysis

A collection of SQL queries solved on the **Sakila** sample database (MySQL), moving from basic filtering to joins, aggregation, subqueries, CTEs, and window functions. Built as hands-on practice for Data Analyst interview preparation.

## 📌 About the Project

This project answers 31 business-style questions against the Sakila DVD rental database — customer behavior, film ratings, revenue by store/staff/category, and month-over-month growth. Each query is written to answer a specific question a business stakeholder might ask, not just to demonstrate syntax.

## 🗂️ Database

- **Database:** Sakila (official MySQL sample database)
- **Key tables used:** `customer`, `film`, `film_category`, `inventory`, `rental`, `payment`, `staff`, `store`
- Download: [MySQL Sakila Sample Database](https://dev.mysql.com/doc/sakila/en/)

## 🛠️ Tools & Concepts Used

- MySQL
- Joins: `INNER JOIN`, `LEFT JOIN`
- Aggregate functions: `COUNT`, `SUM`, `AVG`
- Subqueries (correlated & non-correlated)
- Common Table Expressions (CTEs)
- Window functions: `ROW_NUMBER()`, `RANK()`, `LAG()`
- `GROUP BY` / `HAVING` / `ORDER BY`
- `NULLIF`, `DATE_FORMAT`

## 📁 Repository Structure

```
├── README.md
├── sakila_queries.sql          # All 31 queries with question comments
└── sakila_sql_questions.docx   # Questions listed separately, without solutions
```

## 📊 Sample Questions Covered

- How many rentals has each customer made?
- Find the top 10 highest-spending customers.
- Which film category generated the most revenue?
- Rank films within each category by rental count using window functions.
- Calculate month-over-month revenue growth percentage.

*(Full list of 31 questions in `sakila_sql_questions.docx`)*

## 🚀 How to Run

1. Install MySQL and load the Sakila sample database.
2. Clone this repo:
   ```bash
   git clone https://github.com/<Rehan-codes24>/<sakila_dataset>.git
   ```
3. Open `sakila_queries.sql` in MySQL Workbench (or any SQL client) and run queries individually.

## 👤 Author

**Rehan** — BCA (AI/ML) student, transitioning into Data Analytics.
[www.linkedin.com/in/rehan-khan-7b9a86250](#) • [https://github.com/Rehan-codes24](#)
