-- Query 1: Write the query returns a table with next columns: title - the title of each film,
-- category - its category, rental_rate - its rental rate category_avg_rental_rate - 
-- and the average rental rate for the category to which it belongs.
SELECT f.title, c.name AS category, f.rental_rate, 
AVG(f.rental_rate) OVER (PARTITION BY c.name) AS category_avg_rental_rate
FROM film f
JOIN film_category fc USING(film_id)
JOIN category c USING (category_id);

-- Query 2: From the payment table, select all payments for August 2005. Display the result in four columns:
-- payment_id, payment_date, amount, rolling_sum - the amount of payments from the beginning of the month
-- with a cumulative total.
SELECT payment_id, payment_date, amount, SUM(amount) OVER (ORDER BY payment_date, payment_id) AS rolling_sum
FROM payment
WHERE payment_date BETWEEN "2005-08-01" AND "2005-08-31";


