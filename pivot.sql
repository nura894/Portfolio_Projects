
drop table if exists salary;
create table salary
(
	emp_id		int,
	emp_name	varchar(30),
	base_salary	int
);
insert into salary values(1, 'Rohan', 5000);
insert into salary values(2, 'Alex', 6000);
insert into salary values(3, 'Maryam', 7000);


drop table if exists income;
create table income
(
	id			int,
	income		varchar(20),
	percentage	int
);
insert into income values(1,'Basic', 100);
insert into income values(2,'Allowance', 4);
insert into income values(3,'Others', 6);


drop table if exists deduction;
create table deduction
(
	id			int,
	deduction	varchar(20),
	percentage	int
);
insert into deduction values(1,'Insurance', 5);
insert into deduction values(2,'Health', 6);
insert into deduction values(3,'House', 4);


drop table if exists emp_transaction;
create table emp_transaction
(
	emp_id		int,
	emp_name	varchar(50),
	trns_type	varchar(20),
	amount		numeric
);




#PROBLEM STATEMENT: Using the given Salary, Income and Deduction tables, first write an sql query to 
       -- populate the Emp_Transaction table as shown below and then generate a salary report as shown.



   
select * from income;
select * from deduction;
select * from salary;
 select * from emp_transaction;

create table emp_transaction
(
	emp_id		int,
	emp_name	varchar(50),
	trns_type	varchar(20),
	amount		numeric
);


#insert into emp_transaction
select emp_id,emp_name, deduction as trans_type, round((percentage/100)*base_salary) as Amount from salary 
cross join
(select deduction, percentage from deduction union
select income ,percentage from income) x
order by emp_id;


 select * from emp_transaction;
 
 
 
 
 with tab as 
		 (select   emp_name, sum(case when trns_type='Basic' then amount end) over(partition by emp_name) as Basic,
						   sum(case when trns_type='Allowance' then amount end) over(partition by emp_name) as Allowance,
						   sum(case when trns_type='Others' then amount end) over(partition by emp_name) as Others,
						   sum(case when trns_type='Insurance' then amount end) over(partition by emp_name) as Insurance,
							sum(case when trns_type='Health' then amount end) over(partition by emp_name) as Health,
							sum(case when trns_type='House' then amount end) over(partition by emp_name) as House
		 from emp_transaction),
  tab2  as ( select * from tab
			group by emp_name , basic, allowance, others, Insurance, Health, House)

select emp_name , basic, allowance, others, ( basic + allowance+ others ) as Gross, Insurance,
	   Health, House , (Insurance + Health + House ) as Total_Deduction,
       ( basic + allowance+ others )-(Insurance + Health + House ) as Net_Pay
from tab2
