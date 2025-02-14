-- Query 1: Write a query to calculate the perimeter of a circle with 
-- diameter 7. Display the result in the circle_perimeter column.
SELECT PI()*7 as circle_perimeter;

-- Query 2: Write a query to calculate the area of a circle with a radius of 12. 
-- Round the result to 6 decimal places and display it in the circle_area column.
SELECT ROUND(PI()*POW(12,2),6) as circle_area;

-- Query 3: Find the length of the hypotenuse of a right triangle with legs equal to 2 and 3.
-- Output the result in the hypotenuse column. Round the result to three decimal places.
SELECT ROUND(3.60555127546399,3) as hypotenuse;

-- Query 4: Write a query that returns a table of factorial values for integers from 0 to 10.
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

-- Query 5: Generate a list of films in JSON format like 
-- {"id": 1, "title": "ACADEMY DINOSAUR", "category": "Documentary"} 
-- in a table with one column film sorted by film id.
SELECT JSON_OBJECT('id', f.film_id, 'title', f.title,'category',c.name) AS film
FROM film f
JOIN film_category fc ON f.film_id=fc.film_id
JOIN category c ON fc.category_id=c.category_id
ORDER BY f.film_id;

-- Query 6: Get all records from the address table where the postal code is an even number.
-- Output a table with two columns address_id and postal_code, sorted address_id.
SELECT address_id, postal_code FROM address
WHERE postal_code%2=0
ORDER BY address_id;

-- Query 7: Build a overal email list for clients and staff. Output a table with the following columns:
-- record_type – customer or employee, last_name, first_name, email - personal data
-- Sort the table by last name and first name.
SELECT 'customer' AS record_type, last_name, first_name, email 
FROM customer
UNION ALL
SELECT 'employee' AS record_type, last_name, first_name, email 
FROM staff
ORDER BY last_name, first_name;

-- Query 8: Generate DOROTHY TAYLOR monthly bill for she's films rentals in August 2005. 
-- The bill shoul be a table with next columns: title - rented film names, rental_date, return_date, 
-- payment_date - relevant dates, rental_rate - film's rental rate, lateness_penalty - 
-- difference between rental rate and paid amount, amount - paid amount
-- Sort the table by payment_date. Add summary row to the bill with Total in title column, 
-- nulls in all data columns and sums in other columns.
SELECT film.title, rental.rental_date, rental.return_date, payment.payment_date, 
film.rental_rate, (payment.amount - film.rental_rate) AS lateness_penalty, payment.amount 
FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
JOIN payment ON rental.rental_id=payment.rental_id
JOIN customer ON rental.customer_id=customer.customer_id
WHERE customer.first_name="DOROTHY" AND customer.last_name="TAYLOR"
AND rental.rental_date>="2005-08-01"AND rental.rental_date<"2005-09-01"
UNION 
SELECT "Total", NULL, NULL, NULL, 
SUM(film.rental_rate), SUM((payment.amount - film.rental_rate)), SUM(payment.amount)
FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
JOIN payment ON rental.rental_id=payment.rental_id
JOIN customer ON rental.customer_id=customer.customer_id
WHERE customer.first_name="DOROTHY" AND customer.last_name="TAYLOR"
AND rental.rental_date>="2005-08-01"AND rental.rental_date<"2005-09-01"
ORDER BY -payment_date DESC;

-- Query 9: Make a list of surnames found both among users and among actors. 
-- Display a table with one column last_name sorted alphabetically.
-- Solve the problem using table operator.
SELECT c.last_name
FROM customer c
INTERSECT
SELECT a.last_name
FROM actor a
ORDER BY last_name;

-- Query 10: Search the customer table for palindrome names.Sort the result by first_name.
SELECT first_name FROM customer
WHERE first_name = REVERSE(first_name)
ORDER BY first_name;

-- Query 11: Output a list of customers in the format Meladze M. 
-- (last name with a capital letter plus the first letter of the name with a dot) in the column customer_name
-- Sort the results by last name.
SELECT CONCAT(UCASE(LEFT(last_name, 1)),LCASE(SUBSTRING(last_name, 2)),
" ",LEFT(first_name,1),".")AS customer_name FROM customer
ORDER BY last_name;

-- Query 12: Imagine that the price in the rental_rate column of the film table includes VAT of 18%. 
-- Write a request to receive the tax amount, price before tax and the full rental price of films.
-- Display a table of results with the following columns: film_id, title, rental_rate_before_tax, 
-- < span class='sql'>tax and rental_rate. Sort it by film_id.
SELECT film_id,title,ROUND((rental_rate-((rental_rate/(1+0.18))*0.18)),2)AS rental_rate_before_tax,
ROUND(((rental_rate/(1+0.18))*0.18),2) AS tax,rental_rate
FROM film
ORDER BY film_id;

-- Query 13: Write a query to get a list of films as a table with columns film_id, title and film_length
-- - the duration of the film in format Xh YYm.
-- Sort it by film_id.
SELECT film_id,title,CONCAT((length DIV 60),"h ",LPAD((length%60),2,"0"),"m") AS film_length
FROM film
ORDER BY film_id;

-- Query 14: Write a query that returns tomorrow's date in the format YYYY-MM-DD in a column called tomorrow.
SELECT (CAST((now()+ interval 1 day) AS DATE)) AS tomorrow;

-- Query 15: Write a query that returns the start and end dates of the current month in the format 
-- YYYY-MM-DD in columns named first_of_month and last_of_month.
SELECT DATE_FORMAT(CURRENT_DATE, '%Y-%m-01') AS first_of_month, (LAST_DAY(now())) AS last_of_month;

-- Query 16: Find the first (Monday) and last (Sunday) dates of the current week and display
-- them in a table with columns last_monday and next_sunday
SELECT DATE_SUB(CURRENT_DATE, INTERVAL WEEKDAY(CURRENT_DATE) DAY) AS last_monday,
DATE_ADD(CURRENT_DATE, INTERVAL (6 - WEEKDAY(CURRENT_DATE)) DAY) AS next_sunday;
