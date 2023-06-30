USE sakila;

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the 
-- customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW sakila.Rental_info_customer AS (
SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, COUNT(rental.rental_id) AS 'rental_count' 
FROM sakila.customer
LEFT JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id
);

SELECT * FROM sakila.Rental_info_customer;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The 
-- Temporary Table should use the rental summary view created in Step 1 to join with the payment table and 
-- calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid_customer AS(
SELECT Rental_info_customer.*, SUM(payment.amount) AS "total_paid"
FROM sakila.Rental_info_customer
JOIN payment
ON Rental_info_customer.customer_id = payment.customer_id
GROUP BY Rental_info_customer.customer_id
);
SELECT * FROM total_paid_customer;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table 
-- created in Step 2. The CTE should include the customer's name, email address, rental count, and total 
-- amount paid.
WITH rental_payment_cte AS (
SELECT * FROM total_paid_customer
)

-- Next, using the CTE, create the query to generate the final customer summary report, which should 
-- include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last 
-- column is a derived column from total_paid and rental_count.
SELECT *, total_paid/rental_count AS 'average_payment_per_rental' FROM rental_payment_cte;