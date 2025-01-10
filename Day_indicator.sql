
-- mySQL

-- PROBLEM STATEMENT:
# In the given input table DAY_INDICATOR field indicates the day of the week with the first character being Monday, followed by Tuesday and so on.
#Write a query to filter the dates column to showcase only those days where day_indicator character for that day of the week is 1








drop table if exists Day_Indicator;
create table Day_Indicator
(
	Product_ID 		varchar(10),	
	Day_Indicator 	varchar(7),
	Dates			date
);


select * from Day_Indicator;

#INSERT INTO Day_Indicator
VALUES 
('AP755', '1010101', STR_TO_DATE('04-Mar-2024','%d-%b-%Y')),
('AP755', '1010101', STR_TO_DATE('05-Mar-2024','%d-%b-%Y')),
('AP755', '1010101', STR_TO_DATE('06-Mar-2024','%d-%b-%Y')),
('AP755', '1010101', STR_TO_DATE('07-Mar-2024','%d-%b-%Y')),
('AP755', '1010101', STR_TO_DATE('08-Mar-2024','%d-%b-%Y')),
('AP755', '1010101', STR_TO_DATE('09-Mar-2024','%d-%b-%Y')),
('AP755', '1010101', STR_TO_DATE('10-Mar-2024','%d-%b-%Y')),
('XQ802', '1000110', STR_TO_DATE('04-Mar-2024','%d-%b-%Y')),
('XQ802', '1000110', STR_TO_DATE('05-Mar-2024','%d-%b-%Y')),
('XQ802', '1000110', STR_TO_DATE('06-Mar-2024','%d-%b-%Y')),
('XQ802', '1000110', STR_TO_DATE('07-Mar-2024','%d-%b-%Y')),
('XQ802', '1000110', STR_TO_DATE('08-Mar-2024','%d-%b-%Y')),
('XQ802', '1000110', STR_TO_DATE('09-Mar-2024','%d-%b-%Y')),
('XQ802', '1000110', STR_TO_DATE('10-Mar-2024','%d-%b-%Y'));



select * from Day_Indicator;





with tab1 as 
		(select * , dayname( Dates) AS DayOf_Week, 
			   CASE 
				 WHEN DAYOFWEEK(dates) = 1 THEN 7
				 ELSE DAYOFWEEK(dates) - 1
			   END AS Dow
		FROM Day_Indicator)

SELECT product_id, day_indicator, dates
-- substring(day_indicator, dow,1) 

FROM tab1
  where  substring(day_indicator, dow,1) =1     

