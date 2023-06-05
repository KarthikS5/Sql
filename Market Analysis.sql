create database Market_Analysis;
use Market_Analysis;

create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id int ,
 order_date date,
 item_id  int,
 buyer_id int ,
 seller_id int 
 );

 create table items
 (
 item_id int     ,
 item_brand varchar(50)
 );


 insert into users
 values (1,'2019-01-01','Lenovo'),
 (2,'2019-02-09','Samsung'),
 (3,'2019-01-19','LG'),
 (4,'2019-05-21','HP');

 insert into items 
 values (1,'Samsung'),
 (2,'Lenovo'),
 (3,'LG'),
 (4,'HP');

 insert into orders 
 values (1,'2019-08-01',4,1,2),
 (2,'2019-08-02',2,1,3),
 (3,'2019-08-03',3,2,3),
 (4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),
 (6,'2019-08-05',2,2,4);
 
 
 select * from users;
 select * from  orders;
 select * from items;
 
 -- write a query to find the the each seller whether the brand of the second item(by date)
--  they sold their fav,
--  if seller sold less than two items report the answer fro that seller as no. of output

-- Approach 1
with cte as (select *,
row_number() over (partition by seller_id order by order_date ) as rn
 from orders)
, fav as (select i.item_brand,u.favorite_brand,
           (case when i.item_brand=u.favorite_brand then 'yes' else 0 end )as cw
			from cte c left join items i
           on c.item_id=i.item_id
            left join users u
            on u.user_id=c.seller_id )
select * from fav 
 where cw ='yes';
 
 
 -- Approach 2
with cte as (select item_brand,
case when item_brand=favorite_brand then 'yes' end  as fav
from orders o left join items i
on o.item_id=i.item_id
left join users u
on u.user_id=o.seller_id)
 select *  from cte 
  where fav ='yes'
