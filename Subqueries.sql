-- Query 1: Write query that returns address and postal code of all addresses located in London.
-- Don't use JOIN for this task.
SELECT address, postal_code
FROM address
WHERE city_id IN
(SELECT city_id FROM city WHERE city = "London");

-- Query 2: Find customers who have never rented a movie starring EMILY DEE.
-- As a result, display a table with columns last_name, first_name - the client's last and first name. 
-- Sort the list by customer last name.
SELECT c.last_name, c.first_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
    WHERE r.customer_id = c.customer_id
    AND a.first_name = 'EMILY' AND a.last_name = 'DEE'
)
ORDER BY c.last_name;

-- Query 3: In case of loss, theft, damage or non-return of the rented disk, 
-- the client will be charged a replacement cost (replacement_cost). 
-- Find the movies with the highest replacement cost in the database using a sub-query condition.
-- Write a query that returns the film_id, title and replacement_cost fields in ascending order of film_id field.
SELECT film_id, title, replacement_cost
FROM film
WHERE replacement_cost IN
(SELECT MAX(replacement_cost) FROM film)
ORDER BY film_id;

-- Query 4: Write an SQL query to find movies whose rental price is higher than the average price of all movies. 
-- Use a subquery to calculate the average rating.
-- The resulting table should include the following columns:
-- film_id - movie identifier, title - movie title and rental_rate - cost film rental.
-- Sort the results in descending order of rental rate.
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC;

-- Query 5: Create an SQL query to find customers who have rented more movies than the average number
-- of rentals among all customers. Use a subquery to calculate the average number of rentals.
-- The resulting table should contain the following columns: customer_id - unique customer identifier, 
-- first_name - customer name, last_name - client’s last name, rental_count - number of films rented.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r USING(customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING rental_count> (SELECT AVG(rental_count) as rental_count
FROM
(SELECT customer_id, COUNT(rental_id) as rental_count
FROM rental
GROUP BY customer_id) AS t);

-- Query 6: In this task you found the average film rental time (in days). 
-- Write a query to receive a list of films that have a below average rental time. 
-- Display the result in a table with film_id, title, and average_rental_time columns.
-- Sort the table by the film_id column.
SELECT f.film_id, f.title, ROUND(AVG(DATEDIFF(r.return_date, r.rental_date)),0) as average_rental_time
FROM film f
JOIN inventory i USING (film_id)
JOIN rental r USING(inventory_id)
GROUP BY f.film_id, f.title
HAVING average_rental_time < (SELECT ROUND(avg(DATEDIFF(return_date, rental_date)), 0) FROM rental)
ORDER BY f.film_id;

-- Query 7: Find movies from the Sakila database that don't have any cast records. 
-- Solve the problem without JOIN tables (using NOT EXISTS condition).
-- Output the result with the fields title, release_year sorted by movie title.
SELECT f.title, f.release_year
FROM film f
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor fa
    WHERE fa.film_id = f.film_id
)
ORDER BY f.title;

-- Query 8: The NC-17 rating is a rating for films classified as suitable for adults only.
-- Write a query to find all actors who have never appeared in films with this rating, using the NOT IN condition.
-- Output a result table with two columns first_name and last_name, sorted alphabetically by last name.
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN
(SELECT fa.actor_id
FROM film f
JOIN film_actor fa USING (film_id)
WHERE f.rating = "NC-17"
GROUP BY actor_id);

