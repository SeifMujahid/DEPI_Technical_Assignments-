--session3_assignment

-------------------------------------------------------------------------------

--create database
create database session3_task;
go 
use session3_task;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--create deprtement table
create table Department (
	DNum int primary key,
	DName nvarchar(255) not null unique
);

--create department locations table
create table Department_Locations (
	DNum int,
	Location nvarchar(255) not null,
	primary key (DNum,Location),
	foreign key (DNum) references Department(DNum)
	on delete cascade on update cascade
);

--create employee table
create table Employee (
	SSN int primary key,
	FName nvarchar(255) not null,
	LName nvarchar(255) not null,
	Birth_Date date ,
	Super_SNN int ,
	DNum int,
	foreign key (Super_SNN) references Employee(SSN)
	on delete no action on update no action,
	foreign key (DNum) references Department(DNum)
	on delete no action on update no action
);
-- adding a new column
alter table Employee ADD Gender char check(Gender in ('M','m','F','f'));

-- create department_manager
create table Department_Manager (
	DNum int ,
	Manager_SSN int,
	Hire_Date date default getdate(),
	primary key (DNum,Manager_SSN),
	foreign key (DNum) references Department(DNum),
	foreign key (Manager_SSN) references Employee(SSN)
);

--create project table
create table Project (
	PNum int primary key,
	PName nvarchar(255) not null,
	City nvarchar(255) ,
	DNum Int
);
--adding a fk constraint
alter table Project add constraint FK_Project_Department foreign key (DNum) references Department(DNum);

--create work table
create table Work (
	Employee_SSN int,
	PNum int,
	Working_Hours decimal(5,2) check (Working_Hours>0),
	primary key (Employee_SSN,PNum),
	foreign key (Employee_SSN) references Employee(SSN),
	foreign key (PNum) references Project(PNum)
);

-- create dependent table weak entity
create table Dependent (
	Name nvarchar(255),
	Employee_SSN int,
	Gender varchar(255),
	Birth_Date date ,
	primary key (Name,Employee_SSN),
	foreign key (Employee_SSN) references Employee(SSN)
);

-- dropping an existing constraint
alter table Dependent drop constraint PK__Dependen__AE416F642ECEFC3B;
-- modifying a column's data type
alter table Dependent alter column Gender char;
alter table Dependent add constraint CHK_Gender_Values check (Gender in ('M', 'm', 'F', 'f'));

--add dependent pk constraint
alter table Dependent add constraint PK_Dependent primary key (Name,Employee_SSN);

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

INSERT INTO Department (DNum, DName) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Finance'),
(4, 'Developing');

--Insert sample data into EMPLOYEE table (at least 5 employees)
INSERT INTO Employee (SSN, FName, LName, Gender, Birth_Date, Super_SNN, DNum) VALUES
('123456789', 'Seif', 'Allithy', 'M', '04/01/2004', NULL, 1),
('234567891', 'Karim', 'Essam', 'M', '01/01/2001', '123456789', 4),
('345678912', 'Shahd', 'Mohamed', 'F', '05/08/1999', '345678912', 2),
('456789123', 'Maryam', 'Sayed', 'F', '12/11/1980', '123456789', 3),
('567891234', 'Osama', 'Waleed', 'M', '02/02/2002', '456789123', 4);

--Insert sample data into DEPENDENT
INSERT INTO DEPENDENT (Employee_SSN, Name, Gender, Birth_Date) VALUES 
('123456789', 'Fatema Seif', 'F', '01/01/2030'),
('345678912', 'Ahmed Mohamed', 'M', '02/02/2010');

--Insert sample data into Project
INSERT INTO Project (PNum, PName, City, DNum) VALUES
(100, 'Payroll System', 'Alex', 1),
(101, 'Exmination Wedsite', 'Cairo', 4),
(102, 'E-Commerce', 'Benha', 4);

--Insert sample data into Work
INSERT INTO Work (Employee_SSN, PNum, Working_Hours) VALUES
('123456789', 100, 10),
('234567891', 101, 20), 
('234567891', 102, 15);

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

use StoreDB;

--1-List all products with list price greater than 1000
select product_id as ID , product_name as [Product Name] , list_price as Price
from production.products
where list_price >1000
order by list_price ;
--2-Get customers from "CA" or "NY" states
select customer_id as ID , CONCAT(first_name,' ',last_name) as [Full Name],state , city
from sales.customers
where state= 'CA' or state='NY'
order by state;
--3-Retrieve all orders placed in 2023
select order_id as ID , order_date,order_status as Status
from sales.orders
where year(order_date)=2023
order by order_date desc;
--4-Show customers whose emails end with @gmail.com
select customer_id as ID, CONCAT(first_name,' ',last_name) as [Full Name],email
from sales.customers
where email like '%@gmail.com';
--5-Show all inactive staff
select staff_id as ID , CONCAT(first_name,' ',last_name) as [Full Name],active
from sales.staffs
where active=0;
--6-List top 5 most expensive products
select top 5 product_id as ID , product_name , list_price
from production.products
order by list_price desc;
--7-Show latest 10 orders sorted by date
select top 10 order_id as ID , order_date
from sales.orders
order by order_date desc;
--8-Retrieve the first 3 customers alphabetically by last name
select top 3 customer_id as ID , CONCAT(first_name,' ',last_name) as [Full Name] , last_name
from sales.customers
order by last_name ;
--9-Find customers who did not provide a phone number
select customer_id as ID , CONCAT(first_name,' ',last_name) as [Full Name] , phone
from sales.customers
where phone is null;
--10-Show all staff who have a manager assigned
select staff_id as ID , CONCAT(first_name,' ',last_name) as [Full Name] , manager_id as [Manager Id]
from sales.staffs
where manager_id is not null;
--11-Count number of products in each category
select category_id  as [Category ID] ,count(product_id) as [Number Of Products]
from production.products
group by category_id
order by category_id;
--12-Count number of customers in each state
select state, count(customer_id) as [Customers Number]
from sales.customers
group by state
order by count(customer_id);
--13-Get average list price of products per brand
select brand_id as [Brand ID],count(product_id) as [Products Number],AVG(list_price) as Average
from production.products
group by brand_id
order by brand_id;
--14-Show number of orders per staff
select staff_id as [Staff ID],count(order_id) as [Orders Number]
from sales.orders
group by staff_id
order by staff_id;
--15-Find customers who made more than 2 orders
select customer_id as[Customer ID], count(order_id) as [Orders Number]
from sales.orders
group by customer_id
having count(order_id)>2
order by count(order_id)desc;
--16-Products priced between 500 and 1500
select product_name , list_price
from production.products
where list_price between 500 and 1500
order by list_price;
--17-Customers in cities starting with "S"
select customer_id,CONCAT(first_name,' ',last_name) as [Full Name] , city
from sales.customers
where city like 'S%'
order by customer_id;
--18-Orders with order_status either 2 or 4
select order_id as ID , order_status as Status
from sales.orders
where order_status= 2 or order_status=4
order by order_id;
--19-Products from category_id IN (1, 2, 3)
select product_id as [Product ID] , product_name as Name , category_id as [Category ID]
from production.products
where category_id in (1,2,3)
order by product_id;
--20-Staff working in store_id = 1 OR without phone number
select staff_id as [Staff ID],store_id as [Store ID],phone
from sales.staffs
where store_id=1 or phone is null;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------