select * from covid_cases;

#removing the dublicate rows
with dublicate as ( select * from ( select *, row_number() over(partition by cases_reported ) as rnk from covid_cases) x
                   ) 

delete from dublicate 
where rnk >1;









INSERT INTO covid_cases VALUES (20124, '2020-01-10');


SET SQL_SAFE_UPDATES = 0;


select * from covid_cases;

with casa as (select  month(dates) as months, sum(cases_reported) as sum_total  from covid_cases
			group by months),
	 per as ( select * , sum(sum_total) over(order by months) as percentage, lag(sum_total) over(order by months) 
             as lagg
             from casa),
     op as (  select * , lag( percentage) over(order by months) , 
     (((percentage -lag( percentage) over(order by months))/lag( percentage) over(order by months))*100) as result
     
     from per),
   hana as (select months, round(result,1)
              from op)            
           
select * from hana ;         




with casa as (select  month(dates) as months, sum(cases_reported) as sum_total  from covid_cases
			group by months),
	 per as ( select * , sum(sum_total) over(order by months) as percentage
             from casa)
       
select months, case 
               when months>1 then round(((sum_total/lag(percentage) over(order by months))*100),1) 
               else '-' end as percentage_increase
from per;





