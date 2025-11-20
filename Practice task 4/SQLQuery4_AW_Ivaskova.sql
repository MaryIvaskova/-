-- lT


---------------------------------------------------------
-- ЗАВДАННЯ 7.1 — Працівники, що відпочивали менше 10 годин
-- Опис: знайти всіх працівників із VacationHours < 10.
---------------------------------------------------------

SELECT 
    e.BusinessEntityID,
    p.FirstName,
    p.LastName,
    e.VacationHours
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.VacationHours < 10;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 7.1';


---------------------------------------------------------
-- ЗАВДАННЯ 7.2 — Працівники, що відпочивали більше 30 годин
-- Опис: знайти всіх працівників із VacationHours > 30.
---------------------------------------------------------

SELECT 
    e.BusinessEntityID,
    p.FirstName,
    p.LastName,
    e.VacationHours
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.VacationHours > 30;

PRINT 'РЕЗУЛЬТАТ ЗАВДАННЯ 7.2';

