select * from walmart;


--Q1 solutions:
select 
	distinct payment_method, 
	count (*) as no_of_payments,
	sum(quantity) as num_qty_sold
	from walmart
	group by payment_method;

-- Q2 solutions
select *
from
(
	select branch,
		category,
		avg(rating) as avg_rating,
		rank() over(
		partition by branch order by avg(rating) desc 
		)
		as rank
		from walmart
		group by 1,2
)
where rank = 1;

--Q3 solution
select *
from 
(
	select
		branch,
		to_char(to_date(date, 'dd/mm/yy'), 'Day') as day,
		count(*) as no_transaction,
		rank() over(partition by branch order by count(*) desc) as rank
	from walmart
	group by 1, 2
)
where rank = 1;

-- Q4 solution
select 
	distinct payment_method, 
	count (*) as no_of_payments
	from walmart
	group by payment_method;

-- Q5 solution

select 
	city,
	category,
	max(rating) as max_rating,
	min(rating) as min_rating,
	avg(rating) as rating
from walmart
group by 1,2;

-- Q6 solution
select 
	category,
	sum(total) as total_revenue,
	sum(total*profit_margin) as profit_margin
from walmart
group by 1;

-- Q7 solution
with cte
as
(
	select 
	branch,
	payment_method,
	count(*) as total_transaction,
	rank() over(partition by branch order by count(*) desc) as rank
from walmart
group by 1,2 
)
select *
from cte
where rank = 1

-- Q8 solution
select 
branch,
	case
		when extract(hour from (time::time)) < 12 then 'morning'
		when extract(hour from (time::time)) between 12 and 17 then 'afternoon'
		else 'evening'
	end day_time,
	count(*) as invoices
from walmart
group by 1,2
order by 1,3 desc;