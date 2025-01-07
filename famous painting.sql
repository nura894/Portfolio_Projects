select * from canvas_size;
select * from artist;
select * from museum;
select * from museum_hours;
select * from product_size;
select * from subject;
select * from work;
select * from image_link;


-- 1) Fetch all the paintings which are not displayed on any museums?
select * from work;
select * from image_link;
select w.* from work as w 
left join museum as m on m.museum_id= w.museum_id
 where w.museum_id is null;

select * from work w
where w.museum_id is null;





-- 2) Are there museums without any paintings?

select * from work;
select * from museum ;


select m.*,w.* from museum as m 
left join work as w on w.museum_id = m.museum_id
where w.museum_id is null ;

select 1 from work;

select * from museum m
	where not exists (select 1 from work w
					 where w.museum_id=m.museum_id);
                                         

-- 3) How many paintings have an asking price of more than their regular price? 

select * from work;
select * from product_size
where sale_price> regular_price;


-- 4) Identify the paintings whose asking price is less than 50% of its regular price
select * from product_size
where sale_price<(0.5* regular_price);




-- 5) Which canva size costs the most?
select * from product_size;
select * from canvas_size;


select *
from (select c.width,p.sale_price, c.height , dense_rank() over (order by p.sale_price desc) as rnk
 from product_size p 
 join canvas_size c on p.size_id = c.size_id
) x
where x.rnk =1;


#6) Delete duplicate records from work, product_size, subject and image_link tables
-- work
select * from
(select *, row_number() over(partition by name,artist_id,museum_id ,style) rnk
 from work) x
 where x.rnk >1;




#7) Identify the museums with invalid city information in the given dataset
select * from museum
where city regexp '^[0-9]+$';

select * from museum
where city not regexp '[^-~]';

#8) Museum_Hours table has 1 invalid entry. Identify it and remove it.
  
  select * from museum_hours;
  select min(museum_id), day from museum_hours
	group by museum_id, day ;
  
  
#9) Fetch the top 10 most famous painting subject
select * ,dense_rank () over ( order by total desc) from
(select subject ,count(*) as total from subject
group by subject
order by total desc) x
limit 10;



select *,dense_rank() over (order by total desc) from(
select subject, count(1) as total from subject s 
join work w on w.work_id = s.work_id
group by subject) x 
limit 10;


select * 
	from (
		select s.subject,count(1) as no_of_paintings
		,dense_rank() over(order by count(1) desc) as ranking
		from work w
		join subject s on s.work_id=w.work_id
		group by s.subject ) x
	where ranking <= 10;


#10) Identify the museums which are open on both Sunday and Monday.
#    Display museum name, city.

-- select * from museum m
	#where not exists (select 1 from work w
					 #where w.museum_id=m.museum_id);  #just for understanding purpose 

select * from museum_hours mh
join museum m on mh.museum_id= m.museum_id
where mh.day = 'Sunday'
and exists ( select 1 from museum_hours mh1
where mh.museum_id=mh1.museum_id and mh1.day ='Monday');

select * from museum_hours mh
join museum m on mh.museum_id= m.museum_id     #exist will check the condition 
where mh.day = 'Sunday'
and exists ( select 1 from museum_hours mh1
where mh1.day ='Monday');



select * from museum_hours mh
#where mh.day = 'Monday'
where exists ( select 1 from museum_hours mh1
where mh.museum_id=mh1.museum_id and mh1.day ='Sunday' and mh.day='Monday');

-- the outer query first filters for records where the museum is open on Sunday. 
-- Then, for each of these records, the subquery checks if there's a corresponding record with the same museum_id for Monday.

select * from museum_hours mh 
where mh.day = 'Sunday'
union
select * from museum_hours mh1
where mh1.day = 'Monday';   -- this query will return either sun, monday unique records



select m.name, m.city, m.museum_id,mh1.day,mh2.day from museum_hours mh1
join museum m on mh1.museum_id= m.museum_id
join museum_hours mh2
on mh1.museum_id= mh2.museum_id
where mh1.day = 'Sunday' and mh2.day= 'Monday';


#11) How many museums are open every single day?

select count(*) from
(select museum_id , count(*) as total from museum_hours
group by museum_id) x
join museum m on m.museum_id = x.museum_id
where x.total = 7;

select count(*) from
(select museum_id , count(*) as total from museum_hours
group by museum_id) x
where x.total =7;





#12) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
select m.name, m.museum_id, x.total from (
select w.museum_id,count(*) as total from museum m
join work w on w.museum_id= m.museum_id
group by w.museum_id) x
join museum m on m.museum_id = x.museum_id
order by x.total desc
limit 5;



select m.name as museum, m.city,m.country,x.no_of_painintgs
	from (	select m.museum_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			group by m.museum_id) x
	join museum m on m.museum_id=x.museum_id
	where x.rnk<=5;


#13) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
select ar.full_name , x.total from
(select a.artist_id,a.full_name ,count(*) as total from work w
join artist a on a.artist_id = w.artist_id
group by a.artist_id,a.full_name
order by artist_id ) x
join artist ar on ar.artist_id=x.artist_id
order by x.total desc
limit 6;

select * from artist;

select a.full_name as artist, a.nationality,x.no_of_paintings
	from (	select a.artist_id, count(1) as no_of_paintings
			, rank() over(order by count(1) desc) as rnk
			from work w
			join artist a on a.artist_id=w.artist_id
			group by a.artist_id) x
	join artist a on a.artist_id=x.artist_id
	where x.rnk<=5
    order by x.no_of_paintings desc;

select * from
(select a.artist_id, a.full_name, count(1) as no_of_paintings
			, rank() over(order by count(1) desc) as rnk
			from work w
			join artist a on a.artist_id=w.artist_id
            
			group by a.artist_id,a.full_name
            order by rnk) x
            where x.rnk <=5;

#14) Display the 3 least popular canva sizes

select *  from canvas_size c 
join product_size p on p.size_id = c.size_id
;



#15) Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?

select *,timediff(close,open) from museum_hours;

#16) Which museum has the most no of most popular painting style?

#first find out most popular painting based on rank base
#Popularity is defined based on most no of paintings in a museum

select m.name, y.rnk, y.total from museum m join (
select x.*,dense_rank () over (order by x.total desc) as rnk from (
select w.museum_id, count(*) as total from work w
join museum m on m.museum_id= w.museum_id
group by museum_id) x ) y on y.museum_id =m.museum_id 
order by y.rnk ;

select m.name, x.rnk, x.total from museum m join (
select w.museum_id, count(*) as total, dense_rank () over (order by count(*) desc) as rnk  from work w
join museum m on m.museum_id= w.museum_id
group by museum_id) x on x.museum_id =m.museum_id 
order by x.rnk ;

with pop_style as 
			(select style
			,rank() over(order by count(1) desc) as rnk
			from work
			group by style),
		cte as
			(select w.museum_id, m.name as museum_name,ps.style, count(1) as no_of_paintings
			,rank() over(order by count(1) desc) as rnk1
			from work w
			join museum m on m.museum_id=w.museum_id
			join pop_style ps on ps.style = w.style
			where w.museum_id is not null
			and ps.rnk=1
			group by w.museum_id, m.name,ps.style)
	select museum_name,style,no_of_paintings
	from cte ;



with pip as 
		(select style ,count(1), dense_rank () over (order by count(1) desc) as rnk 
		from work
		group by style),
	ma as (select w.museum_id, m.name as museum_name, p.style, count(1) as no_of_paintings
			
			from work w 
            join museum m on m.museum_id=w.museum_id
            join pip p on p.style=w.style
            where w.museum_id is not null
			and p.rnk=1
		    group by m.museum_id, m.name, p.style
            order by no_of_paintings desc)
      select museum_name,style,no_of_paintings
	from ma;       
			
select * from work;
with pip as 
		(select  style, dense_rank() over (order by count(1) desc) as rnk
		 from work
		 group by style),
	 so as  (select w.museum_id as id, m.name as name, p.style as style, count(*) as total_painting
            from work w join museum m on m.museum_id =w.museum_id
            join pip p on p.style = w.style
            where w.work_id is not null and p.rnk= 1 
            group by w.museum_id , m.name , p.style
            order by total_painting desc )
        select id , name, style , total_painting
        from so;
    
                
         











SELECT 
    m.name, w.style, COUNT(*) as counting
FROM
    work w
        JOIN
    museum m ON m.museum_id = w.museum_id    
GROUP BY m.name, w.style
order by counting desc; 
   
   
   
 select * from work;
 select * from museum;

select w.style , count(*) as total from work w 
join museum m on m.museum_id= w.museum_id
group by w.style
order by total desc  
limit 1 ;

select * from work;


            
     
            
 select * from work;
 

#17) Identify the artists whose paintings are displayed in multiple countries

select * from artist;
select * from museum;
select * from work;



select x.name, countries    from 
(select a.artist_id, a.full_name as name , count(*) as countries from artist a
join work w on a.artist_id=w.artist_id
join museum m on m.museum_id=w.museum_id
group by a.artist_id, a.full_name
having count(*)>1) x
order by countries desc
;
 

with cte as
		(select distinct a.full_name as artist
		, w.name as painting, m.name as museum
		, m.country
		from work w
		join artist a on a.artist_id=w.artist_id
		join museum m on m.museum_id=w.museum_id)
	select artist,count(1) as no_of_countries
	from cte
	group by artist
	having count(1)>1
	order by 2 desc;

#18) Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma.


#this is the only real solution else are just practices wise
with countr as
		(select  country  from
		(select country,  count(*), dense_rank() over(order by count(*) desc ) as rnk from museum
		group by country) x
		where x.rnk =1),
	cty as  
		(select  city  from
		(select city,  count(*), dense_rank() over(order by count(*) desc ) as rnk from museum
		group by city) x
		where x.rnk =1)
    select GROUP_CONCAT(DISTINCT country ORDER BY country SEPARATOR ', ') AS countries,
    GROUP_CONCAT(city ORDER BY city SEPARATOR ', ') AS cities
    from countr country
    cross join cty city;


SELECT 
    country, 
    GROUP_CONCAT(city SEPARATOR ',') AS cities
FROM (
    SELECT 
        country, 
        city, 
        COUNT(*) AS museum_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM 
        museum
    GROUP BY 
        country, city
) ranked_museums
WHERE 
    rnk = 1
GROUP BY 
    country;

SELECT 
    GROUP_CONCAT(DISTINCT country ORDER BY country SEPARATOR ', ') AS countries,
    GROUP_CONCAT(city ORDER BY city SEPARATOR ', ') AS cities
FROM (
    SELECT 
        country, 
        city, 
        DENSE_RANK() OVER ( ORDER BY COUNT(*) DESC) AS rnk
    FROM 
        museum
    GROUP BY 
        country, city
) ranked_museums
WHERE 
    rnk = 1;



#19) Identify the artist and the museum where the most expensive and least expensive painting is placed. Display the artist name, sale_price, painting name, museum name, museum city and canvas label


select * from artist;
select * from museum;
select * from work;
select* from canvas_size;
select * from product_size; #expensive


select * from product_size p
join work w on w.work_id=p.work_id
join artist a on a.artist_id=w.artist_id


;








#20) Which country has the 5th highest no of paintings?
select * from
(select country, count(*) total_painting, dense_rank() over(order by count(*) desc) as rnk from museum m
join work w on w.museum_id=m.museum_id
group by country) x
where rnk =5
;

with cte as 
		(select m.country, count(1) as no_of_Paintings
		, rank() over(order by count(1) desc) as rnk
		from work w
		join museum m on m.museum_id=w.museum_id
		group by m.country)
	select country, no_of_Paintings
	from cte 
	where rnk=5;



#21) Which are the 3 most popular and 3 least popular painting styles?

select	w.style, count(*) total from work w 
join museum m on m.museum_id=w.museum_id
where style is not null and style!=''
group by w.style
order by total desc
;

with cte as 
		(select style, count(1) as cnt
		, rank() over(order by count(1) desc) rnk, #dense_rank() over(order by count(1) desc) rnko
		, count(1) over() as no_of_records
		from work
		where style is not null and style!=''
		group by style)
	select style
	, case when rnk <=3 then 'Most Popular' else 'Least Popular' end as remarks 
	from cte
	where rnk <=3
	or rnk > no_of_records - 3;




#22) Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.

select * from 
(select a.full_name, nationality, count(*) no_of_painting, dense_rank() over( order by count(*) desc)  rnk from work w
join museum m on m.museum_id=w.museum_id
join artist a on a.artist_id=w.artist_id
join subject s on s.work_id=w.work_id
where country!='USA' and s.subject='Portraits'
group by 1, 2) x
where rnk = 1
;

select full_name as artist_name, nationality, no_of_paintings
	from (
		select a.full_name, a.nationality
		,count(1) as no_of_paintings
		,rank() over(order by count(1) desc) as rnk
		from work w
		join artist a on a.artist_id=w.artist_id
		join subject s on s.work_id=w.work_id
		join museum m on m.museum_id=w.museum_id
		where s.subject='Portraits'
		and m.country != 'USA'
		group by a.artist_id, a.full_name, a.nationality) x
	where rnk=1;	




