--Query 1 - Detect Duplicate Records
use cleaning_project_1 ;
select customer_name, email, city, order_date, amount, count(*)
from order_cleaned
group by customer_name, email, city, order_date, amount
having count(*)>1;

--Query 2 - Remove Duplicate Records
delete from order_cleaned where order_id not in(
select order_id from(
    select  min(order_id) as order_id
    from order_cleaned
    group by customer_name, email, city, order_date, amount) as temp
);

--Query 3 - Find NULL Emails
select * from order_cleaned
where email is null ;

--fill null emails as - unknown@email.com
--Query 4- Replace Missing Emails

update order_cleaned
set email= 'unknown@email.com'
where email is null;

-- Query 5 detect invalid emails

select * from order_cleaned 
where email not like '%@%.%' ;

-- Query 6 fix invalid emails 

update order_cleaned 
set email = 'rohit@gmail.com'
where order_id = 10 ;

-- Query 7 extra spaces in customer name

update order_cleaned
set customer_name = trim(customer_name);

-- Query 8 - fix city spelling mistake 
update order_cleaned
set city = 'Mumbai'
where city = 'Mum bai' ;

-- Query 9 - Remove Extra Spaces in City 
update order_cleaned
set city = trim(city);

-- Query 10 - Fix date format (yyyy-dd-mm)
UPDATE order_cleaned
SET order_date = STR_TO_DATE(order_date, '%Y-%d-%m')
WHERE order_date REGEXP '^[0-9]{4}-(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])$';

-- Query 11 Fix date format (mm-dd-yyyy)
update order_cleaned 
set order_date = STR_TO_DATE(order_date, '%m-%d-%Y') 
WHERE order_date REGEXP '^[0-9]{2}-[1-3][0-9]-[0-9]{4}';

-- Query 12 - fix date format (dd-mm-yyyy)
update order_cleaned
set order_date = STR_TO_DATE(order_date, '%d-%m-%Y')
WHERE order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}';


-- Query  13 -Find Missing Dates
select * 
from order_cleaned 
where order_date is null ;

-- Query 14 - Replace Missing Date (2024-01-01)

update order_cleaned 
set order_date = '2024-01-01'
where order_date is null ; 

-- Query 15  Fix negative amount 
update order_cleaned 
set amount = abs(amount)
where amount < 0 ;

-- Query 16 Fix NULL amount (with 0)

update order_cleaned 
set amount = 0
where amount is null ;

DESCRIBE order_cleaned ;

-- Query 17  Change the datatypes 
ALTER TABLE order_cleaned
MODIFY order_id INT,
MODIFY customer_name VARCHAR(100),
MODIFY email VARCHAR(100),
MODIFY city VARCHAR(50),
MODIFY order_date DATE,
MODIFY amount INT ;
