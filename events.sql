-- Find out the employees who attended all company events

drop table if exists employees;
create table employees
(
	id			int,
	name		varchar(50)
);
insert into employees values(1, 'Lewis');
insert into employees values(2, 'Max');
insert into employees values(3, 'Charles');
insert into employees values(4, 'Sainz');


drop table if exists events;
create table events
(
	event_name		varchar(50),
	emp_id			int,
	dates			date
);


INSERT INTO events VALUES ('Product launch', 1, STR_TO_DATE('01-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Product launch', 3, STR_TO_DATE('01-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Product launch', 4, STR_TO_DATE('01-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Conference', 2, STR_TO_DATE('02-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Conference', 2, STR_TO_DATE('03-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Conference', 3, STR_TO_DATE('02-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Conference', 4, STR_TO_DATE('02-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Training', 3, STR_TO_DATE('04-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Training', 2, STR_TO_DATE('04-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Training', 4, STR_TO_DATE('04-03-2024', '%d-%m-%Y'));
INSERT INTO events VALUES ('Training', 4, STR_TO_DATE('05-03-2024', '%d-%m-%Y'));




select * from employees;

select event_name  from events;


with cte as 
		(select emp.id, emp.name, ev.event_name from employees emp 
		join events ev on ev.emp_id = emp.id
		group by emp.id, emp.name, ev.event_name
		order by emp.name)
select name, count(*) as no_of_events from cte
group by id, name
having no_of_events=(select count(distinct event_name) from events) ;



# much more simpler
select emp.name , count(distinct event_name) as counting from events ev
join employees  emp on emp.id= ev.emp_id
group by emp_id , emp.name
having counting = (select count(distinct event_name)  from events)
order by emp_id;

select * from events;



#Another way to solve

with cte as 
		(select emp.name, ev.event_name , count(ev.event_name) over(partition by emp.name) as counting from employees emp 
		join events ev on ev.emp_id = emp.id
		group by emp.name, ev.event_name
		order by emp.name)
select name, count(*) as no_of_events from cte
where counting = (select count(distinct event_name) from events)
group by name;



