
--"Top Customers"
SELECT TOP 10
    c.CompanyName,
    c.City,
    c.Country,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName, c.City, c.Country
ORDER BY TotalSpent DESC;

--"Sales Performance by Category"
SELECT 
    cat.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS CategoryRevenue,
    SUM(od.Quantity) AS TotalUnitsSold
FROM Categories cat
JOIN Products p ON cat.CategoryID = p.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY cat.CategoryName
ORDER BY CategoryRevenue DESC
OFFSET 0 ROWS;


--"DailyRevenue"
SELECT 
    o.OrderDate,
	ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS DailyRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate IS NOT NULL
GROUP BY 
    o.OrderDate;

--"Stock Levels vs. Demand by Category"
SELECT TOP (100) PERCENT
    cat.CategoryName,
    p.ProductName,
    p.UnitsInStock,
    p.UnitsOnOrder,
    p.ReorderLevel,
    SUM(od.Quantity) AS TotalUnitsSold
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName, p.ProductID, p.ProductName, p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel
HAVING p.UnitsInStock + p.UnitsOnOrder < p.ReorderLevel * 2
ORDER BY TotalUnitsSold DESC;

--"total profit"
SELECT 
    YEAR(o.OrderDate) AS OrderYear,
	ROUND(SUM(od.UnitPrice * od.Quantity), 2) AS TotalSale,
	SUM(od.Quantity) AS TotalProductsale,
	ROUND(SUM(od.UnitPrice * od.Quantity *  od.Discount), 2) AS Totaldiscount,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS YearlyRevenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY OrderYear
OFFSET 0 ROWS;

