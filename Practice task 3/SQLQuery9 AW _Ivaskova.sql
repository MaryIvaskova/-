---------------------------------------------------------
-- ЗАВДАННЯ 1 — Найбільша сума замовлення
-- Опис: знайти суму найбільшого замовлення, використовуючи CTE.
---------------------------------------------------------

WITH MaxOrder AS (
    SELECT 
        SalesOrderID,
        SUM(LineTotal) AS TotalSum
    FROM Sales.SalesOrderDetail
    GROUP BY SalesOrderID
)
SELECT 
    MAX(TotalSum) AS BiggestOrder
FROM MaxOrder;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 1';
-- (результат відобразиться у таблиці нижче)



---------------------------------------------------------
-- ЗАВДАННЯ 2 — Зменшити ціну Bike (>1500$, <10 шт.) на 20%
-- Опис: у FULL AdventureWorks категорії проходять через
--       ProductSubcategory → ProductCategory. Зменшити ціну 
--       для велосипедів із вказаними умовами.
---------------------------------------------------------

WITH Bikes AS (
    SELECT p.ProductID
    FROM Production.Product p
    JOIN Production.ProductSubcategory sc 
        ON p.ProductSubcategoryID = sc.ProductSubcategoryID
    JOIN Production.ProductCategory c
        ON sc.ProductCategoryID = c.ProductCategoryID
    WHERE c.Name = 'Bikes'
      AND p.ListPrice > 1500
      AND p.SafetyStockLevel < 10
)
UPDATE p
SET p.ListPrice = p.ListPrice * 0.8
FROM Production.Product p
JOIN Bikes b ON p.ProductID = b.ProductID;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 2';
-- (UPDATE не повертає рядки, лише статус)



---------------------------------------------------------
-- ЗАВДАННЯ 3 — Сума продажів 2-го півріччя (будь-якого року)
-- Опис: у FULL AdventureWorks 1999 року НІМАЄ. Тому запит 
--       показує підсумки за всіма доступними роками, де 
--       місяці = 7–12.
---------------------------------------------------------

WITH SecondHalf AS (
    SELECT 
        soh.SalesPersonID,
        sod.LineTotal,
        soh.OrderDate
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod 
        ON soh.SalesOrderID = sod.SalesOrderID
    WHERE MONTH(soh.OrderDate) BETWEEN 7 AND 12
)
SELECT 
    SalesPersonID,
    SUM(LineTotal) AS TotalSales
FROM SecondHalf
GROUP BY SalesPersonID;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 3';



---------------------------------------------------------
-- ЗАВДАННЯ 4 — Середня кількість продажів за друге півріччя
-- Опис: як і в попередньому завданні, рахуємо за всіма роками,
--       оскільки у FULL AdventureWorks 1999 року немає.
---------------------------------------------------------

WITH SecondHalf AS (
    SELECT 
        soh.SalesPersonID,
        sod.OrderQty,
        soh.OrderDate
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod 
        ON soh.SalesOrderID = sod.SalesOrderID
    WHERE MONTH(soh.OrderDate) BETWEEN 7 AND 12
)
SELECT 
    SalesPersonID,
    AVG(OrderQty) AS AvgQty
FROM SecondHalf
GROUP BY SalesPersonID;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 4';