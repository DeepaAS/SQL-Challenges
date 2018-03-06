--A self JOIN is a regular join, but the table is joined with itself.

-- customers that are from the same city
Select * from employees;

select CONCAT(m.FirstName, ' ', m.LastName) as Manager,
CONCAT(e.FirstName, ' ', e.LastName) as DirectReport
from Employees e
inner join Employees m on m.EmployeeID = e.ReportsTo
order by Manager;

select CONCAT(e.FirstName, ' ', e.LastName) as FullName,
from Employees e
inner join Employees e2 on e2.City = e.City
and (e.FirstName <> e2.FirstName and e.LastName <> e2.LastName)
order by e.City;

select * from Customers;

select Distinct(c.City), c.ContactName
from Customers c
inner join Customers c1 on c1.City = c.City
order by c.City;