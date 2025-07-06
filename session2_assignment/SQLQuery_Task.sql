--create database
create database Task;

-----------------------------------------------------------------------------------

--active database
use Task

-----------------------------------------------------------------------------------

--create employee table
CREATE TABLE EMPLOYEE (
    SSN INT PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    LName NVARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender CHAR(1),
    Super_SSN INT,
    DNum INT
);

--create department table
CREATE TABLE Department (
    DNum INT PRIMARY KEY,
    DName VARCHAR(100)
);

--create department locations table to control multi value property (locations)
CREATE TABLE Department_Locations (
    DNum INT,
    Location VARCHAR(100),
    PRIMARY KEY (DNum, Location),
    FOREIGN KEY (DNum) REFERENCES Department(DNum)
);

--create project table
CREATE TABLE Project (
    PNum INT PRIMARY KEY,
    PName NVARCHAR(100),
    City NVARCHAR(100),
    DNum INT,
    FOREIGN KEY (DNum) REFERENCES Department(DNum)
);

--create dependent table (weak entity)
CREATE TABLE Dependent (
    Name NVARCHAR(100),
    Employee_SSN INT,
    Gender CHAR(1),
    BirthDate DATE,
    PRIMARY KEY (Name, Employee_SSN),
    FOREIGN KEY (Employee_SSN) REFERENCES Employee(SSN)
);

--create departement manager table to control relation between department and manager 
CREATE TABLE Department_Manager (
    DNum INT PRIMARY KEY,
    Manager_SSN INT,
    HireDate DATE,
    FOREIGN KEY (DNum) REFERENCES Department(DNum),
    FOREIGN KEY (Manager_SSN) REFERENCES Employee(SSN)
);

--create work table to control relation between project and employee
CREATE TABLE Work (
    Employee_SSN INT,
    PNum INT,
    Working_Hours INT,
    PRIMARY KEY (Employee_SSN, PNum),
    FOREIGN KEY (Employee_SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (PNum) REFERENCES Project(PNum)
);

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--Insert sample data into DEPARTMENT table (at least 3 departments)
INSERT INTO Department (DNum, DName) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Finance'),
(4, 'Developing');

--Insert sample data into EMPLOYEE table (at least 5 employees)
INSERT INTO Employee (SSN, FName, LName, Gender, BirthDate, Super_SSN, DNum) VALUES
('123456789', 'Seif', 'Allithy', 'M', '04/01/2004', NULL, 1),
('234567891', 'Karim', 'Essam', 'M', '01/01/2001', '123456789', 4),
('345678912', 'Shahd', 'Mohamed', 'F', '05/08/1999', '345678912', 2),
('456789123', 'Maryam', 'Sayed', 'F', '12/11/1980', '123456789', 3),
('567891234', 'Osama', 'Waleed', 'M', '02/02/2002', '456789123', 4);

--Update an employee's department
UPDATE Employee
SET DNum = 3
WHERE SSN = '567891234';

--Insert sample data into DEPENDENT
INSERT INTO DEPENDENT (Employee_SSN, Name, Gender, BirthDate) VALUES 
('123456789', 'Fatema Seif', 'F', '01/01/2030'),
('345678912', 'Ahmed Mohamed', 'M', '02/02/2010');

--Delete a dependent record
DELETE FROM Dependent
WHERE Name = 'Fatema Seif' AND Employee_SSN = '123456789';

--Retrieve all employees working in a specific department
SELECT SSN, FName+' '+LName as [Full Name], DNum ,Gender, BirthDate, Super_SSN
FROM Employee
WHERE DNum = 3;

--Insert sample data into Project
INSERT INTO Project (PNum, PName, City, DNum) VALUES
(100, 'Payroll System', 'Alex', 1),
(101, 'Exmination Wedsite', 'Cairo', 4),
(102, 'E-Commerce', 'Benha', 4);

--Insert sample data into Work
INSERT INTO Work (Employee_SSN, PNum, Working_Hours) VALUES
('123456789', 100, 10),
('234567891', 101, 20), 
('234567891', 102, 15);

--Find all employees and their project assignments with working hours ( self study "join")
SELECT E.SSN, E.FName, E.LName,P.PName, W.Working_Hours
FROM 
Employee E
JOIN Work W ON E.SSN = W.Employee_SSN
JOIN Project P ON W.PNum = P.PNum;