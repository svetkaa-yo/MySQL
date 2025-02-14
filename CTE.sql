-- Query 1: Using recursive CTE write the query returning single columns table date 
-- contains all dates from 2005-07-01 to 2005-07-31.
WITH RECURSIVE cte_name AS (
    SELECT '2005-07-01' AS date
    UNION ALL
    SELECT DATE_ADD(date, INTERVAL 1 DAY)
    FROM cte_name
    WHERE date < '2005-07-31'
)
SELECT date
FROM cte_name;

-- Query 2: Using the solution to the previous problem, write a query to count the number 
-- of weekends (Saturday and Sunday) in July 2005. 
-- The result should contain a single value in the weekend_days column.
WITH RECURSIVE cte_name AS (
    SELECT '2005-07-01' AS date
    UNION ALL
    SELECT DATE_ADD(date, INTERVAL 1 DAY)
    FROM cte_name
    WHERE date < '2005-07-31'
)
SELECT COUNT(*) AS weekend_days
FROM cte_name
WHERE DAYOFWEEK(date) IN (1, 7);

-- Query 3: Write a query that returns a table of factorial values for integers from 0 to 10.
-- The table must contain two columns n - a number from 0 to 10 and f the factorial value of this number.
WITH RECURSIVE Factorial(n, f) AS (
    SELECT 0, 1  -- base case: factorial of 0 is 1
    UNION ALL
    SELECT n + 1, f * (n + 1)
    FROM Factorial
    WHERE n < 10
)
SELECT n, f
FROM Factorial;

-- Query 4: Using the solution to this problem, find the average weekly number of rentals in August 2005.
-- The result should be the number in the weekly_average_rentals_count column.
WITH RECURSIVE cte_name(week_num, weekly_average_rentals_count) AS(
SELECT week_num, AVG(weekly_rental_count) AS weekly_average_rental_count
FROM
(SELECT WEEK(rental_date) AS week_num, customer_id, COUNT(rental_id) as weekly_rental_count
FROM rental
WHERE DATE_FORMAT(rental_date, '%Y-%m') = '2005-08'
GROUP BY week_num, customer_id
ORDER BY customer_id) AS weekly_rentals
GROUP BY week_num
ORDER BY week_num)
SELECT AVG(weekly_average_rentals_count) AS weekly_average_rentals_count
FROM cte_name;

-- Query 5: Find clients occupying the top three places by the number of films rented.
-- Please note: several clients may have the same number of films rented.
-- Display a table with columns: last_name, first_name, cnt (the number taken in film rental).
-- Sort the results by the number of movies you rented in descending order, and then by last name.
WITH RECURSIVE top_active_clients (last_name, first_name, cnt, r) AS (
SELECT c.last_name, c.first_name, COUNT(r.rental_id) AS cnt, RANK() OVER (ORDER BY COUNT(r.rental_id) DESC)
FROM customer c
JOIN rental r USING (customer_id)
GROUP BY c.last_name, c.first_name
ORDER BY cnt DESC,last_name)
SELECT last_name, first_name, cnt
FROM top_active_clients
LIMIT 4;

