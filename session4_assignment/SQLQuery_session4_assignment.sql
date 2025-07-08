--session4-task

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

use StoreDB;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--1. Count the total number of products in the database.
select count(*) as [Total Products]
from production.products;
--2. Find the average, minimum, and maximum price of all products.
select max(list_price) as Maximum , min(list_price) as Minimum , avg(list_price) as Average
from production.products;
--3. Count how many products are in each category.
select category_id as [Categiry ID], count(product_id) as [Products Number]
from production.products
group by category_id
order by category_id;
--4. Find the total number of orders for each store.
select store_id as [Store ID] , count(order_id) as [Orders Number]
from sales.orders
group by store_id
order by store_id;
--5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.
select top 10 UPPER(first_name) as [First Name] , LOWER(last_name) as [Last Name]
from sales.customers
order by customer_id;
--6. Get the length of each product name. Show product name and its length for the first 10 products.
select top 10 product_id as ID , product_name as Name , len(product_name) as Lenth
from production.products
order by product_id;
--7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.
select customer_id as ID , concat(first_name , ' ' , last_name ) as Name , phone , LEFT(phone,3) as [Area Code]
from sales.customers
order by customer_id
offset 0 rows fetch next 15 rows only;
--8. Show the current date and extract the year and month from order dates for orders 1-10.
select order_id as ID , GETDATE() as [Current Date],
order_date as [Order Date],
YEAR(order_date) as [Order Year] ,
MONTH(order_date) as [Order Month]
from sales.orders
where order_id between 1 and 10
order by order_id;
--9. Join products with their categories. Show product name and category name for first 10 products.
select top 10 pp.product_name as [Product Name] , pc.category_name as [Category Name]
from production.products pp join production.categories pc 
on pp.category_id = pc.category_id
order by pp.product_id;
--10. Join customers with their orders. Show customer name and order date for first 10 orders.
select top 10 concat(sc.first_name , ' ' ,sc.last_name ) as[Customer Name], so.order_date as [ Order Date]
from sales.customers sc join sales.orders so
on sc.customer_id=so.customer_id
order by so.order_id;
--11. Show all products with their brand names, even if some products don't have brands. Include product name, brand name (show 'No Brand' if null).
select pp.product_id as [Product ID], pp.product_name as [Product Name], COALESCE(pb.brand_name,'No Brand') as [Brand Name]
from production.products pp left outer join production.brands pb
on pp.brand_id=pb.brand_id
order by pp.product_id;
--12. Find products that cost more than the average product price. Show product name and price.
select product_id as ID , product_name as [Product Name],list_price as Price 
from production.products
where list_price>(select avg(list_price) from production.products)
order by product_id;
--13. Find customers who have placed at least one order. Use a subquery with IN. Show customer_id and customer_name.
select sc.customer_id as ID , concat(sc.first_name , ' ' , sc.last_name ) as Name
from sales.customers sc
where 1 <= (select count(so.order_id) from sales.orders so where so.customer_id = sc.customer_id);
--14. For each customer, show their name and total number of orders using a subquery in the SELECT clause.
select concat(sc.first_name , ' ' , sc.last_name ) as Name ,
(select count(so.order_id) from sales.orders so where so.customer_id = sc.customer_id) as [Orders number]
from sales.customers sc
order by [Orders number] desc;
--15. Create a simple view called easy_product_list that shows product name, category name, and price. Then write a query to select all products from this view where price > 100.
create view easy_product_listas as 
select pp.product_name , pc.category_name ,pp.list_price
from production.products pp join production.categories pc
on pp.category_id=pc.category_id;

select * 
from easy_product_listas 
where list_price>100
order by list_price;
--16. Create a view called customer_info that shows customer ID, full name (first + last), email, and city and state combined. Then use this view to find all customers from California (CA).
create view customer_info as 
select customer_id , concat(first_name , ' ' , last_name ) as Full_Name , email , concat(city ,'-',state) as Location 
from sales.customers;

select * 
from customer_info
where Location like '%CA'
order by customer_id;
--17. Find all products that cost between $50 and $200. Show product name and price, ordered by price from lowest to highest.
select product_name as Name,list_price as Price
from production.products
where list_price between 50 and 200
order by list_price asc;
--18. Count how many customers live in each state. Show state and customer count, ordered by count from highest to lowest.
select state , count(customer_id) as [Customers Number]
from sales.customers
group by state
order by [Customers Number] desc;
--19. Find the most expensive product in each category. Show category name, product name, and price.
select pc.category_name as [Category Name], pp.product_name as [Product Name], pp.list_price as Price
from production.products pp join production.categories pc
on pp.category_id=pc.category_id
where pp.list_price = (select max(pp2.list_price) from production.products pp2 where pp2.category_id =pp.category_id)
--20. Show all stores and their cities, including the total number of orders from each store. Show store name, city, and order count.
select ss.store_name as [Store Name], ss.city as city ,count(so.order_id) as [Orders Number]
from sales.stores ss join sales.orders so
on so.store_id=ss.store_id
group by ss.store_name ,ss.city
order by [Orders Number];

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------