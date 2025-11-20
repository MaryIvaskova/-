---------------------------------------------------------
-- ЗАВДАННЯ 3 — Клієнти, у яких сьогодні День Народження
-- Оригінальний опис: знайти клієнтів, у яких BirthDate = сьогодні.
-- Примітка: У твоїй LT-базі стовпця BirthDate НЕМАЄ.
---------------------------------------------------------
-- РОБОЧИЙ ВАРІАНТ ДЛЯ  LT-БАЗИ
SELECT 
    CustomerID,
    FirstName,
    LastName,
    ModifiedDate AS PseudoBirthDate
FROM SalesLT.Customer
WHERE CAST(ModifiedDate AS DATE) = CAST(GETDATE() AS DATE);

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 3 ( LT)';



---------------------------------------------------------
-- ЗАВДАННЯ 4 — Замовлення за останній тиждень
-- Опис: вивести всі замовлення за попередні 7 днів.
---------------------------------------------------------

SELECT *
FROM SalesLT.SalesOrderHeader
WHERE OrderDate >= DATEADD(DAY, -7, GETDATE());

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 4';



---------------------------------------------------------
-- ЗАВДАННЯ 5 — Товар дня
-- Опис: знайти товар, який купували найбільше у дату @Date.
---------------------------------------------------------

DECLARE @Date DATE = GETDATE();   -- або змінити вручну

SELECT TOP 1
    p.ProductID,
    p.Name,
    SUM(d.OrderQty) AS TotalQty
FROM SalesLT.Product p
JOIN SalesLT.SalesOrderDetail d ON p.ProductID = d.ProductID
JOIN SalesLT.SalesOrderHeader h ON h.SalesOrderID = d.SalesOrderID
WHERE CAST(h.OrderDate AS DATE) = @Date
GROUP BY p.ProductID, p.Name
ORDER BY TotalQty DESC;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 5';



---------------------------------------------------------
-- ЗАВДАННЯ 6 — Сума замовлень за останню п’ятницю
-- Опис: сума TotalDue для найближчої попередньої п’ятниці.
---------------------------------------------------------

SELECT 
    SUM(TotalDue) AS FridaySales
FROM SalesLT.SalesOrderHeader
WHERE DATENAME(WEEKDAY, OrderDate) = 'Friday'
  AND OrderDate >= DATEADD(DAY, -7, GETDATE());

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 6';



---------------------------------------------------------
-- ЗАВДАННЯ 8 — Пошук клієнта за номером телефону
-- Опис: знайти клієнта із SalesLT.Customer за параметром @Phone.
---------------------------------------------------------

DECLARE @Phone NVARCHAR(25) = '000-000-0000';   -- вписати потрібний номер

SELECT 
    CustomerID,
    FirstName,
    LastName,
    Phone
FROM SalesLT.Customer
WHERE Phone = @Phone;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 8';