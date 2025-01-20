-- Pizza Delivery Status --- 

drop table cust_orders;
create table cust_orders
(
cust_name   varchar(50),
order_id    varchar(10),
status      varchar(50)
);

insert into cust_orders values ('John', 'J1', 'DELIVERED');
insert into cust_orders values ('John', 'J2', 'DELIVERED');
insert into cust_orders values ('David', 'D1', 'SUBMITTED');
insert into cust_orders values ('David', 'D2', 'DELIVERED'); -- This record is missing in question
insert into cust_orders values ('David', 'D3', 'CREATED');
insert into cust_orders values ('Smith', 'S1', 'SUBMITTED');
insert into cust_orders values ('Krish', 'K1', 'CREATED');



select * from cust_orders;

/*Pizza Delivery Status	
PROBLEM STATEMENT	A pizza company is taking orders from customers, and each pizza ordered is added to their database as a separate order.	
	Each order has an associated status, "CREATED or SUBMITTED or DELIVERED'. 	
	An order's Final_ Status is calculated based on status as follows:	
		1. When all orders for a customer have a status of DELIVERED, that customer's order has a Final_Status of COMPLETED.
		2. If a customer has some orders that are not DELIVERED and some orders that are DELIVERED, 
        the Final_ Status is IN PROGRESS.
		3. If all of a customer's orders are SUBMITTED, the Final_Status is AWAITING PROGRESS.
		4. Otherwise, the Final Status is AWAITING SUBMISSION.
        
Write a query to report the customer_name and Final_Status of each customer's order. Order the results by customer
name.
*/
        
 select * from cust_orders;
 
 
 select  distinct cust_name , 'COMPLETED' as status from cust_orders c1
 where status = 'DELIVERED' 
 and not exists (select * from cust_orders c2 
                  where c1.cust_name = c2.cust_name 
                AND c2.status in ('SUBMITTED', 'CREATED'))
 union
  select  distinct cust_name , 'IN PROGRESS' as status from cust_orders c1
 where status = 'SUBMITTED' 
 and exists (select * from cust_orders c2 
                  where c1.cust_name = c2.cust_name 
                AND c2.status in ( 'DELIVERED','CREATED'))
  union
  select  distinct cust_name , 'AWAITING PROGRESS' as status from cust_orders c1
 where status = 'SUBMITTED' 
 and not exists (select * from cust_orders c2 
                  where c1.cust_name = c2.cust_name 
                AND c2.status in ('DELIVERED', 'CREATED'))
 union
  select  distinct cust_name , 'AWAITING SUBMISSION' as status from cust_orders c1
 where status = 'CREATED' 
 and  not exists (select * from cust_orders c2 
                  where c1.cust_name = c2.cust_name 
                AND c2.status in ( 'DELIVERED','SUBMITTED'));
                
    #2nd solution            
                
	SELECT 
    cust_name,
    CASE 
        WHEN COUNT(CASE WHEN status != 'DELIVERED' THEN 1 END) = 0 THEN 'COMPLETED'
        WHEN COUNT(CASE WHEN status = 'DELIVERED' THEN 1 END) > 0 
             AND COUNT(CASE WHEN status != 'DELIVERED' THEN 1 END) > 0 THEN 'IN PROGRESS'
        WHEN COUNT(CASE WHEN status = 'SUBMITTED' THEN 1 END) = COUNT(*) THEN 'AWAITING PROGRESS'
        ELSE 'AWAITING SUBMISSION'
    END AS Final_Status
FROM cust_orders
GROUP BY cust_name;        

-- or

	SELECT 
    cust_name,
    CASE 
        WHEN COUNT(CASE WHEN status = 'DELIVERED' THEN 1 END) = count(*) THEN 'COMPLETED'
        WHEN COUNT(CASE WHEN status = 'DELIVERED' THEN 1 END) > 0 
             AND COUNT(CASE WHEN status != 'DELIVERED' THEN 1 END) > 0 THEN 'IN PROGRESS'
        WHEN COUNT(CASE WHEN status = 'SUBMITTED' THEN 1 END) = COUNT(*) THEN 'AWAITING PROGRESS'
        ELSE 'AWAITING SUBMISSION'
    END AS Final_Status
FROM cust_orders
GROUP BY cust_name;        
                

                
                
 
 
 
 
 
 
 
 
 
                
                
                
  
 