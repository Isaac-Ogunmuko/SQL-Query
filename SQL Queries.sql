/* =======================================================================
   Project: Company Database Analytics & Data Manipulation
   Author: Isaac Ogunmuko
   Description: A comprehensive suite of SQL queries handling data 
                retrieval, complex joins, subqueries, and DML operations 
                for a standard corporate organizational schema.
   ======================================================================= */

USE company;

/* ================================================================================================================
Seed initial employee records into the EMPLOYEE table
================================================================================================================= */
INSERT INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES ('Kendrick', 'L', 'Lamar', '999001111', '1987-06-17', '11120 Compton Ave, Los Angeles, CA', 'M', 55000, '888665555', 5);

/* ==========================================================================================
 Identify employees belonging to the highest-earning department
========================================================================================== */
SELECT Lname
FROM EMPLOYEE
ORDER BY Lname ASC;

/* =================================================================================================================
Simulate a 15% salary increase for the 'ProductY' project team
================================================================================================================= */
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Dno = (
    SELECT Dno
    FROM EMPLOYEE
    WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE)
);

/* =========================================================================================================
 Extract project IDs associated with 'Smith' as a worker or manager
========================================================================================================= */
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Super_ssn = '888665555';

/* ================================================================================================================
 Clean up organizational structure by removing the Operations department
================================================================================================================ */
SELECT E.Fname, E.Lname, E.Salary AS Current_Salary,
       E.Salary * 1.15 AS Raised_Salary
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
JOIN PROJECT P ON W.Pno = P.Pnumber
WHERE P.Pname = 'ProductY';

/* ======================================================================================================
 Question 6: Retrieve the name and address of all employees who work for the 'Headquarters' department.
====================================================================================================== */
SELECT E.Fname, E.Lname, E.Address
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Dno = D.Dnumber
WHERE D.Dname = 'Headquarters';

/* ============================================================================================
 Question 7: Write a query to update the birth date of the employee whose ssn is '999001111'. 
 The new birth date is '1965-01-08'
============================================================================================ */
UPDATE EMPLOYEE
SET Bdate = '1965-01-08'
WHERE Ssn = '999001111';

/* =============================================================================================
 Question 8: For every project located in ‘Stafford’, list the project number, the controlling 
 department number, and the department manager’s last name, address, and birth date.
============================================================================================= */
SELECT P.Pnumber, P.Dnum,
       E.Lname AS Manager_Lname,
       E.Address AS Manager_Address,
       E.Bdate AS Manager_Bdate
FROM PROJECT P
JOIN DEPARTMENT D ON P.Dnum = D.Dnumber
JOIN EMPLOYEE E ON D.Mgr_ssn = E.Ssn
WHERE P.Plocation = 'Stafford';

/* ==========================================================================
 Question 9: For each employee, retrieve the employee’s first and last name 
 and the first and last name of his or her immediate supervisor
========================================================================== */
SELECT E.Fname AS Emp_Fname, E.Lname AS Emp_Lname,
       S.Fname AS Sup_Fname, S.Lname AS Sup_Lname
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE S ON E.Super_ssn = S.Ssn;

/* ================================================================================================
 Question 10: Make a list of all project numbers for projects that involve an employee whose last 
 name is ‘Smith’, either as a worker or as a manager of the department that controls the project.
================================================================================================ */
SELECT DISTINCT P.Pnumber
FROM PROJECT P
WHERE P.Pnumber IN (
    SELECT W.Pno
    FROM WORKS_ON W
    JOIN EMPLOYEE E ON W.Essn = E.Ssn
    WHERE E.Lname = 'Smith'
)
OR P.Pnumber IN (
    SELECT P2.Pnumber
    FROM PROJECT P2
    JOIN DEPARTMENT D ON P2.Dnum = D.Dnumber
    JOIN EMPLOYEE E ON D.Mgr_ssn = E.Ssn
    WHERE E.Lname = 'Smith'
);

/* ================================================================================================
 Question 11: Retrieve a list of employees and the projects they are working on, ordered 
 by department and, within each department, ordered alphabetically by last name, then first name.
================================================================================================ */
SELECT E.Dno, E.Lname, E.Fname, P.Pname
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
JOIN PROJECT P ON W.Pno = P.Pnumber
ORDER BY E.Dno ASC, E.Lname ASC, E.Fname ASC;

/* ==================================================================
 Question 12: Write a query to insert the following new departments
================================================================== */
INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES
('Marketing',        11, '666666601', '2000-07-22'),
('Human Resources',  12, '987654321', '2010-04-02'),
('Finance',          13, '444444402', '2012-07-12'),
('Operations',       14, '666666602', '2024-05-22'),
('Customer Service', 15, '666666600', '2020-05-22');

/* ================================================================
 Question 13:Write a query to delete the ‘Operations’ department.
================================================================ */
DELETE FROM DEPARTMENT
WHERE Dname = 'Operations';