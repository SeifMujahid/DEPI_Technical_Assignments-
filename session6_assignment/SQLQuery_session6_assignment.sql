--session6_task
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

use StoreDB;
go

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--1. Customer Spending Analysis#
--Write a query that uses variables to find the total amount spent by customer ID 1.
--Display a message showing whether they are a VIP customer (spent > $5000) or regular customer.

declare @customer_id int =1;
declare @total_spend int;

select @total_spend=sum(soi.list_price * soi.quantity)
from sales.order_items soi join sales.orders so 
on soi.order_id = so.order_id
where so.customer_id = @customer_id;

select @total_spend as 'Total Spend for customer 1';

--2. Product Price Threshold Report#
--Create a query using variables to count how many products cost more than $1500. 
--Store the threshold price in a variable and display both the threshold and count in a formatted message.

declare @price int = 1500;
declare @no_products int;

select @no_products =count(product_id)
from production.products
where list_price > @price;

print 'Number of products with price greater than $' + cast(@price as varchar) + 
      ' is ' + cast(@no_products as varchar) + ' Product.';

--3. Staff Performance Calculator#
--Write a query that calculates the total sales for staff member ID 2 in the year 2023.
--Use variables to store the staff ID, year, and calculated total. Display the results with appropriate labels.

declare @staff_id int =2;
declare @year int = 2023;
declare @total int ;

select @total=sum(soi.list_price * soi.quantity)
from sales.order_items soi join sales.orders so
on soi.order_id = so.order_id
where so.staff_id = @staff_id and YEAR(so.order_date) = @year;

select 'Total Sales For Staff ID ' + cast(@staff_id as varchar(255)) +
	   ' IS $'+ cast(@total as varchar(255)) + ' IN ' + cast(@year as varchar(255)) as [Staff Performance];

--4. Global Variables Information#
--Create a query that displays the current server name, SQL Server version, and the number of rows affected by the last statement.
--Use appropriate global variables.

print 'Server Name: ' + @@servername;
print 'SQL Server Version: ' + @@version;
print 'Rows Affected by Last Statement: ' + cast(@@rowcount as varchar);

--5.Write a query that checks the inventory level for product ID 1 in store ID 1.
--Use IF statements to display different messages based on stock levels:#
--If quantity > 20: Well stocked
--If quantity 10-20: Moderate stock
--If quantity < 10: Low stock - reorder needed

declare @product_id int =1;
declare @store_id int =1;
declare @quantity int;

select @quantity= quantity
from production.stocks
where product_id = @product_id and store_id = @store_id;

if @quantity>20
	begin
		print 'Well stocked';
	end
else if @quantity>=10 and @quantity <=20
	begin
		print 'Moderate stock';
	end
else
	begin
		print 'Low stock - reorder needed';
	end

--6.Create a WHILE loop that updates low-stock items (quantity < 5) in batches of 3 products at a time.
--Add 10 units to each product and display progress messages after each batch.

declare @batch_size int = 3;
declare @updated_count int = 0;
declare @total_to_update int;

select @total_to_update = count(*)
from production.stocks
where quantity < 5;

while @updated_count < @total_to_update
begin
    with cte as (
        select top(@batch_size) *
        from production.stocks
        where quantity < 5
        order by product_id
    )
    update cte set quantity = quantity + 10;
    set @updated_count += @batch_size;
    print concat('Batch updated. Total updated so far: ', @updated_count);
end

--7. Product Price Categorization#
--Write a query that categorizes all products using CASE WHEN based on their list price:
--Under $300: Budget
--$300-$800: Mid-Range
--$801-$2000: Premium
--Over $2000: Luxury

select *,
	case
		when list_price < 300 then 'Budget'
		when list_price between 300 and 800 then 'Mid-Range'
		when list_price between 801 and 2000 then 'Premium'
		when list_price > 2000 then 'Luxury'
	end as [Product Price Categorization]
from production.products;


--8. Customer Order Validation#
--Create a query that checks if customer ID 5 exists in the database. 
--If they exist, show their order count.If not, display an appropriate message.

declare @c_id int = 5;
declare @order_count int;

if exists (select 1 from sales.customers where customer_id = @c_id)
	begin
		select @order_count = count(*) 
		from sales.orders 
		where customer_id = @c_id;

		print 'customer id ' + cast(@c_id as varchar) + 
			  ' has orderd ' + cast(@order_count as varchar) + ' orders.';
	end
else
	begin
		print 'customer id ' + cast(@c_id as varchar) + ' does not exist.';
	end

--9. Shipping Cost Calculator Function#
--Create a scalar function named CalculateShipping that takes an order total as input and returns shipping cost:
--Orders over $100: Free shipping ($0)
--Orders $50-$99: Reduced shipping ($5.99)
--Orders under $50: Standard shipping ($12.99)

go
create function calculateshipping (@order_price decimal(10,2))
returns decimal(10,2)
as
begin
    if @order_price > 100
        return 0.00;
    else if @order_price >= 50 and @order_price <= 99
        return 5.99;
    else
        return 12.99;
	return 0.00;
end;
go

select[dbo].[calculateshipping](60.00) as [Shipping Cost];

--10. Product Category Function#
--Create an inline table-valued function named GetProductsByPriceRange that accepts minimum and maximum price parameters
--and returns all products within that price range with their brand and category information.
go
create function getproductsbypricerange (@min_price decimal(10,2),@max_price decimal(10,2))
returns table
as
return (
	select p.product_id,p.product_name,p.list_price,b.brand_name,c.category_name
	from production.products p join production.brands b
	on p.brand_id = b.brand_id join production.categories c
	on p.category_id = c.category_id
	where p.list_price between @min_price and @max_price
);
go

select * from getproductsbypricerange(500, 1500);

--11. Customer Sales Summary Function#
--Create a multi-statement function named GetCustomerYearlySummary that takes a customer ID and
--returns a table with yearly sales data including total orders, total spent, and average order value for each year.

go
create function getcustomeryearlysummary (@customer_id int)
returns @summary table (
    year int,
    total_orders int,
    total_spent decimal(18,2),
    avg_order_value decimal(18,2)
)
as
begin
    insert into @summary
    select 
        year(so.order_date) as year,
        count(distinct so.order_id) as total_orders,
        sum(soi.list_price * soi.quantity) as total_spent,
        avg(cast(soi.list_price * soi.quantity as decimal(18,2))) as avg_order_value
    from sales.orders so join sales.order_items soi 
	on so.order_id = soi.order_id
    where so.customer_id = @customer_id
    group by year(so.order_date)
    return
end
go

select * from getcustomeryearlysummary(343);

--12. Discount Calculation Function#
--Write a scalar function named CalculateBulkDiscount that determines discount percentage based on quantity:
--1-2 items: 0% discount
--3-5 items: 5% discount
--6-9 items: 10% discount
--10+ items: 15% discount

go
create function calculatebulkdiscount (@quantity int)
returns int
as
begin
    declare @discount int
    set @discount = case
        when @quantity between 1 and 2 then 0
        when @quantity between 3 and 5 then 5
        when @quantity between 6 and 9 then 10
        when @quantity >= 10 then 15
        else 0
    end
    return @discount
end;
go

select dbo.calculatebulkdiscount(7) as discount_percent;

--13. Customer Order History Procedure#
--Create a stored procedure named sp_GetCustomerOrderHistory that accepts a customer ID and optional start/end dates.
--Return the customer's order history with order totals calculated.

go
create procedure sp_getcustomerorderhistory 
    @customer_id int, 
    @start date = '2022-10-01', 
    @end date = '2024-12-30'
as
begin
    set nocount on;
    select so.customer_id, so.order_id, sum(soi.list_price * soi.quantity) as order_total
    from sales.orders so join sales.order_items soi 
	on so.order_id = soi.order_id
    where so.customer_id = @customer_id and so.order_date between @start and @end
    group by so.customer_id, so.order_id;
end;
go

exec sp_GetCustomerOrderHistory @customer_id=343;

--14. Inventory Restock Procedure#
--Write a stored procedure named sp_RestockProduct with input parameters for store ID, product ID, and restock quantity.
--Include output parameters for old quantity, new quantity, and success status.

go
create procedure sp_restockproduct 
    @store_id int, 
    @product_id int, 
    @restock_qty int,
    @old_qty int output,
    @new_qty int output,
    @success bit output
as
begin
    set nocount on;
    if exists (
        select 1 
        from production.stocks 
        where store_id = @store_id and product_id = @product_id
    )
		begin
			select @old_qty = quantity 
			from production.stocks 
			where store_id = @store_id and product_id = @product_id;

			update production.stocks 
			set quantity = quantity + @restock_qty 
			where store_id = @store_id and product_id = @product_id;

			select @new_qty = quantity 
			from production.stocks 
			where store_id = @store_id and product_id = @product_id;

			set @success = 1;
		end
    else
		begin
			set @old_qty = null;
			set @new_qty = null;
			set @success = 0;
		end
end;
go

declare @old_qty int, @new_qty int, @success bit;

exec sp_restockproduct 
    @store_id = 1, 
    @product_id = 1, 
    @restock_qty = 10, 
    @old_qty = @old_qty output, 
    @new_qty = @new_qty output, 
    @success = @success output;

print 'Old Quantity: ' + cast(@old_qty as varchar);
print 'New Quantity: ' + cast(@new_qty as varchar);
print 'Success: ' + cast(@success as varchar);

--15. Order Processing Procedure#
--Create a stored procedure named sp_ProcessNewOrder that handles complete order creation with proper transaction control and error handling. 
--Include parameters for customer ID, product ID, quantity, and store ID.

go
create procedure sp_processneworder 
    @customer_id int,
    @product_id int,
    @quantity int,
    @store_id int
as
begin
    set nocount on;
    declare @order_id int,
            @list_price decimal(10,2),
            @stock_qty int;

    select @stock_qty = quantity
    from production.stocks
    where store_id = @store_id and product_id = @product_id;

    if @stock_qty is null or @stock_qty < @quantity
    begin
        print 'product not found.';
        return;
    end

    begin transaction;
    insert into sales.orders (customer_id, order_status, order_date, store_id, staff_id)
    values (@customer_id, 1,getdate(), @store_id, 1);

    set @order_id = scope_identity();

    select @list_price = list_price
    from production.products
    where product_id = @product_id;

	insert into sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
    values (@order_id, 1, @product_id, @quantity, @list_price, 0);

    update production.stocks
    set quantity = quantity - @quantity
    where store_id = @store_id and product_id = @product_id;
    commit transaction;
    print 'Order processed successfully. Order ID: ' + cast(@order_id as varchar);
end;
go

exec sp_processneworder 
    @customer_id = 101, 
    @product_id = 12, 
    @quantity = 2, 
    @store_id = 1;

--16. Dynamic Product Search Procedure#
--Write a stored procedure named sp_SearchProducts that builds dynamic SQL based on optional parameters:
--product name search term, category ID, minimum price, maximum price, and sort column.

go
create procedure sp_SearchProducts
    @product_name nvarchar(255) = null,
    @category_id int = null,
    @min_price decimal(10,2) = null,
    @max_price decimal(10,2) = null,
    @sort_column nvarchar(255) = null
as
begin
    set nocount on;
    declare @sql nvarchar(max) = '
        select product_id, product_name, category_id, list_price
        from production.products 
		where ';

    if @product_name is not null
        set @sql += ' product_name like ''%' + @product_name + '%''';
    else if @category_id is not null
        set @sql += ' category_id = ' + cast(@category_id as nvarchar);
    else if @min_price is not null
        set @sql += ' list_price >= ' + cast(@min_price as nvarchar);
    else if @max_price is not null
        set @sql += ' list_price <= ' + cast(@max_price as nvarchar);

    if @sort_column is not null and @sort_column in ('product_name', 'category_id', 'list_price', 'product_id')
        set @sql += ' order by ' +  quotename (@sort_column) ;
    else
        set @sql += ' order by product_id';
    exec sp_executesql @sql;
end;
go

exec sp_SearchProducts @product_name = 'Purple Label Custom Fit French Cuff Shirt - White', @sort_column = 'list_price';

exec sp_SearchProducts @category_id = 3, @min_price = 500, @max_price = 2000;

--17. Staff Bonus Calculation System#
--Create a complete solution that calculates quarterly bonuses for all staff members.
--Use variables to store date ranges and bonus rates. Apply different bonus percentages based on sales performance tiers.


declare @start_date date = '2024-01-01';
declare @end_date date = '2024-03-31';

declare @tier1_rate decimal(5,2) = 0.40;
declare @tier2_rate decimal(5,2) = 0.30;
declare @tier3_rate decimal(5,2) = 0.20;
declare @tier4_rate decimal(5,2) = 0.10;

select 
    s.staff_id, s.first_name + ' ' + s.last_name as staff_name,sum(oi.list_price * oi.quantity) as total_sales,
    case
        when sum(oi.list_price * oi.quantity) >= 50000 then @tier1_rate
        when sum(oi.list_price * oi.quantity) between 30000 and 49999.99 then @tier2_rate
        when sum(oi.list_price * oi.quantity) between 10000 and 29999.99 then @tier3_rate
        else @tier4_rate
    end as bonus_rate,
    case
        when sum(oi.list_price * oi.quantity) >= 50000 then sum(oi.list_price * oi.quantity) * @tier1_rate
        when sum(oi.list_price * oi.quantity) between 30000 and 49999.99 then sum(oi.list_price * oi.quantity) * @tier2_rate
        when sum(oi.list_price * oi.quantity) between 10000 and 29999.99 then sum(oi.list_price * oi.quantity) * @tier3_rate
        else sum(oi.list_price * oi.quantity) * @tier4_rate
    end as bonus_amount
from sales.orders o join sales.order_items oi
on o.order_id = oi.order_id join sales.staffs s 
on o.staff_id = s.staff_id
where o.order_date between @start_date and @end_date
group by s.staff_id, s.first_name, s.last_name
order by bonus_amount desc;


--18. Smart Inventory Management#
--Write a complex query with nested IF statements that manages inventory restocking.
--Check current stock levels and apply different reorder quantities based on product categories and current stock levels.

select  p.product_id, p.product_name, c.category_name, s.store_id, st.quantity as current_stock,
    case 
        when c.category_name = 'Belts' and st.quantity < 10 then 30
        when c.category_name = 'Jewelry' and st.quantity < 15 then 25
        when c.category_name = 'Watches' and st.quantity < 50 then 100
        when st.quantity < 20 then 40
        else 0
    end as reorder_quantity,
    case 
        when (
				(c.category_name = 'Belts' and st.quantity < 10) or
				(c.category_name = 'Jewelry' and st.quantity < 15) or
				(c.category_name = 'Watches' and st.quantity < 50) or
				(st.quantity < 20)
             ) then 'Restock Needed'
        else 'Sufficient Stock'
    end as restock_status
from production.products p join production.stocks st 
on p.product_id = st.product_id join production.categories c 
on p.category_id = c.category_id join sales.stores s
on st.store_id = s.store_id
order by restock_status desc, reorder_quantity desc;

--19. Customer Loyalty Tier Assignment#
--Create a comprehensive solution that assigns loyalty tiers to customers based on their total spending.
--Handle customers with no orders appropriately and use proper NULL checking.

select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, isnull(sum(oi.list_price * oi.quantity), 0) as total_spent,
    case 
        when sum(oi.list_price * oi.quantity) >= 10000 then 'Platinum'
        when sum(oi.list_price * oi.quantity) >= 5000 then 'Gold'
        when sum(oi.list_price * oi.quantity) >= 1000 then 'Silver'
        when sum(oi.list_price * oi.quantity) >= 1 then 'Bronze'
        else 'New'
    end as loyalty_tier
from sales.customers c left join sales.orders o
on c.customer_id = o.customer_id left join sales.order_items oi
on o.order_id = oi.order_id
group by c.customer_id, c.first_name, c.last_name
order by total_spent desc;

--20. Product Lifecycle Management#
--Write a stored procedure that handles product discontinuation including checking for pending orders, 
--optional product replacement in existing orders, clearing inventory, and providing detailed status messages.

go
create procedure sp_DiscontinueProduct
    @product_id int,
    @replacement_product_id int = null,
    @message nvarchar(400) output
as
begin
    set nocount on;
    if exists (
        select 1
        from sales.orders o
        join sales.order_items oi on o.order_id = oi.order_id
        where oi.product_id = @product_id and o.order_status = 'Pending'
    )
    begin
        if @replacement_product_id is not null
        begin
            update oi
            set product_id = @replacement_product_id
            from sales.orders o
            join sales.order_items oi on o.order_id = oi.order_id
            where oi.product_id = @product_id and o.order_status = 1;
			set @message = 'Product replaced in pending orders and discontinued.';
        end
        else
        begin
            set @message = 'Cannot discontinue product: pending orders exist. Provide a replacement product.';
            return;
        end
    end
    else
    begin
        set @message = 'No pending orders found for product.';
    end
    update production.stocks
    set quantity = 0
    where product_id = @product_id;
    update sales.order_items
    set discount= 1
    where product_id = @product_id;
    set @message = @message + ' Inventory cleared and product marked as discontinued.';
end;
go

declare @msg nvarchar(400);
exec sp_DiscontinueProduct 
    @product_id = 101, 
    @replacement_product_id = 105, 
    @message = @msg output;
print @msg;

-------------------------------------------------------------------------------
--Bonus Challenges#
-------------------------------------------------------------------------------

--21. Advanced Analytics Query#
--Create a query that combines multiple advanced concepts to generate a comprehensive sales report 
--showing monthly trends, staff performance, and product category analysis.

with MonthlySales as (
    select 
        format(so.order_date, 'yyyy-MM') as month,
        sum(soi.list_price * soi.quantity) as total_sales
    from sales.orders so
    join sales.order_items soi on so.order_id = soi.order_id
    group by format(so.order_date, 'yyyy-MM')
),
StaffSales as (
    select 
        s.staff_id,
        s.first_name + ' ' + s.last_name as staff_name,
        format(so.order_date, 'yyyy-MM') as month,
        sum(soi.list_price * soi.quantity) as staff_monthly_sales,
        row_number() over (partition by format(so.order_date, 'yyyy-MM') order by sum(soi.list_price * soi.quantity) desc) as sales_rank
    from sales.orders so
    join sales.order_items soi on so.order_id = soi.order_id
    join sales.staffs s on so.staff_id = s.staff_id
    group by s.staff_id, s.first_name, s.last_name, format(so.order_date, 'yyyy-MM')
),
CategorySales as (
    select 
        c.category_name,
        format(so.order_date, 'yyyy-MM') as month,
        sum(soi.list_price * soi.quantity) as category_sales
    from sales.orders so
    join sales.order_items soi on so.order_id = soi.order_id
    join production.products p on soi.product_id = p.product_id
    join production.categories c on p.category_id = c.category_id
    group by c.category_name, format(so.order_date, 'yyyy-MM')
)
select 
    ms.month,
    ms.total_sales as [total_sales_all],
    ss.staff_name,
    ss.staff_monthly_sales,
    ss.sales_rank,
    cs.category_name,
    cs.category_sales
from MonthlySales ms
left join StaffSales ss on ss.month = ms.month and ss.sales_rank = 1
left join CategorySales cs on cs.month = ms.month
order by ms.month, cs.category_name;

--22. Data Validation System#
--Build a complete data validation system using functions and procedures that ensures data integrity
--when inserting new orders, including customer validation, inventory checking, and business rule enforcement.

go
create function fn_ValidateCustomer (@customer_id int)
returns bit
as
begin
    if exists (select 1 from sales.customers where customer_id = @customer_id)
        return 1;
    return 0;
end;
go
go
create function fn_CheckInventory (
    @product_id int,
    @store_id int,
    @required_qty int
)
returns bit
as
begin
    declare @available int;
    select @available = quantity
    from production.stocks
    where product_id = @product_id and store_id = @store_id;

    if @available is null or @available < @required_qty
        return 0;
    return 1;
end;
go
go
create procedure sp_InsertValidatedOrder
    @customer_id int,
    @staff_id int,
    @store_id int,
    @product_id int,
    @quantity int
as
begin
    set nocount on;
    
    if dbo.fn_ValidateCustomer(@customer_id) = 0
    begin
        print 'Error: Invalid customer ID.';
        return;
    end;

    if @quantity <= 0
    begin
        print 'Error: Quantity must be positive.';
        return;
    end;

    if dbo.fn_CheckInventory(@product_id, @store_id, @quantity) = 0
    begin
        print 'Error: Insufficient inventory for product.';
        return;
    end;

    declare @price decimal(10,2);
    select @price = list_price
    from production.products
    where product_id = @product_id;

    if @price is null
    begin
        print 'Error: Invalid product ID.';
        return;
    end;

    declare @order_id int;

    insert into sales.orders (customer_id, order_status, order_date, required_date, store_id, staff_id)
    values (@customer_id, 1, getdate(), dateadd(day, 5, getdate()), @store_id, @staff_id);

    set @order_id = scope_identity();

    insert into sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
    values (@order_id, 1, @product_id, @quantity, @price, 0);

    update production.stocks
    set quantity = quantity - @quantity
    where product_id = @product_id and store_id = @store_id;

    print 'Order inserted successfully.';
end;
go
exec sp_InsertValidatedOrder
    @customer_id = 1,
    @staff_id = 2,
    @store_id = 1,
    @product_id = 5,
    @quantity = 2;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------