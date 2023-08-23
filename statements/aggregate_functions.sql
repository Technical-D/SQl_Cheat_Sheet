Aggregate Functions

NULLS
-- NULLs are a datatype that specifies where no data exists in SQL.
-- When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. We don't use =, because NULL isn't considered a value in SQL. Rather, it is a property of the data.
-- Example
SELECT *
FROM accounts
WHERE primary_poc IS NULL;


COUNT
-- COUNT the Number of Rows in a Table
-- Here is an example of finding all the rows in the accounts table.
SELECT COUNT(*)
FROM accounts;
-- But we could have just as easily chosen a column to drop into the aggregation function:
SELECT COUNT(accounts.id)
FROM accounts;
-- Notice that COUNT does not consider rows that have NULL values. Therefore, this can be useful for quickly identifying which rows have missing data. 


SUM
-- Gives the sum of all values in specified column
-- Unlike COUNT, you can only use SUM on numeric columns. However, SUM will ignore NULL values
-- An important thing to remember: aggregators only aggregate vertically - the values of a column. If you want to perform a calculation across rows, you would do this with simple arithmetic.

-- Aggregation Questions
-- 1. Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) AS total_poster_qty
FROM orders;

-- 2. Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) AS total_standard_qty
FROM orders;

-- 3. Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) AS total_dollar_sales
FROM orders;

-- 4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.

SELECT standard_amt_usd + gloss_amt_usd AS std_gloss_total
FROM Orders;

-- 5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) as standard_price_per_unit
FROM orders;


MIN & MAX
-- MIN gives Minimun values from column
-- MAX gives Maximum values from column
-- Notice that MIN and MAX are aggregators that again ignore NULL values.
-- Expert Tip: Functionally, MIN and MAX are similar to COUNT in that they can be used on non-numerical columns. Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. As you might suspect, MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”

-- Example
SELECT MAX(standard_qty) AS max_standard_qty, MIN(standard_qty) AS min_standard_qty
FROM orders;


AVG
-- AVG returns the mean of the data - that is the sum of all of the values in the column divided by the number of values in a column. 
-- This aggregate function again ignores the NULL values in both the numerator and the denominator.

-- Questions: MIN, MAX, & AVERAGE
-- 1. When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) AS earliest_order_date
FROM orders;

-- 2.Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at 
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- 3. When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) AS latest_web_event
FROM web_events;

-- 4. Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at 
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

-- 5.Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT AVG(standard_amt_usd) AS avg_standard_price,
       AVG(gloss_amt_usd) AS avg_gloss_price,
       AVG(poster_amt_usd) AS avg_poster_price,
       AVG(standard_qty) AS avg_standard_qty,
       AVG(gloss_qty) AS avg_gloss_qty,
       AVG(poster_qty) AS avg_poster_qty
FROM orders;

-- 6. what is the MEDIAN total_usd spent on all orders?
SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
-- Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. This is the average of 2483.16 and 2482.55. This gives the median of 2482.855. This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit. SQL didn't even calculate the median for us. The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them.

