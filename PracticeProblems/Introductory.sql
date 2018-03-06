-- Problem #1: 1. Which shippers do we have? We have a table called Shippers. Return all the fields from all the shippers
SELECT * FROM Shippers;

-- Problem #2: Certain fields from Categories - In the Categories table, selecting all the fields using this SQL: Select * from Categories
-- ...will return 4 columns. We only want to see two columns, CategoryName and Description.
SELECT CategoryName, Description FROM Categories;

-- Problem #3: Sales Representatives - We’d like to see just the FirstName, LastName, and HireDate of all the employees with the Title of Sales Representative. Write a SQL statement that returns only those employees.
SELECT FirstName, LastName, HireDate FROM Employees WHERE Title = 'Sales Representative';

-- Problem #4: Sales Representatives in the United States. Now we’d like to see the same columns as above, but only for those employees that both have the title of Sales Representative, and also are in the United States.
SELECT FirstName, LastName, HireDates FROM Employees WHERE Title = 'Sales Representative' AND Country = 'USA';

-- Problem #5: Orders placed by specific EmployeeID. Show all the orders placed by a specific employee. The EmployeeID for this Employee (Steven Buchanan) is 5.
SELECT OrderID, OrderDate FROM Orders WHERE EmployeeID = 5;

-- Problem #6: Suppliers and ContactTitles - In the Suppliers table, show the SupplierID, ContactName, and ContactTitle for those Suppliers whose ContactTitle is not Marketing Manager.
SELECT SupplierID, ContactName, ContactTitle FROM Suppliers WHERE ContactTitle <> 'Marketing Manager';

-- Problem #7: Products with “queso” in ProductName. In the products table, we’d like to see the ProductID and ProductName for those products where the ProductName includes the string “queso”.
SELECT ProductID, ProductName FROM Products WHERE ProductName like '%Queso%';

-- Problem #8: Orders shipping to France or Belgium. Looking at the Orders table, there’s a field called ShipCountry. Write a query that shows the OrderID, CustomerID, and ShipCountry for the orders where the ShipCountry is either France or Belgium.
SELECT OrderID, CustomerID, ShipCountry FROM Orders WHERE ShipCountry = 'France' OR ShipCountry = 'Belgium';

-- Problem #9: Orders shipping to any country in Latin America. Now, instead of just wanting to return all the orders from France of Belgium, we want to show all the orders from any Latin American country. But we don’t have a list of Latin American countries in a table in the Northwind database. So, we’re going to just use this list of Latin American countries that happen to be in the Orders table:
-- Brazil, Mexico, Argentina, Venezuela. It doesn’t make sense to use multiple Or statements anymore, it would get too convoluted. Use the In statement. 
SELECT OrderID, CustomerID, ShipCountry FROM Orders WHERE ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela'); 

-- Problem #10: Employees, in order of age. For all the employees in the Employees table, show the FirstName, LastName, Title, and BirthDate. Order the results by BirthDate, so we have the oldest employees first.
SELECT FirstName, LastName, Title, BirthDate FROM Employees ORDER BY BirthDate;

-- Problem #11: Showing only the Date with a DateTime field. In the output of the query above, showing the Employees in order of BirthDate, we see the time of the BirthDate field, which we don’t want. Show only the date portion of the BirthDate field.
SELECT FirstName, LastName, Title, CAST(BirthDate AS date) AS DateOnlyBirthDate FROM Employees ORDER BY BirthDate;

-- Problem #12: Employees full name. Show the FirstName and LastName columns from the Employees table, and then create a new column called FullName, showing FirstName and LastName joined together in one column, with a space in- between.
SELECT firstName, LastName, CONCAT(firstName, ' ', LastName) as fullName from Employees;

-- Problem #13: OrderDetails amount per line item. In the OrderDetails table, we have the fields UnitPrice and Quantity. Create a new field, TotalPrice, that multiplies these two together. We’ll ignore the Discount field for now.In addition, show the OrderID, ProductID, UnitPrice, and Quantity. Order by OrderID and ProductID.
select OrderID, ProductID, UnitPrice, Quantity, (UnitPrice*Quantity) as TotalPrice from OrderDetails order by OrderID, ProductID;

-- Problem #14: How many customers? How many customers do we have in the Customers table? Show one value only, and don’t rely on getting the recordcount at the end of a resultset.
select COUNT(CustomerID) from Customers;

-- Problem #15: When was the first order? Show the date of the first order ever made in the Orders table.
select MIN(OrderDate) from Orders;

-- Problem #16: Countries where there are customers. Show a list of countries where the Northwind company has customers.
select Country from Customers group by Country;

-- Problem #17: Contact titles for customers. Show a list of all the different values in the Customers table for ContactTitles. Also include a count for each ContactTitle. This is similar in concept to the previous question “Countries where there are customers”, except we now want a count for each ContactTitle.
select ContactTitle, COUNT(ContactTitle) AS TotalContactTitles from Customers Group by ContactTitle ORDER by TotalContactTitles DESC;

-- Problem #18: Products with their associated supplier names. We’d like to show, for each product, the associated Supplier. Show the ProductID, ProductName, and the CompanyName of the Supplier. Sort by ProductID. This question will introduce what may be a new concept, the Join clause in SQL. The Join clause is used to join two or more relational database tables together in a logical way. Here’s a data model of the relationship between Products and Suppliers.
Select * from Products;
select * from Suppliers;

select ProductID, ProductName, CompanyName as Supplier from Suppliers join Products on Suppliers.SupplierID = Products.SupplierID;

select ProductID, ProductName, CompanyName as Supplier from Products join Suppliers on Products.SupplierID = Suppliers.SupplierID;

-- Problem #19: Orders and the Shipper that was used. We’d like to show a list of the Orders that were made, including the Shipper that was used. Show the OrderID, OrderDate (date only), and CompanyName of the Shipper, and sort by OrderID.In order to not show all the orders (there’s more than 800), show only those rows with an OrderID of less than 10300.
select * from Orders;
Select * from Shippers; 

select OrderID, DATE(OrderDate), CompanyName as Shipper from Orders join Shippers on Orders.Shipvia = Shippers.ShipperID where OrderID < 10300;