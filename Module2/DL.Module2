/*Product Categories*/
select
category,
sum(sales) total_sales, 
sum(profit) total_profit
from orders o
group by category;


select 
sum(profit)/sum(sales) * 100 as profit_ratio,
sum(profit)/count(order_id)
from orders o 