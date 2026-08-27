use Sakila;

select * from film;

-- Q1. How many total customers are there in the Sakila database?
select count(*) from customer;

-- Q2. How many total films are there?
select count(*) from film;

-- Q3. What are the unique ratings for films?
select distinct rating from film;

-- Q4. Find films with a PG-13 rating.
SELECT 
    title, rating
FROM
    film
WHERE
    rating = 'PG-13';
    
-- Q5. Find films whose rental rate is $2.99.

select * from film;

SELECT 
    title, rental_rate
FROM
    film
WHERE
    rental_rate = 2.99;

-- Q6. Find the top 10 longest films.

SELECT 
    title, length
FROM
    film
ORDER BY length DESC
LIMIT 10;

-- Q7. How many films are there in each rating category?

select * from film;
select distinct rating from film;
-- PG, G, NC-17, PG-13, release savepoint
SELECT 
    rating, COUNT(title) AS total_film
FROM
    film
GROUP BY rating ;

-- Q8. What is the average film rental rate?

SELECT 
    AVG(rental_rate) AS avg_rate
FROM
    film;

-- Q9. Calculate the average rental rate for each rating?.

SELECT 
    rating, AVG(rental_rate) AS avg_rental_rate
FROM
    film
GROUP BY rating;

-- Q10. How many rentals has each customer made?

SELECT 
    c.customer_id, COUNT(r.rental_id) AS rent_qty
FROM
    customer c
        LEFT JOIN
    rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY rent_qty DESC;

-- Q11. Show each customer's first name, last name, and their total number of rentals.

SELECT 
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rental
FROM
    customer c
        LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY c.first_name , c.last_name
ORDER BY total_rental DESC;

-- Q12. Show the customers name and rental date for every rental.

SELECT 
    c.first_name, c.last_name, rental_id, r.rental_date
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
ORDER BY r.rental_date DESC;

-- Q13. Show the film title for every rental.
 
SELECT 
    r.rental_id, f.title
FROM
    rental r
        INNER JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    film f ON f.film_id = i.film_id;
 
 -- Q14. Show customer name + film title + rental date.
 
 select * from customer;
 select * from rental;
 select * from inventory;
 select * from film;
 
SELECT 
    c.first_name, c.last_name, f.title, r.rental_date
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    film f ON f.film_id = i.film_id;

-- Q15. How many rentals occurred in each film category?

 select * from inventory;
 select * from film_category;
 select * from rental;
    
SELECT 
    fc.category_id, count(r.rental_id) as total_rental
FROM
    film_category fc
        INNER JOIN
    inventory i ON fc.film_id = i.film_id
        JOIN
    rental r ON i.inventory_id = r.inventory_id
GROUP BY fc.category_id;

-- 														
-- Q16. How much did each customer pay in total?

SELECT 
    c.customer_id, SUM(p.amount) AS total_amount
FROM
    customer c
        LEFT JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- Q17. Find the top 10 highest-spending customers.

SELECT 
    c.customer_id , sum(p.amount) as total_amount
FROM
    customer c
        INNER JOIN
    payment p ON c.customer_id = p.customer_id
    group by   c.customer_id
    order by total_amount desc limit 10;

-- Q18. Which film category generated the most revenue?

select *from film_category; -- flim_id and categ_id
select * from inventory; -- film_id and storeid and inven_id
select * from rental; -- rnt_id and cust_id and inven_id
select *from payment;  -- cust_id and rnt_id

SELECT 
    fc.category_id, SUM(p.amount) AS revenue
FROM
    film_category fc
        INNER JOIN
    inventory i ON fc.film_id = i.film_id
        JOIN
    rental r ON i.inventory_id = r.inventory_id
    JOIN
    payment p on r.rental_id = p.rental_id
GROUP BY fc.category_id
ORDER BY revenue DESC;

-- Q19. Calculate the total revenue for each store?

select *from store; -- store_id
select *from staff; -- store_id, staff_id
select *from payment; -- customer_id, staff_id

select s.store_id, SUM(p.amount) AS revenue
FROM
    store s
        INNER JOIN
    staff sf ON s.store_id = sf.store_id
        JOIN
    payment p ON sf.staff_id = p.staff_id
GROUP BY s.store_id
ORDER BY revenue DESC;

-- Q20. Which staff member processes the most revenue?

select *from staff; -- store_id staff_id
select *from store; -- store_id
select *from payment; -- customer_id, staff_id

select sf.staff_id, SUM(p.amount) AS revenue
FROM
    store s
        INNER JOIN
    staff sf ON s.store_id = sf.store_id
        JOIN
    payment p ON sf.staff_id = p.staff_id
GROUP BY sf.staff_id
ORDER BY revenue DESC;


-- Q21. Find customers who spend more than the average customer spending.

select *from customer; -- customer_id
select *from payment; -- customer_id,

-- total spending 
SELECT 
    customer_id, SUM(amount) AS total_spending
FROM
    payment
GROUP BY customer_id;

-- avg spending from  total spending

SELECT 
    AVG(total_spending)
FROM
    (SELECT 
        customer_id, SUM(amount) AS total_spending
    FROM
        payment
    GROUP BY customer_id) AS customer_spending;

-- customer spend more then avg customer 

SELECT 
    customer_id, total_spending
FROM
    (SELECT 
        customer_id, SUM(amount) AS total_spending
    FROM
        payment
    GROUP BY customer_id) AS customer_spending
WHERE
    total_spending > (SELECT 
            AVG(total_spending)
        FROM
            (SELECT 
                customer_id, SUM(amount) AS total_spending
            FROM
                payment
            GROUP BY customer_id) AS customer_spending);

-- Q22. Find films whose rental rate is greater than the average rental rate?

select * from film;

SELECT 
    film_id,
    title,
    rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
);

-- Q23. Calculate each customer's total spending using a CTE, then find the top 10 customers.
select * from customer;
select * from payment;

WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spending
FROM customer_spending
ORDER BY total_spending DESC
LIMIT 10;

-- Q24. Calculate each category's revenue using a CTE, then find the highest-revenue category.

WITH category_revenue AS (
    SELECT 
        fc.category_id,
        SUM(p.amount) AS revenue
    FROM film_category fc
    INNER JOIN inventory i 
        ON fc.film_id = i.film_id
    INNER JOIN rental r 
        ON i.inventory_id = r.inventory_id
    INNER JOIN payment p 
        ON r.rental_id = p.rental_id
    GROUP BY fc.category_id
)
SELECT 
    category_id,
    revenue
FROM category_revenue
ORDER BY revenue DESC
LIMIT 1;


-- Q25. Rank each customer based on their total spending.

select * from payment;

with customer_spending as (
select 
	customer_id,
	sum(amount) as total_spending
    from payment
    group by customer_id
    )
select 
	customer_id, total_spending,
rank() over (order by total_spending desc) as ranking
from customer_spending;

-- Q26. Rank films within each category by rental count.
   
select * from film_category; -- category_id, film_id
select * from inventory; -- film_id, inventory_id, store_id
select * from rental; -- rental_id, inventory_id, customer_id, staff_id

with film_rental as 
(
	select 
		fc.category_id,
		fc.film_id,
		count(r.rental_id) as rental_count
	from film_category fc
	join inventory i
		on fc.film_id = i.film_id
	join rental r 
		on i.inventory_id = r.inventory_id
	group by fc.category_id, fc.film_id
)
select 
	category_id,
    film_id,
    rental_count,
	rank() over (partition by category_id order by rental_count desc) as ranking
from film_rental;

-- Q27. Find the top 3 films by rental count in each category?

with film_rental as 
(
	select 
		fc.category_id,
		fc.film_id,
		count(r.rental_id) as rental_count
	from film_category fc
	join inventory i
		on fc.film_id = i.film_id
	join rental r 
		on i.inventory_id = r.inventory_id
	group by fc.category_id, fc.film_id
),
ranked_film as (
	select 
		category_id,
		film_id,
		rental_count,
		rank() over (partition by category_id order by rental_count desc) as ranking
	from film_rental )
select
	* from ranked_film 
	WHERE ranking <= 3;
	
-- Q28. Calculate each month's total revenue and compare it with the previous month's revenue.

select * from payment;

with monthly_revenue as (	
    select 
		date_format(payment_date, '%Y-%m') as month,
		sum(amount) as revenue
	from payment
	group by month 
)
select
	month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as previous_revenue
from monthly_revenue;

-- Q29. Calculate each month's total revenue and compare it with the previous month's revenue and
--  also show the revenue difference from the previous month. 

with monthly_revenue as (	
    select 
		date_format(payment_date, '%Y-%m') as month,
		sum(amount) as revenue
	from payment
	group by month 
),
comparision_month as 
    (select month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as previous_revenue
    from monthly_revenue)
select 
	month,
    revenue,
    previous_revenue,
   (revenue - previous_revenue) as revenue_diff
    from comparision_month;

-- Q30. Calculate the month-over-month revenue growth percentage.

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') AS month,
        SUM(amount) AS revenue
    FROM payment
    GROUP BY month
),
monthly_comparison AS (
    SELECT 
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    previous_revenue,
    ((revenue - previous_revenue) / NULLIF(previous_revenue, 0)) * 100 AS mom_growth_pct
FROM monthly_comparison;



						



