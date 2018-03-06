-- The FULL OUTER JOIN keyword return all records when there is a match in either left (table1) or right (table2) table records.
-- Note: FULL OUTER JOIN can potentially return very large result-sets!

select Orders.OrderID, Orders.CustomerID, Customers.ContactName
from Orders
Full outer join Customers on Orders.CustomerID = Customers.CustomerID;

select Orders.OrderID, Orders.CustomerID, Customers.ContactName
from Customers
full outer join Orders on Customers.CustomerID = Orders.CustomerID;