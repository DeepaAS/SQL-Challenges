-- Problem #20: Categories, and the total products in each category. For this problem, we’d like to see the total number of products in each category. Sort the results by the total number of products, in descending order.
select * from Categories;
select * from Products;

select CategoryName, Count(ProductID) As TotalProducts from Products join Categories on Products.CategoryID = Categories.CategoryID group by CategoryName order by TotalProducts DESC;

select CategoryID, Count(ProductID) from Products group by CategoryID order by Count DESC;

-- Problem #21: Total customers per country/city. In the Customers table, show the total number of customers per Country and City.
select * from customers;
select Country, City, COUNT(Country) as TotalCustomer from Customers group by City, Country Order by TotalCustomer desc;

-- Problem #22: Products that need reordering. What products do we have in our inventory that should be reordered? For now, just use the fields UnitsInStock and ReorderLevel, where UnitsInStock is less than the ReorderLevel, ignoring the fields UnitsOnOrder and Discontinued. Order the results by ProductID.
Select * from Products;

select ProductID, ProductName, UnitsInStock, ReorderLevel from Products where UnitsInStock < ReorderLevel order by ProductID;

-- Problem #23: Products that need reordering, continued. Now we need to incorporate these fields—UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued— into our calculation. We’ll define “products that need reordering” with the following:  UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel The Discontinued flag is false (0).

select ProductID, ProductName, UnitsInStock, ReorderLevel from Products where ((UnitsInStock + UnitsOnOrder) <= ReorderLevel) and Discontinued = 0 order by ProductID;

-- Problem #24: 24. Customer list by region. A salesperson for Northwind is going on a business trip to visit customers, and would like to see a list of all customers, sorted by region, alphabetically. However, he wants the customers with no region (null in the Region field) to be at the end, instead of at the top, where you’d normally find the null values. Within the same region, companies should be sorted by CustomerID.
Select * from Customers;

select CustomerID, CompanyName, Region, 
CAse 
	when Region is Null then 1
	Else 0
end
from Customers
Order by Region, CustomerID;

-- Problem #25: High freight charges. Some of the countries we ship to have very high freight charges. We'd like to investigate some more shipping options for our customers, to be able to offer them lower freight charges. Return the three ship countries with the highest average freight overall, in descending order by average freight.
Select * from Orders;
select ShipCountry, AVG(Freight) as AverageFreight from Orders group by ShipCountry order by AverageFreight DESC Limit 3;
select ShipCountry, AVG(Freight) as AverageFreight from Orders group by ShipCountry order by AverageFreight DESC Fetch first 3 rows only;

select Top 3 ShipCountry, AVG(Freight) AS AverageFreight from orders group by ShipCountry order by AverageFreight


-- Problem #26: High freight charges - 2015. We're continuing on the question above on high freight charges. Now, instead of using all the orders we have, we only want to see orders from the year 2015.
select ShipCountry, AVG(Freight) as AverageFreight from Orders where Date_Part('Year', OrderDate) = 2015 group by ShipCountry order by AverageFreight DESC Limit 3;

-- Problem #27:
--Incorrect results
select ShipCountry, AVG(Freight) as AverageFreight from Orders where OrderDate between '1/1/2015' and '12/31/2015' group by ShipCountry order by AverageFreight DESC Limit 3;

select * from orders order by OrderDate desc;

-- Problem #28: High freight charges - last year. We're continuing to work on high freight charges. We now want to get the three ship countries with the highest average freight charges. But instead of filtering for a particular year, we want to use the last 12 months of order data, using as the end date the last OrderDate in Orders.
select ShipCountry, AVG(Freight) as AverageFreight from Orders where OrderDate between '2015-05-06' and '2016-05-06' group by ShipCountry order by AverageFreight DESC Limit 3;

select * from Orders where OrderDate between ((select Max(OrderDate) from Orders) - interval '365 days') and (select Max(OrderDate) from Orders) limit 3;

select Max(OrderDate) - interval '12 months' from Orders;

select ShipCountry, AVG(Freight) as AverageFreight 
from Orders 
where OrderDate between ((select Max(OrderDate) from Orders) - interval '365 days') and (select Max(OrderDate) from Orders) 
group by ShipCountry 
order by AverageFreight DESC Limit 3;

-- Problem #29: Inventory list. We're doing inventory, and need to show information like the below, for all orders. Sort by OrderID and Product ID.
select * from Employees --EmployeeID, LastName
Select * from Orders; -- OrderID
select * from Products; -- ProductName
Select * from OrderDetails; -- Quantity

select e.EmployeeID,
       e.LastName,
       o.OrderID,
       p.ProductName,
       od.Quantity 
from Employees e
     inner join Orders o
	on e.EmployeeID = o.EmployeeID
     inner join OrderDetails od
	on o.OrderID = od.OrderID
     inner join Products p
	ON od.ProductID = p.ProductID


-- Problem #30: Customers with no orders.There are some customers who have never actually placed an order. Show these customers.
select * from Customers;

select c.CustomerID, o.OrderID 
from Customers c 
     left join Orders o 
	on c.CustomerID = o.CustomerID 
where o.CustomerID is null 
order by c.CustomerID;

-- Problem #31: Customers with no orders for EmployeeID 4. One employee (Margaret Peacock, EmployeeID 4) has placed the most orders. However, there are some customers who've never placed an order with her. Show only those customers who have never placed an order with her.
Select distinct CustomerID From Customers Where CustomerID NOT in (select CustomerID from Orders where EmployeeID=4);

select * from Customers;

select * from Orders;

	
with OrdersEmp4 as (
     Select distinct CustomerID
     From Customers 
     Where CustomerID NOT in (select CustomerID from Orders where EmployeeID=4)
     )
select	distinct(oe.CustomerID), o.CustomerID
from OrdersEmp4 oe
     left join Orders o 
	on oe.CustomerID = o.CustomerID
-- where o.CustomerID is null and o.EmployeeID = 4;







