CREATE TABLE sales_data (
  `customer_id` VARCHAR(1),
  `order_date` DATE,
  `product_id` INTEGER
);

INSERT INTO sales_data
  (`customer_id`, `order_date`, `product_id`)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');



CREATE TABLE menu (
  `product_id` INTEGER,
  `product_name` VARCHAR(5),
  `price` INTEGER
);


INSERT INTO menu
  (`product_id`, `product_name`, `price`)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');


CREATE TABLE members (
  `customer_id` VARCHAR(1),
  `join_date` DATE
);


INSERT INTO members
  (`customer_id`, `join_date`)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
-- 1. What is the total amount each customer spent at the restaurant?
 select customer_id, sum(price) as cust_tot_amt 
 from sales_data
 inner join menu
 on sales_data.product_id = menu.product_id
 group by customer_id;
  
 -- 2. How many days has each customer visited the restaurant?
select customer_id, count(order_date) no_times_visited 
from sales_data
group by customer_id; 
 
 -- 3. What was the first item from the menu purchased by each customer?
with t1 as
(
select customer_id, order_date, product_name, price,
 row_number() over(partition by customer_id order by order_date) as first_order from sales_data
inner join menu
	on sales_data.product_id = menu.product_id
)
select * from t1 where first_order = 1;
 
 
 -- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_name, most_purchased from  
(select product_name, count(product_name) as most_purchased, row_number() over() as row_num from sales_data
 inner join menu
  on sales_data.product_id = menu.product_id
  group by product_name) t2
  order by row_num desc
  limit 1;


-- 5. Which item was the most popular for each customer?
with t3 as
(
select customer_id, product_name, count(product_name) as max_order, 
dense_rank() over(partition by customer_id order by count(product_name) desc) as rank_for_max_order from sales_data
inner join menu
	on sales_data.product_id = menu.product_id
group by customer_id, product_name)
select customer_id, product_name from t3 where rank_for_max_order = 1;

-- 6. Which item was purchased first by the customer after they became a member?
with t4 as
(
select sales_data.customer_id as s_cust_id, order_date, sales_data.product_id as s_product_id, join_date, product_name, price,
 case
	when order_date >= join_date then '0' or '1'  
 end as mem_or_not
 from sales_data
 inner join members 
	on sales_data.customer_id = members.customer_id
right join menu
	on sales_data.product_id = menu.product_id
order by s_cust_id
), final_table as
(
select *, row_number() over(partition by s_cust_id) as r_num 
from t4 
where mem_or_not = 1
)
select S_cust_id, product_name from final_table  where mem_or_not = 1 and r_num = 1; 


-- 7. Which item was purchased just before the customer became a member?
with t4 as
(
select sales_data.customer_id as s_cust_id, order_date, sales_data.product_id as s_product_id, join_date, product_name, price,
 case
	when order_date >= join_date then '0' or '1'  
 end as mem_or_not
 from sales_data
 inner join members 
	on sales_data.customer_id = members.customer_id
right join menu
	on sales_data.product_id = menu.product_id
order by s_cust_id
), final_table as
(
select *, row_number() over(partition by s_cust_id) as r_num 
from t4 
where mem_or_not is null
)
select S_cust_id, product_name from final_table  where mem_or_not is null and r_num = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
with t4 as
(
select sales_data.customer_id as s_cust_id, order_date, sales_data.product_id as s_product_id, join_date, product_name, price,
 case
	when order_date >= join_date then '0' or '1'  
 end as mem_or_not
 from sales_data
 inner join members 
	on sales_data.customer_id = members.customer_id
right join menu
	on sales_data.product_id = menu.product_id
order by s_cust_id
), final_table as
(
select *, row_number() over(partition by s_cust_id) as r_num 
from t4 
where mem_or_not is null
)
select s_cust_id, count(s_cust_id) as order_count, sum(price) as total_cost 
from final_table
group by s_cust_id; 

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with t5 as
(
select customer_id, order_date, sales_data.product_id as s_product_id, product_name, price,
case
	when product_name = 'sushi' then (price * 20)
    when product_name != 'sushi' then (price * 10)
end product_points
from sales_data
inner join menu
	on sales_data.product_id = menu.product_id
)
select customer_id, sum(product_points) as total_points 
from t5
group by customer_id;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi: 
-- how many points do customer A and B have at the end of January?
with t4 as
(
select sales_data.customer_id as s_cust_id, order_date, sales_data.product_id as s_product_id, join_date, product_name, price,
 case
	when order_date >= join_date then '0' or '1'  
 end as mem_or_not
 from sales_data
 inner join members 
	on sales_data.customer_id = members.customer_id
right join menu
	on sales_data.product_id = menu.product_id
order by s_cust_id
)
select *, row_number() over(partition by s_cust_id) as r_num 
from t4 
where mem_or_not = 1;















