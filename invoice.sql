
#PROBLEM STATEMENT: In the given input table, some of the invoice are missing, write a sql query to identify the missing serial no. 
-- As an assumption, consider the serial no with the lowest value to be the first generated invoice and the highest serial no value to be the last generated invoice


drop table if exists invoice;
create table invoice
(
	serial_no		int,
	invoice_date	date
);
INSERT INTO invoice (serial_no, invoice_date) VALUES (330115, STR_TO_DATE('01-Mar-2024', '%d-%b-%Y'));
INSERT INTO invoice (serial_no, invoice_date) VALUES (330120, STR_TO_DATE('01-Mar-2024', '%d-%b-%Y'));
INSERT INTO invoice (serial_no, invoice_date) VALUES (330121, STR_TO_DATE('01-Mar-2024', '%d-%b-%Y'));
INSERT INTO invoice (serial_no, invoice_date) VALUES (330122, STR_TO_DATE('02-Mar-2024', '%d-%b-%Y'));
INSERT INTO invoice (serial_no, invoice_date) VALUES (330125, STR_TO_DATE('02-Mar-2024', '%d-%b-%Y'));


select * from invoice;


#using recusion to generate all serial_no values 
# 1st solution

with recursive seq as ( select min(serial_no) as num from invoice
                        union 
                        select num+1 from seq 
                        where num<(select max(serial_no) from invoice))
  select num from seq 
  where num not in ( select serial_no from invoice inv where seq.num=inv.serial_no);
  
  
 # solution 2nd
 
 with recursive seq as ( select min(serial_no) as num from invoice
                        union 
                        select num+1 from seq 
                        where num<(select max(serial_no) from invoice))
  select s.num from seq s
 left join invoice inv on inv.serial_no = s.num
 where inv.serial_no is null;



SELECT * FROM invoice;

  