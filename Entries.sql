create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),
('A','Bangalore','A1@gmail.com',1,'CPU'),
('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),
('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
('B','Bangalore','B2@gmail.com',1,'MONITOR');



 
with cte as 
(select floor, name, count(floor) as floor_visited
, rank() over (partition by name order by count(floor) desc) as rn
from entries
group by floor,name)
, total_visite as
(select name, count(1) as visite ,group_concat(distinct resources,'') as resource_used from entries
group by name)
select ct.floor as most_visite, ct.name, tv.visite, tv.resource_used
from cte ct inner join total_visite tv
on  tv.name= ct.name
where rn =1
;


select name, resources from
(select name, resources ,
group_concat(resources,'') as gp 
from
entries
group by name, resources 
) a
where gp not like '%c%'
