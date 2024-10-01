-- Query 1: Increase salary by 10% for the 10 doctors with the most patients treated in the last 3 years.

SELECT d.DoctorID, d.FirstName || ' ' || d.LastName AS DoctorName, d.Salary, COUNT(pd.PatientID) AS NumPatients,
       d.DepartmentID, dep.DepartmentName
FROM Doctors d
JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
JOIN Patients p ON pd.PatientID = p.PatientID
JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
WHERE EXTRACT(YEAR FROM p.AdmissionDate) BETWEEN EXTRACT(YEAR FROM SYSDATE) - 3 AND EXTRACT(YEAR FROM SYSDATE)
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Salary, d.DepartmentID, dep.DepartmentName
ORDER BY NumPatients DESC, d.DoctorID ASC
FETCH FIRST 10 ROWS ONLY;


UPDATE Doctors
SET Salary = Salary * 1.1
WHERE DoctorID IN (
    SELECT DoctorID
    FROM (
        SELECT d.DoctorID, COUNT(pd.PatientID) AS NumPatients
        FROM Doctors d
        JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
        JOIN Patients p ON pd.PatientID = p.PatientID
        JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
        WHERE EXTRACT(YEAR FROM p.AdmissionDate) BETWEEN EXTRACT(YEAR FROM SYSDATE) - 3 AND EXTRACT(YEAR FROM SYSDATE)
        GROUP BY d.DoctorID, d.DepartmentID, dep.DepartmentName
        ORDER BY NumPatients DESC, d.DoctorID ASC
        FETCH FIRST 10 ROWS ONLY
    )
);


SELECT d.DoctorID, d.FirstName || ' ' || d.LastName AS DoctorName, d.Salary, COUNT(pd.PatientID) AS NumPatients,
       d.DepartmentID, dep.DepartmentName
FROM Doctors d
JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
JOIN Patients p ON pd.PatientID = p.PatientID
JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
WHERE EXTRACT(YEAR FROM p.AdmissionDate) BETWEEN EXTRACT(YEAR FROM SYSDATE) - 3 AND EXTRACT(YEAR FROM SYSDATE)
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Salary, d.DepartmentID, dep.DepartmentName
ORDER BY NumPatients DESC, d.DoctorID ASC
FETCH FIRST 10 ROWS ONLY;


-- Query 2: Increase salary by 15% for doctors in departments where the average
-- salary-to-experience ratio is below the overall average.

SELECT dp.DepartmentID, dp.DepartmentName, 
       ROUND(AVG(d.Salary), 2) AS AverageSalary, 
       ROUND(AVG(MONTHS_BETWEEN(SYSDATE, d.HireDate) / 12), 2) AS AverageExperience,
       ROUND(AVG(d.Salary) / NULLIF(AVG(MONTHS_BETWEEN(SYSDATE, d.HireDate) / 12), 0), 2) AS SalaryPerYearExperience
FROM Departments dp
JOIN Doctors d ON dp.DepartmentID = d.DepartmentID
GROUP BY dp.DepartmentID, dp.DepartmentName;


UPDATE Doctors d
SET d.Salary = d.Salary * 1.15
WHERE d.DepartmentID IN (
    SELECT dp.DepartmentID
    FROM Departments dp
    JOIN Doctors d2 ON dp.DepartmentID = d2.DepartmentID
    GROUP BY dp.DepartmentID
    HAVING ROUND(AVG(d2.Salary) / NULLIF(AVG(MONTHS_BETWEEN(SYSDATE, d2.HireDate) / 12), 0), 2) < (
        SELECT ROUND(AVG(d3.Salary) / NULLIF(AVG(MONTHS_BETWEEN(SYSDATE, d3.HireDate) / 12), 0), 2)
        FROM Doctors d3
    )
);


SELECT dp.DepartmentID, dp.DepartmentName, 
       ROUND(AVG(d.Salary), 2) AS AverageSalary, 
       ROUND(AVG(MONTHS_BETWEEN(SYSDATE, d.HireDate) / 12), 2) AS AverageExperience,
       ROUND(AVG(d.Salary) / NULLIF(AVG(MONTHS_BETWEEN(SYSDATE, d.HireDate) / 12), 0), 2) AS SalaryPerYearExperience
FROM Departments dp
JOIN Doctors d ON dp.DepartmentID = d.DepartmentID
GROUP BY dp.DepartmentID, dp.DepartmentName;


ROLLBACK;
