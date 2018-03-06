-- Problem #32: High-value customers. We want to send all of our high-value customers a special VIP gift. We're defining high-value customers as those who've made at least 1 order with a total value (not including the discount) equal to $10,000 or more. We only want to consider orders made in the year 2016.
Select * from Orders where Date_Part('year', Orderdate) = 2016

select c.CustomerID, c.CompanyName, o.OrderID, sum(od.UnitPrice * od.Quantity) as TotalOrderAmount
from Customers c
    join Orders o
	on c.CustomerID = o.CustomerID
    join OrderDetails od
	on o.OrderID = od.OrderID
where extract(year from OrderDate)=2016
      group by c.CustomerID, o.OrderID
Having sum(od.UnitPrice * od.Quantity) >= 10000
order by TotalOrderAmount desc;

--Problem 33: High-value customers - total orders.The manager has changed his mind. Instead of requiring that customers have at least one individual orders totaling $10,000 or more, he wants to define high-value customers as those who have orders totaling $15,000 or more in 2016. How would you change the answer to the problem above?

select c.CustomerID, c.CompanyName, o.OrderID, sum(od.UnitPrice * od.Quantity) as TotalOrderAmount
from Customers c
    join Orders o
	on c.CustomerID = o.CustomerID
    join OrderDetails od
	on o.OrderID = od.OrderID
where extract(year from OrderDate)=2016
      group by c.CustomerID, o.OrderID
Having sum(od.UnitPrice * od.Quantity) >= 10000
order by TotalOrderAmount desc;


Select * from Orders where CustomerID = 'VINET';
select * from OrderDetails where OrderId = 10248;


select c.CustomerID, c.CompanyName, round(sum(od.UnitPrice * od.Quantity)::numeric,2) as TotalOrderAmount
from Customers c
    join Orders o
	on c.CustomerID = o.CustomerID
    join OrderDetails od
	on o.OrderID = od.OrderID
where extract(year from OrderDate)=2016
      group by c.CustomerID
Having sum(od.UnitPrice * od.Quantity) >= 15000
order by TotalOrderAmount desc;

-- Problem #34: High-value customers - with discount. Change the above query to use the discount when calculating high-value customers. Order by the total amount which includes the discount.

select c.CustomerID, c.CompanyName, round(sum(od.UnitPrice * od.Quantity)::numeric,2) as TotalWithoutDiscount, round(sum(od.UnitPrice * od.Quantity*(1-od.Discount))::numeric,2) as TotalWithDiscount
from Customers c
    join Orders o
	on c.CustomerID = o.CustomerID
    join OrderDetails od
	on o.OrderID = od.OrderID
where extract(year from OrderDate)=2016
      group by c.CustomerID
Having sum(od.UnitPrice * od.Quantity*(1-od.Discount)) >= 10000
order by TotalWithDiscount desc;


-- Problem #35: Month-end orders. At the end of the month, salespeople are likely to try much harder to get orders, to meet their month-end quotas. Show all orders made on the last day of the month. Order by EmployeeID and OrderID


select * from Orders; -- OrderId, OrderDate

select EmployeeId, OrderId, OrderDate from Orders
where (extract(Day from OrderDate) = 31 and (extract(month from OrderDate) in (1, 3, 5, 7, 8, 10, 12)))
     or (extract(day from OrderDate) = 30 and (extract(month from OrderDate) in (4, 6, 9, 11)))
     or (extract(day from OrderDate) in (28, 29) and (extract(month from OrderDate) in (2)))
Order by EmployeeId, OrderId, OrderDate;


-- Problem #36: Orders with many line items.The Northwind mobile app developers are testing an app that customers will use to show orders. In order to make sure that even the largest orders will show up correctly on the app, they'd like some samples of orders that have lots of individual line items. Show the 10 orders with the most line items, in order of total line items.

select OrderId, count(ProductID) as TotalLineItems
from OrderDetails
group by OrderId
Order by TotalLineItems desc limit 10;

-- Problem #37: Orders - random assortment. The Northwind mobile app developers would now like to just get a random assortment of orders for beta testing on their app. Show a random set of 2% of all orders.
Select OrderId 
from Orders
Order by Random()
limit ((select count(*) from Orders) * 0.02);

-- Problem #38: Orders - accidental double-entry. Janet Leverling, one of the salespeople, has come to you with a request. She thinks that she accidentally double-entered a line item on an order, with a different ProductID, but the same quantity. She remembers that the quantity was 60 or more. Show all the OrderIDs with line items that match this, in order of OrderID

Select OrderId
From OrderDetails
Where quantity>=60
Group By OrderId, Quantity
Having Count(*) >= 2
Order by OrderID asc


--Problem # 39: Orders - accidental double-entry details. Based on the previous question, we now want to show details of the order, for orders that match the above criteria.
select OrderId, ProductId, UnitPrice, Quantity, Discount 
from OrderDetails
where OrderId in (
      Select OrderId
      From OrderDetails
      Where quantity>=60
      Group By OrderId, Quantity
      Having Count(*) >= 2)
Order By OrderId, ProductId

-- Problem #40: Orders - accidental double-entry details. Here's another way of getting the same results as in the previous problem, using a derived table instead of a CTE. However, there's a bug in this SQL. It returns 20 rows instead of 16. Correct the SQL.

Select OrderDetails.OrderID, ProductID, UnitPrice, Quantity, Discount
From OrderDetails
	Join (
	   Select distinct(OrderID)
	   From OrderDetails
	   Where Quantity >= 60
	   Group By OrderID, Quantity
	   Having Count(*) > 1
	)  PotentialProblemOrders
       on PotentialProblemOrders.OrderID = OrderDetails.OrderID
	Order by OrderID, ProductID

--Problem #41: Late orders. Some customers are complaining about their orders arriving late. Which orders are late?
Select OrderID, OrderDate, RequiredDate, ShippedDate
from Orders 
where requireddate < shippeddate

-- Problem #42: Late orders - which employees? Some salespeople have more orders arriving late than others. Maybe they're not following up on the order process, and need more training. Which salespeople have the most orders arriving late?
select * from Orders

Select e.EmployeeId, LastName, count(requireddate < shippeddate) as TotalLateOrders
from Orders
join Employees e
   on Orders.EmployeeID = e.EmployeeID
where requireddate < shippeddate
group by e.EmployeeID
Order by TotalLateOrders desc

-- Another Method
Select e.EmployeeId, LastName, count(L.OrderID) as TotalLateOrders
from Employees e
join (
	Select OrderId, EmployeeID
	from Orders
	where Requireddate::date < Shippeddate::Date
) L
On e.EmployeeID=L.EmployeeID
group by e.EmployeeID
Order by TotalLateOrders desc;


--Problem #43: Late orders vs. total orders. Andrew, the VP of sales, has been doing some more thinking some more about the problem of late orders. He realizes that just looking at the number of orders arriving late for each salesperson isn't a good idea. It needs to be compared against the total number of orders per salesperson. Return results like the following:
with LateOrders as (
	Select E.EmployeeId, LastName, count(L.OrderID) as TotalLateOrders
	from Employees E
	join (
		Select OrderId, EmployeeID
		from Orders
		where Requireddate::date < Shippeddate::Date
	) L
	On E.EmployeeID=L.EmployeeID
	group by E.EmployeeID
), 
AllOrders as (
	Select E.EmployeeID, count(OrderId) as TotalOrders
	From Employees E
        JOIN Orders O
        ON E.EmployeeID=O.EmployeeId
        Group By E.EmployeeID
)
Select A.EmployeeID, LastName, TotalOrders, TotalLateOrders
	From LateOrders L
	JOIN AllOrders A
	ON A.EmployeeId=L.EmployeeId
	Order By A. EmployeeId;

--Problem #44: Late orders vs. total orders - missing employee. There's an employee missing in the answer from the problem above. Fix the SQL to show all employees who have taken orders.

with LateOrders as (
	Select E.EmployeeId, LastName, count(L.OrderID) as TotalLateOrders
	from Employees E
	join (
		Select OrderId, EmployeeID
		from Orders
		where Requireddate::date < Shippeddate::Date
	) L
	On E.EmployeeID=L.EmployeeID
	group by E.EmployeeID
), 
AllOrders as (
	Select E.EmployeeID, count(OrderId) as TotalOrders
	From Employees E
        JOIN Orders O
        ON E.EmployeeID=O.EmployeeId
        Group By E.EmployeeID
)
Select A.EmployeeID, LastName, TotalOrders, TotalLateOrders
	From LateOrders L
	right outer JOIN AllOrders A
	ON A.EmployeeId=L.EmployeeId
	Order By A. EmployeeId;






