create database product_tq;
use product_tq;

CREATE TABLE product
( 
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);

INSERT INTO product VALUES
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);
COMMIT;

select * from product;

with cte as (select * ,
row_number() over (partition by product_category order by price desc ) as rn
from product)
select * from cte 
 where rn =1;
 
 -- FIRST_VALUE 
-- Write query to display the most expensive product under each category (corresponding to each record)
select *,
FIRST_VALUE(product_name)  over(partition by product_category order by price desc) as most_exp_product,
 row_number() over(partition by product_category order by price desc) as rn
from product;

-- Write query to display the where total price greater than avg price product under each category.
select product_category,price,sum(price) as total,
row_number() over(partition by product_category order by sum(price) desc) as rn 
from product
where price >(select round(avg(price),2) from product
 )
 group by 1,2 ;

-- Write query to display the average price  with percent rank product under phone category.
select *,
round(avg(price)  over(partition by product_category )) as avg_product,
percent_rank () over(partition by product_category order by price desc )
 from product
 where product_category ='phone';
 
 
 -- Write query to display the most expensive product under each category "HIGHEST EXPENSIVE" (corresponding to each record)

 with most_exp_pro_each_category as (select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product,
row_number() over(partition by product_category order by price desc) as rn
from product)
select * from most_exp_pro_each_category
where rn<=1;

-- Write query to display the most expensive product under each category "LEAST EXPENSIVE" (corresponding to each record)

 with least_exp_pro_each_category as (select *,
last_value(product_name) over(partition by product_category order by price desc rows between unbounded preceding and unbounded following) as least_exp_product,
row_number() over(partition by product_category order by price desc) as rn
from product)
select * from least_exp_pro_each_category
where rn<=1;


with cte as (select *,
row_number() over (partition by product_category order by price desc)  as rn ,
first_value(product_name) over (partition by product_category order by price desc rows between 2 preceding and 2 following)  as most_exp ,
last_value(product_name ) over (partition by product_category order by price  desc rows between 2 preceding and 2 preceding )  as low_exp 
,nth_value(product_name,5)over (partition by product_category order by price desc rows between unbounded preceding and unbounded following ) as nth
from product)
select * from cte 
where rn <=1 and product_category='phone';

-- NTH_VALUE 
-- Write query to display the Second most expensive product under each category.
-- second_most_exp_product means it takes value of 6th expensive price from table
-- or you can retrieve data any kind of price putting "nth_value"
select *,
 first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 6) over(partition by product_category order by price desc) AS second_most_exp_product
from product
window w as (partition by product_category order by price desc
            range between unbounded preceding and current row  );
            
            
            
-- NTILE
-- Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.
--  Ntile mainly divide by entire row with given input
select product_name, 
case when buckets = 1 then 'Expensive Phones'
     when buckets = 2 then 'Mid Range Phones'
     when buckets = 3 then 'Cheaper Phones' 
     when buckets = 4 THEN  'LOWEST PHONES'
     END as Phone_Category
from  (select *,
    ntile(5) over (order by price desc) as buckets
    from product
    where product_category = 'Phone') x;  
    
-- query to fetch all product which are constituting first 30%
with cte as  (select *,
cume_dist() over (order by price desc ) as cume_distribution,
cast(round(cume_dist() over (order by price desc)*100,2 ) as decimal )as cume_dist_percetage
from product)
select * from cte 
where cume_dist_percetage<=40 and product_category='laptop';

-- query to find how much percentage more expensive of galaxy z flip 3  or airpods pro  Percent rank
with cte as (select*,
percent_rank() over (order by price ) as percent,
cast(round(percent_rank() over (order by price )*100,2 ) as decimal ) as per_rate
from product)
select* from cte
where product_name='galaxy z flip 3' or product_name ='airpods pro';


-- mean
 select avg(price) from product
 
-- median 
SELECT
    SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(price ORDER BY price), ',', (COUNT(*) + 1) DIV 2), ',', -1) AS median_value
FROM
    product;
    
    
    -- Mode 
SELECT price AS mode_value
FROM (
    SELECT price, COUNT(price) AS count
    FROM product
    GROUP BY price
    ORDER BY count DESC
    LIMIT 1
) AS subquery;

