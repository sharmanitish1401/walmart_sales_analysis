use walmart;
select * from walmart_table;
 
select count(*) from walmart_table;

select distinct payment_method from walmart_table;

-- 1 Find out different no. of payment method and no. of transaction , no. of quantity sold
select payment_method, count(*) as no_of_payements  from walmart_table
group by payment_method
;
-- 2 select total quantity sold in different payment method
select payment_method,  sum(quantity) as No_of_quantity_sold from walmart_table
group by payment_method
;
select count(distinct Branch) from walmart_table;

-- 3 indentify highest rated category in each branch displaying branch category and avg rating
select Branch, category , avg(rating)
from walmart_table
group by 1, 2
order by 1,3 desc;


-- find the avg rating for each branch and category
select * from (
select Branch, category , avg(rating) as avg_rating, rank() over(partition by Branch order by avg(rating) DESC) as ranked
from walmart_table
group by 1, 2
) as t
where ranked =1;

-- determine the avg, min, max  rating of product  for each city 
select City, category
, min(rating) as min_rating, max(rating) as max_rating, avg(rating) as avg_rating 
from walmart_table
group by 1,2;

-- find the category wise profit
select category , sum(Total*profit_margin) as total_profit from walmart_table
group by 1
order by total_profit desc;

	-- select payment method which is mostly used in branch
with cte
as
(select branch , 
       payment_method , 
	   count(payment_method) as no_of_times_used, 
       Rank() over(partition by branch order by count(payment_method) DESC) as ranking
from walmart_table
group by branch , payment_method
)
select * from CTE
where ranking=1;

-- categorize the sales into 3 groups morning, afternoon, evening
-- find out each shift and no. of invoices
WITH CTE
AS
(select *,
       case
       when extract(hour from time) between 6 and 11 then  'MORNING'
       when extract(hour from time) between 12 and 17 then  'AFTERNOON'
	   ELSE 'EVENING'
       END AS SHIFT
FROM WALMART_TABLE)

SELECT BRANCH, SHIFT, COUNT(*) AS INVOICE FROM CTE
group by BRANCH, SHIFT;




-- indentify 5 branch with highest  decrease ration in revenue compare to last year

WITH REVENUE_2022
AS
(
SELECT BRANCH, SUM(TOTAL) AS REVENUE_2022 FROM WALMART_TABLE
WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
GROUP BY BRANCH
),      
REVENUE_2023
AS
(SELECT BRANCH, SUM(TOTAL) AS REVENUE_2023 FROM WALMART_TABLE
 WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
 GROUP BY BRANCH
)

SELECT D.BRANCH, D.REVENUE_2022, C.REVENUE_2023, round((REVENUE_2022-REVENUE_2023)/REVENUE_2022 *100 , 2)AS RATIO FROM REVENUE_2022 D
JOIN REVENUE_2023 C ON C.BRANCH=D.BRANCH
GROUP BY D.BRANCH
order by 4 DESC;


-- indentify  the busiest day for each branch on no. of transactions


with cte
as
(select *, Dayname(STR_TO_DATE(date, '%d/%m/%y')) as Day from walmart_table
)
select branch , count(*) as no_of_transaction, Day from CTE
group by 1,3 
order by 1,2 desc;