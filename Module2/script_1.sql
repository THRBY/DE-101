--Total Sales & Profit & Profit Ratio
select 
	round(sum(sales), 2) as total_sales, 
	round(sum(profit), 2) total_profit,
	round(sum(profit)/sum(sales), 2) profit_ratio	
from orders o;

--Profit per Order
select 
	region,
	segment,
	order_id,
	round(sum(profit), 2) total_profit,
	count(order_id)
from orders o
group by region, segment, order_id
order by region, segment, total_profit desc;
	
--Sales per Customer
select 
	customer_name,
	customer_id,
	round(sum(sales), 2) as total_sales
from orders o 
group by customer_id, customer_name
order by total_sales;

--Avg. Discount
select 
	order_date,
	round(sum(sales), 2) as total_sales, 
	round(sum(profit), 2) total_profit,
	round(avg(discount), 3) avg_discount 
from orders o
group by order_date
order by order_date;

--Monthly Sales by Segment
SELECT 	
	segment,
	EXTRACT(YEAR FROM order_date) AS sale_year,
	EXTRACT(MONTH FROM order_date) AS sale_month,
	round(sum(sales), 2) AS Продажи
FROM public.orders
GROUP BY segment, sale_year, sale_month
ORDER BY sale_year, sale_month;

--Monthly Sales by Product Category
select
	category, 
	EXTRACT(YEAR FROM order_date) as sale_year
	,EXTRACT(MONTH FROM order_date) as sale_month
	,round(sum(sales), 2) as Sales
FROM public.orders
group by sale_year, sale_month,category
order by sale_year, sale_month;

--Product Category
select
	category,
	round(sum(sales), 2) total_sales, 
	round(sum(profit), 2) total_profit
from orders o
group by category
order by 1;
	
-- Sales and Profit by Customer
select 
	customer_name,
	round(sum(sales), 2) as total_sales,
	round(sum(profit), 2) as total_profit
from orders o 
	group by customer_name;
