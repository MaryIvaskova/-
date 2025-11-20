-- Ѕј«ј: ADVENTUREWORKS (FULL)

---------------------------------------------------------
-- «ј¬ƒјЌЌя 3 Ч ѕроцедура: кл≥Їнти/прац≥вники, у €ких сьогодн≥ ƒень Ќародженн€
-- ќпис: шукаЇ прац≥вник≥в ≥з HumanResources.Employee, у €ких BirthDate = поточна дата,
--       ≥ додаЇ њх ≥мена та пр≥звища з Person.Person.
---------------------------------------------------------
IF OBJECT_ID('dbo.CustomersBirthdayToday', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CustomersBirthdayToday;
GO

CREATE PROCEDURE CustomersBirthdayToday
AS
BEGIN
    SELECT 
        e.BusinessEntityID,
        p.FirstName,
        p.LastName,
        e.BirthDate
    FROM HumanResources.Employee e
    JOIN Person.Person p
        ON e.BusinessEntityID = p.BusinessEntityID
    WHERE e.BirthDate IS NOT NULL
      AND MONTH(e.BirthDate) = MONTH(GETDATE())
      AND DAY(e.BirthDate) = DAY(GETDATE());
END;
GO

EXEC dbo.CustomersBirthdayToday;


---------------------------------------------------------
-- «ј¬ƒјЌЌя 4 Ч ‘ункц≥€: замовленн€ за останн≥й тиждень
-- ќпис: повертаЇ вс≥ замовленн€ Sales.SalesOrderHeader за попередн≥ 7 дн≥в.
---------------------------------------------------------
IF OBJECT_ID('dbo.OrdersLastWeek', 'IF') IS NOT NULL
    DROP FUNCTION dbo.OrdersLastWeek;
GO

CREATE FUNCTION OrdersLastWeek()
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Sales.SalesOrderHeader
    WHERE OrderDate >= DATEADD(DAY, -7, GETDATE())
);
GO

SELECT * FROM dbo.OrdersLastWeek();


---------------------------------------------------------
-- «ј¬ƒјЌЌя 5 Ч ‘ункц≥€: Ђ“овар дн€ї
-- ќпис: повертаЇ товар, €кий купували найб≥льше у вказаний день @Date.
---------------------------------------------------------
IF OBJECT_ID('dbo.ProductOfDay', 'IF') IS NOT NULL
    DROP FUNCTION dbo.ProductOfDay;
GO

CREATE FUNCTION ProductOfDay(@Date DATE)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1
        p.ProductID,
        p.Name,
        SUM(d.OrderQty) AS TotalQty
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
    JOIN Sales.SalesOrderHeader h ON h.SalesOrderID = d.SalesOrderID
    WHERE CAST(h.OrderDate AS DATE) = @Date
    GROUP BY p.ProductID, p.Name
    ORDER BY TotalQty DESC
);
GO

SELECT * FROM dbo.ProductOfDay(GETDATE());


---------------------------------------------------------
-- «ј¬ƒјЌЌя 6 Ч ‘ункц≥€: сума замовлень за останню пТ€тницю
-- ќпис: повертаЇ суму TotalDue замовлень, зроблених у найближчу попередню пТ€тницю.
---------------------------------------------------------
IF OBJECT_ID('dbo.LastFridaySales', 'IF') IS NOT NULL
    DROP FUNCTION dbo.LastFridaySales;
GO

CREATE FUNCTION LastFridaySales()
RETURNS TABLE
AS
RETURN
(
    SELECT SUM(TotalDue) AS FridaySales
    FROM Sales.SalesOrderHeader
    WHERE DATENAME(WEEKDAY, OrderDate) = 'Friday'
      AND OrderDate >= DATEADD(DAY, -7, GETDATE())
);
GO

SELECT * FROM dbo.LastFridaySales();


---------------------------------------------------------
-- «ј¬ƒјЌЌя 7 Ч “аблиц≥: прац≥вники з <10 ≥ >70 VacationHours
-- ќпис: створити дв≥ таблиц≥ з ≥менами, пр≥звищами, посадами та VacationHours.
---------------------------------------------------------

-- 7.1 Ч VacationHours < 10
IF OBJECT_ID('dbo.EmployeesLowVacation', 'U') IS NOT NULL
    DROP TABLE dbo.EmployeesLowVacation;

SELECT 
    e.BusinessEntityID,
    p.FirstName,
    p.LastName,
    e.JobTitle,
    e.VacationHours
INTO EmployeesLowVacation
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.VacationHours < 10;

SELECT * FROM EmployeesLowVacation;


-- 7.2 Ч VacationHours > 70
IF OBJECT_ID('dbo.EmployeesHighVacation', 'U') IS NOT NULL
    DROP TABLE dbo.EmployeesHighVacation;

SELECT 
    e.BusinessEntityID,
    p.FirstName,
    p.LastName,
    e.JobTitle,
    e.VacationHours
INTO EmployeesHighVacation
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.VacationHours > 70;

SELECT * FROM EmployeesHighVacation;


---------------------------------------------------------
-- «ј¬ƒјЌЌя 8 Ч ‘ункц≥€: пошук кл≥Їнта за номером телефону
-- ќпис: знаходить кл≥Їнта по номеру з Person.PersonPhone.
---------------------------------------------------------
IF OBJECT_ID('dbo.FindCustomerByPhone', 'IF') IS NOT NULL
    DROP FUNCTION dbo.FindCustomerByPhone;
GO

CREATE FUNCTION FindCustomerByPhone(@Phone NVARCHAR(25))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        c.CustomerID,
        p.FirstName,
        p.LastName,
        pp.PhoneNumber
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
    WHERE pp.PhoneNumber = @Phone
);
GO

SELECT * FROM dbo.FindCustomerByPhone('000-000-0000');
