create table orders
(
	order_id int primary key,
	date date not null,
	time time not null

)

select * from orders
--Retrieve the total number of orders placed.
select count(order_id) from orders -- 
21350

create table order_details
(
	order_details_id int primary key,
	order_id int not null,
	pizza_id varchar(50) not null,
	quantity int not null
)
select * from order_details

create table pizzas
(
	pizza_id varchar(50) primary key,
	pizza_type_id varchar(50) not null,
	size char(1) not null,
	price decimal(3,2) not null
	
)
select * from pizzas

alter table pizzas
drop column price 

alter table pizzas
add price int8 not null

--Calculate the total revenue generated from pizza sales.
select round(sum(o.quantity*p.price)) as total_sales
from order_details as o
join pizzas as p
on o.pizza_id=p.pizza_id
limit 1

--highest price pizza

select t.name,p.price
from pizzas as p
inner join pizza_types as t
on p.pizza_type_id= t.pizza_type_id
order by price desc
limit 1

--Identify the most common pizza size ordered.
select distinct count(size),size from pizzas
group by size
order by count desc
limit 1

--List the top 5 most ordered pizza types along with their quantities.

select distinct  name, sum(quantity)
from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
inner join order_details as o
on p.pizza_id=o.pizza_id
group by pt.name
order by sum desc
limit 5

--Join the necessary tables to find the total quantity of each pizza category ordered.

select  pt.category, sum(o.quantity)
from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
inner join order_details as o
on o.pizza_id=p.pizza_id
group by pt.category
order by sum desc

--Determine the distribution of orders by hour of the day.

select distinct extract (hour from o.time),sum(od.quantity)
from orders as o
inner join order_details as od
on od.order_id=o.order_id
group by extract 
order by extract asc

--Join relevant tables to find the category-wise distribution of pizzas.

select pt.category, sum(od.quantity)
from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
inner join order_details as od
on p.pizza_id=od.pizza_id
group by pt.category
order by sum desc

--Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(total_orders) from 
(select o.date , sum(od.quantity) as total_orders
from orders as o
inner join order_details as od
on o.order_id=od.order_id
group by o.date) as order_quantity
 
--Determine the top 3 most ordered pizza types based on revenue.

select pt.name, sum(od.quantity*p.price) as total_sales
from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
inner join order_details as od
on od.pizza_id=p.pizza_id
group by pt.name
order by total_sales desc
limit 3

--Calculate the percentage contribution of each pizza type to total revenue.


select pt.category, 
round(sum(od.quantity*p.price)) / (select round(sum(o.quantity*p.price)) 
as total_sales
from order_details as o
join pizzas as p
on o.pizza_id=p.pizza_id
limit 1)*100
as total_revenue
from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
inner join order_details as od
on od.pizza_id=p.pizza_id
group by pt.category
order by total_revenue desc

--Analyze the cumulative revenue generated over time.

select date, 
sum(revenue) over(order by date) as cum_revenue
from
(select o.date,sum(od.quantity*p.price) as revenue
from orders as o
inner join order_details as od
on o.order_id=od.order_id
inner join pizzas as p
on p.pizza_id=od.pizza_id
group by o.date)as sales



 












			
