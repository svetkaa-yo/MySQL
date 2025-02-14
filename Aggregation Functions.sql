-- Query 1: Find the average length of the movie.
-- Display the result in the avg_film_length column.
SELECT AVG(length) AS avg_film_length FROM film;

-- Query 2: Find the minimal and maximal film replacement cost.
-- Display the result as two columns table minimal_replacement_cost and maximal_replacement_cost.
SELECT MIN(replacement_cost) AS minimal_replacement_cost, 
MAX(replacement_cost) AS maximal_replacement_cost FROM film;

-- Query 3: Find the average movie rental time (in days). Display the result in a column named average_rental_time.
-- The rental time is calculated as the difference between return_date and rental_date in the rent table.
-- Round the result to the nearest whole number.
SELECT ROUND(AVG(DATEDIFF(return_date,rental_date)),0) AS average_rental_time FROM rental;

-- Query 4: Find the average rental time of a movie (in days).
-- Display the result as one columns table average_rental_time. 
-- The rental time calculate as difference between return_date and rental_date in table rental.
SELECT AVG(DATEDIFF(return_date,rental_date)) AS average_rental_time FROM rental;

-- Query 5: Find the number of employees in each department.
-- Output the name of the department DEPARTMENT and the number of employees in it EMP_COUNT.
-- Sort the results in descending order of number of employees.
SELECT d.DEPARTMENT,(COUNT(e.EMP_NO)) AS EMP_COUNT 
FROM EMPLOYEE e
RIGHT JOIN DEPARTMENT d ON e.DEPT_NO = d.DEPT_NO
GROUP BY d.DEPARTMENT
ORDER BY EMP_COUNT DESC;

-- Query 6: Find the number of films in each category.
--  Display a table with two columns category and film_count, sort it by category names in alphabetical order.
SELECT (c.name) AS category, COUNT(f.film_id) AS film_count
FROM category c
LEFT JOIN film_category fc ON c.category_id=fc.category_id
LEFT JOIN film f ON fc.film_id=f.film_id
GROUP BY c.name
ORDER BY category;

-- Query 7: Find the average cost of renting a movie for each category.
-- Display the result in two columns category and avg_rental_rate sorted in descending order of price.
SELECT (c.name) AS category, (AVG(f.rental_rate)) AS avg_rental_rate
FROM category c
LEFT JOIN film_category fc ON c.category_id=fc.category_id
LEFT JOIN film f ON fc.film_id=f.film_id
GROUP BY c.name
ORDER BY avg_rental_rate DESC;

-- Query 8: Find the minimum, maximum and average length of a movie for each category.
-- Display the result in the form of a table with columns: category - name of the movie category, 
-- min_length, max_length and avg_length sorted by category in alphabetical order.
SELECT (c.name) AS category, MIN(length) AS min_length, MAX(length) AS max_length, AVG(length) AS avg_length
FROM category c
LEFT JOIN film_category fc ON c.category_id=fc.category_id
LEFT JOIN film f ON fc.film_id=f.film_id
GROUP BY c.name
ORDER BY category;

-- Query 9: Find categories with an average movie length of more than two hours.
-- Display the result as a table with columns: category - the name of the movie category 
-- and avg_length sorted in descending order of the average movie length.
SELECT (c.name) AS category,AVG(length) AS avg_length
FROM category c
LEFT JOIN film_category fc ON c.category_id=fc.category_id
LEFT JOIN film f ON fc.film_id=f.film_id
GROUP BY c.name
HAVING avg_length>120
ORDER BY avg_length DESC;

-- Query 10: Of the movies available, find the ones that are least rented based on the number 
-- of records in the rental table.
-- Display the movie title in the title column and the number of rentals in the rentals_count column.
-- Sort the table by movie title.
select f.title, count(r.rental_id) AS rentals_count
from rental r
JOIN inventory i ON i.inventory_id=r.inventory_id
join film f on f.film_id=i.film_id
GROUP BY f.title having count(r.rental_id) = (select count(r.rental_id) AS rentals_count
from rental r
JOIN inventory i ON i.inventory_id=r.inventory_id
join film f on f.film_id=i.film_id
GROUP BY f.title ORDER BY rentals_count limit 1)
ORDER BY rentals_count;

-- Query 11: Write an SQL query to find the top three customers with the highest total payment volume 
-- in the Sakila database. Display in result table the first name, last name and total payment amount 
-- of clients in the first_name, last_name and total_pay columns respectively. 
-- Sort the results by total_pay in descending order.
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_pay
FROM customer c
JOIN payment p ON c.customer_id=p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_pay DESC
LIMIT 3;

-- Query 12: Find the average movie rental time for each customer.
-- Display the result as a table with columns customer_id, first_name, last_name and average_rental_time.
-- The rental time is calculated as the difference between return_date and rental_date in the rental table.
-- Round the result up to the nearest whole number. Sort the result in ascending order of the customer_id field.
SELECT c.customer_id, c.first_name, c.last_name, 
CEIL(AVG(DATEDIFF(r.return_date,r.rental_date))) AS average_rental_time
FROM rental r
JOIN customer c USING (customer_id)
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- Query 13: Write query calculate the total payment amount for each month and display the results 
-- in descending order based on the payment month.
-- The query should return only two columns: payment_month - The month of the payment (formatted as "YYYY-MM") 
-- and payment_amount - The total payment amount for each month.
SELECT DATE_FORMAT(payment_date, "%Y-%m") AS payment_month, SUM(amount) AS payment_amount
FROM payment
GROUP BY payment_month
ORDER BY payment_month DESC;

-- Query 14: Find the number of movie discs in each category in each of the two stores.
-- Write a query that displays a table with columns: category - the name of the movie category, store_1 and store_2 - number of discs with films of this category in the store.
-- Sort the results by category in alphabetical order.
SELECT c.name AS category, 
    COUNT(DISTINCT CASE WHEN i.store_id = 1 THEN i.inventory_id END) AS store_1,
    COUNT(DISTINCT CASE WHEN i.store_id = 2 THEN i.inventory_id END) AS store_2
FROM category c
LEFT JOIN film_category fc ON c.category_id=fc.category_id
LEFT JOIN film f ON fc.film_id=f.film_id
LEFT JOIN inventory i ON f.film_id=i.film_id
GROUP BY category
ORDER BY category;

-- Query 15: Find employees whose salaries were increased several times within one year.
-- The result should contain the following columns EMP_NO, FIRST_NAME, LAST_NAME - employee data, 
-- CHANGES_YEAR - year of salary increase, CHANGES_COUNT - number of increases per year. 
-- Sort the result by employee number.
SELECT e.EMP_NO, e.FIRST_NAME, e.LAST_NAME, EXTRACT(YEAR FROM sh.CHANGE_DATE) AS CHANGES_YEAR, 
COUNT(sh.NEW_SALARY) AS CHANGES_COUNT
FROM EMPLOYEE e
JOIN SALARY_HISTORY sh USING (EMP_NO)
GROUP BY EMP_NO, FIRST_NAME, LAST_NAME, CHANGES_YEAR
HAVING COUNT(sh.EMP_NO)>=2
ORDER BY EMP_NO;

-- Query 16: Write a query that calculates the ratio of the minimum salary in a department to the maximum.
-- Display a table of two columns DEPARTMENT - the name of the department in which he works and 
-- SALARY_DIFF_RATIO sorted in descending order of the coefficient.
SELECT d.DEPARTMENT, (MIN(CAST(e.SALARY AS float(4)))/MAX(CAST (e.SALARY AS float(4)))) AS SALARY_DIFF_RATIO
FROM DEPARTMENT d
JOIN EMPLOYEE e USING(DEPT_NO)
GROUP BY d.DEPARTMENT
ORDER BY SALARY_DIFF_RATIO DESC;

-- Query 17: Write a query to calculate the revenue of each store for each quarter of 2005.
-- The result should consist of the following fields: store_id and I, II , III, IV -
-- amounts of income for each quarter, respectively
-- To define store_id value, use a join to the staff table.
SELECT s.store_id, 
    IFNULL(SUM(CASE WHEN QUARTER(p.payment_date) = 1 AND YEAR(p.payment_date) = 2005 THEN p.amount END), 0.00) AS I,
    IFNULL(SUM(CASE WHEN QUARTER(p.payment_date) = 2 AND YEAR(p.payment_date) = 2005 THEN p.amount END), 0.00) AS II,
    IFNULL(SUM(CASE WHEN QUARTER(p.payment_date) = 3 AND YEAR(p.payment_date) = 2005 THEN p.amount END), 0.00) AS III,
    IFNULL(SUM(CASE WHEN QUARTER(p.payment_date) = 4 AND YEAR(p.payment_date) = 2005 THEN p.amount END), 0.00) AS IV
FROM store s
LEFT JOIN staff st USING (store_id)
LEFT JOIN payment p USING (staff_id)
GROUP BY s.store_id

-- Query 18: Find the three countries with the largest number of customers living there.
-- Output the result in two columns: country and customers_count sorted by the number of 
-- clients from largest to smallest.
SELECT c.country, COUNT(cu.customer_id) AS customers_count
FROM country c
JOIN city ci USING (country_id)
JOIN address USING (city_id)
JOIN customer cu USING (address_id)
GROUP BY country
ORDER BY customers_count DESC
LIMIT 3;

-- Query 19: Find the number of discs in rental at the end of the day 2005-05-31 for each rental point. 
-- Print the result in two columns store_id and rented_at_2005_05_31 Sort the resulting list in ascending 
-- order store_id.
SELECT inventory.store_id, COUNT(rental.rental_date) AS rented_at_2005_05_31
FROM inventory
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_date <= '2005-05-31 23:59:00'
  AND (rental.return_date IS NULL OR rental.return_date > '2005-05-31 23:59:59')
GROUP BY inventory.store_id
ORDER BY inventory.store_id ASC;

-- Query 20: Find the number of discs returned during 2005-06-01 for each rental point. 
-- Print the result in two columns store_id and returned_at_2005_06_01. 
-- Sort the resulting list in ascending order store_id.
SELECT i.store_id, COUNT(r.rental_id) AS returned_at_2005_06_01
FROM inventory i
JOIN rental r USING (inventory_id)
WHERE r.return_date BETWEEN "2005-06-01 00:00:00" AND "2005-06-01 23:59:00"
GROUP BY i.store_id
ORDER BY i.store_id;

-- Query 21: Find the actor's surnames that appear more than once in the table. 
-- Output the result in two columns: last_name - the last name of the actor and first_names - 
-- a list of names of actors bearing this last name, separated by commas.
-- Sort the list by last name in alphabetical order.
SELECT last_name, GROUP_CONCAT(first_name) AS first_names
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>1
ORDER BY last_name;

-- Query 22: Get the name of each movie from the movies table along with the list of actors.
-- The list of actors should consist of the actor's first and last name, separated by a space,
-- separated by commas and sorted alphabetically. (As in this example: ELVIS MARX, SISSY SOBIESKI, VAL BOLGER).
-- The query result should contain two columns: title - the title of the movie and actors, 
-- ordered by the number of actors in descending order.
SELECT f.title, 
GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.first_name, a.last_name ASC SEPARATOR ', ') AS actors
FROM film f
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
GROUP BY f.title
ORDER BY COUNT(fa.actor_id) DESC;

-- Query 23: Find all the actors who starred in the movie ARIZONA BANG.
-- Output the resulting table from two columns first_name, last_name sorted in descending order 
-- of the actor's popularity (an actor who has starred in more films should be in first line).
SELECT a.first_name, a.last_name
FROM film f
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
WHERE a.actor_id IN (SELECT actor_id FROM film_actor JOIN film USING (film_id) WHERE title="ARIZONA BANG")
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY COUNT(fa.film_id) DESC;

-- Query 24: Find the average number of disks rented by each customer in August 2005, broken down by week.
-- Present the result in two columns: week_num - week number, weekly_average_rental_count - the average number
-- of discs rented by one user. Sort the results by week number.
SELECT week_num, AVG(weekly_rental_count) AS weekly_average_rental_count
FROM
(SELECT WEEK(rental_date) AS week_num, customer_id, COUNT(rental_id) as weekly_rental_count
FROM rental
WHERE DATE_FORMAT(rental_date, '%Y-%m') = '2005-08'
GROUP BY week_num, customer_id
ORDER BY customer_id) AS weekly_rentals
GROUP BY week_num
ORDER BY week_num;

-- Query 25: Find the customers who have rented the same film more when one time. 
-- Present the result as table with next columns: first_name, last_name - client's name and surname,
-- title - film's title, first_rental_date, last_rental_date - the film first and last rental dates,
-- rentals_count - how many times the film was rented by client.
-- Sort the table by film title.
SELECT c.first_name, c.last_name, f.title, (MIN(rental_date)) AS first_rental_date, 
(MAX(rental_date)) AS last_rental_date, (COUNT(rental_id)) AS rentals_count
FROM rental r
JOIN customer c USING (customer_id)
JOIN inventory i USING (inventory_id)
JOIN film f USING (film_id)
GROUP BY c.first_name, c.last_name, f.title
HAVING COUNT(f.title)>1
ORDER BY f.title;

-- Query 26: Make a list of films of which only one of the company's stores has copies.
-- Display a table with columns film_id, title, store_id - the store identifier where there is a copy, 
-- quantity - the number of copies in the store. Sort the table by movie title.
SELECT film_id,title,GROUP_CONCAT(store_id) AS store_id, SUM(quantity) AS quantity
FROM
(SELECT f.film_id, f.title,i.store_id, COUNT(i.inventory_id) AS quantity
FROM inventory i
JOIN film f USING (film_id)
GROUP BY f.film_id, f.title, i.store_id
ORDER BY f.title) AS t
GROUP BY t.film_id, t.title
HAVING store_id REGEXP '^[0-9]$';

-- Query 27: Make a list of films, all copies of which were in the hands of clients 
-- on the date 2005-05-31 12:00:00.
-- Display a table with film_id, title columns. Sort the table by movie title.
SELECT f.film_id, f.title
FROM film f
JOIN inventory i USING(film_id)
JOIN rental r USING (inventory_id)
WHERE r.rental_date <= '2005-05-31 12:00:00' AND r.return_date > '2005-05-31 12:00:00'
GROUP BY f.film_id, f.title
HAVING COUNT(i.inventory_id) = (SELECT COUNT(i2.inventory_id)
FROM inventory i2 WHERE i2.film_id = f.film_id)
ORDER BY f.title;

-- Query 28: Find the number of films in each category.
-- Return the result in JSON format like [{"Action": 64}, {"Animation": 66}, ...] in the films_by_category column.
SELECT JSON_ARRAYAGG(JSON_OBJECT(name, films_by_category)) AS films_by_category
FROM
(SELECT c.name, COUNT(f.title) AS films_by_category
FROM film f
JOIN film_category fc USING (film_id)
JOIN category c USING (category_id)
GROUP BY c.name) AS t;

-- Query 29: Write a SQL query to find the most rented movie in the February, 2006. 
-- Show the film's title in the most_rented_movie column.
-- The result should be a single-column table, single-row.
SELECT title as most_rented_movie
FROM
(SELECT f.title, COUNT(r.rental_id) AS quantity
FROM inventory i
JOIN film f USING (film_id)
JOIN rental r USING (inventory_id)
WHERE r.rental_date LIKE "2006-02%"
GROUP BY f.title
ORDER BY quantity DESC
LIMIT 1) AS t;

-- Query 30: Find the films with the most rentals in 2005 in each category. 
-- Display a table with columns category, most_rented_films - the name of the film 
-- (if several films have the same number of rentals, display the names in alphabetical order, separated by commas)
-- and rentals_count - the number of movie rentals during the year.
-- Sort the table by the first column.
select film_count.category, GROUP_CONCAT(film_count.film_name) as most_rented_films, film_count.rental_count as rentals_count from (
SELECT c.name AS category, 
(f.title) AS film_name, 
COUNT(r.rental_id) AS rental_count
FROM inventory i
JOIN film f USING (film_id)
JOIN rental r USING (inventory_id)
JOIN film_category fc USING (film_id)
JOIN category c USING (category_id)
WHERE YEAR(r.rental_date) = 2005
GROUP BY category, film_name) as film_count
JOIN
(SELECT inner_count.category, MAX(rental_count) as max_count_r
FROM (
SELECT c.name AS category, 
(f.title) AS film_name, 
COUNT(r.rental_id) AS rental_count
FROM inventory i
JOIN film f USING (film_id)
JOIN rental r USING (inventory_id)
JOIN film_category fc USING (film_id)
JOIN category c USING (category_id)
WHERE YEAR(r.rental_date) = 2005
GROUP BY category, film_name
) as inner_count group by category) as max_count on film_count.category=max_count.category 
and film_count.rental_count = max_count.max_count_r
group by film_count.category 

-- Query 31: Find the average movie rental price and the average actual movie rental amount for each category.
-- Display the result in three columns category, avg_rental_rate and avg_payment_amount.
-- Sort the result in descending order of the difference between the actual and nominal value.
SELECT c.name AS category, t.avg_rental_rate, AVG(p.amount) AS avg_payment_amount
FROM category c
JOIN film_category fc USING (category_id)
JOIN film f USING (film_id)
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
JOIN payment p USING (rental_id)
JOIN (
SELECT c.name AS category, AVG(f.rental_rate) AS avg_rental_rate
FROM category c
JOIN film_category fc USING (category_id)
JOIN film f USING (film_id)
GROUP BY category) AS t 
ON t.category=c.name
GROUP BY category
ORDER BY (t.avg_rental_rate-avg_payment_amount);