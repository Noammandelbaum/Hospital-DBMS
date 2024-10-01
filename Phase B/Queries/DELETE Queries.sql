-- Query 1: The hospital management wants to delete records of patients 
-- who were released more than 3 years ago and have not been re-admitted since,
-- provided all their treating doctors have more than 5 years of experience at the hospital.

SELECT p.PatientID, p.FirstName, p.LastName, p.ReleaseDate
FROM Patients p
WHERE p.ReleaseDate < ADD_MONTHS(SYSDATE, -36)
AND NOT EXISTS (
    SELECT 1
    FROM PatientDoctor pd2
    JOIN Patients p2 ON pd2.PatientID = p2.PatientID
    WHERE pd2.PatientID = p.PatientID
    AND p2.AdmissionDate > p.ReleaseDate
)
AND NOT EXISTS (
    SELECT 1
    FROM PatientDoctor pd
    JOIN Doctors d ON pd.DoctorID = d.DoctorID
    WHERE pd.PatientID = p.PatientID
    AND d.HireDate >= ADD_MONTHS(SYSDATE, -60)
);

DELETE FROM Patients p
WHERE p.PatientID IN (
    SELECT p.PatientID
    FROM Patients p
    WHERE p.ReleaseDate < ADD_MONTHS(SYSDATE, -36)
    AND NOT EXISTS (
        SELECT 1
        FROM PatientDoctor pd2
        JOIN Patients p2 ON pd2.PatientID = p2.PatientID
        WHERE pd2.PatientID = p.PatientID
        AND p2.AdmissionDate > p.ReleaseDate
    )
    AND NOT EXISTS (
        SELECT 1
        FROM PatientDoctor pd
        JOIN Doctors d ON pd.DoctorID = d.DoctorID
        WHERE pd.PatientID = p.PatientID
        AND d.HireDate >= ADD_MONTHS(SYSDATE, -60)
    )
);

SELECT p.PatientID, p.FirstName, p.LastName, p.ReleaseDate
FROM Patients p
WHERE p.ReleaseDate < ADD_MONTHS(SYSDATE, -36)
AND NOT EXISTS (
    SELECT 1
    FROM PatientDoctor pd2
    JOIN Patients p2 ON pd2.PatientID = p2.PatientID
    WHERE pd2.PatientID = p.PatientID
    AND p2.AdmissionDate > p.ReleaseDate
)
AND NOT EXISTS (
    SELECT 1
    FROM PatientDoctor pd
    JOIN Doctors d ON pd.DoctorID = d.DoctorID
    WHERE pd.PatientID = p.PatientID
    AND d.HireDate >= ADD_MONTHS(SYSDATE, -60)
);


-- Query 2: As part of an efficiency process, the hospital intends to remove doctors
-- from less active departments who currently have no patients.

SELECT d.DoctorID, d.FirstName || ' ' || d.LastName AS DoctorName, d.DepartmentID, dep.DepartmentName, dep.OccupiedBeds
FROM Doctors d
LEFT JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
WHERE pd.PatientID IS NULL
  AND dep.OccupiedBeds < (
      SELECT AVG(OccupiedBeds) FROM Departments
  )
ORDER BY d.DepartmentID;

DELETE FROM Doctors
WHERE DoctorID IN (
    SELECT d.DoctorID
    FROM Doctors d
    LEFT JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
    JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
    WHERE pd.PatientID IS NULL
      AND dep.OccupiedBeds < (
          SELECT AVG(OccupiedBeds) FROM Departments
      )
);

SELECT d.DoctorID, d.FirstName || ' ' || d.LastName AS DoctorName, d.DepartmentID, dep.DepartmentName, dep.OccupiedBeds
FROM Doctors d
LEFT JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
WHERE pd.PatientID IS NULL
  AND dep.OccupiedBeds < (
      SELECT AVG(OccupiedBeds) FROM Departments
  )
ORDER BY d.DepartmentID;


ROLLBACK;
