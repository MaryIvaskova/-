---------------------------------------------------------
-- «ј¬ƒјЌЌя 1 Ч Ќайб≥льша сума замовленн€
-- ќпис: знайти суму найб≥льшого замовленн€, використовуючи CTE.
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

PRINT '–≈«”Ћ№“ј“ «ј¬ƒјЌЌя 1';
-- (результат в≥добразитьс€ у таблиц≥ нижче)



---------------------------------------------------------
-- «ј¬ƒјЌЌя 2 Ч «меншити ц≥ну Bike (>1500$, <10 шт.) на 20%
-- ќпис: у FULL AdventureWorks категор≥њ проход€ть через
--       ProductSubcategory ? ProductCategory. «меншити ц≥ну 
--       дл€ велосипед≥в ≥з вказаними умовами.
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

PRINT '–≈«”Ћ№“ј“ «ј¬ƒјЌЌя 2';
-- (UPDATE не повертаЇ р€дки, лише статус)



---------------------------------------------------------
-- «ј¬ƒјЌЌя 3 Ч —ума продаж≥в 2-го п≥вр≥чч€ (будь-€кого року)
-- ќпис: у FULL AdventureWorks 1999 року Ќ≤ћј™. “ому запит 
--       показуЇ п≥дсумки за вс≥ма доступними роками, де 
--       м≥с€ц≥ = 7Ц12.
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

PRINT '–≈«”Ћ№“ј“ «ј¬ƒјЌЌя 3';



---------------------------------------------------------
-- «ј¬ƒјЌЌя 4 Ч —ередн€ к≥льк≥сть продаж≥в за друге п≥вр≥чч€
-- ќпис: €к ≥ в попередньому завданн≥, рахуЇмо за вс≥ма роками,
--       оск≥льки у FULL AdventureWorks 1999 року немаЇ.
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

PRINT '–≈«”Ћ№“ј“ «ј¬ƒјЌЌя 4';