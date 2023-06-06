create database case_study;
use case_study;

CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);


select * from customers;
select * from orders;
select * from products;
select * from order_items;



-- 1) Which product has the highest price? Only return a single row.

select * from products 
where price = (select  max(price) 
from products);

-- 2) Which customer has made the most orders?

-- Approach 1
with cte as (select o.customer_id, count(*) as highest_orders,
dense_rank () over (order by count(*) desc)  as rn 
from  orders o join customers c
on o.customer_id=c.customer_id
group by 1) 
select * from cte 
where rn =1;
 

-- approach 2
with cte as (select customer_id,
count(*) as cmi
from orders 
group by customer_id)
select  CT.customer_id, C.first_name,C.last_name FROM 
CTE CT JOIN CUSTOMERS C
ON C.CUSTOMER_ID = CT.CUSTOMER_ID
 WHERE CMI IN (SELECT MAX(CMI) FROM CTE);
 
 
 -- 3) What’s the total revenue per product?
 
select p.product_name,p.product_id, sum(p.price*o.quantity)as revenue from 
order_items o join products p
on p.product_id=o.product_id
group by 1,2
order by revenue desc
;

-- 4) Find the day with the highest revenue.

select o.order_date,sum(p.price*i.quantity) as revenue
from orders o join order_items i 
on o.order_id=i.order_id
join products p 
on p.product_id=i.product_id
group by 1
order by revenue desc
 limit 1
;

-- 5) Find the first order (by date) for each customer.

select * 
from orders o ;

with cte as (select  *,
row_number() over (partition by customer_id order by order_date ) as rownum
 from orders)
  select * from cte 
where rownum=1;

-- 6) Find the top 3 customers who have ordered the most distinct products
select * from orders ;
select * from products;
select * from customers; 
select * from order_items;
 
 select  o.customer_id, first_name,count(distinct i.product_id) as total_order from
 orders o join customers c
on c.customer_id=o.customer_id
join order_items  i
on o.order_id=i.order_id
group by 1;

select c.customer_id, count(distinct i.product_id) as total,
rank () over( order by c.customer_id ) as dn
from orders c join order_items i 
 on c.order_id=i.order_id
group by 1;

-- 7) Which product has been bought the least in terms of quantity?

with cte as  (select product_name as name,i.product_id as product,sum( quantity) as total
-- row_number()over(partition by sum( quantity) order by product_name)  as rn
from products p join order_items i 
on i.product_id=p.product_id
group by 1,2
order by total ) 
   select name,product from cte 
    where total=3
;
  -- or
with cte as (select product_id ,
sum(quantity) as q
from order_items
group by 1)
select * from cte 
where q =(select min(q) from cte);


-- 8) What is the median order total?
-- here round(price,4)- for the odd ,
-- avg(price) for the even

select round(price,4) as median from  (select p.product_id, sum(price*quantity) as price, 
row_number() over ( order by sum(price*quantity) asc, product_id asc) as rn,
row_number() over (order by sum(price*quantity) desc) as rnn
from products p join order_items i
on i.product_id=p.product_id
group by 1
order by price )a
  where rn in (rnn, rnn-1,rnn+1)
   ;

-- 9) For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
with cte as (select  i.order_id, sum(p.price*i.quantity) as total
from order_items i join products p 
on i.product_id=p.product_id
group by 1)
select  order_id,total,
case when total>300 then 'Expensive' 
when total>100 then 'Affordable' else 'cheap'
end as order_type 
from cte 
;
-- 10) Find customers who have ordered the product with the highest price.
with cte as (select c.customer_id as cc,first_name as name ,p.price
from customers c join orders o
on o.customer_id = c.customer_id
join order_items i 
on i.order_id=o.order_id
join products p
on p.product_id = i.product_id
)
    select cc, name ,max(price) as highest from cte
     group by 1,2
     order by highest desc
     
     
