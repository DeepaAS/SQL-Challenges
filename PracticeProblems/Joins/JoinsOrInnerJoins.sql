-- Update
Update Orders
set CustomerID = null 
where OrderId = 10248;

-- Inner Joins
-- select all orders with customer information

select * from Orders 
where OrderID = 10248;

Select * from Customers;

select OrderID, ContactName 
from Orders 
Inner JOIN Customers on Orders.CustomerID = Customers.CustomerID
where OrderId = 10248;

Select OrderID, ContactName
from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID;


-- Join THREE tables. select all orders with customer and shipper information
select * from Shippers;
Select * from Orders;
SElect * from Customers;

select Orders.OrderID, Customers.ContactName, Shippers.CompanyName
from ((Orders
inner join Shippers on Orders.Shipvia = Shippers.ShipperID)
inner join Customers on Orders.CustomerID = Customers.CustomerID);

SELECT Orders.OrderID, Customers.ContactName, Shippers.CompanyName
FROM ((Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID)
INNER JOIN Shippers ON Orders.Shipvia = Shippers.ShipperID);













