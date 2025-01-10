
create table student_tests
(
	test_id		int,
	marks		int
);
insert into student_tests values(100, 55);
insert into student_tests values(101, 55);
insert into student_tests values(102, 60);
insert into student_tests values(103, 58);
insert into student_tests values(104, 40);
insert into student_tests values(105, 50);

select * from student_tests;


#return only rows only growing from previous row



with score as 
			(select *,  case when marks> lag(marks,1,0) over(order by test_id) then 1 else 0 end as growth
			from student_tests)
select test_id, marks
from score
where growth =1;

with score as 
			(select *,  case when marks> lag(marks,1) over(order by test_id) then 1 else 0 end as growth
			from student_tests)
select test_id, marks
from score
where growth =1