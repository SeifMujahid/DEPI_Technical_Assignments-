--session5_task
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

use StoreDB;
go

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--1.Write a query that classifies all products into price categories:
--Products under $300: "Economy"
--Products $300-$999: "Standard"
--Products $1000-$2499: "Premium"
--Products $2500 and above: "Luxury"

select product_name,list_price,
	case 
		when list_price < 300 then 'Economy'
		when list_price between 300 and 999 then 'Standard'
		when list_price between 1000 and 2499 then 'Premium' 
		when list_price >= 2500 then 'Luxury'
		else 'Not Categorized'
	end as Category
from production.products;

-------------------------------------------------------------------------------

--2.Create a query that shows order processing information with user-friendly status descriptions:
--Status 1: "Order Received"
--Status 2: "In Preparation"
--Status 3: "Order Cancelled"
--Status 4: "Order Delivered"
--Also add a priority level:
--Orders with status 1 older than 5 days: "URGENT"
--Orders with status 2 older than 3 days: "HIGH"
--All other orders: "NORMAL"

select order_id,order_status,order_date,
	case order_status
		when 1 then 'Order Received'
		when 2 then 'In Preparation'
		when 3 then 'Order Cancelled'
		when 4 then 'Order Delivered'
		else 'Not Valid Status'
	end as [Order Status] ,
	case 
		when order_status = 1 and DATEDIFF(day,order_date,GETDATE())>5 then 'URGENT'
		when order_status = 2 and DATEDIFF(day,order_date,GETDATE())>3 then 'HIGH'
		else 'Normal'
	end as [Periority Level]
from sales.orders;

-------------------------------------------------------------------------------

--3.Write a query that categorizes staff based on the number of orders they've handled:
--0 orders: "New Staff"
--1-10 orders: "Junior Staff"
--11-25 orders: "Senior Staff"
--26+ orders: "Expert Staff"

 select ss.staff_id , count(so.order_id) as [Orders Count],
	case
		when count(so.order_id) = 0 then 'New Staff'
		when count(so.order_id) between 1 and 10 then 'Junior Staff'
		when count(so.order_id) between 11 and 25 then 'Senior Staff'
		when count(so.order_id) >= 26 then 'Expert Staff'
		else 'Not In Category'
	end as [Staff Category]
 from sales.staffs ss join sales.orders so
 on ss.staff_id = so.staff_id
 group by ss.staff_id;

 -------------------------------------------------------------------------------

--4.Create a query that handles missing customer contact information:
--ISNULL to replace missing phone numbers with "Phone Not Available"
--Use COALESCE to create a preferred_contact field (phone first, then email, then "No Contact Method")
--Show complete customer information

select customer_id,first_name,last_name,ISNULL(phone,'Phone Not Available') as [Phone] ,email,coalesce(phone,email,'No Contact Method')as[preferred_contact]
from sales.customers;

-------------------------------------------------------------------------------

--5.Write a query that safely calculates price per unit in stock:
--Use NULLIF to prevent division by zero when quantity is 0
--Use ISNULL to show 0 when no stock exists
--Include stock status using CASE WHEN
--Only show products from store_id = 1

select  pp.product_id,pp.product_name,
		isnull(pp.list_price/nullif( ps.quantity,0),0) as [Price Per Unit],
		case
			when ps.quantity = 0 then 'Out Of Stock'
			else 'In Stock'
		end as [Stock Status]
from production.stocks ps join production.products pp 
on ps.product_id = pp.product_id 
where ps.store_id =1;

-------------------------------------------------------------------------------

--6.Create a query that formats complete addresses safely:
--Use COALESCE for each address component
--Create a formatted_address field that combines all components
--Handle missing ZIP codes gracefully

select CONCAT(first_name,' ', last_name) as [Full Name] ,
	   concat(coalesce(street,'No Street'),' - ',coalesce(city,'No City'),' - ',coalesce(state,'No STate')) as [Formated Address],
	   ISNULL(zip_code,'No Zip Code') as [Zip Code]
from sales.customers;

-------------------------------------------------------------------------------

--7.Use a CTE to find customers who have spent more than $1,500 total:
--Create a CTE that calculates total spending per customer
--Join with customer information
--Show customer details and spending
--Order by total_spent descending

with Total_Spend as (
	select so.customer_id as [customer_id], sum(soi.list_price * soi.quantity) as [Total]
	from sales.orders so join sales.order_items soi 
	on so.order_id = soi.order_id
	group by so.customer_id 
)
select sc.customer_id as ID, CONCAT(sc.first_name,' ',sc.last_name) as Name , ts.Total as [Total Spend]
from sales.customers sc join Total_Spend Ts
on sc.customer_id=ts.customer_id
where ts.Total >1500
order by ts.Total desc;

-------------------------------------------------------------------------------

--8.Create a multi-CTE query for category analysis:
--CTE 1: Calculate total revenue per category
--CTE 2: Calculate average order value per category
--Main query: Combine both CTEs
--Use CASE to rate performance: >$50000 = "Excellent", >$20000 = "Good", else = "Needs Improvement"

with Revenue as (
	select sum(soi.quantity * soi.list_price) as revenue , pp.category_id
	from sales.order_items soi join production.products pp
	on soi.product_id=pp.product_id
	group by pp.category_id
),
total_order as (
	select sum(soi.list_price * soi.quantity) as total ,so.order_id , pp.category_id
	from sales.order_items soi join sales.orders so
	on soi.order_id= so.order_id join production.products pp
	on pp.product_id = soi.product_id
	group by so.order_id , pp.category_id
),
avg_value_category as (
	select avg(total) as total , category_id
	from total_order
	group by category_id
)
select r.category_id  as [Category ID],r.revenue as [Revenue] ,av.total as [Average Per Category],
	case
		when r.revenue > 50000 then 'Excellent'
		when r.revenue > 20000 then 'Good'
		else 'Needs Improvement'
	end as [performance]
from Revenue r join avg_value_category av 
on r.category_id =av.category_id
order by r.category_id;

-------------------------------------------------------------------------------

--9.Use CTEs to analyze monthly sales trends:
--CTE 1: Calculate monthly sales totals
--CTE 2: Add previous month comparison
--Show growth percentage

with monthlysales as (
    select 
        cast(datefromparts(year(so.order_date), month(so.order_date), 1) as date) as month_start,
        sum(soi.quantity * soi.list_price) as total_sales
    from sales.orders so join sales.order_items soi
	on so.order_id = soi.order_id
    group by year(so.order_date), month(so.order_date)
)
, saleswithprevious as (
    select curr.month_start,curr.total_sales,prev.total_sales as previous_sales
    from monthlysales curr left join monthlysales prev
    on curr.month_start = dateadd(month, 1, prev.month_start)
)
select 
     concat(year(month_start), ' - ', MONTH(month_start)) as [Month],total_sales as [current month sales],previous_sales as [previous month sales],
	isnull(((total_sales - previous_sales) * 100.0) / previous_sales,0 )as growth_percentage
from saleswithprevious
order by month_start;

-------------------------------------------------------------------------------

--10.Create a query that ranks products within each category:
--Use ROW_NUMBER() to rank by price (highest first)
--Use RANK() to handle ties
--Use DENSE_RANK() for continuous ranking
--Only show top 3 products per category

with ranked_products as (
    select category_id,product_id,product_name,list_price,
        row_number() over (partition by category_id order by list_price desc) as row_num,
        rank() over (partition by category_id order by list_price desc) as price_rank,
        dense_rank() over (partition by category_id order by list_price desc) as dense_price_rank
    from production.products
)
select *
from ranked_products
where row_num <= 3;

-------------------------------------------------------------------------------

--11.Rank customers by their total spending:
--Calculate total spending per customer
--Use RANK() for customer ranking
--Use NTILE(5) to divide into 5 spending groups
--Use CASE for tiers: 1="VIP", 2="Gold", 3="Silver", 4="Bronze", 5="Standard"

with customer_spending as (
    select so.customer_id,sum(soi.quantity * soi.list_price) as total_spent
    from sales.orders so
    join sales.order_items soi on so.order_id = soi.order_id
    group by so.customer_id
)
select  cs.customer_id, c.first_name + ' ' + c.last_name as full_name, cs.total_spent,
    rank() over (order by cs.total_spent desc) as spending_rank,
    ntile(5) over (order by cs.total_spent desc) as spending_group,
    case ntile(5) over (order by cs.total_spent desc)
        when 1 then 'VIP'
        when 2 then 'Gold'
        when 3 then 'Silver'
        when 4 then 'Bronze'
        when 5 then 'Standard'
    end as tier
from customer_spending cs
join sales.customers c on cs.customer_id = c.customer_id
order by cs.total_spent desc;

-------------------------------------------------------------------------------

--12.Create a comprehensive store performance ranking:
--Rank stores by total revenue
--Rank stores by number of orders
--Use PERCENT_RANK() to show percentile performance

with store_metrics as (
    select s.store_id,s.store_name,sum(soi.quantity * soi.list_price) as total_revenue,count(distinct so.order_id) as total_orders
    from sales.stores s join sales.staffs sf 
	on s.store_id = sf.store_id join sales.orders so
	on sf.staff_id = so.staff_id join sales.order_items soi
	on so.order_id = soi.order_id
    group by s.store_id, s.store_name
)
select store_id,store_name,total_revenue,total_orders,
    rank() over (order by total_revenue desc) as revenue_rank,
    rank() over (order by total_orders desc) as orders_rank,
    percent_rank() over (order by total_revenue desc) as revenue_percentile
from store_metrics
order by revenue_rank;

-------------------------------------------------------------------------------

--13.Create a PIVOT table showing product counts by category and brand:
--Rows: Categories
--Columns: Top 4 brands (Electra, Haro, Trek, Surly)
--Values: Count of products

select *
from (
    select pp.category_id as category_id, pb.brand_name as brand_name
    from production.products pp join production.brands pb
	on pp.brand_id=pb.brand_id
    where pb.brand_name in ('Electra', 'Haro', 'Trek', 'Surly')
) as sourse
pivot (
    count(brand_name)
    for brand_name in ([Electra], [Haro], [Trek], [Surly])
) as pivot_table;

-------------------------------------------------------------------------------

--14.Create a PIVOT showing monthly sales revenue by store:
--Rows: Store names
--Columns: Months (Jan through Dec)
--Values: Total revenue
--Add a total column

select *
from (
    select s.store_name, month(o.order_date) as order_month, oi.list_price * oi.quantity as revenue
    from sales.orders o join sales.order_items oi 
	on o.order_id = oi.order_id join sales.stores s
	on o.store_id = s.store_id
) as sales_data
pivot (
    sum(revenue)
    for order_month in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) as monthly_sales;

-------------------------------------------------------------------------------

--15.PIVOT order statuses across stores:
--Rows: Store names
--Columns: Order statuses (Pending, Processing, Completed, Rejected)
--Values: Count of orders

select *
from (
    select s.store_name,o.order_status
    from sales.orders o join sales.stores s 
	on o.store_id = s.store_id
) as source_data
pivot (
    count(order_status)
    for order_status in ([1], [2], [3], [4])
) as status_pivot;

-------------------------------------------------------------------------------

--16.Create a PIVOT comparing sales across years:
--Rows: Brand names
--Columns: Years (2022, 2023, 2024)
--Values: Total revenue
--Include percentage growth calculations

with brand_sales as (
    select  pr.brand_id, b.brand_name, year(o.order_date) as sales_year, sum(oi.quantity * oi.list_price) as revenue
    from sales.orders o join sales.order_items oi 
	on o.order_id = oi.order_id join production.products pr
	on oi.product_id = pr.product_id join production.brands b
	on pr.brand_id = b.brand_id
    where year(o.order_date) in (2022, 2023, 2024)
    group by pr.brand_id, b.brand_name, year(o.order_date)
),
pivoted as (
    select 
    brand_name,
        isnull([2022], 0) as y2022,
        isnull([2023], 0) as y2023,
        isnull([2024], 0) as y2024
    from brand_sales
    pivot (
        sum(revenue)
        for sales_year in ([2022], [2023], [2024])
    ) as p
)
select *,
    case when y2022 = 0 then null else round((y2023 - y2022) * 100.0 / y2022, 2) end as growth_2022_2023,
    case when y2023 = 0 then null else round((y2024 - y2023) * 100.0 / y2023, 2) end as growth_2023_2024
from pivoted
order by brand_name;

-------------------------------------------------------------------------------

--17.Use UNION to combine different product availability statuses:
--Query 1: In-stock products (quantity > 0)
--Query 2: Out-of-stock products (quantity = 0 or NULL)
--Query 3: Discontinued products (not in stocks table)

select p.product_id,p.product_name,'in-stock' as status
from production.products p join production.stocks s 
on p.product_id = s.product_id
where s.quantity > 0
union
select p.product_id,p.product_name,'out-of-stock' as status
from production.products p join production.stocks s
on p.product_id = s.product_id
where s.quantity is null or s.quantity=0
union
select  p.product_id, p.product_name, 'discontinued' as status
from production.products p
where not exists (
    select 1 
    from production.stocks s 
    where s.product_id = p.product_id
);

-------------------------------------------------------------------------------

--18.Use INTERSECT to find loyal customers:
--Find customers who bought in both 2022 AND 2023
--Show their purchase patterns

select customer_id
from sales.orders
where year(order_date) = 2022
intersect
select customer_id
from sales.orders
where year(order_date) = 2023;


-------------------------------------------------------------------------------

--19.Use multiple set operators to analyze product distribution:
--INTERSECT: Products available in all 3 stores
--EXCEPT: Products available in store 1 but not in store 2
--UNION: Combine above results with different labels

select product_id, 'available in all stores' as status
from production.stocks
where store_id = 1
intersect
select product_id, 'available in all stores'
from production.stocks
where store_id = 2
intersect
select product_id, 'available in all stores'
from production.stocks
where store_id = 3
union
select product_id, 'only in store 1'
from production.stocks
where store_id = 1
except
select product_id, 'only in store 1'
from production.stocks
where store_id = 2;

-------------------------------------------------------------------------------

--20.Complex set operations for customer retention:
--Find customers who bought in 2022 but not in 2023 (lost customers)
--Find customers who bought in 2023 but not in 2022 (new customers)
--Find customers who bought in both years (retained customers)
--Use UNION ALL to combine all three groups

select customer_id, 'lost customer' as status
from sales.orders
where year(order_date) = 2022
except
select customer_id, 'lost customer'
from sales.orders
where year(order_date) = 2023
union all
select customer_id, 'new customer'
from sales.orders
where year(order_date) = 2013
except
select customer_id, 'new customer'
from sales.orders
where year(order_date) = 2022
union all
select customer_id, 'retained customer'
from sales.orders
where year(order_date) = 2022
intersect
select customer_id, 'retained customer'
from sales.orders
where year(order_date) = 2023;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------