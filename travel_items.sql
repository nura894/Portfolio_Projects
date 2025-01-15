create table travel_items
(
	id              int,
	item_name       varchar(50),
	total_count     int
);
insert into travel_items values (1, 'Water Bottle', 2);
insert into travel_items values (2, 'Tent', 1);
insert into travel_items values (3, 'Apple', 4);


-- Q5 : Ungroup the given input data --- 


select * from travel_items;

# this query will require recursion 
# we use level to check the iteration 

with recursive cte as (select id, item_name, total_count, 1 as level  from travel_items 
             union 
             select c1.id , c1.item_name, c1.total_count -1 , c1.level +1  from cte c1
              where c1.total_count >1 
                 )
select * from cte
order by level;




# A sample , how recursion works
with recursive numbers as  (select 1 as n
                        union 
                        select n+1 from numbers
                        where n<10
						)
select * from numbers
