JOIN

Why Would We Want to Split Data Into Separate Tables?

-- Splitting data into separate tables is a common practice in relational database design, and it offers several benefits that help organize and manage data effectively. Here are some reasons why you might want to split data into separate tables:

-- Splitting data into separate tables in a relational database helps improve data organization, integrity, security, performance, and maintainability. It's a fundamental principle of good database design that aims to achieve efficiency, accuracy, and flexibility in handling data.

Database Normalization
-- When creating a database, it is really important to think about how data will be stored. This is known as normalization

-- Below we see an example of a query using a JOIN statement.

SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- if we want to pull only the account name and the dates in which that account placed an order, but none of the other columns, we can do this with the following query

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Quiz Questions
-- 1. Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT * 
from orders 
JOIN accounts
on orders.account_id = accounts.id;

-- 2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty,
accounts.website, accounts.primary_poc
from orders 
JOIN accounts
on orders.account_id = accounts.id;

-- If we wanted to join the sales_reps and region tables together, how would you do it
select *
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id;

-- JOIN More than Two Tables Refer ERD for tabels
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;

-- Alias
-- When we JOIN tables together, it is nice to give each table an alias. Frequently an alias is just the first letter of the table name.
-- Example:

FROM tablename AS t1
JOIN tablename2 AS t2

-- requently, you might also see these statements without the AS statement. Each of the above could be written in the following way instead, and they would still produce the exact same results:

FROM tablename t1
JOIN tablename2 t2

-- Questions 
--1. Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

SELECT a.name, a.primary_poc, w.occurred_at, w.channel
FROM web_events AS W
JOIN accounts AS A
ON w.account_id = a.id
where a.name = 'Walmart';

-- 2.Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name AS Region_name, s.name AS SALE_REP_name, a.name AS Account_name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
Join accounts AS a
ON s.id = a.sales_rep_id
ORDER BY a.name;

-- 3. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT r.name as Region_name , a.name as Account_name , (o.total_amt_usd/(o.total+0.01)) as Unit_price
FROM region as r
JOIN sales_reps as s
ON r.id = s.region_id
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o 
ON a.id = o.account_id;

-- OUTER JOINS
-- Types of Outer JOIN
1.LEFT JOIN
2.RIGHT JOIN
3.FULL OUTER JOIN

-- You might see the SQL syntax of
LEFT OUTER JOIN
OR
RIGHT OUTER JOIN
-- These are the exact same commands as the LEFT JOIN and RIGHT JOIN

-- Similar to the above, you might see the language FULL OUTER JOIN, which is the same as OUTER JOIN.

-- Note:If you have two or more columns in your SELECT that have the same name after the table name such as accounts.name and sales_reps.name you will need to alias them. Otherwise it will only show one of the columns. You can alias them like accounts.name AS AcountName, sales_rep.name AS SalesRepName

-- Questions
-- 1. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name Region, s.name Sales_Rep, a.name Account
FROM region AS r
JOIN sales_reps as s 
ON r.id = s.region_id
JOIN accounts as a 
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY a.name;


-- 2.Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name Region, s.name Sales_Rep, a.name Account
FROM region AS r
JOIN sales_reps as s 
ON r.id = s.region_id
JOIN accounts as a 
ON s.id = a.sales_rep_id
WHERE s.name LIKE 'S%' AND r.name = 'Midwest'
ORDER BY a.name;

-- 3.Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name Region, s.name Sales_Rep, a.name Account
FROM region AS r
JOIN sales_reps as s 
ON r.id = s.region_id
JOIN accounts as a 
ON s.id = a.sales_rep_id
WHERE s.name LIKE '% K%' AND r.name = 'Midwest'
ORDER BY a.name;

-- 4.Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

SELECT r.name region, a.name account, (total_amt_usd/(total+0.01)) unit_price
FROM region as r 
JOIN sales_reps as s 
ON r.id = s.region_id
JOIN accounts as a 
ON a.sales_rep_id = s.id
JOIN orders as o 
ON a.id = o.account_id
WHERE o.standard_qty > 100;

-- 5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name region, a.name account, (total_amt_usd/(total+0.01)) unit_price
FROM region as r 
JOIN sales_reps as s 
ON r.id = s.region_id
JOIN accounts as a 
ON a.sales_rep_id = s.id
JOIN orders as o 
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price;

-- 6. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name region, a.name account, (total_amt_usd/(total+0.01)) unit_price
FROM region as r 
JOIN sales_reps as s 
ON r.id = s.region_id
JOIN accounts as a 
ON a.sales_rep_id = s.id
JOIN orders as o 
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price DESC;

-- 7.What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.

SELECT DISTINCT a.name as Accout , w.channel as Channel
FROM web_events as w 
JOIN accounts as a 
ON w.account_id = a.id
WHERE a.id = 1001;

-- 8. Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders as o 
JOIN Accounts as a 
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at DESC;


-- JOINs
-- In this lesson, you learned how to combine data from multiple tables using JOINs. The three JOIN statements you are most likely to use are:

-- JOIN - an INNER JOIN that only pulls data that exists in both tables.
-- LEFT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the FROM even if they do not exist in the JOIN statement.
-- RIGHT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the JOIN even if they do not exist in the FROM statement.