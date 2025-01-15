-- Q4 : Convert the given input to expected output --- 

drop table src_dest_distance;
create table src_dest_distance
(
    source          varchar(20),
    destination     varchar(20),
    distance        int
);
insert into src_dest_distance values ('Bangalore', 'Hyderbad', 400);
insert into src_dest_distance values ('Hyderbad', 'Bangalore', 400);
insert into src_dest_distance values ('Mumbai', 'Delhi', 400);
insert into src_dest_distance values ('Delhi', 'Mumbai', 400);
insert into src_dest_distance values ('Chennai', 'Pune', 400);
insert into src_dest_distance values ('Pune', 'Chennai', 400);

select * from src_dest_distance;

# removing the dublicate data 
# 1st solution 

with cte as 
		(select *, case when source> destination then concat(source, destination) 
				  else concat(destination, source) end as together
		from src_dest_distance),
tab as (select *, row_number () over( partition by together) as rnk  from cte 
			)
select * from tab
where rnk>1;



#  2nd solution 

with cte as (select * , row_number () over () as num
             from src_dest_distance) 
select c1.source, c1.destination from cte c1 
join cte c2  on c1.num < c2.num 
			and c1.source= c2.destination 
			and c1.destination=c2.source






