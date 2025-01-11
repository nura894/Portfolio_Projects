drop TABLE if exists orders;
CREATE TABLE orders 
(
	customer_id 	INT,
	dates 			DATE,
	product_id 		INT
);
INSERT INTO orders VALUES
(1, '2024-02-18', 101),
(1, '2024-02-18', 102),
(1, '2024-02-19', 101),
(1, '2024-02-19', 103),
(2, '2024-02-18', 104),
(2, '2024-02-18', 105),
(2, '2024-02-19', 101),
(2, '2024-02-19', 106); 

#PROBLEM STATEMENT: 
-- Write an sql query to merge products per customer for each day as shown in expected output.


select dates, product_id from orders
union
select dates, group_concat(product_id) as product
from orders 
group by  customer_id,dates
order by dates, product_id ;


select  *from orders








