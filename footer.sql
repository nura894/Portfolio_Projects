
DROP TABLE IF EXISTS FOOTER;
CREATE TABLE FOOTER 
(
	id 			INT PRIMARY KEY,
	car 		VARCHAR(20), 
	length 		INT, 
	width 		INT, 
	height 		INT
);

INSERT INTO FOOTER VALUES (1, 'Hyundai Tucson', 15, 6, NULL);
INSERT INTO FOOTER VALUES (2, NULL, NULL, NULL, 20);
INSERT INTO FOOTER VALUES (3, NULL, 12, 8, 15);
INSERT INTO FOOTER VALUES (4, 'Toyota Rav4', NULL, 15, NULL);
INSERT INTO FOOTER VALUES (5, 'Kia Sportage', NULL, NULL, 18); 

SELECT * FROM FOOTER;



#PROBLEM STATEMENT: Write a sql query to return the footer values from input table,
--                 meaning all the last non null values from each field as shown in expected output.










SET SQL_SAFE_UPDATES = 0;


select  * from

(select  car from footer where car is not null
order by id desc
limit 1) car

 cross join

(select length  from footer
where length is not null
order by id desc
limit 1) length
 cross join
 
(select  width from footer
where width is not null
order by id desc
limit 1 ) width 
cross join

(select  height from footer
where height is not null
order by id desc
limit 1) height;





#2nd solution

with new as (
		  select *, 
		   sum(case when length is null then 0 else 1 end ) over (order by id) as lenth,
           sum(case when height is null then 0 else 1 end ) over (order by id) as heigh,
           sum(case when width is null then 0 else 1 end ) over(order by id) as wid
          from footer)
select car, first_value(length) over (partition by lenth) as length,
          first_value(width) over (partition by wid) as width,
          first_value(height) over (partition by heigh) as height
 from new
 order by id desc
 limit 1 
 
 ;
 




