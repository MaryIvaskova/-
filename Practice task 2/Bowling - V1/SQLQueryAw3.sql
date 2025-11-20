 -- ВАРІАНТ 1
-- ===============================================
-- Завдання 1.
-- Вивести всіх клієнтів, які мають хоча б одне замовлення та відображаємо ідентифікатор, назву компанії та електронну -адресу
/**SELECT DISTINCT
    c.CustomerID,
    c.CompanyName,
    c.EmailAddress
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS o
    ON c.CustomerID = o.CustomerID;

    -- Завдання 2.
-- Визначити кількість замовлень та суму продажів по кожному клієнту
SELECT
    c.CustomerID,
    c.CompanyName,
    c.EmailAddress,
    COUNT(o.SalesOrderID) AS TotalOrders,
    SUM(o.TotalDue) AS TotalSales
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS o
    ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID,
    c.CompanyName,
    c.EmailAddress
ORDER BY 
    TotalSales DESC;
    **/

 -- ВАРІАНТ 6
-- ===============================================
-- ЗАВДАННЯ 3
-- Знайти продукти, які замовляли лише один раз і лише одним клієнтом
SELECT 
    p.ProductID,
    p.Name
FROM SalesLT.Product AS p
JOIN SalesLT.SalesOrderDetail AS d
    ON p.ProductID = d.ProductID
GROUP BY 
    p.ProductID, 
    p.Name
HAVING 
    COUNT(d.SalesOrderDetailID) = 1
    AND COUNT(DISTINCT d.SalesOrderID) = 1;
-- ===============================================


-- ===============================================
-- ЗАВДАННЯ 2 (варіант через IN)
-- Вивести клієнтів, які зробили хоча б одне замовлення
-- у кожному з першого та останнього років у базі
DECLARE @FirstYear INT, @LastYear INT;

SELECT 
    @FirstYear = MIN(YEAR(OrderDate)),
    @LastYear = MAX(YEAR(OrderDate))
FROM SalesLT.SalesOrderHeader;

SELECT 
    c.CustomerID,
    c.CompanyName
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS o
    ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) IN (@FirstYear, @LastYear)
GROUP BY 
    c.CustomerID,
    c.CompanyName
HAVING 
    COUNT(DISTINCT YEAR(o.OrderDate)) = 2;
GO
    -- ЗАВДАННЯ 2 (варіант через OR)
DECLARE @FirstYear INT, @LastYear INT;

SELECT 
    @FirstYear = MIN(YEAR(OrderDate)),
    @LastYear = MAX(YEAR(OrderDate))
FROM SalesLT.SalesOrderHeader;

SELECT 
    c.CustomerID,
    c.CompanyName
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS o
    ON c.CustomerID = o.CustomerID
WHERE 
    YEAR(o.OrderDate) = @FirstYear
    OR YEAR(o.OrderDate) = @LastYear
GROUP BY 
    c.CustomerID,
    c.CompanyName
HAVING 
    COUNT(DISTINCT YEAR(o.OrderDate)) = 2;

-- ЗАВДАННЯ 1
-- Визначити продукт, який приносив найбільший прибуток у кожній категорії
WITH ProfitPerProduct AS (
    SELECT 
        pc.Name AS CategoryName,
        p.Name AS ProductName,
        SUM(d.UnitPrice * d.OrderQty) AS TotalProfit,
        ROW_NUMBER() OVER (
            PARTITION BY pc.ProductCategoryID 
            ORDER BY SUM(d.UnitPrice * d.OrderQty) DESC
        ) AS rn
    FROM SalesLT.Product AS p
    JOIN SalesLT.ProductCategory AS pc
        ON p.ProductCategoryID = pc.ProductCategoryID
    JOIN SalesLT.SalesOrderDetail AS d
        ON p.ProductID = d.ProductID
    GROUP BY 
        pc.ProductCategoryID,
        pc.Name,
        p.Name
)
SELECT 
    CategoryName,
    ProductName,
    TotalProfit
FROM ProfitPerProduct
WHERE rn = 1
ORDER BY CategoryName;
-- ===============================================
--роки--
SELECT 
    MIN(YEAR(OrderDate)) AS FirstYear,
    MAX(YEAR(OrderDate)) AS LastYear
FROM SalesLT.SalesOrderHeader;