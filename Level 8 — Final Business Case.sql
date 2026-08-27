						-- 🏆 — Final Business Case


-- Q. Management wants To understand the overall performance of the DVD rental business. Create an analytical report containing:

-- Q1. Total customers
select count(*) from customer;

-- Q2. Total rentals
select count(*) from rental;

-- Q3. Total revenue
SELECT 
    SUM(amount) AS total_revenue
FROM
    payment;

-- Q4. Average rental revenue

SELECT 
    AVG(amount) AS avg_revnue
FROM
    payment;

-- Q5. Top 10 customers by spending

SELECT customer_id, SUM(amount) AS total_spending
FROM payment
GROUP BY customer_id
ORDER BY total_spending DESC
LIMIT 10;


-- Q6.Top 10 films by rental count

SELECT 
    i.film_id, COUNT(r.rental_id) AS rental_count
FROM
    rental r
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
GROUP BY i.film_id
ORDER BY rental_count DESC
LIMIT 10;


-- Q7. Top 5 categories by revenue

SELECT fc.category_id, SUM(p.amount) AS total_revenue
FROM film_category fc
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY fc.category_id
ORDER BY total_revenue DESC
LIMIT 5;

-- Q8. Revenue by store
select * from payment;
select * from staff;

select
	s.store_id,
    sum(p.amount) as revenue
from payment p
join staff s 
on p.staff_id = s.staff_id 
group by s.store_id; 

-- Q9. Revenue by staff member

select
	staff_id,
    sum(amount) as revenue
from payment 
group by staff_id;

-- Q10. Monthly revenue trend

select * from payment;
select 
	date_format(payment_date, '%Y-%m') as month,
	sum(amount) as monthly_revenue
from payment 
group by month;
    
-- Q11. Month-over-month revenue growth

WITH monthly_revenue as (
select 
	date_format(payment_date, '%Y-%m') as month,
	sum(amount) as revenue
from payment 
group by month
),
monthly_comparison as (
select 
	month,
    revenue,
    lag(revenue) over(order by month) as previous_revenue 
    from monthly_revenue 
    )
SELECT
    month,
    revenue,
    previous_revenue,
    ((revenue - previous_revenue) / NULLIF(previous_revenue, 0)) * 100 AS mom_growth_pct
FROM monthly_comparison;

-- Q12. Top 3 films within each category
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




