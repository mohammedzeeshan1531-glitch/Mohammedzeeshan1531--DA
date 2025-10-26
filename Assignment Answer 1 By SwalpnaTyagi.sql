--- Question 1(a)
select employeeNumber,firstname,lastname  from employees where jobtitle ="Sales Rep"and reportsto=1102; 
---- 1(b)
select productline from  productlines where productline like "%cars";
--- Question 2
select customernumber, customername , 
case when country = "USA" or country = "canada" then "North America"
when country = "UK" or country = "France" or country ="Germany" then "Europe"
else "other "
end as  customersegment from  customers;

---- Question 3(a)
select  productcode , sum(quantityordered) as totalquantity from orderdetails group by productCode  order by totalquantity desc limit 10 ;

---- Question 3(b)
#  Select  monthname(paymentdate) as paymentmonth  , count(customernumber) as num_payments from payments where count(customernumber) >20  group by paymentmonth  order by count(customernumber) desc ;

---- Question 4(a)
create database customer_orders;
use customer_orders;
create table customers (customer_id int primary key auto_increment,first_name varchar(50), last_name varchar(50) ,email varchar(255) unique, phone_number varchar(20));
alter table customers modify column first_name varchar (50) not null;
alter table customers modify column last_name varchar (50) not null;

 ---- Question 4(b)
create table orders 
(order_id int primary key auto_increment,
 customer_id int ,
 order_date date, 
 total_amount decimal(10,2) check (total_amount>0),
 foreign key(customer_id) references customers (customer_id) on update cascade on delete cascade);
desc orders ;
desc customers;

---- Question 5
select country,count(orderNumber)as order_count from  customers inner join  orders on customers.customerNumber= orders.customerNumber group by country order by order_count desc limit 5;

---- Question 6
create table Project 
 (EmployeeID int primary key auto_increment,
 FullName varchar(50) not null,
 Gender ENUM ('Male','Female'),
 ManagerID Int);
desc project;
 insert into Project values (1 ,"Pranaya" , 'Male', 3),(2,"Priyanka", 'Female',1),(3,"Preety",'Female',Null),(4,"Anurag", 'Male', 1),(5,"Sabmit",'Male', 1),(6,"Rajesh",'Male',3),(7,"Hina",'Female',3);
select * from Project ;
select P.FullName as ManagerName, T.Fullname as EmployeeName   from Project P join project T on (P.EmployeeID = T.ManagerID) order by P.EmployeeID;

--- Question 7
Create table Facility (Facility_ID int not null, 
Name Varchar(100), 
State varchar(100),
Country varchar(100)  );
desc Facility ;
alter table Facility modify column Facility_ID int not null primary key Auto_increment;
alter table Facility Add column city varchar(100) not null after Name;
desc Facility ;

--- Question 8
CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine AS productLine,SUM(od.quantityOrdered * od.priceEach) AS total_sales,COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    productlines pl
JOIN 
    products p ON pl.productLine = p.productLine
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;
select * from product_category_sales;
---- Question 9
call Get_Country_payments_proc (2003, "France");
/* CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Country_payments_proc`(In Input_Yr int,in Input_Country varchar(100))
BEGIN
declare Total_amount int ;
select Input_yr as Year, Input_Country as country , concat(round(sum(amount)/1000), "K")
 as Total_amount from payments p join customers c on p.CustomerNumber = c.CustomerNumber where year(paymentdate) = Input_yr and  country=Input_country ;
end */ # CreatedProcedure


---- Question 10(a)
select  customers.customerName,  count(orders.orderNumber)as order_count, dense_rank () over(order by count(orders.orderNumber) desc) as Ranking from 
  customers join orders on customers .customernumber = orders. customerNumber group by customerName ;
  
---- Question 10(b)
 with cte as (select year(orderdate), monthname(orderdate), count(orderNumber) as TotalOrder,lag(count(orderNumber ),1) over (Partition by year(orderdate) ) as Last_month_order
  from orders 
  group by  year(orderdate), monthname(orderdate) )select *,  concat(round((TotalOrder -Last_month_order)/Last_month_order *100),"%" ) as YOY_Growth  from CTE;

---- Question 11
select productline ,count(productline)as Total  from products where buyPrice > (select avg(buyPrice) from products) group by productline order by  Total desc;

---- Question 12
Create table Emp_EH (EmpID int Primary Key, EmpName varchar(50), EmailAddress varchar(100));
desc Emp_EH;  

Call Q12_insert_Error_proc (1, "Siri","abc@gmail.com");
  call Q12_insert_Error_proc (2, 2,"abc@gmail.com");
  call Q12_insert_Error_proc (3, 5,"bcd@gmail.com");
  call Q12_insert_Error_proc (4,"Sita","cd@gmail.com",5);
   call Q12_insert_Error_proc (4, 7,"cd@gmail.com");# error handled
   call Q12_insert_Error_proc (dfgg, "Hari","cd@gmail.com");
   
   Insert into EMP_BIT values (dfgg, "Hari","cd@gmail.com"); # got msg Error Handled for Dulpicate entry
   
   /* CREATE DEFINER=`root`@`localhost` PROCEDURE `Q12_insert_Error_proc`(IN ID int, E_Name varchar(50),email_id varchar(100))
BEGIN
 DECLARE CONTINUE HANDLER FOR SQLexception
 Begin
 SELECT 'Error occurred' as message ;	
 end;
Insert into EMP_EH(EmpID, EmpName ,EmailAddress) values (ID,E_Name,email_id);
END */

---- Question 13
Create Table EMP_BIT (Name varchar(50), Occupation varchar(50),Working_date Date, Working_Hours int);
 Desc EMP_BIT;
 Insert into EMP_BIT values ('Robin', 'Scientist', '2020-10-04', 12),
                            ('Warner', 'Engineer', '2020-10-04', 10),  
                            ('Peter', 'Actor', '2020-10-04', 13),  
							('Marco', 'Doctor', '2020-10-04', 14),  
                            ('Brayden', 'Teacher', '2020-10-04', 12),  
                            ('Antonio', 'Business', '2020-10-04', 11);
select * from EMP_BIT;
 Insert into EMP_BIT values ('Rubi', 'Scientist', '2020-10-04', -10); 
Insert into EMP_BIT values ('Ritibi', 'Scientist', '2020-10-04', -16); 
Insert into EMP_BIT values ('binu', 'Scientist', '2020-10-04', -10); 
/*
Inserted Trigger
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if new.Working_Hours<0 then set new.Working_Hours=  - new.Working_Hours;
end if;
END
*/