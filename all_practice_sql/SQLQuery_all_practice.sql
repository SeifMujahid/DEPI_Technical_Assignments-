--practice-all-sql
-------------------------------------------------------------------------------

use AdventureWorks2022;
go

-------------------------------------------------------------------------------

--1.1 List all employees hired after January 1, 2012, showing their ID, first name, last name, and hire date, ordered by hire date descending.

select e.BusinessEntityID,p.FirstName,p.LastName,e.HireDate
from HumanResources.Employee e join person.Person p 
on e.BusinessEntityID=p.BusinessEntityID
where e.HireDate > '01-01-2012'
order by e.HireDate desc;

--1.2 List products with a list price between $100 and $500,
--showing product ID, name, list price, and product number, ordered by list price ascending.

select p.ProductID,p.Name,p.ProductNumber,p.ListPrice
from Production.Product p
where p.ListPrice between 100 and 500
order by p.ListPrice asc;

--1.3 List customers from the cities 'Seattle' or 'Portland', showing customer ID, first name, last name, and city, using appropriate joins.

select c.CustomerID,p.FirstName,p.LastName,a.City
from Sales.Customer c join person.person p
on c.PersonID=p.BusinessEntityID join Person.BusinessEntityAddress b  
on p.BusinessEntityID = b.BusinessEntityID join person.Address a 
on a.AddressID = b.AddressID
where a.City = 'Seattle' or  a.City ='Portland';

--1.4 List the top 15 most expensive products currently being sold,
--showing name, list price, product number, and category name, excluding discontinued products.

select top(15) p.Name,p.ProductNumber, c.Name
from Production.Product p join Production.ProductSubcategory sc
on p.ProductSubcategoryID = sc.ProductSubcategoryID join Production.ProductCategory c
on c.ProductCategoryID=sc.ProductCategoryID
where p.SellEndDate is null;

--2.1 List products whose name contains 'Mountain' and color is 'Black', showing product ID, name, color, and list price.

select p.ProductID,p.Name,p.Color,p.ListPrice
from Production.Product p
where( p.Name like '%Mountain%') and (p.color ='Black');

--2.2 List employees born between January 1, 1970, and December 31, 1985, showing full name, birth date, and age in years.

select concat(p.FirstName,' ',p.LastName) as [Full Name] , e.BirthDate , DATEDIFF(year,e.BirthDate,getdate()) as Age
from HumanResources.Employee e join Person.Person p 
on p.BusinessEntityID=e.BusinessEntityID
where e.BirthDate between '01-01-1970' and '12-31-1985';

--2.3 List orders placed in the fourth quarter of 2013, showing order ID, order date, customer ID, and total due.

select salesorderid as [order id],orderdate,customerid as [customer id],totaldue
from sales.salesorderheader
where orderdate >= '2013-10-01' and orderdate < '2014-01-01'
order by orderdate;

--2.4 List products with a null weight but a non-null size, showing product ID, name, weight, size, and product number.

select ProductID,Name,Weight,Size,ProductNumber
from Production.Product
where Weight is null and Size is not null;

--3.1 Count the number of products by category, ordered by count descending.

select  c.Name as [Category Name],count(p.ProductID) as  [Products Count]
from Production.Product p join Production.ProductSubcategory s
on p.ProductSubcategoryID=s.ProductSubcategoryID join Production.ProductCategory c
on s.ProductCategoryID=c.ProductCategoryID
group by c.Name
order by count(c.ProductCategoryID) desc;

--3.2 Show the average list price by product subcategory, including only subcategories with more than five products.

select s.Name as [Subcategory Name], avg(p.ListPrice) [Average Price],count(p.ProductID) as [products count]
from Production.Product p join Production.ProductSubcategory s
on p.ProductSubcategoryID = s.ProductSubcategoryID
where p.ListPrice is not null
group by s.Name
having count(p.ProductID)>5 ;

--3.3 List the top 10 customers by total order count, including customer name.

select top(10) concat(p.FirstName,' ',p.LastName) as [Full Name] , count(o.SalesOrderID) as [Ordrs Count]
from person.Person p join sales.Customer c
on p.BusinessEntityID = c.PersonID join Sales.SalesOrderHeader o
on c.CustomerID = o.CustomerID
group by p.FirstName ,p.LastName;

--3.4 Show monthly sales totals for 2013, displaying the month name and total amount.

select MONTH(OrderDate) as [Month] ,datename(month,orderdate) as [month name], count(SalesOrderID) as [Orders Count],sum(totaldue) as [total sales]
from Sales.SalesOrderHeader
where year(orderdate)=2013
group by datename(month,orderdate),MONTH(OrderDate);

--4.1 Find all products launched in the same year as 'Mountain-100 Black, 42'. Show product ID, name, sell start date, and year.

select ProductID,Name,SellStartDate,YEAR(SellStartDate)
from Production.Product
where YEAR(SellStartDate) = (select YEAR(SellStartDate) from Production.Product where Name='Mountain-100 Black, 42');

--4.2 Find employees who were hired on the same date as someone else.
--Show employee names, shared hire date, and the count of employees hired that day.

with emp_count as (
  select hiredate, count(BusinessEntityID) as Employees_count
  from humanresources.employee
  group by hiredate
  having count(BusinessEntityID) > 1
)
select concat(p.FirstName,' ',p.LastName) as [Full Name],e.HireDate, ec.Employees_count as [Employees Count]
from person.Person p join HumanResources.Employee e
on p.BusinessEntityID = e.BusinessEntityID join emp_count ec
on ec.HireDate=e.HireDate
order by e.HireDate;

--5.1 Create a table named Sales.ProductReviews with columns for
--review ID, product ID, customer ID, rating, review date, review text, verified purchase flag, and helpful votes.
--Include appropriate primary key, foreign keys, check constraints, defaults, and a unique constraint on product ID and customer ID.

create table Sales.ProductReviews (
	review_id int identity(1,1) primary key ,
	rating int check(rating between 1 and 5),
	review_date date not null default getdate(),
	reviwe_text text,
	verified_purchase_flag bit not null,
	helpful_votes int not null default 0,
	product_id int,
	customer_id int,
	constraint c1 foreign key (product_id) references Production.Product(ProductID)
			   on delete set null on update cascade,
	constraint c2 foreign key (customer_id) references Sales.Customer(CustomerID)
			   on delete set null on update cascade
);

--6.1 Add a column named LastModifiedDate to the Production.Product table, with a default value of the current date and time.

alter table Production.Product add  LastModifiedDate date default getdate();

--6.2 Create a non-clustered index on the LastName column of the Person.Person table, including FirstName and MiddleName.

create nonclustered index index1
on Person.Person(LastName)
include(FirstName,MiddleName);

--6.3 Add a check constraint to the Production.Product table to ensure that ListPrice is greater than StandardCost.

update production.product set listprice = standardcost + 1 where listprice <= standardcost
--not work because of not valid data so i edited bad data and then add the constraint
alter table production.product add constraint ck_listprice check (listprice > standardcost);

--7.1 Insert three sample records into Sales.ProductReviews using existing product and customer IDs, with varied ratings and meaningful review text.

insert into sales.productreviews (product_id, customer_id, rating, reviwe_text, verified_purchase_flag, helpful_votes)
values
 (770, 18325, 5, 'Excellent.', 1, 10),
 (780, 18326, 3, 'Average.', 1, 2),
 (790, 18327, 1, 'Bad.', 0, 0);

--7.2 Insert a new product category named 'Electronics' and a corresponding product subcategory named 'Smartphones' under Electronics.

insert into production.productcategory(name) values('Electronics');
insert into production.productsubcategory(name, productcategoryid) values('Smartphones', 5);

--7.3 Copy all discontinued products (where SellEndDate is not null) into a new table named Sales.DiscontinuedProducts.

select * into sales.discontinuedproducts
from production.product
where sellenddate is not null;

--8.1 Update the ModifiedDate to the current date for all products where ListPrice is greater than $1000 and SellEndDate is null.

update production.product set lastmodifieddate = sysdatetime()
where listprice > 1000 and sellenddate is null;

--8.2 Increase the ListPrice by 15% for all products in the 'Bikes' category and update the ModifiedDate.

update p set p.listprice = p.listprice * 1.15, p.lastmodifieddate = sysdatetime()
from production.product p join production.productsubcategory sc 
on p.productsubcategoryid = sc.productsubcategoryid join production.productcategory c
on sc.productcategoryid = c.productcategoryid
where c.name = 'Bikes';

--8.3 Update the JobTitle to 'Senior' plus the existing job title for employees hired before January 1, 2010.

update humanresources.employee set jobtitle = 'Senior ' + jobtitle
where hiredate < '2010-01-01';

--9.1 Delete all product reviews with a rating of 1 and helpful votes equal to 0.

delete from sales.productreviews where rating=1 and helpful_votes=0;

--9.2 Delete products that have never been ordered, using a NOT EXISTS condition with Sales.SalesOrderDetail.

delete from production.product
where not exists (
  select 1 from sales.salesorderdetail where sales.salesorderdetail.productid = production.product.productid
);

--9.3 Delete all purchase orders from vendors that are no longer active.

delete po 
from purchasing.purchaseorderheader po
join purchasing.vendor v on po.vendorid = v.BusinessEntityID
where v.activeflag = 0;

--10.1 Calculate the total sales amount by year from 2011 to 2014, showing year, total sales, average order value, and order count.

select year(orderdate) as sales_year, sum(totaldue) as total_sales, avg(totaldue) as avg_order, count(*) as order_count
from sales.salesorderheader
where year(orderdate) between 2011 and 2014
group by year(orderdate)
order by sales_year;

--10.2 For each customer, show customer ID, total orders, total amount, average order value, first order date, and last order date.

select c.customerid, count(*) as total_orders, sum(soh.totaldue) as total_amount,
	   avg(soh.totaldue) as avg_order, min(soh.orderdate) as first_order, max(soh.orderdate) as last_order
from sales.salesorderheader soh join sales.customer c 
on soh.customerid = c.customerid
group by c.customerid;

--10.3 List the top 20 products by total sales amount, including product name, category, total quantity sold, and total revenue.

select top(20) p.name, c.name as category, sum(sod.orderqty) as total_qty, sum(sod.UnitPrice) as total_revenue
from sales.salesorderdetail sod join production.product p
on sod.productid = p.productid join production.productsubcategory sc 
on p.productsubcategoryid = sc.productsubcategoryid join production.productcategory c
on sc.productcategoryid = c.productcategoryid
group by p.name, c.name
order by total_revenue desc;

--10.4 Show sales amount by month for 2013, displaying the month name, sales amount, and percentage of the yearly total.

with monthly as (
 select month(orderdate) as [month], sum(totaldue) as monthly_sales
 from sales.salesorderheader
 where year(orderdate)=2013
 group by month(orderdate)
),
yearly_sales as (
 select sum(totaldue) as year_sales
 from sales.salesorderheader
 where year(orderdate)=2013
)
select datename(month, datefromparts(2013,m.month,1)) as month_name,m.monthly_sales,
	   concat(cast(monthly_sales/y.year_sales*100 as nvarchar),' %') as percent_of_year
from monthly m cross join yearly_sales y
order by m.month;

--11.1 Show employees with their full name, age in years, years of service, hire date formatted as 'Mon DD, YYYY', and birth month name.

select concat(p.firstname,' ',p.lastname) as full_name,
 datediff(year,e.BirthDate,getdate()) as age,
 datediff(year,e.hiredate,getdate()) as years_service,
 format(e.hiredate,'MMM dd, yyyy') as hire_date,
 datename(month,e.BirthDate) as birth_month
from humanresources.employee e join person.person p 
on e.businessentityid = p.businessentityid;

--11.2 Format customer names as 'LAST, First M.' (with middle initial), extract the email domain, and apply proper case formatting.

select UPPER(p.FirstName)+', '+p.LastName+' '+ upper(LEFT(p.MiddleName,1)) as [Customer Name] ,
	   substring(e.EmailAddress,charindex('@',e.EmailAddress),charindex('.',e.EmailAddress))as email_domain
from sales.customer c join person.person p
on c.personid = p.BusinessEntityID join Person.EmailAddress e
on p.BusinessEntityID=e.BusinessEntityID
where UPPER(p.FirstName)+', '+p.LastName+' '+ upper(LEFT(p.MiddleName,1)) is not null;

--11.3 For each product, show name, weight rounded to one decimal, weight in pounds (converted from grams), and price per pound.

select name, round(weight,1) as weight_kg, weight * 2.20462 as weight_pounds,listprice / weight*2.20462 as price_per_pound
from production.product
where weight is not null ;

--12.1 List product name, category, subcategory, and vendor name for products that have been purchased from vendors.

select p.name, c.name as category, sc.name as subcategory, v.name as vendor
from production.product p join production.productsubcategory sc 
on p.productsubcategoryid = sc.productsubcategoryid join production.productcategory c 
on sc.productcategoryid = c.productcategoryid join purchasing.productvendor pv
on p.productid = pv.productid join purchasing.vendor v 
on pv.BusinessEntityID = v.BusinessEntityID;

--12.2 Show order details including order ID, customer name, salesperson name, territory name, product name, quantity, and line total.

select soh.salesorderid, concat(pp.firstname,' ',pp.lastname) as customer, emp.firstname as salesperson, t.name as territory,
	   p.name as product, sod.orderqty, sod.LineTotal
from sales.salesorderheader soh join sales.customer c
on soh.customerid = c.customerid join person.person pp
on c.personid = pp.businessentityid join sales.salesperson sp 
on soh.salespersonid = sp.businessentityid join person.person emp 
on sp.businessentityid = emp.businessentityid join sales.salesterritory t 
on sp.territoryid = t.territoryid join sales.salesorderdetail sod 
on soh.salesorderid = sod.salesorderid join production.product p 
on sod.productid = p.productid;

--12.3 List employees with their sales territories, including employee name, job title, territory name, territory group, and sales year-to-date.

select concat(p.firstname,' ',p.lastname) as employee,e.JobTitle ,t.name as territory, t.TerritoryID, sp.salesytd
from humanresources.employee e join person.person p
on e.businessentityid = p.businessentityid left outer join sales.salesperson sp 
on e.businessentityid = sp.BusinessEntityID left outer join sales.salesterritory t 
on sp.territoryid = t.territoryid;

--13.1 List all products with their total sales, including those never sold.
--Show product name, category, total quantity sold (zero if never sold), and total revenue (zero if never sold).

select p.name, c.name as category, isnull(sum(sod.orderqty),0) as total_qty,isnull(sum(sod.LineTotal),0) as total_revenue
from production.product p join production.productsubcategory sc 
on p.productsubcategoryid = sc.productsubcategoryid join production.productcategory c
on sc.productcategoryid = c.productcategoryid left join sales.salesorderdetail sod 
on p.productid = sod.productid
group by p.name, c.name;

--13.2 Show all sales territories with their assigned employees, including unassigned territories.
--Show territory name, employee name (null if unassigned), and sales year-to-date.

select t.name as territory, concat(p.firstname,' ',p.lastname) as employee, t.salesytd
from sales.salesterritory t left outer join sales.salesperson sp 
on t.territoryid = sp.territoryid left outer join person.person p
on sp.businessentityid = p.businessentityid;

--13.3 Show the relationship between vendors and product categories, including vendors with no products and categories with no vendors.

--14.1 List products with above-average list price, showing product ID, name, list price, and price difference from the average.

with avgprice as(
select avg(listprice) as avgp 
from production.product
)
select p.productid, p.name, p.listprice, p.listprice - a.avgp as diff_from_avg
from production.product p cross join avgprice a
where p.listprice > a.avgp;

--14.2 List customers who bought products from the 'Mountain' category, showing customer name, total orders, and total amount spent.

select concat(pp.firstname,' ',pp.lastname) as customer, count(distinct soh.salesorderid) as orders, sum(soh.totaldue) as total_spent
from sales.salesorderheader soh
join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
join production.product p on sod.productid = p.productid
join production.productsubcategory sc on p.productsubcategoryid = sc.productsubcategoryid
join production.productcategory pc on sc.productcategoryid = pc.productcategoryid
join sales.customer c on soh.customerid = c.customerid
join person.person pp on c.personid = pp.businessentityid
where pc.name like '%Mountain%'
group by pp.firstname, pp.lastname
order by total_spent desc;

--14.3 List products that have been ordered by more than 100 different customers, showing product name, category, and unique customer count.

select p.name, c.name as category, count(distinct soh.customerid) as cust_count
from sales.salesorderdetail sod
join production.product p on sod.productid = p.productid
join production.productsubcategory sc on p.productsubcategoryid = sc.productsubcategoryid
join production.productcategory c on sc.productcategoryid = c.productcategoryid
join sales.salesorderheader soh on sod.salesorderid = soh.salesorderid
group by p.name, c.name
having count(distinct soh.customerid) > 100;

--14.4 For each customer, show their order count and their rank among all customers.

select customerid, count(*) as order_count,
rank() over (order by count(*) desc) as rank
from sales.salesorderheader
group by customerid;

--15.1 Create a view named vw_ProductCatalog with product ID, name, product number, category, subcategory, list price, standard cost,
--profit margin percentage, inventory level, and status (active/discontinued).

go
create view vw_productcatalog as
select p.productid, p.name, p.productnumber, c.name as category, sc.name as subcategory,
 p.listprice, p.standardcost,(p.listprice - p.standardcost) / p.listprice * 100 as profit_margin_pct,pp.Quantity as inventory_level,
 case
 when p.sellenddate is null then 'active' 
 else 'discontinued' 
 end as status
from production.product p
join production.productsubcategory sc on p.productsubcategoryid = sc.productsubcategoryid
join production.productcategory c on sc.productcategoryid = c.productcategoryid
left join production.productinventory pp on p.productid = pp.productid;
go

--15.2 Create a view named vw_SalesAnalysis with year, month, territory, total sales, order count, average order value, and top product name.

go
create view vw_salesanalysis as
with sales_data as (
    select year(soh.orderdate) as yr,month(soh.orderdate) as mth, t.name as territory, soh.salesorderid, soh.totaldue
    from sales.salesorderheader soh join sales.salesperson sp 
	on soh.salespersonid = sp.businessentityid join sales.salesterritory t
	on sp.territoryid = t.territoryid
),
top_products as (
    select year(soh.orderdate) as yr,month(soh.orderdate) as mth,t.name as territory,p.name as product_name,
			rank() over (
							partition by year(soh.orderdate), month(soh.orderdate), t.name
							order by sum(sod.linetotal) desc
			) as rnk
    from sales.salesorderheader soh
    join sales.salesperson sp on soh.salespersonid = sp.businessentityid
    join sales.salesterritory t on sp.territoryid = t.territoryid
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    join production.product p on sod.productid = p.productid
    group by year(soh.orderdate), month(soh.orderdate), t.name, p.name
)
select sd.yr,sd.mth,sd.territory,sum(sd.totaldue) as total_sales,count(sd.salesorderid) as order_count,avg(sd.totaldue) as avg_order,
	   tp.product_name as top_product
from sales_data sd left join top_products tp
on sd.yr = tp.yr and sd.mth = tp.mth and sd.territory = tp.territory and tp.rnk = 1
group by sd.yr, sd.mth, sd.territory, tp.product_name;
go

--15.3 Create a view named vw_EmployeeDirectory with full name, job title, department, manager name, hire date, years of service, email, and phone.

go
create view vw_employeedirectory as
select
    e.businessentityid,
    concat(p.firstname, ' ', p.middlename, ' ', p.lastname) as full_name,
    e.jobtitle,
    d.name as department,
    concat(mp.firstname, ' ', mp.middlename, ' ', mp.lastname) as manager_name,
    e.hiredate,
    datediff(year, e.hiredate, getdate()) as years_of_service,
    ea.emailaddress,
    pp.phonenumber
from humanresources.employee e
join person.person p on e.businessentityid = p.businessentityid
left join humanresources.employeedepartmenthistory edh 
    on e.businessentityid = edh.businessentityid and edh.enddate is null
left join humanresources.department d on edh.departmentid = d.departmentid
left join person.emailaddress ea on e.businessentityid = ea.businessentityid
left join person.personphone pp on e.businessentityid = pp.businessentityid
left join humanresources.employee m on e.organizationnode.GetAncestor(1) = m.organizationnode
left join person.person mp on m.businessentityid = mp.businessentityid;
go


--15.4 Write three different queries using the views you created, demonstrating practical business scenarios.

select top(5) yr,mth,territory,total_sales
from vw_salesanalysis
order by total_sales desc; 

select full_name,jobtitle,department,hiredate,years_of_service
from vw_employeedirectory
where years_of_service >= 10
order by years_of_service desc;

select full_name,jobtitle,department,hiredate,years_of_service
from vw_employeedirectory
order by years_of_service desc
offset 0 rows fetch next 10 rows only;

--16.1 Classify products by price as 'Premium' (greater than $500),
--'Standard' ($100 to $500), or 'Budget' (less than $100), and show the count and average price for each category.

select
    case
        when listprice > 500 then 'Premium'
        when listprice between 100 and 500 then 'Standard'
        else 'Budget'
    end as price_category,
    count(*) as product_count,
    avg(listprice) as avg_price
from production.product
where listprice > 0  
group by
    case
        when listprice > 500 then 'Premium'
        when listprice between 100 and 500 then 'Standard'
        else 'Budget'
    end;


--16.2 Classify employees by years of service as 'Veteran' (10+ years), 
--'Experienced' (5-10 years), 'Regular' (2-5 years), or 'New' (less than 2 years), and show salary statistics for each group.

select
    case
        when datediff(year, e.hiredate, getdate()) >= 10 then 'Veteran'
        when datediff(year, e.hiredate, getdate()) between 5 and 9 then 'Experienced'
        when datediff(year, e.hiredate, getdate()) between 2 and 4 then 'Regular'
        else 'New'
    end as service_category,
    count(*) as employee_count,
    min(ph.rate) as min_salary,
    max(ph.rate) as max_salary,
    avg(ph.rate) as avg_salary
from humanresources.employee e
join humanresources.employeepayhistory ph on e.businessentityid = ph.businessentityid
where ph.RateChangeDate = (
    select max(RateChangeDate)
    from humanresources.employeepayhistory
    where businessentityid = e.businessentityid
)
group by
    case
        when datediff(year, e.hiredate, getdate()) >= 10 then 'Veteran'
        when datediff(year, e.hiredate, getdate()) between 5 and 9 then 'Experienced'
        when datediff(year, e.hiredate, getdate()) between 2 and 4 then 'Regular'
        else 'New'
    end;


--16.3 Classify orders by size as 'Large' (greater than $5000),
--'Medium' ($1000 to $5000), or 'Small' (less than $1000), and show the percentage distribution.

select
    order_size,
    count(*) as order_count,
    cast(100.0 * count(*) / sum(count(*)) over () as decimal(5,2)) as percentage
from (
    select
        case
            when totaldue > 5000 then 'Large'
            when totaldue between 1000 and 5000 then 'Medium'
            else 'Small'
        end as order_size
    from sales.salesorderheader
) as classified_orders
group by order_size;


--17.1 Show products with name, weight (display 'Not Specified' if null),
--size (display 'Standard' if null), and color (display 'Natural' if null).

select
    name,
    isnull(cast(weight as varchar), 'Not Specified') as weight,
    isnull(size, 'Standard') as size,
    isnull(color, 'Natural') as color
from production.product;

--17.2 For each customer, display the best available contact method, prioritizing email address, then phone, then address line.

select 
    c.customerid,
    p.firstname + ' ' + p.lastname as customer_name,
    coalesce(ea.emailaddress, pp.phonenumber, a.addressline1) as best_contact_method
from sales.customer c
join person.person p on c.personid = p.businessentityid
left join person.emailaddress ea on p.businessentityid = ea.businessentityid
left join person.personphone pp on p.businessentityid = pp.businessentityid
left join person.businessentityaddress bea on p.businessentityid = bea.businessentityid
left join person.address a on bea.addressid = a.addressid;

--17.3 Find products where weight is null but size is not null, and also find products where both weight and size are null.
--Discuss the impact on inventory management.

select productid,name,weight,size,
	   case 
		 when weight is null and size is not null then 'Missing Weight Only'
		 when weight is null and size is null then 'Missing Weight and Size'
	   end as data_issue
from production.product
where (weight is null and size is not null) or (weight is null and size is null);

--18.1 Create a recursive query to show the complete employee hierarchy, including employee name, manager name, hierarchy level, and path.

with employee_hierarchy as (
    select 
        e.businessentityid,
        p.firstname + ' ' + p.lastname as employee_name,
        cast(null as varchar(200)) as manager_name,  -- fixed cast size
        0 as hierarchy_level,
        cast(p.firstname + ' ' + p.lastname as varchar(500)) as path,
        e.organizationnode
    from humanresources.employee e
    join person.person p on e.businessentityid = p.businessentityid
    where e.organizationnode.GetLevel() = 0

    union all

    select 
        e.businessentityid,
        p.firstname + ' ' + p.lastname as employee_name,
        cast(eh.employee_name as varchar(200)) as manager_name,  -- cast to match anchor
        eh.hierarchy_level + 1,
        cast(eh.path + ' > ' + p.firstname + ' ' + p.lastname as varchar(500)) as path,
        e.organizationnode
    from humanresources.employee e
    join person.person p on e.businessentityid = p.businessentityid
    join employee_hierarchy eh 
        on e.organizationnode.GetAncestor(1) = eh.organizationnode
)
select businessentityid,employee_name,manager_name,hierarchy_level,path
from employee_hierarchy
order by path;

--18.2 Create a query to compare year-over-year sales for each product, showing product, sales for 2013,
--sales for 2014, growth percentage, and growth category.

with sales_by_year as (
    select 
        p.productid,
        p.name as product_name,
        year(soh.orderdate) as sales_year,
        sum(sod.linetotal) as total_sales
    from sales.salesorderheader soh
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    join production.product p on sod.productid = p.productid
    where year(soh.orderdate) in (2013, 2014)
    group by p.productid, p.name, year(soh.orderdate)
),
pivoted as (
    select 
        productid,
        product_name,
        isnull([2013], 0) as sales_2013,
        isnull([2014], 0) as sales_2014
    from sales_by_year
    pivot (
        sum(total_sales)
        for sales_year in ([2013], [2014])
    ) as p
)
select productid,product_name,sales_2013,sales_2014,
    case 
        when sales_2013 = 0 and sales_2014 = 0 then 0
        when sales_2013 = 0 then 100
        else round(((sales_2014 - sales_2013) * 100.0) / sales_2013, 2)
    end as growth_percentage,
    case 
        when sales_2013 = 0 and sales_2014 = 0 then 'No Sales'
        when sales_2013 = 0 then 'New'
        when sales_2014 = 0 then 'Dropped'
        when sales_2014 > sales_2013 then 'Increased'
        when sales_2014 < sales_2013 then 'Decreased'
        else 'Stable'
    end as growth_category
from pivoted
order by growth_percentage desc;

--19.1 Rank products by sales within each category, showing product name, category, sales amount, rank, dense rank, and row number.

with product_sales as (
    select 
        p.productid,
        p.name as product_name,
        pc.name as category_name,
        sum(sod.linetotal) as total_sales
    from production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    join sales.salesorderdetail sod on p.productid = sod.productid
    group by p.productid, p.name, pc.name
)
select product_name,category_name,total_sales,
    rank() over(partition by category_name order by total_sales desc) as rank,
    dense_rank() over(partition by category_name order by total_sales desc) as dense_rank,
    row_number() over(partition by category_name order by total_sales desc) as row_num
from product_sales
order by category_name, total_sales desc;

--19.2 Show the running total of sales by month for 2013, displaying month, monthly sales, running total, and percentage of year-to-date.

with monthly_sales as (
    select 
        datename(month, soh.orderdate) as month_name,
        month(soh.orderdate) as month_number,
        sum(sod.linetotal) as monthly_sales
    from sales.salesorderheader soh
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    where year(soh.orderdate) = 2013
    group by datename(month, soh.orderdate), month(soh.orderdate)
),
ordered_sales as (
    select 
        month_name,
        month_number,
        monthly_sales,
        sum(monthly_sales) over(order by month_number) as running_total,
        sum(monthly_sales) over() as yearly_total
    from monthly_sales
)
select 
    month_name,
    monthly_sales,
    running_total,
    round((running_total * 100.0) / yearly_total, 2) as pct_of_ytd
from ordered_sales
order by month_number;

--19.3 Show the three-month moving average of sales for each territory, displaying territory, month, sales, and moving average.

with monthly_sales as (
    select 
        t.name as territory,
        year(soh.orderdate) as sales_year,
        month(soh.orderdate) as sales_month,
        sum(sod.linetotal) as monthly_sales
    from sales.salesorderheader soh
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    join sales.salesterritory t on soh.territoryid = t.territoryid
    where soh.orderdate is not null
    group by t.name, year(soh.orderdate), month(soh.orderdate)
)
select 
    territory,
    sales_year,
    sales_month,
    monthly_sales,
    round(
        avg(monthly_sales) over (
            partition by territory
            order by sales_year, sales_month
            rows between 2 preceding and current row
        ), 2
    ) as moving_avg_3_months
from monthly_sales
order by territory, sales_year, sales_month;

--19.4 Show month-over-month sales growth, displaying month, sales, previous month sales, growth amount, and growth percentage.

with monthly_sales as (
    select 
        year(orderdate) as sales_year,
        month(orderdate) as sales_month,
        datename(month, orderdate) + ' ' + cast(year(orderdate) as varchar) as month_name,
        sum(totaldue) as monthly_sales
    from sales.salesorderheader
    where orderdate is not null
    group by year(orderdate), month(orderdate), datename(month, orderdate)
),
sales_with_lag as (
    select 
        sales_year,
        sales_month,
        month_name,
        monthly_sales,
        lag(monthly_sales) over (order by sales_year, sales_month) as previous_month_sales
    from monthly_sales
)
select 
    month_name,
    monthly_sales as current_month_sales,
    previous_month_sales,
    (monthly_sales - previous_month_sales) as growth_amount,
    case 
        when previous_month_sales = 0 or previous_month_sales is null then null
        else round(((monthly_sales - previous_month_sales) * 100.0) / previous_month_sales, 2)
    end as growth_percentage
from sales_with_lag
order by sales_year, sales_month;

--19.5 Divide customers into four quartiles based on total purchase amount, showing customer name, total purchases, quartile, and quartile average.

with customer_purchases as (
    select 
        c.customerid,
        p.firstname + ' ' + p.lastname as customer_name,
        sum(soh.totaldue) as total_purchase
    from sales.customer c
    join person.person p on c.personid = p.businessentityid
    join sales.salesorderheader soh on c.customerid = soh.customerid
    group by c.customerid, p.firstname, p.lastname
),
quartiled_customers as (
    select *,
        ntile(4) over (order by total_purchase desc) as quartile
    from customer_purchases
),
quartile_avg as (
    select 
        quartile,
        avg(total_purchase) as quartile_average
    from quartiled_customers
    group by quartile
)
select 
    qc.customer_name,
    qc.total_purchase,
    qc.quartile,
    qa.quartile_average
from quartiled_customers qc
join quartile_avg qa on qc.quartile = qa.quartile
order by qc.quartile, qc.total_purchase desc;

--20.1 Create a pivot table showing product categories as rows and years (2011-2014) as columns, displaying sales amounts with totals.

with category_sales as (
    select 
        pc.name as category_name,
        year(soh.orderdate) as sales_year,
        sum(sod.linetotal) as sales_amount
    from sales.salesorderheader soh
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    join production.product p on sod.productid = p.productid
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    where year(soh.orderdate) between 2011 and 2014
    group by pc.name, year(soh.orderdate)
)
select 
    category_name,
    isnull([2011], 0) as [2011],
    isnull([2012], 0) as [2012],
    isnull([2013], 0) as [2013],
    isnull([2014], 0) as [2014],
    isnull([2011], 0) + isnull([2012], 0) + isnull([2013], 0) + isnull([2014], 0) as total_sales
from category_sales
pivot (
    sum(sales_amount)
    for sales_year in ([2011], [2012], [2013], [2014])
) as pivot_table
order by category_name;

--20.2 Create a pivot table showing departments as rows and gender as columns, displaying employee count by department and gender.

with dept_gender_counts as (
    select 
        d.name as department,
        e.gender,
        count(*) as employee_count
    from humanresources.employee e
    join humanresources.employeedepartmenthistory edh 
        on e.businessentityid = edh.businessentityid and edh.enddate is null
    join humanresources.department d 
        on edh.departmentid = d.departmentid
    group by d.name, e.gender
)
select 
    department,
    isnull([M], 0) as Male,
    isnull([F], 0) as Female,
    isnull([M], 0) + isnull([F], 0) as Total
from dept_gender_counts
pivot (
    sum(employee_count)
    for gender in ([M], [F])
) as pivot_table
order by department;

--20.3 Create a dynamic pivot table for quarterly sales, automatically handling an unknown number of quarters.

DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

SELECT @columns = STRING_AGG(QUOTENAME(quarter_label), ',')
FROM (
    SELECT DISTINCT 
        'Q' + CAST(DATEPART(QUARTER, orderdate) AS VARCHAR) + '-' + CAST(YEAR(orderdate) AS VARCHAR) AS quarter_label
    FROM sales.salesorderheader
) AS sub;

SET @sql = '
WITH sales_data AS (
    SELECT 
        ''Q'' + CAST(DATEPART(QUARTER, soh.orderdate) AS VARCHAR) + ''-'' + CAST(YEAR(soh.orderdate) AS VARCHAR) AS quarter_label,
        SUM(sod.linetotal) AS sales_amount
    FROM sales.salesorderheader soh
    JOIN sales.salesorderdetail sod ON soh.salesorderid = sod.salesorderid
    GROUP BY DATEPART(QUARTER, soh.orderdate), YEAR(soh.orderdate)
)
SELECT *
FROM (
    SELECT quarter_label, sales_amount FROM sales_data
) AS src
PIVOT (
    SUM(sales_amount) FOR quarter_label IN (' + @columns + ')
) AS pivot_table;
';

EXEC sp_executesql @sql;

--21.1 Find products sold in both 2013 and 2014, and combine with products sold only in 2013, showing a complete analysis.

WITH sales_by_year AS (
    SELECT 
        sod.productid,
        YEAR(soh.orderdate) AS sales_year
    FROM sales.salesorderheader soh
    JOIN sales.salesorderdetail sod ON soh.salesorderid = sod.salesorderid
    WHERE YEAR(soh.orderdate) IN (2013, 2014)
    GROUP BY sod.productid, YEAR(soh.orderdate)
),
product_years AS (
    SELECT 
        productid,
        MAX(CASE WHEN sales_year = 2013 THEN 1 ELSE 0 END) AS sold_2013,
        MAX(CASE WHEN sales_year = 2014 THEN 1 ELSE 0 END) AS sold_2014
    FROM sales_by_year
    GROUP BY productid
)
SELECT 
    p.name AS product_name,
    CASE 
        WHEN py.sold_2013 = 1 AND py.sold_2014 = 1 THEN 'Sold in 2013 and 2014'
        WHEN py.sold_2013 = 1 AND py.sold_2014 = 0 THEN 'Sold only in 2013'
        ELSE 'Other'
    END AS sales_status
FROM product_years py
JOIN production.product p ON py.productid = p.productid
WHERE py.sold_2013 = 1;

--21.2 Compare product categories with high-value products (greater than $1000)
--to those with high-volume sales (more than 1000 units sold), using set operations.

with high_value_categories as (
    select distinct pc.name as category
    from production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    where p.listprice > 1000
),

high_volume_categories as (
    select pc.name as category
    from sales.salesorderdetail sod
    join production.product p on sod.productid = p.productid
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    group by pc.name
    having sum(sod.orderqty) > 1000
)

select category, 'high-value & high-volume' as category_type
from high_value_categories
intersect
select category, 'high-value & high-volume'
from high_volume_categories

union all

select category, 'high-value only'
from high_value_categories
except
select category, 'high-value only'
from high_volume_categories

union all

select category, 'high-volume only'
from high_volume_categories
except
select category, 'high-volume only'
from high_value_categories;

--22.1 Declare variables for the current year, total sales, and average order value, and display year-to-date statistics with formatted output.

declare @current_year int = year(getdate());
declare @total_sales money;
declare @avg_order_value money;

select 
    @total_sales = sum(totaldue),
    @avg_order_value = avg(totaldue)
from sales.salesorderheader
where year(orderdate) = @current_year;

print 'year-to-date sales summary for year: ' + cast(@current_year as varchar);
print 'total sales: $' + format(@total_sales, '#,##0.00');
print 'average order value: $' + format(@avg_order_value, '#,##0.00');

--22.2 Check if a specific product exists in inventory. If it exists, show details; if not, suggest similar products. 

declare @product_name nvarchar(100) = 'road-550-w-yellow-44';  

if exists (
    select 1 
    from production.product p
    join production.productinventory pi on p.productid = pi.productid
    where p.name = @product_name and pi.quantity > 0
)
begin
    select 
        p.productid,
        p.name,
        p.productnumber,
        pi.quantity,
        pi.locationid
    from production.product p
    join production.productinventory pi on p.productid = pi.productid
    where p.name = @product_name;
end
else
begin
    print 'product not found in inventory. suggesting similar products:'

    select top 5
        p.productid,
        p.name,
        p.productnumber,
        pi.quantity,
        pi.locationid
    from production.product p
    join production.productinventory pi on p.productid = pi.productid
    where p.name like '%' + parsename(replace(@product_name, '-', '.'), 1) + '%'
      and pi.quantity > 0
    order by pi.quantity desc;
end

--22.3 Generate a monthly sales summary for each month in 2013 using a loop.

declare @month int = 1;
declare @year int = 2013;

print 'monthly sales summary for ' + cast(@year as varchar);

while @month <= 12
begin
    declare @start_date date = datefromparts(@year, @month, 1);
    declare @end_date date = eomonth(@start_date);
    declare @monthly_sales money;

    select @monthly_sales = sum(totaldue)
    from sales.salesorderheader
    where orderdate >= @start_date and orderdate <= @end_date;

    print 'month: ' + datename(month, @start_date) + 
          ' | sales: $' + isnull(format(@monthly_sales, '#,##0.00'), '0.00');

    set @month += 1;
end

--22.4 Implement error handling for a product price update operation, including logging errors and rolling back on failure.

if not exists (
    select 1 from sys.tables where name = 'error_log' and schema_id = schema_id('dbo')
)
begin
    create table dbo.error_log (
        id int identity(1,1) primary key,
        error_time datetime default getdate(),
        procedure_name sysname,
        error_message nvarchar(max),
        error_severity int,
        error_state int,
        error_line int
    );
end
go

begin try
    begin transaction;
    update production.product
    set listprice = listprice * 1.1
    where productsubcategoryid = 1;  

    commit transaction;
    print 'product prices updated successfully.';
end try
begin catch
    rollback transaction;

    insert into dbo.error_log (
        procedure_name,
        error_message,
        error_severity,
        error_state,
        error_line
    )
    values (
        error_procedure(),
        error_message(),
        error_severity(),
        error_state(),
        error_line()
    );

    print 'error occurred. transaction rolled back. check dbo.error_log for details.';
end catch;

--23.1 Create a scalar function to calculate customer lifetime value, including total amount spent and weighted recent activity,
--with parameters for date range and activity weight.

go
create function dbo.fn_customer_lifetime_value
(
    @customerid int,
    @start_date date,
    @end_date date,
    @activity_weight float
)
returns money
as
begin
    declare @total_spent money;
    declare @recent_activity money;
    declare @lifetime_value money;

    select @total_spent = sum(totaldue)
    from sales.salesorderheader
    where customerid = @customerid
      and orderdate between @start_date and @end_date;

    select @recent_activity = sum(totaldue)
    from sales.salesorderheader
    where customerid = @customerid
      and orderdate between dateadd(day, -90, @end_date) and @end_date;

    set @total_spent = isnull(@total_spent, 0);
    set @recent_activity = isnull(@recent_activity, 0);

    set @lifetime_value = @total_spent + (@recent_activity * @activity_weight);

    return @lifetime_value;
end;
go

--23.2 Create a multi-statement table-valued function to return products by price range and category,
--including error handling for invalid parameters.

go
create function dbo.fn_products_by_price_and_category
(
    @min_price money,
    @max_price money,
    @category_name nvarchar(50)
)
returns @result table
(
    productid int,
    productname nvarchar(100),
    category nvarchar(100),
    listprice money
)
as
begin
    if @min_price < 0 or @max_price < 0 or @min_price > @max_price
    begin
        return;
    end
    if not exists (
        select 1
        from production.productcategory
        where name = @category_name
    )
    begin
        return;
    end

    insert into @result
    select p.productid,
           p.name as productname,
           pc.name as category,
           p.listprice
    from production.product p
    join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
    join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
    where pc.name = @category_name
      and p.listprice between @min_price and @max_price;

    return;
end;
go

--23.3 Create an inline table-valued function to return all employees under a specific manager, including hierarchy level and employee path.

go
create function dbo.fn_employees_under_manager
(
    @manager_id int
)
returns table
as
return
(
    with manager_node as (
        select organizationnode
        from humanresources.employee
        where businessentityid = @manager_id
    ),
    employee_hierarchy as (
        select 
            e.businessentityid,
            p.firstname + ' ' + p.lastname as employeename,
            e.organizationnode,
            0 as hierarchy_level,
            cast(p.firstname + ' ' + p.lastname as nvarchar(max)) as path
        from humanresources.employee e
        join person.person p on e.businessentityid = p.businessentityid
        cross join manager_node
        where e.businessentityid = @manager_id

        union all

        select 
            e.businessentityid,
            p.firstname + ' ' + p.lastname,
            e.organizationnode,
            eh.hierarchy_level + 1,
            cast(eh.path + ' > ' + p.firstname + ' ' + p.lastname as nvarchar(max))
        from humanresources.employee e
        join person.person p on e.businessentityid = p.businessentityid
        join employee_hierarchy eh on e.organizationnode.GetAncestor(1) = eh.organizationnode
    )
    select 
        businessentityid,
        employeename,
        hierarchy_level,
        path
    from employee_hierarchy
    where businessentityid != @manager_id
);
go

--24.1 Create a stored procedure to get products by category, with parameters for category name, minimum price, and maximum price,
--including parameter validation and error handling.

go
create procedure dbo.usp_getproductsbycategoryandpricerange
    @category_name nvarchar(50),
    @min_price money,
    @max_price money
as
begin
    begin try
        if @min_price < 0 or @max_price < 0
        begin
            raiserror('Price values must be non-negative.', 16, 1);
            return;
        end

        if @min_price > @max_price
        begin
            raiserror('Minimum price cannot be greater than maximum price.', 16, 1);
            return;
        end

        if not exists (
            select 1
            from production.productsubcategory ps
            join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
            where pc.name = @category_name
        )
        begin
            raiserror('Invalid category name.', 16, 1);
            return;
        end

        select 
            p.productid,
            p.name as product_name,
            pc.name as category,
            ps.name as subcategory,
            p.listprice
        from production.product p
        join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
        join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
        where pc.name = @category_name
          and p.listprice between @min_price and @max_price
        order by p.listprice;

    end try
    begin catch
        declare @errmsg nvarchar(4000) = error_message();
        raiserror('An error occurred: %s', 16, 1, @errmsg);
    end catch
end;
go

--24.2 Create a stored procedure to update product pricing, including an audit trail, business rule validation, and transaction management.

create table production.productpriceaudit (
        auditid int identity primary key,
        productid int,
        oldprice money,
        newprice money,
        changedon datetime default getdate(),
        changedby sysname default suser_sname()
);
go
create procedure dbo.usp_update_product_price
    @productid int,
    @newprice money
as
begin
    set nocount on;

    declare @oldprice money;

    begin try
        if @newprice <= 0
        begin
            raiserror('Price must be greater than zero.', 16, 1);
            return;
        end
        if not exists (select 1 from production.product where productid = @productid)
        begin
            raiserror('Product ID does not exist.', 16, 1);
            return;
        end

        begin transaction;
        select @oldprice = listprice from production.product where productid = @productid;

        update production.product
        set listprice = @newprice
        where productid = @productid;

        insert into production.productpriceaudit (productid, oldprice, newprice)
        values (@productid, @oldprice, @newprice);

        commit transaction;

        print 'Price updated successfully and audit logged.';
    end try
    begin catch
        if @@trancount > 0 rollback transaction;

        declare @msg nvarchar(4000) = error_message();
        raiserror('Error occurred: %s', 16, 1, @msg);
    end catch
end;
go

--24.3 Create a stored procedure to generate a comprehensive sales report for a given date range and territory,
--including summary statistics and detailed breakdowns.

go
create procedure dbo.usp_sales_report_by_territory
    @startdate date,
    @enddate date,
    @territoryid int
as
begin
    set nocount on;

    if @startdate is null or @enddate is null or @startdate > @enddate
    begin
        raiserror('Invalid date range provided.', 16, 1);
        return;
    end

    if not exists (select 1 from sales.salesterritory where territoryid = @territoryid)
    begin
        raiserror('Invalid territory ID.', 16, 1);
        return;
    end

    print '--- Summary Statistics ---';

    select
        t.name as territory,
        count(distinct soh.salesorderid) as order_count,
        sum(soh.totaldue) as total_sales,
        avg(soh.totaldue) as avg_order_value
    from sales.salesorderheader soh
    join sales.salesterritory t on soh.territoryid = t.territoryid
    where soh.orderdate between @startdate and @enddate
      and soh.territoryid = @territoryid
    group by t.name;

    print '--- Detailed Breakdown: Sales by Customer and Product ---';

    select
        soh.salesorderid,
        soh.orderdate,
        p.firstname + ' ' + p.lastname as customer_name,
        pr.name as product_name,
        sod.orderqty,
        sod.unitprice,
        sod.linetotal
    from sales.salesorderheader soh
    join sales.customer c on soh.customerid = c.customerid
    join person.person p on c.personid = p.businessentityid
    join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
    join production.product pr on sod.productid = pr.productid
    where soh.orderdate between @startdate and @enddate
      and soh.territoryid = @territoryid
    order by soh.orderdate, soh.salesorderid;
end;
go

--24.4 Create a stored procedure to process bulk orders from XML input,
--including transaction management, validation, error handling, and returning order confirmation details.

--24.5 Create a stored procedure to perform flexible product searches with dynamic filtering by name, category, price range, and date range,
--returning paginated results and total count.

go
create procedure dbo.usp_search_products
    @name nvarchar(100) = null,
    @category nvarchar(100) = null,
    @minPrice money = null,
    @maxPrice money = null,
    @startDate date = null,
    @endDate date = null,
    @pageNumber int = 1,
    @pageSize int = 10
as
begin
    set nocount on;

    declare @offset int = (@pageNumber - 1) * @pageSize;

    with filtered_products as (
        select 
            p.productid,
            p.name,
            pc.name as category,
            p.listprice,
            p.sellstartdate,
            p.sellenddate
        from production.product p
        join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
        join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
        where 
            (@name is null or p.name like '%' + @name + '%') and
            (@category is null or pc.name = @category) and
            (@minPrice is null or p.listprice >= @minPrice) and
            (@maxPrice is null or p.listprice <= @maxPrice) and
            (@startDate is null or p.sellstartdate >= @startDate) and
            (@endDate is null or (p.sellenddate is not null and p.sellenddate <= @endDate))
    )

    select 
        productid,
        name,
        category,
        listprice,
        sellstartdate,
        sellenddate
    from filtered_products
    order by name
    offset @offset rows fetch next @pageSize rows only;

    select count(*) as total_count from filtered_products;
end;
go

--25.1 Create a trigger on Sales.SalesOrderDetail to update product inventory and maintain sales statistics after insert,
--including error handling and transaction management.

drop table if exists dbo.error_log;

create table dbo.error_log (
    id int identity primary key,
    errormessage nvarchar(max),
    procedure_name sysname,
    error_line int,
    log_date datetime
);

go
create or alter trigger trg_after_insert_salesorderdetail
on sales.salesorderdetail
after insert
as
begin
    set nocount on;

    begin try
        begin tran;

        update p
        set p.safetystocklevel = p.safetystocklevel - i.orderqty
        from production.product p
        join inserted i on p.productid = i.productid;

        insert into dbo.sales_order_stats_log (salesorderid, productid, quantity, entrydate)
        select 
            i.salesorderid,
            i.productid,
            i.orderqty,
            sysdatetime()
        from inserted i;

        commit tran;
    end try
    begin catch
        if @@trancount > 0
            rollback tran;

        declare @errmsg nvarchar(max) = error_message();
        declare @errproc sysname = error_procedure();
        declare @errline int = error_line();

        insert into dbo.error_log (errormessage, procedure_name, error_line, log_date)
        values (@errmsg, @errproc, @errline, sysdatetime());

        throw;
    end catch;
end;
go

--25.2 Create a view combining multiple tables and implement an INSTEAD OF trigger for insert operations, 
--handling complex business logic and data distribution.

create view vw_customer_orders as
select 
    soh.salesorderid,
    soh.orderdate,
    soh.customerid,
    c.firstname + ' ' + c.lastname as customer_name,
    sod.productid,
    p.name as product_name,
    sod.orderqty,
    sod.unitprice
from sales.salesorderheader soh
join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
join sales.customer sc on soh.customerid = sc.customerid
join person.person c on sc.personid = c.businessentityid
join production.product p on sod.productid = p.productid;

go
create trigger trg_instead_of_insert_vw_customer_orders
on vw_customer_orders
instead of insert
as
begin
    set nocount on;
    declare @new_orderid int;

    declare @output_orderid table (salesorderid int);

    if exists (select 1 from inserted where orderqty <= 0)
    begin
        raiserror ('order quantity must be greater than 0.', 16, 1);
        rollback;
        return;
    end;

    insert into sales.salesorderheader (
        orderdate,
        customerid,
        subtotal,
        taxamt,
        freight,
        modifieddate
    )
    output inserted.salesorderid into @output_orderid
    select
        orderdate,
        customerid,
        0,          
        0,          
        0,          
        getdate()
    from inserted;

    select top 1 @new_orderid = salesorderid from @output_orderid;

    insert into sales.salesorderdetail (
        salesorderid,
        productid,
        orderqty,
        unitprice,
        modifieddate
    )
    select
        @new_orderid,
        productid,
        orderqty,
        unitprice,
        getdate()
    from inserted;
end;



--25.3 Create an audit trigger for Production.Product price changes, logging old and new values with timestamp and user information.

create table production.product_price_audit (
    audit_id int identity(1,1) primary key,
    productid int,
    old_price money,
    new_price money,
    changed_by sysname,
    changed_at datetime default getdate()
);

go
create trigger trg_audit_product_price
on production.product
after update
as
begin
    set nocount on;

    insert into production.product_price_audit (
        productid,
        old_price,
        new_price,
        changed_by,
        changed_at
    )
    select
        d.productid,
        d.listprice,
        i.listprice,
        suser_sname(),
        getdate()
    from deleted d
    join inserted i on d.productid = i.productid
    where isnull(d.listprice, 0) <> isnull(i.listprice, 0);
end;

--26.1 Create a filtered index for active products only (SellEndDate IS NULL) and for recent orders (last 2 years),
--and measure performance impact.

set statistics io on;
set statistics time on;


create nonclustered index ix_active_products
on production.product (name)
where sellenddate is null;


create nonclustered index ix_recent_orders
on sales.salesorderheader (orderdate, customerid)
where orderdate >= '2023-07-20';  


select productid, name
from production.product
where sellenddate is null
and name like 'b%';

select salesorderid, customerid, orderdate
from sales.salesorderheader
where orderdate >= '2023-07-20';

-------------------------------------------------------------------------------




