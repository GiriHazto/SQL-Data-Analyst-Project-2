CREATE DATABASE IF NOT EXISTS walmartSales;
use  walmartsales;

select * from sales;

-- --------------------------------------------------------------------------------------
-- Feature Engineering ------------------------------------------------------------------

-- time of the day -----

Select time from sales;

-- Add the time of the day ---

select time,
(case
	when time between "00:00:00"and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
end)
 as time_of_date
from sales;

Alter table sales Add column time_of_day varchar(20);
update sales 
set time_of_day = (
case when time between "00:00:00"and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
    end
);


-- day_name of the column  ---------------------------------------------------------------------------

select date, 
	dayname(date) from sales;
    
alter table sales add column day_name varchar(20);
update sales 
set day_name = dayname(date);
select * from sales;

-- month_name (new column) ----------------------------------------------------------

select date, monthname(date) from sales;

alter table sales add column month_name varchar(20);
update sales 
set month_name = monthname(date);
select * from sales;

-- what is the total revenue by month ----------------------------------------------
select 
	month_name as month ,
    sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- Generic -----------------------------
--  how many unique cities does the date have? ----------------

select distinct city from sales;
select distinct branch from sales;
select distinct city, branch from sales;


--  what month had the largest COGS? ---------------
select 
	month_name as month, 
    sum(cogs) as COGS
from sales
group by month_name 
order by Cogs desc;
-- How many unique product lines does the data have --------------
select count(distinct product_line) from sales; 

-- what is the most common payment method -------------------------
select count(payment_method) as cnt from sales
group by payment_method;

-- what is the city with the largest revenue ----------------------------

select branch, city, sum(total) as total_revenue
from sales
group by  city, branch
order by total_revenue desc;
    
-- which branch sold more products than average product sold ------------------

select branch, sum(quantity) as qty
from sales
group by branch 
having sum(quantity) >
(select avg(quantity) from sales);

-- What is the average rating of each product line ---- 
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;



-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

