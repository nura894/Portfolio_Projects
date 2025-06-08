/* 1) Find the overall most popular girl and boy names and show 
how they have changed in popularity rankings over the years */
-- most popular names

select name, sum(births) from names
where gender = 'F'
group by name
order by 2 desc 
limit 5  --Jessica

with girls_overyear as 
	(select year,name, dense_rank() over(partition by year order by sum(births) desc ) as rnk
	from names
	where gender = 'F'
	group by year, name)
select * from girls_overyear
where name = 'Jessica'
	

select name, sum(births) from names
where gender = 'M'
group by name
order by 2 desc 
limit 30


with boys_overyear as 
	(select year,name, row_number() over(partition by year order by sum(births) desc ) as rnk
	from names
	group by year, name)
select * from boys_overyear
where name = 'Aliyah'
and year = 1980

select * from names
limit 5


-- 2) Find the names with the biggest jumps in popularity from the first year of the data set to the last year
with use as
	(with all_overyear as 
			(select year,name, dense_rank() over(partition by year order by sum(births) desc ) as rnk
			from names
			group by year, name)
			select * from all_overyear),
t_1980 as 
      (select * from use 
	  where year =1980),
t_2009 as 
      (select * from use
	  where year= 2009)
select t1.year, t2.year, t1.name,t1.rnk as rnk_1980, t2.rnk as rnk_2009, t2.rnk-t1.rnk as drop_rnk
from t_1980 as t1
join t_2009 as t2 on t1.name=t2.name
order by drop_rnk 



-- 3) For each year, return the 3 most popular girl names and 3 most popular boy names

with popular_year as 
	(select year, name,gender,
	 row_number() over(partition by year, gender order by sum(births) desc) as rnk
	from names
	group by year, name, gender)
select year, gender, string_agg(name,',') 
from popular_year
where rnk <4
group by year, gender



-- 4) For each decade, return the 3 most popular girl names and 3 most popular boy names
select * from names

with popular_year as 
	(select floor(year/10)*10 as decade, name,gender,
	 row_number() over(partition by floor(year/10)*10, gender order by sum(births) desc) as rnk
	from names
	group by floor(year/10)*10, name, gender)
select decade, gender, string_agg(name,',') 
from popular_year
where rnk <4
group by decade, gender


-- 5) Return the number of babies born in each of the six regions (NOTE: The state of MI should be in the Midwest region)

with cte as
	(select distinct case when region = 'New England' then 'New_England' else region end as region,
	        state from regions)
select r.region, sum(births) total_babies_born
from cte r
join names n on r.state=n.state
group by 1


-- 6) Return the 3 most popular girl names and 3 most popular boy names within each region
with by_decade as 
	(select r.region, n.name, n.gender,
	      row_number() over(partition by r.region, gender order by sum(births) desc) as rnk
	from regions r
	join names n on r.state=n.state
	group by r.region, n.name, n.gender)
select region, gender, string_agg(name,',') as names
from by_decade
where rnk<4
group by region, gender

-- 7) Find the 10 most popular androgynous names (names given to both females and males)



select name, count( distinct gender), sum(births)
from names
group by name
having count( distinct gender) = 2
order by 3 desc
limit 10


/* 8) Find the length of the shortest and longest names, and identify the most popular short names 
  (those with the fewest characters) and long names (those with the most characters) */

--longest name 
with cte as
	(select  name , length(name), births, dense_rank() over(order by length(name) desc) as rnk
	from names
	order by 2 desc )
select name, sum(births) as total 
from cte
where rnk =1
group by name
order by total desc
limit 1

-- shortest name

with cte as
	(select name , length(name), births, dense_rank() over(order by length(name)) as rnk
	from names
	order by 2 desc )
select name, sum(births) as total 
from cte
where rnk =1
group by name
order by total desc
limit 1



/* 9) The founder of Maven Analytics is named Chris.
      Find the state with the highest percent of babies named "Chris" */
with cte as 
       (select r.state,   sum(births) total_babies_born
		from regions r 
		join names n on r.state=n.state
		group by 1 ),
cte1 as 
       (select r.state,  sum(births) total_chris_born
		from regions r 
		join names n on r.state=n.state
		where name= 'Chris'
		group by 1)
select t1.state, total_chris_born, total_babies_born, round(total_chris_born :: numeric/total_babies_born,6) as per
from cte1 t1 
join cte t2 on t1.state= t2.state
order by 4 desc 




/* 10) The founder of Maven Analytics is named Chris.
 Find the region with the highest percent of babies named "Chris" from total Chris named babies */

with cte2 as 
	(with cte as
		(select distinct case when region = 'New England' then 'New_England' else region end as region,
		        state from regions)
	select r.region, name,  sum(births) total_babies_born
	from cte r 
	join names n on r.state=n.state
	where name = 'Chris'
	group by 1 ,2),
cte3 as 	
	(select sum(total_babies_born)
	from cte2)
select * , (select * from cte3 ) as total, 
        round((total_babies_born/(select * from cte3 ) *100),0) as per
from cte2
order by 3 desc 
limit 1