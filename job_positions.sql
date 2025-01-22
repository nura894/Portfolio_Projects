

drop table if exists job_positions;
create table job_positions
(
	id			int,
	title 		varchar(100),
	grup      varchar(10),
	levels		varchar(10),
	payscale	int,
	totalpost	int
);
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

drop table if exists job_employees;
create table job_employees
(
	id				int,
	name 			varchar(100),
	position_id 	int
);
insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

select * from job_positions;
select * from job_employees;

with cte1 as
		(with recursive cte as 
					(select * from job_positions je
					union
					select id, title, grup, levels,payscale, totalpost-1 as totalpost from cte 
					where totalpost >1 )
		 select *  from cte)
select c.id,c.title,c.grup, c.levels, c.payscale, coalesce(jb.name, 'vacant')  from cte1 c
left join job_employees jb on jb.id =c.totalpost and c.id =jb.position_id
 order by c.id, jb.name desc








