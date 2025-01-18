----- Q7 : Derive the output --- 

drop table sales_data;
create table sales_data
    (
        sales_date      date,
        customer_id     varchar(30),
        amount          varchar(30)
    );
-- Insert the values
INSERT INTO sales_data VALUES ('2021-01-01', 'Cust-1', '50$');
INSERT INTO sales_data VALUES ('2021-01-02', 'Cust-1', '50$');
INSERT INTO sales_data VALUES ('2021-01-03', 'Cust-1', '50$');
INSERT INTO sales_data VALUES ('2021-01-01', 'Cust-2', '100$');
INSERT INTO sales_data VALUES ('2021-01-02', 'Cust-2', '100$');
INSERT INTO sales_data VALUES ('2021-01-03', 'Cust-2', '100$');
INSERT INTO sales_data VALUES ('2021-02-01', 'Cust-2', '-100$');
INSERT INTO sales_data VALUES ('2021-02-02', 'Cust-2', '-100$');
INSERT INTO sales_data VALUES ('2021-02-03', 'Cust-2', '-100$');
INSERT INTO sales_data VALUES ('2021-03-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-04-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-05-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-06-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-07-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-08-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-09-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-10-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-11-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-12-01', 'Cust-3', '-1$');

select * from sales_data;


WITH cte AS (
    SELECT *,
           DATE_FORMAT(sales_date, '%b-%y') AS dates
    FROM sales_data
)
SELECT customer_id,
       COALESCE(SUM(CASE WHEN dates = 'Jan-21' THEN amount END), 0) AS jan_21,
       COALESCE(SUM(CASE WHEN dates = 'Feb-21' THEN amount END), 0) AS Feb_21,
       COALESCE(SUM(CASE WHEN dates = 'Mar-21' THEN amount END), 0) AS Mar_21,
       COALESCE(SUM(CASE WHEN dates = 'Apr-21' THEN amount END), 0) AS Apr_21,
       COALESCE(SUM(CASE WHEN dates = 'May-21' THEN amount END), 0) AS May_21,
       COALESCE(SUM(CASE WHEN dates = 'Jun-21' THEN amount END), 0) AS Jun_21,
       COALESCE(SUM(CASE WHEN dates = 'Jul-21' THEN amount END), 0) AS Jul_21,
       COALESCE(SUM(CASE WHEN dates = 'Aug-21' THEN amount END), 0) AS Aug_21,
       COALESCE(SUM(CASE WHEN dates = 'Sep-21' THEN amount END), 0) AS Sep_21,
       COALESCE(SUM(CASE WHEN dates = 'Oct-21' THEN amount END), 0) AS Oct_21,
       COALESCE(SUM(CASE WHEN dates = 'Nov-21' THEN amount END), 0) AS Nov_21,
       COALESCE(SUM(CASE WHEN dates = 'Dec-21' THEN amount END), 0) AS Dec_21,
       COALESCE(SUM(CASE WHEN dates = 'Jan-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Feb-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Mar-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Apr-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'May-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Jun-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Jul-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Aug-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Sep-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Oct-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Nov-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Dec-21' THEN amount END), 0) AS total
FROM cte
GROUP BY customer_id

UNION ALL

SELECT 'Total',
       COALESCE(SUM(CASE WHEN dates = 'Jan-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Feb-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Mar-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Apr-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'May-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Jun-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Jul-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Aug-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Sep-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Oct-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Nov-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Dec-21' THEN amount END), 0),
       COALESCE(SUM(CASE WHEN dates = 'Jan-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Feb-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Mar-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Apr-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'May-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Jun-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Jul-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Aug-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Sep-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Oct-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Nov-21' THEN amount END), 0) +
       COALESCE(SUM(CASE WHEN dates = 'Dec-21' THEN amount END), 0)
FROM cte;








 



