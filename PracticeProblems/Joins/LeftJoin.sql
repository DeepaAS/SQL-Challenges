select Distinct(CustomerID) from Orders where CustomerID is not Null group by CustomerID;

select * from Customers where CustomerID = 'FISSA';
where ContactName = 'Diego Roel';
-- Left Joins

-- The LEFT JOIN keyword returns all records from the left table (table1), and the matched records from the right table (table2). The result is NULL from the right side, if there is no match.


select Orders.OrderID, Orders.CustomerID, Customers.ContactName
from Orders
Left join Customers on Orders.CustomerID = Customers.CustomerID;

select Orders.OrderID, Orders.CustomerID, Customers.ContactName
from Customers
Left join Orders On Customers.CustomerID = Orders.CustomerID;