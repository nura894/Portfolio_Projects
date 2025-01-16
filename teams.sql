-- Q6 : IPL Matches --- 

drop table teams;
create table teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');


select * from teams;

/* PROBLEM STATEMENT	There are 10 IPL team. 
	1) Write an sql query such that each team play with every other team just once. 
	2) Write an sql query such that each team play with every other team twice.	*/



-- 1) Write an sql query such that each team play with every other team just once. 

select * from teams;

with cte as (select  *, row_number() over()  as roww
             from teams t1 )
select c1.team_code , c2.team_name from cte c1
join cte c2 on c1.roww< c2.roww;


-- 2) Write an sql query such that each team play with every other team twice.


select * from teams;

with cte as (select  *, row_number() over()  as roww
             from teams t1 )
 select * from cte c1
 join cte c2 on c1.roww <>c2.roww
 order by c1.team_code;            
