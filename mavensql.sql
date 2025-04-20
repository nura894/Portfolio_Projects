select * from order_details

select * from menu_items

--View the menu_items table and write a query to find the number of items on the menu

select count(*)
from menu_items

--What are the least and most expensive items on the menu?

select item_name, price
from menu_items
where price =(select max(price) from menu_items)
or price= (select min(price) from menu_items)

--How many Italian dishes are on the menu?


select * from order_details

select * from menu_items

select count(*) as total_italian_dishes
from menu_items
where category= 'Italian'

--What are the least and most expensive Italian dishes on the menu?

select * from menu_items

select item_name as italian_dishes, price
from menu_items
where price = (select max(price) from menu_items where category= 'Italian' )
or price = (select min(price) from menu_items where category= 'Italian')


--How many dishes are in each category?

select category, count(*)
from menu_items
group by category


--What is the average dish price within each category?

select category , round(avg(price),2) as avg_price
from menu_items
group by category


--View the order_details table. What is the date range of the table?

select * from order_details
select max(order_date) , min(order_date) from order_details


--How many orders were made within this date range? 
select count(distinct order_id)
from order_details


--How many items were ordered within this date range?
select * from order_details

select count(*)
from order_details

--Which orders had the most number of items?
with cte as 
	(select order_id, count(item_id) as items
	from order_details
	group by order_id)
select *
from cte 
where items= (select max(items) from cte)


--How many orders had more than 12 items?

with cte as 
	(select order_id, count(item_id) as items
	from order_details
	group by order_id)
select count(*)
from cte 
where items>12


--Combine the menu_items and order_details tables into a single table
select * from order_details
select * from menu_items

select *
from menu_items m
join order_details o on m.menu_item_id =o.item_id


--What were the least and most ordered items? What categories were they in?

with cte as
	(select m.item_name, m.category, count(*) as total_ordered
	from menu_items m
	join order_details o on m.menu_item_id =o.item_id
	group by m.item_name , m.category)
select *
from cte
where total_ordered = (select max(total_ordered) from cte) 
or    total_ordered = (select min(total_ordered) from cte)


--What were the top 5 orders that spent the most money?

select order_id, sum(price)
from menu_items m
join order_details o on m.menu_item_id =o.item_id
group by 1
order by 2 desc
limit 5

--View the details of the top 5 highest spend order. Which specific items were purchased?

select category, count(*)
from menu_items m
join order_details o on m.menu_item_id =o.item_id 
where order_id in 
    (select order_id 
	from menu_items m
	join order_details o on m.menu_item_id =o.item_id
	group by 1
	order by sum(price) desc
	limit 5)
group by 1


--Top 5 item_name by total price spend.
with cte as
	(select m.item_name, m.category, count(*) as total_ordered, sum(m.price) price
	from menu_items m
	join order_details o on m.menu_item_id =o.item_id
	group by m.item_name , m.category)
select *
from cte
order by price desc
limit 5