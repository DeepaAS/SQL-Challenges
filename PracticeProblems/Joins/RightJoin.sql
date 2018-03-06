
-- RIGHT Join
-- The RIGHT JOIN keyword returns all records from the right table (table2), and the matched records from the left table (table1). The result is NULL from the left side, when there is no match.

select Orders.OrderID, Orders.CustomerID, Customers.ContactName
from Orders
RIGHT join Customers on Orders.CustomerID = Customers.CustomerID;

select Orders.OrderID, Orders.CustomerID, Customers.ContactName
from Customers
right join Orders on Customers.CustomerID = Orders.CustomerID;