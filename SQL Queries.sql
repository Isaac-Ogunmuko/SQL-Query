/* =======================================================================
   Project: Company Database Analytics & Data Manipulation
   Author: Isaac Ogunmuko
   Description: A comprehensive suite of SQL queries handling data 
                retrieval, complex joins, subqueries, and DML operations 
                for a standard corporate organizational schema.
   ======================================================================= */

USE company;

/* ================================================================================================================
Data Population & Testing: Populate base employee directory records for schema validation
================================================================================================================= */
INSERT INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES ('Kendrick', 'L', 'Lamar', '999001111', '1987-06-17', '11120 Compton Ave, Los Angeles, CA', 'M', 55000, '888665555', 5);

/* =================================================================================================================
 Compensation Benchmarking: Extract personnel tied to the top-earning department using nested aggregation subqueries
==================================================================================================================== */
SELECT Lname
FROM EMPLOYEE
ORDER BY Lname ASC;

/* =================================================================================================================
Compensation Forecasting: Model a 15% merit adjustment for project 'ProductY' personnel
================================================================================================================= */
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Dno = (
    SELECT Dno
    FROM EMPLOYEE
    WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE)
);

/* ==========================================================================================================
Stakeholder Project Mapping: Isolate project keys linked to 'Smith' via direct work or departmental oversight
============================================================================================================= */
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Super_ssn = '888665555';

/* ================================================================================================================
Data Maintenance: Execute targeted department decommissioning and structural cleanup
================================================================================================================ */
SELECT E.Fname, E.Lname, E.Salary AS Current_Salary,
       E.Salary * 1.15 AS Raised_Salary
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
JOIN PROJECT P ON W.Pno = P.Pnumber
WHERE P.Pname = 'ProductY';

/* ======================================================================================================
Department Roster Extraction: Filter employee directory for Headquarters location contact details
====================================================================================================== */
SELECT E.Fname, E.Lname, E.Address
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Dno = D.Dnumber
WHERE D.Dname = 'Headquarters';

/* ============================================================================================
Data Maintenance: Correct employee demographic records for compliance
============================================================================================ */
UPDATE EMPLOYEE
SET Bdate = '1965-01-08'
WHERE Ssn = '999001111';

/* =================================================================================================
Regional Reporting: Fetch project management and department leadership details for Stafford location
==================================================================================================== */
SELECT P.Pnumber, P.Dnum,
       E.Lname AS Manager_Lname,
       E.Address AS Manager_Address,
       E.Bdate AS Manager_Bdate
FROM PROJECT P
JOIN DEPARTMENT D ON P.Dnum = D.Dnumber
JOIN EMPLOYEE E ON D.Mgr_ssn = E.Ssn
WHERE P.Plocation = 'Stafford';

/* ======================================================================================================================
Organizational Hierarchy Mapping: Self-join to extract employee-to-supervisor reporting structures across all departments
========================================================================================================================= */
SELECT E.Fname AS Emp_Fname, E.Lname AS Emp_Lname,
       S.Fname AS Sup_Fname, S.Lname AS Sup_Lname
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE S ON E.Super_ssn = S.Ssn;

/* ================================================================================================================================
Cross-Functional Project Audit: Identify all active project IDs linked to 'Smith' through direct assignment or department oversight
=================================================================================================================================== */
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

/* =======================================================================================================================
Resource Allocation Reporting: Generate employee-project assignments sorted hierarchically by department and employee name
========================================================================================================================== */
SELECT E.Dno, E.Lname, E.Fname, P.Pname
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
JOIN PROJECT P ON W.Pno = P.Pnumber
ORDER BY E.Dno ASC, E.Lname ASC, E.Fname ASC;

/* ==================================================================
Data Seeding: Populate new functional departments and assigned management
================================================================== */
INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES
('Marketing',        11, '666666601', '2000-07-22'),
('Human Resources',  12, '987654321', '2010-04-02'),
('Finance',          13, '444444402', '2012-07-12'),
('Operations',       14, '666666602', '2024-05-22'),
('Customer Service', 15, '666666600', '2020-05-22');

/* ================================================================
Schema Cleanup: Remove inactive or restructured departments from database
================================================================ */
DELETE FROM DEPARTMENT
WHERE Dname = 'Operations';


