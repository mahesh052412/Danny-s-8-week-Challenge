-- Creating table and inserting values
 
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  `runner_id` INTEGER,
  `registration_date` DATE
);
INSERT INTO runners
  (`runner_id`, `registration_date`)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  `order_id` INTEGER,
  `customer_id` INTEGER,
  `pizza_id` INTEGER,
  `exclusions` VARCHAR(4),
  `extras` VARCHAR(4),
  `order_time` TIMESTAMP
);

INSERT INTO customer_orders
  (`order_id`, `customer_id`, `pizza_id`, `exclusions`, `extras`, `order_time`)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  `order_id` INTEGER,
  `runner_id` INTEGER,
  `pickup_time` VARCHAR(19),
  `distance` VARCHAR(7),
  `duration` VARCHAR(10),
  `cancellation` VARCHAR(23)
);

INSERT INTO runner_orders
  (`order_id`, `runner_id`, `pickup_time`, `distance`, `duration`, `cancellation`)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  `pizza_id` INTEGER,
  `pizza_name` TEXT
);
INSERT INTO pizza_names
  (`pizza_id`, `pizza_name`)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  `pizza_id` INTEGER,
  `toppings` TEXT
);
INSERT INTO pizza_recipes
  (`pizza_id`, `toppings`)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  `topping_id` INTEGER,
  `topping_name` TEXT
);
INSERT INTO pizza_toppings
  (`topping_id`, `topping_name`)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  

  
CREATE TABLE sec_cust_orders(
  `order_id` INTEGER,
  `customer_id` INTEGER,
  `pizza_id` INTEGER,
  `exclusions` VARCHAR(4),
  `extras` VARCHAR(4),
  `order_date` date,
  `order_time` time
);  

select * from sec_cust_orders;

-- Creating new table and spliting date and time
insert sec_cust_orders
select order_id, customer_id, pizza_id, exclusions, extras, 
		substring_index(substring_index(order_time, ' ',1), ' ', -1) as order_date,
		substring_index(substring_index(order_time, ' ',2), ' ', -1) as order_time1
from customer_orders;


-- Cleaning the data
-- Upadting the null values
update sec_cust_orders
set extras = 0
where extras = '' or extras = 'null' or extras is null;

update sec_cust_orders
set extras = trim(extras);

select * from sec_cust_orders;

-- Standerdaizing the data to new rows and columns
create table final_sec_cust_orders as
select *, left(exclusions, 1) as exclusion,
		  left(extras, 1) as extra
          from sec_cust_orders
union
select *, right(exclusions, 1) as exclusion,
		  right(extras, 1) as extra
          from sec_cust_orders
;

-- Droping the unwanted column
alter table final_sec_cust_orders
drop column extras;

-- Final table for cust orders
select * from final_sec_cust_orders
order by order_id;


select * from runner_orders;

-- Spliting the date and time to new column
create table runner_order as
select *, substring_index(pickup_time,' ', 1) as pickup_date,
		  substring_index(pickup_time,' ', -1) as pickup_time1
          from runner_orders;
          
select * from runner_order;

-- Droped the column
alter table runner_order
drop column pickup_time;

-- Updating the null values
update runner_order
set distance = 0
where distance = 'null';

update runner_order
set duration = 0
where duration = 'null';

update runner_order
set cancellation = 'delivered'
where cancellation = '';

update runner_order
set pickup_time1 = 0
where pickup_time1 = 'null' or pickup_time1 is null;

update runner_order
set pickup_date = '1999-01-01'
where pickup_date = '0000-00-00';

-- Replacing the values by standardizing 
update runner_order set distance = replace(distance, 'km', '');

update runner_order set duration = replace(duration, 'mins', '');

-- Taking out the spaces
update runner_order set duration = trim(duration);
update runner_order set distance = trim(distance);
update runner_order set cancellation = trim(cancellation);
update runner_order set pickup_date = trim(pickup_date);
update runner_order set pickup_time = trim(pickup_time);


-- Updating the data types
alter table runner_order
modify distance int;

alter table runner_order
modify duration int;

alter table runner_order
modify pickup_time1 time;

alter table runner_order
modify pickup_date date;

select * from final_sec_cust_orders;
select * from runners;
select * from runner_order;
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;

-- PIZZA METRICS

-- 1.How many pizzas were ordered?
select count(order_id) as pizzas_ordered from final_sec_cust_orders;

-- 2.How many unique customer orders were made?
with t1 as 
(
select  distinct order_id from final_sec_cust_orders
)
select count(order_id) as u_cust_orders from t1;
 
 -- 3.How many successful orders were delivered by each runner?
 select count(order_id) successful_orders from runner_order
 where cancellation = '';

-- How many of each type of pizza was delivered?
select count(pizza_id) as type_of_pizza_delivered
from ( select pizza_id from final_sec_cust_orders group by pizza_id) t1;

-- How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id, pizza_id, count(customer_id) as no_of_orders_cust from final_sec_cust_orders
group by customer_id, pizza_id
order by customer_id;


-- What was the maximum number of pizzas delivered in a single order?

select final_sec_cust_orders.order_id, count(final_sec_cust_orders.order_id) as delivered_pizza 
from final_sec_cust_orders
inner join runner_order
	on final_sec_cust_orders.order_id = runner_order.order_id
group by final_sec_cust_orders.order_id
order by delivered_pizza desc
limit 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select (select count(order_id) 
from final_sec_cust_orders
where exclusion > 0 or extra > 0) atleast_1_change ,(select count(order_id)
from final_sec_cust_orders
where exclusion = 0 and extra = 0) no_change from final_sec_cust_orders
limit 1;


-- How many pizzas were delivered that had both exclusions and extras?
select count(final_sec_cust_orders.order_id) as delivered_pizza 
from final_sec_cust_orders
inner join runner_order
	on final_sec_cust_orders.order_id = runner_order.order_id
where cancellation = 'delivered' and exclusion > 0 and extra > 0;

-- What was the total volume of pizzas ordered for each hour of the day?

select * 
from final_sec_cust_orders
order by order_date, order_time;



