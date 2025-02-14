-- Query 1: Selecting all users
SELECT * FROM users;

-- Query 2: Write a SQL query to select the sex and body_mass_g columns 
-- from the little_penguins table, sorted so that penguins with the 
-- largest body mass are displayed first.
SELECT sex, body_mass_g
FROM little_penguins
ORDER BY body_mass_g DESC;

-- Query 3: Retrieve all records from address table where postal code 
-- does not provided. Sort the result by address_id.
SELECT * FROM address
WHERE postal_code IS NULL;

-- Query 4: Get name column from the language table in alphabetical order.
SELECT name
FROM language
ORDER BY name ASC;

-- Query 5: Select all the values of the actors' first and last names from the actor table.
SELECT first_name, last_name from actor;

-- Query 6: Get list of values from the name column of the language table.
SELECT name FROM language;

-- Query 7: Select the movie titles from the table film. Sort the resulting list alphabetically
SELECT title FROM film ORDER BY title;

-- Query 8: From the customer table, select all records about last_name,
-- first_name and email is sorted by last name in alphabetical order.
SELECT last_name, first_name, email FROM customer ORDER BY last_name;

--Query 9: Write an SQL query that lists the unique rating values from the film table in 
-- alphabetical order.
SELECT DISTINCT rating FROM film ORDER BY rating;

-- Query 10: Get titles of five longest films sorted by their length in desc order.
SELECT title FROM film ORDER BY length DESC LIMIT 5;

-- Query 11: Select the title, description and year of release of films from the film table.
-- Sort the resulting list by name in alphabetical order and output the first ten lines
SELECT title, description, release_year FROM film ORDER BY title ASC LIMIT 10;

-- Query 12: For ease of display, we will divide the list of films into pages of ten entries each.
-- To form the third page of the list, select the title, description and year of release of films from 
-- the film table.
-- Sort the resulting list by name in alphabetical order and print ten lines starting from the twenty-first.
SELECT title, description, release_year FROM film ORDER BY title LIMIT 20,10;

-- Query 13: Select the title, rental rate and length of films from the film table.
-- Sort the resulting list in descending order of rental rate, films with the same
-- rate sort by length of the film in ascending order.
SELECT title, rental_rate, length FROM film ORDER BY rental_rate DESC, length ASC;

-- Query 14: Find the one longest movie from film table.
-- If more than one movies have the same duration get one with lowest replacement_cost
-- Write a query, without using aggregate functions, that returns two columns: title and release_year.
SELECT title, release_year FROM film ORDER BY length DESC, replacement_cost ASC LIMIT 1;

-- Query 15: Find all movies over three hours long. Write a query that returns a result
-- consisting of three columns: the title of the movie, its description and the duration 
-- in minutes, sorted by the length of the movie.
SELECT title, description, length FROM film WHERE length > 180 ORDER BY length;

-- Query 16: Find staff members worked in store number 1 and get all theirs data.
SELECT * FROM staff WHERE staff_id = 1;

-- Query 17: Find all customers who are currently active (active = 1) in the customer table.
-- The result table must contain next fields customer_id, first_name and last_name.
SELECT customer_id, first_name, last_name FROM customer WHERE active = 1;

-- Query 18: Get actors who have the first name Scarlett.
SELECT * FROM actor WHERE first_name = 'Scarlett';

-- Query 19: Find all films where description contains 
-- the Student word. Output these films titles in alphabetical order.
SELECT title FROM film WHERE description LIKE '%Student%';

-- Query 20: Find all films longer then 3 hours and get their title,
-- release year and length sorted by length in ascending order.
SELECT title, release_year, length FROM film WHERE length > 180 ORDER BY length;

-- Query 21: Find all comedies over three hours long.
-- Write a query that returns a result consisting of three columns: the name of the film, 
-- the year of release and the duration in minutes, sorted by the length of the film.
SELECT title, release_year, length FROM film  
INNER JOIN film_category ON film.film_id=film_category.film_id  
INNER JOIN category ON film_category.category_id=category.category_id 
WHERE category.name='Comedy' AND length > 180 ORDER BY length;

-- Query 22: Select last and first names and email addresses of customers whose
-- first and last names do not contain a any letter “A”. Sort the result by customer_id.
SELECT last_name, first_name, email 
FROM customer 
WHERE first_name NOT LIKE ('%A%') AND last_name NOT LIKE ('%A%') 
ORDER BY customer_id;

-- Query 23: Find all films with NC-17 (adults only) rating where description contains
-- the 'Database Administrator' substring.
-- Output these films titles, descriptions, release_years and in alphabetical order of title.
SELECT title, description, release_year FROM film 
WHERE rating='NC-17' AND description LIKE ('%Database Administrator%') ORDER BY title ASC;

-- Query 24: Find all films where description contains the Dog or Cat words marked 
-- with PG or PG-13 rating (for viewing under parents control).
-- Output these films titles, descriptions, release_years and in alphabetical order of title.
SELECT title, description, release_year FROM film WHERE rating='PG' 
OR rating='PG-13' HAVING description LIKE '%dog%' OR description LIKE '%cat%' ORDER BY title ASC;

-- Query 25: The films rated with R (Restricted) and NC-17 (Adults only) cannot be rented by youth customers.
-- Get list of this films in two columns title, rating sorted by title.
-- Use the OR keyword in query condition.
SELECT title, rating FROM film WHERE rating='R' OR rating='NC-17' ORDER BY title ASC;

-- Query 26: Films rated PG (Parental Guidance Suggested) and PG-13 (Parents Strongly Cautioned) 
-- may only be viewed by children under parental supervision.
-- Get a list of these movies in two columns title, rating, sorted by title.
SELECT title, rating FROM film WHERE rating='PG' OR rating='PG-13' ORDER BY title ASC;

-- Query 27: Retrieve all employees working on the "Video Database" project.
-- Write a query that displays the employee number, first name, last name, hire date, and job code.
-- Sort the results by last name in alphabetical order. If the last names are the same, sort by job code.
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, e.job_code
FROM employee e
INNER JOIN employee_project ep ON e.emp_no=ep.emp_no
INNER JOIN project p ON ep.proj_id=p.proj_id WHERE proj_name='Video Database'
ORDER BY last_name, job_code;

-- Query 28: Write a query for retrieve list of all employees working outside the US.
--The result must contain all columns from the table EMPLOYEE.
SELECT * FROM employee WHERE job_country NOT IN ('USA');

-- Query 29: Write a query that retrieves a list of all employees hired in 1992.
-- The result should contain the following columns FULL_NAME - the full 
-- name of the employee and HIRE_DATE - the hiring date. Sort the results by ascending date of appointment.
SELECT full_name, hire_date FROM employee WHERE hire_date LIKE ('%1992%') ORDER BY hire_date ASC;

-- Query 30: Write an SQL query to get a list of films that are not available for rent (table inventory).
-- Display the titles of these films in the film_title column in alphabetical order.
-- Use a tables join to solve the problem.
SELECT DISTINCT f.title AS film_title 
FROM film f 
LEFT JOIN inventory i ON f.film_id=i.film_id 
WHERE inventory_id IS NULL ORDER BY title;

-- Query 31: Write an SQL query to retrieve a list of languages from the language table for 
-- which there are no available films.
-- Display the language names in alphabetical order in a column named language.
-- Use a tables join to solve the problem.
SELECT l.name AS 'language'
FROM language l
LEFT JOIN film f ON l.language_id=f.language_id
WHERE f.language_id IS NULL
ORDER BY name;

-- Query 32: Write a SQL query that displays the titles of all movies and their 
-- categories from the Sakila database.
SELECT f.title, c.name
FROM film f
INNER JOIN film_category fc ON f.film_id=fc.film_id
INNER JOIN category c ON fc.category_id=c.category_id;

-- Query 33: Extract name and domain from customer email addresses in Sakila database.
-- Write a query that returns three columns: email, address - the part of the email address 
-- before the "@" sign and domain - the part after “@”.
-- Sort the result by email field.
SELECT email, SUBSTRING_INDEX(email, '@', 1) AS 'address',
SUBSTRING_INDEX(email, '@', -1) AS 'domain'
FROM customer
ORDER BY email;

-- Query 34: Get columns definitions of address table
DESCRIBE address;

-- Query 35: Get list of indexes of film table and their definitions.
SHOW INDEX FROM film;

-- Query 36: Find movies from the Sakila database that don't have any cast records. 
-- Solve the problem using JOIN operator.
-- Output the result with the fields title, release_year sorted by movie title.
SELECT f.title, f.release_year
FROM film f
LEFT JOIN film_actor fa ON f.film_id=fa.film_id
WHERE actor_id IS NULL
ORDER BY title ASC;

-- Query 37: Find clients whose first name is the last name of another client. 
-- Display a table with the fields customer_id, first_name, last_name for the first client and 
-- such the same fields customer_id, first_name, last_name for the second. 
-- Sort by customer_id of the first client.
SELECT c.customer_id, c.first_name, c.last_name, cu.customer_id, cu.first_name, cu.last_name
FROM customer c
INNER JOIN customer cu ON c.first_name=cu.last_name
ORDER BY c.customer_id;

-- Query 38: Find clients who met at one of the rental points. 
-- Display a table with fields meet_time - according the rental time, 
-- store_id, clients. span> list of meeting clients in the format 
-- JOHN SNOW, DAENERYS TARGARYEN, sorted by clients's last name.
-- The results table should be sorted by meeting time and store id.
-- (Customers met if they rented movies from the same branch at the same time).
select r.rental_date as meet_time,  s.store_id, 
GROUP_CONCAT(DISTINCT c.first_name, " " ,c.last_name ORDER BY c.last_name) as "customers"  
from rental r
inner join customer c on c.customer_id = r.customer_id
inner join staff s on s.staff_id = r.staff_id
group by r.rental_date, s.store_id having count(c.customer_id) > 1
order by r.rental_date, s.store_id;

-- Query 39: Write an SQL query to find films in the Sakila database that are currently 
-- in inventory (from the inventory table) but have never been rented out.
-- Display the titles of these films in alphabetical order.
-- Use table joins to solve the task.
SELECT f.title FROM inventory i
LEFT JOIN film f ON i.film_id=f.film_id
LEFT JOIN rental r ON i.inventory_id=r.inventory_id
WHERE r.inventory_id IS NULL;

-- Query 40: Get all the films in the following categories: Comedy, Music and Travel. 
-- Output table with film_id, title and category columns sorted by film_id. 
-- Write a query without using the OR keyword in the condition.
SELECT f.film_id, f.title, c.name category FROM film f
JOIN film_category fc ON f.film_id=fc.film_id
JOIN category c ON fc.category_id=c.category_id
WHERE c.name IN ("Comedy","Music","Travel")
ORDER BY f.film_id;

-- Query 41: Select first and last names of customers whose first and last names begin with the same letter.
-- Sort the results by first and last name.
SELECT first_name, last_name
FROM customer
WHERE LEFT(first_name, 1) = LEFT(last_name, 1)
ORDER BY first_name, last_name;

-- Query 42: Find all films rented by KATIE ELLIOTT. Output the result in two columns title and rating.
-- Sort the list so that movies for adults (rated R) come first, and then all the others in alphabetical order.
SELECT f.title, f.rating FROM film f
JOIN inventory i ON f.film_id=i.film_id
JOIN rental r ON i.inventory_id=r.inventory_id
JOIN customer c ON r.customer_id=c.customer_id
WHERE c.first_name="Katie" AND c.last_name="Elliott"
ORDER BY CASE WHEN f.rating = "R" THEN 0
ELSE 1
END, f.title;
