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


GROUP BY
-- GROUP BY can be used to aggregate data within subsets of the data. For example, grouping for different accounts, different regions, or different sales representatives.

-- Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.

-- The GROUP BY always goes between WHERE and ORDER BY.

-- ORDER BY works like SORT in spreadsheet software.

-- Questions: GROUP BY
-- 1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT o.occurred_at, a.name
FROM Orders AS o 
JOIN accounts AS a 
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

-- 2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name, SUM(o.total_amt_usd) AS total_sales
FROM orders AS o 
JOIN accounts AS a 
ON o.account_id = a.id
GROUP BY a.name;

-- 3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT w.occurred_at , w.channel, a.name
FROM web_events AS w 
JOIN accounts AS a 
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- 4. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(*) AS total_number_times_uesd
FROM web_events
GROUP BY channel;

-- 5. Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM web_events AS w 
JOIN accounts AS a 
ON w.account_id = a.id
ORDER BY w.occurred_at 
LIMIT 1;

-- 6. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name , MIN(total_amt_usd) AS smallest_order
FROM Orders AS o 
JOIN accounts AS a 
ON o.account_id = a.id
GROUP BY a.name
ORDER BY smallest_order;

-- 7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name AS region_name , COUNT(s.id) AS count_of_salesrep
FROM region as r 
JOIN sales_reps AS s 
ON r.id = s.region_id
GROUP BY r.name
ORDER BY count_of_salesrep;

GROUP BY Part II
-- You can GROUP BY multiple columns at once, as we showed here. This is often useful to aggregate across a number of different segments.

-- The order of columns listed in the ORDER BY clause does make a difference. You are ordering the columns from left to right.

-- The order of column names in your GROUP BY clause doesn’t matter—the results will be the same regardless. If we run the same query and reverse the order in the GROUP BY clause, you can see we get the same results.

-- Questions: GROUP BY Part II
-- 1. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name , AVG(standard_qty) avg_std_qty, AVG(gloss_qty) avg_gloss_qty, AVG(poster_qty) avg_poster_qty
FROM orders o 
JOIN accounts a 
ON o.account_id = a.id
GROUP BY a.name;

-- 2. For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name , AVG(standard_amt_usd) avg_std_cost, AVG(gloss_amt_usd) avg_gloss_cost, AVG(poster_amt_usd) avg_poster_cost
FROM orders o 
JOIN accounts a 
ON o.account_id = a.id
GROUP BY a.name;

-- 4. Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT s.name , w.channel, COUNT(*) as num_of_event
FROM web_events w 
JOIN accounts a 
ON w.account_id = a.id
JOIN sales_reps s 
ON a.sales_rep_id = s.id 
GROUP BY s.name, w.channel
ORDER BY num_of_event DESC;

-- 4. Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT r.name , w.channel , COUNT(*) AS num_of_event
FROM web_events w 
JOIN accounts a 
ON w.account_id = a.id
JOIN sales_reps s 
ON a.sales_rep_id = s.id 
JOIN region r 
ON r.id = s.region_id
GROUP BY r.name, w.channel 
ORDER BY num_of_event DESC;


DISTINCT
-- DISTINCT is always used in SELECT statements, and it provides the unique rows for all columns written in the SELECT statement. Therefore, you only use DISTINCT once in any particular SELECT statement.

-- You could write:
SELECT DISTINCT column1, column2, column3
FROM table1;
-- which would return the unique (or DISTINCT) rows across all three columns.
-- You would not write:
SELECT DISTINCT column1, DISTINCT column2, DISTINCT column3
FROM table1;

-- Questions: DISTINCT
-- 1. Use DISTINCT to test if there are any accounts associated with more than one region.
-- The below two queries have the same number of resulting rows (351), so we know that every account is associated with only one region. If each account was associated with more than one region, the first query should have returned more rows than the second query.
SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;
-- and
SELECT DISTINCT id, name
FROM accounts;

-- 2.Have any sales reps worked on more than one account?
-- Actually all of the sales reps have worked on more than one account. The fewest number of accounts any sales rep works on is 3. There are 50 sales reps, and they all have more than one account. Using DISTINCT in the second query assures that all of the sales reps are accounted for in the first query.
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;
-- and
SELECT DISTINCT id, name
FROM sales_reps;


HAVING
-- HAVING is the “clean” way to filter a query that has been aggregated, but this is also commonly done using a subquery. Essentially, any time you want to perform a WHERE on an element of your query that was created by an aggregate, you need to use HAVING instead.

-- Questions: HAVING
-- 1. How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id,s.name, count(a.id) AS num_accounts
FROM accounts a 
JOIN sales_reps s 
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(a.id) > 5
ORDER BY num_accounts;

-- 2. How many accounts have more than 20 orders?
SELECT a.id,a.name, COUNT(o.id) AS num_order
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(o.id) > 20
ORDER BY num_order;

-- 3. Which account has the most orders?
SELECT a.id,a.name, COUNT(o.id) AS num_order
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_order DESC
LIMIT 1;

-- 4. Which accounts spent more than 30,000 usd total across all orders?
SELECT a.id , a.name, SUM(o.total_amt_usd) AS total_spent
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(total_amt_usd) > 30000
ORDER BY total_spent;

-- 5. Which accounts spent less than 1,000 usd total across all orders?
SELECT a.id , a.name, SUM(o.total_amt_usd) AS total_spent
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(total_amt_usd) < 1000
ORDER BY total_spent;

-- 6. Which account has spent the most with us?
SELECT a.id , a.name, SUM(o.total_amt_usd) AS total_spent
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

-- 7. Which account has spent the least with us?
SELECT a.id , a.name, SUM(o.total_amt_usd) AS total_spent
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

-- 8. Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.id,a.name, w.channel, COUNT(w.channel) use_of_channel
FROM web_events w 
JOIN accounts a 
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name , w.channel
HAVING COUNT(w.channel) > 6
ORDER BY use_of_channel;


-- 9. Which account used facebook most as a channel?
SELECT a.id,a.name, COUNT(w.channel) AS use_of_channel
FROM web_events w 
JOIN accounts a 
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name
ORDER BY use_of_channel DESC
LIMIT 1;

-- 10. Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) AS use_of_channel
FROM web_events w 
JOIN accounts a 
ON w.account_id = a.id
GROUP BY a.name, a.id, w.channel
ORDER BY used_by DESC
LIMIT 10;


DATE 
-- The first function you are introduced to in working with dates is DATE_TRUNC.
-- DATE_TRUNC allows you to truncate your date to a particular part of your date-time column. Common trunctions are day, month, and year.
-- DATE_PART can be useful for pulling a specific portion of a date, but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order. Rather you are grouping for certain components regardless of which year they belonged in.
-- NOTE: You can reference the columns in your select statement in GROUP BY and ORDER BY clauses with numbers that follow the order they appear in the select statement.

What is DATE_TRUNC()?
-- DATE_TRUNC() is a function used to round or truncate a timestamp to the interval you need. When used to aggregate data, it allows you to find time-based trends like daily purchases or messages per second.

How to use DATE_TRUNC() in SQL
-- To remove the unwanted detail of a timestamp, feed it into the DATE_TRUNC() function. The date_trunc function shortens timestamps so they are easier to read. 

Syntax
DATE_TRUNC('[interval]', time_column)
-- The time_column is the database column that contains the timestamp you'd like to round, and [interval] dictates your desired precision level. You can round off a timestamp to one of these units of time: day, month, second etc.

-- Questions: Working With DATEs
-- 1. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', o.occurred_at) AS year , SUM(total_amt_usd) total_spent
FROM orders o 
GROUP BY 1
ORDER BY 2 DESC;
-- When we look at the yearly totals, you might notice that 2013 and 2017 have much smaller totals than all other years. If we look further at the monthly data, we see that for 2013 and 2017 there is only one month of sales for each of these years (12 for 2013 and 1 for 2017). Therefore, neither of these are evenly represented. Sales have been increasing year over year, with 2016 being the largest sales to date. At this rate, we might expect 2017 to have the largest sales.

-- 2. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
-- In order for this to be 'fair', we should remove the sales from 2013 and 2017. For the same reasons as discussed above.
SELECT DATE_PART('month', occurred_at) AS month , SUM(total_amt_usd) total_sales
FROM orders o 
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
-- The greatest sales amounts occur in December (12).

-- 3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) AS year, COUNT(*) num_order
FROM orders o 
GROUP BY 1
ORDER BY 2 DESC;
-- Again, 2016 by far has the most amount of orders, but again 2013 and 2017 are not evenly represented to the other years in the dataset.

-- 4. Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) AS year, COUNT(*) num_order
FROM orders o 
GROUP BY 1
ORDER BY 2 DESC;
-- December still has the most sales, but interestingly, November has the second most sales (but not the most dollar sales. To make a fair comparison from one month to another 2017 and 2013 data were removed.

-- 5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', o.occurred_at) AS month, SUM(o.gloss_amt_usd) AS total_spend
FROM orders o 
JOIN accounts a 
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
-- May 2016 was when Walmart spent the most on gloss paper.