create database Sample;
GO
use Sample;
create table department (
dept_no varchar(10) not null primary key,
dept_name varchar(50),
location varchar(50)
);
create table employee (
emp_no int not null primary key,
emp_fname varchar(50) not null,
emp_lname varchar(50) not null,
dept_no varchar(10) foreign key references department(dept_no)
);
create table project (
project_no varchar(10) not null primary key,
project_name varchar(50),
budget money
);
create table works_on (
emp_no int foreign key references employee(emp_no),
project_no varchar(10) foreign key references project(project_no),
job varchar(50),
enter_date date,
constraint PK_works_on primary key (emp_no, project_no)
);
GO
insert into department values ('d1', 'research', 'Dallas'),
('d2', 'accounting', 'Seattle'),
('d3', 'marketing', 'Dallas');
insert into employee values (2581, 'Elke', 'Hansel', 'd2'),
(9031, 'Elsa', 'Bertoni', 'd2'),
(10102, 'Ann', 'Jones', 'd3'),
(18316, 'John', 'Barrimore', 'd1'),
(25348, 'Matthew', 'Smith', 'd3'),
(28559, 'Sybill', 'Moser', 'd1'),
(29346, 'James', 'James', 'd2');
insert into project values ('p1', 'Appolo', 120000),
('p2', 'Gemini', 95000),
('p3', 'Mercury', 186500);
insert into works_on values (2581, 'p3', 'analyst', '2007-10-15'),
(9031, 'p1', 'manager', '2007-04-15'),
(9031, 'p3', 'clerk', '2006-11-15'),
(10102, 'p1', 'analyst', '2006-10-01'),
(10102, 'p3', 'manager', '2008-01-01'),
(18316, 'p2', null, '2007-06-01'),
(25348, 'p2', 'clerk', '2007-02-15'),
(28559, 'p1', null, '2007-08-01'),
(28559, 'p2', 'clerk', '2008-02-01'),
(29346, 'p1', 'clerk', '2007-01-04'),
(29346, 'p2', null, '2006-12-15');