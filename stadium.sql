create database Stadium;
use Stadium;

drop table if exists stadium;
create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);



/* Write a query to display the records which have 3 or more number consecutive rows
-- write amount of people more than 100(inculsive) each day -- 
write query as 
 id  visite_date  no_of-people
 5   '2017-07-05'    145
 6   '2017-07-05'    1455
 7   '2017-07-05'    199
 8   '2017-07-05'    188 
 */
 
 select * from stadium;
 
--  Approach 1
with cte as (select *,
row_number() over() as rn,
id-row_number() over() as irn
from stadium
where no_of_people>100)
select *  from cte 
where irn>1
;

-- approach 2

with cte as (select *,
lag(no_of_people) over () as prv_one_day,
lag(no_of_people,2) over () as prv_two_day,
 lead(no_of_people) over () as next_one_day,
lead(no_of_people,2) over () as next_two_day
from stadium)
select id,visit_date,no_of_people from cte
where no_of_people >=100  and prv_one_day>=100 and prv_two_day>=100 
or 
no_of_people >=100 and next_one_day>=100 and next_two_day>=100