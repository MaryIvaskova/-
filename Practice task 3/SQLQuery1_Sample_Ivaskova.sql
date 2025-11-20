--Sample
---------------------------------------------------------
-- «ј¬ƒјЌЌя 6 Ч Ћокальна тимчасова таблиц€ (H2 2007)
-- ќпис: створити локальну тимчасову таблицю з ≥менами та пр≥звищами
--       ус≥х сп≥вроб≥тник≥в, €к≥ почали працювати над проЇктами
--       у друг≥й половин≥ 2007 року (липеньЦгрудень).
---------------------------------------------------------

IF OBJECT_ID('tempdb..#Employees2007') IS NOT NULL
    DROP TABLE #Employees2007;

SELECT 
    e.emp_fname AS EmployeeFirstName,
    e.emp_lname AS EmployeeLastName,
    w.enter_date
INTO #Employees2007
FROM works_on AS w
JOIN employee AS e
    ON w.emp_no = e.emp_no
WHERE YEAR(w.enter_date) = 2007
  AND MONTH(w.enter_date) BETWEEN 7 AND 12;

PRINT '–≈«”Ћ№“ј“ «ј¬ƒјЌЌя 6';
SELECT * FROM #Employees2007;



---------------------------------------------------------
-- «ј¬ƒјЌЌя 7 Ч √лобальна таблиц€ + оновленн€ дати
-- ќпис: створити глобальну тимчасову таблицю з ус≥ма записами
--       з works_on за 2007Ц2008 роки та оновити дату початку
--       роботи над проЇктом дл€ сп≥вроб≥тника з emp_no = 29346
--       на 2006-01-06.
---------------------------------------------------------

SELECT *
INTO ##EmployeesProjects
FROM works_on AS w
WHERE YEAR(w.enter_date) BETWEEN 2007 AND 2008;

UPDATE ##EmployeesProjects
SET enter_date = '2006-01-06'
WHERE emp_no = 29346;

PRINT '–≈«”Ћ№“ј“ «ј¬ƒјЌЌя 7';
SELECT * FROM ##EmployeesProjects;



---------------------------------------------------------
-- «ј¬ƒјЌЌя 8 Ч “аблична зм≥нна + новий прац≥вник Kohn
-- ќпис: створити табличну зм≥нну з ус≥ма сп≥вроб≥тниками,
--       у €ких emp_no < 10000, а пот≥м додати нового
--       сп≥вроб≥тника з пр≥звищем Kohn (emp_no = 22123),
--       €кий працюЇ у в≥дд≥л≥ d3.
---------------------------------------------------------

DECLARE @Emp TABLE (
    emp_no    INT,
    emp_fname NVARCHAR(50),
    emp_lname NVARCHAR(50),
    dept_no   CHAR(2)
);

INSERT INTO @Emp (emp_no, emp_fname, emp_lname, dept_no)
SELECT emp_no, emp_fname, emp_lname, dept_no
FROM employee
WHERE emp_no < 10000;

INSERT INTO @Emp (emp_no, emp_fname, emp_lname, dept_no)
VALUES (22123, NULL, 'Kohn', 'd3');

PRINT '–≈«”Ћ№“ј“ «ј¬ƒјЌЌя 8';
SELECT * FROM @Emp;