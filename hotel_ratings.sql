drop table if exists hotel_ratings;
create table hotel_ratings
(
	hotel 		varchar(30),
	year		int,
	rating 		float
);
insert into hotel_ratings values('Radisson Blu', 2020, 4.8);
insert into hotel_ratings values('Radisson Blu', 2021, 3.5);
insert into hotel_ratings values('Radisson Blu', 2022, 3.2);
insert into hotel_ratings values('Radisson Blu', 2023, 3.4);
insert into hotel_ratings values('InterContinental', 2020, 4.2);
insert into hotel_ratings values('InterContinental', 2021, 4.5);
insert into hotel_ratings values('InterContinental', 2022, 1.5);
insert into hotel_ratings values('InterContinental', 2023, 3.8);

select * from hotel_ratings;


#PROBLEM STATEMENT: In the given input table, there are hotel ratings which are either too high or too low compared to the standard ratings the hotel receives each year.
--                  Write a query to identify and exclude these outlier records as shown in expected output below. 


with cte as 
	(select *, round(avg( rating) over(partition by hotel),2) as mean_rating,
          abs(round((rating- round(avg( rating) over(partition by hotel),2)),2)) as diff
	from hotel_ratings),

cte2 as 
		(select * , max(diff) over(partition by hotel) as maxi
		from cte)

select hotel, year, rating  from 
cte2
where diff!=maxi
order by hotel desc , year;



#more simpler
with cte as 
	(select *, round(avg( rating) over(partition by hotel),2) as mean_rating 
	from hotel_ratings),

cte2 as 
		(select *,  #abs(round(( rating- mean_rating),2)) as diff,
				  rank() over(partition by hotel order by abs(rating- mean_rating) desc) as rnk
		   from cte)

select hotel, year, rating from  cte2
where rnk !=1
order by hotel desc , year



