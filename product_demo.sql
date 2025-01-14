# find numbers of apple products in each store
drop table if exists product_demo;
create table product_demo
(
	store_id	int,
	product_1	varchar(50),
	product_2	varchar(50)
);
insert into product_demo values (1, 'Apple - IPhone', '   Apple - MacBook Pro');
insert into product_demo values (1, 'Apple - AirPods', 'Samsung - Galaxy Phone');
insert into product_demo values (2, 'Apple_IPhone', 'Apple: Phone');
insert into product_demo values (2, 'Google Pixel', ' apple: Laptop');
insert into product_demo values (2, 'Sony: Camera', 'Apple Vision Pro');
insert into product_demo values (3, 'samsung - Galaxy Phone', 'mapple MacBook Pro');

select * from product_demo;


select store_id, sum(case when upper(trim(product_1)) like 'APPLE%' then 1 else 0 end)  as pro1,
	             sum(case when upper(trim(product_2)) like 'APPLE%' then 1 else 0 end)  as pro2
from product_demo
group by store_id;











