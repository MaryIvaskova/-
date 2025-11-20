-- Ѕј«ј: SAMPLE

---------------------------------------------------------
-- «ј¬ƒјЌЌя 1 Ч ѕроцедура: зменшити максимальний бюджет на 10%
-- ќпис: знаходить максимальний бюджет у таблиц≥ project та зменшуЇ його на 10%.
---------------------------------------------------------
IF OBJECT_ID('dbo.ReduceMaxBudget', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ReduceMaxBudget;
GO

CREATE PROCEDURE ReduceMaxBudget
AS
BEGIN
    DECLARE @MaxBudget MONEY;

    SELECT @MaxBudget = MAX(budget)
    FROM project;

    UPDATE project
    SET budget = budget * 0.9
    WHERE budget = @MaxBudget;

    SELECT * FROM project WHERE budget = @MaxBudget * 0.9;
END;
GO

EXEC ReduceMaxBudget;


---------------------------------------------------------
-- «ј¬ƒјЌЌя 2 Ч ‘ункц≥€: прац≥вники з≥ стажем б≥льше 3 рок≥в
-- ќпис: визначаЇ прац≥вник≥в, у €ких р≥зниц€ м≥ж enter_date ≥ сьогодн≥ > 3 рок≥в.
---------------------------------------------------------
IF OBJECT_ID('dbo.GetExperiencedEmployees', 'IF') IS NOT NULL
    DROP FUNCTION dbo.GetExperiencedEmployees;
GO

CREATE FUNCTION GetExperiencedEmployees()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        e.emp_no,
        e.emp_fname,
        e.emp_lname,
        w.enter_date,
        DATEDIFF(YEAR, w.enter_date, GETDATE()) AS ExperienceYears
    FROM employee e
    JOIN works_on w ON e.emp_no = w.emp_no
    WHERE DATEDIFF(YEAR, w.enter_date, GETDATE()) > 3
);
GO

SELECT * FROM dbo.GetExperiencedEmployees();