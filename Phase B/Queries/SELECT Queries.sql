-- Query 1: Identify departments that may need additional doctor support in emergencies
-- by analyzing the patient-to-doctor ratio within 20 km and workload in each department.
SELECT
    dp.DepartmentID,
    dp.DepartmentName,
    dp.TotalBeds,
    dp.OccupiedBeds,
    COUNT(DISTINCT d.DoctorID) AS NumberOfNearbyDoctors,
    COUNT(DISTINCT p.PatientID) AS NumberOfPatients,
    (COUNT(DISTINCT p.PatientID) / NULLIF(COUNT(DISTINCT d.DoctorID), 0)) AS PatientsPerDoctor,
    (dp.OccupiedBeds / NULLIF(dp.TotalBeds, 0)) * 100 AS OccupancyRate,
    dp.HeadOfDepartment,
    dp.Phone
FROM
    Departments dp
    LEFT JOIN Doctors d ON dp.DepartmentID = d.DepartmentID AND d.DistanceFromHospital <= 20
    LEFT JOIN Patients p ON dp.DepartmentID = p.DepartmentID AND p.ReleaseDate IS NULL
WHERE
    dp.TotalBeds IS NOT NULL AND dp.OccupiedBeds IS NOT NULL
    
GROUP BY
    dp.DepartmentID,
    dp.DepartmentName,
    dp.TotalBeds,
    dp.OccupiedBeds,
    dp.HeadOfDepartment,
    dp.Phone
HAVING
    (COUNT(DISTINCT d.DoctorID) = 0)
    OR ((COUNT(DISTINCT p.PatientID) / NULLIF(COUNT(DISTINCT d.DoctorID), 0)) > 5)
ORDER BY
    OccupancyRate DESC,
    PatientsPerDoctor DESC;


-- Query 2: List upcoming birthdays of doctors in the next month,
-- including their current patients, organized by departments for event planning.
SELECT
    d.DoctorID,
    d.FirstName || ' ' || d.LastName AS DoctorName,
    dp.DepartmentID,
    dp.DepartmentName,
    EXTRACT(DAY FROM d.DateOfBirth) AS BirthDay,
    EXTRACT(MONTH FROM d.DateOfBirth) AS BirthMonth,
    COUNT(DISTINCT p.PatientID) AS NumberOfCurrentPatients
FROM
    Doctors d
    JOIN Departments dp ON d.DepartmentID = dp.DepartmentID
    LEFT JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
    LEFT JOIN Patients p ON pd.PatientID = p.PatientID AND p.ReleaseDate IS NULL
WHERE
    EXTRACT(MONTH FROM d.DateOfBirth) = EXTRACT(MONTH FROM SYSDATE)
    OR EXTRACT(MONTH FROM d.DateOfBirth) = EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, 1))
GROUP BY
    d.DoctorID,
    d.FirstName,
    d.LastName,
    dp.DepartmentID,
    dp.DepartmentName,
    d.DateOfBirth
ORDER BY
    dp.DepartmentID,
    BirthMonth,
    BirthDay;


-- Query 3: Identify departments with high patient load where most doctors have less than
-- two years of experience to assess training or staffing needs.
SELECT
    dp.DepartmentID,
    dp.DepartmentName,
    ROUND(AVG(d.Salary), 2) AS AverageSalary,
    ROUND(AVG(MONTHS_BETWEEN(SYSDATE, d.HireDate) / 12), 2) AS AverageExperience,
    ROUND((AVG(d.Salary) / NULLIF(AVG(MONTHS_BETWEEN(SYSDATE, d.HireDate) / 12), 0)), 2) AS SalaryPerYearExperience,
    COUNT(d.DoctorID) AS NumberOfDoctors
FROM
    Departments dp
    JOIN Doctors d ON dp.DepartmentID = d.DepartmentID
GROUP BY
    dp.DepartmentID,
    dp.DepartmentName
HAVING
    COUNT(d.DoctorID) > 0
ORDER BY
    SalaryPerYearExperience DESC
FETCH FIRST 5 ROWS ONLY;


-- Query 4: Determine the number of doctors over 60 in each department,
-- their patient workload, and assess the need to train younger doctors for continuity of care.
SELECT
    dp.DepartmentID,
    dp.DepartmentName,
    COUNT(d.DoctorID) AS TotalDoctors,
    COUNT(CASE WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, d.DateOfBirth) / 12) >= 60 THEN d.DoctorID END) AS DoctorsOver60,
    ROUND(AVG(FLOOR(MONTHS_BETWEEN(SYSDATE, d.DateOfBirth) / 12)), 2) AS AverageAge,
    ROUND(AVG(CASE WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, d.DateOfBirth) / 12) >= 60 THEN d.Salary END), 2) AS AverageSalaryOver60,
    ROUND(AVG(CASE WHEN d_over60.DoctorID IS NOT NULL THEN d_over60.NumPatients END), 2) AS AveragePatientsPerDoctorOver60
FROM
    Departments dp
    JOIN Doctors d ON dp.DepartmentID = d.DepartmentID
    LEFT JOIN (
        SELECT
            d.DoctorID,
            COUNT(DISTINCT pd.PatientID) AS NumPatients
        FROM
            Doctors d
            LEFT JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
        WHERE
            FLOOR(MONTHS_BETWEEN(SYSDATE, d.DateOfBirth) / 12) >= 60
        GROUP BY
            d.DoctorID
    ) d_over60 ON d.DoctorID = d_over60.DoctorID
GROUP BY
    dp.DepartmentID,
    dp.DepartmentName
HAVING
    COUNT(CASE WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, d.DateOfBirth) / 12) >= 60 THEN d.DoctorID END) > 0
ORDER BY
    DoctorsOver60 DESC;

