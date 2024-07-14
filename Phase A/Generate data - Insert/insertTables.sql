-- Inserting data into the Departments table
INSERT INTO Departments (DepartmentID, DepartmentName, BuildingName, Floor, Phone, TotalBeds, OccupiedBeds, HeadOfDepartment) VALUES
(1, 'Cardiology', 'Building A', 1, '0256739812', 50, 30, 'John Doe');
INSERT INTO Departments (DepartmentID, DepartmentName, BuildingName,Floor , Phone, TotalBeds, OccupiedBeds, HeadOfDepartment) VALUES
(2, 'Neurology', 'Building B', 2, '0256739813', 40, 20, 'Jane Smith');
INSERT INTO Departments (DepartmentID, DepartmentName, BuildingName, Floor, Phone, TotalBeds, OccupiedBeds, HeadOfDepartment) VALUES
(3, 'Oncology', 'Building C', 3, '0256739814', 60, 40, 'Jim Beam');

-- Inserting data into the Doctors table
INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialty, Phone, DateOfBirth, HireDate, Salary, DistanceFromHospital, DepartmentID) VALUES
(1, 'Alice', 'Johnson', 'Cardiology', '0587677615', TO_DATE('1975-05-20', 'YYYY-MM-DD'), TO_DATE('2000-06-15', 'YYYY-MM-DD'), 120000, 10, 1);
INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialty, Phone, DateOfBirth, HireDate, Salary, DistanceFromHospital, DepartmentID) VALUES
(2, 'Bob', 'Williams', 'Neurology', '0587677616', TO_DATE('1980-11-10', 'YYYY-MM-DD'), TO_DATE('2005-09-01', 'YYYY-MM-DD'), 110000, 20, 2);
INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialty, Phone, DateOfBirth, HireDate, Salary, DistanceFromHospital, DepartmentID) VALUES
(3, 'Charlie', 'Brown', 'Oncology', '0587677617', TO_DATE('1985-02-25', 'YYYY-MM-DD'), TO_DATE('2010-03-20', 'YYYY-MM-DD'), 130000, 15, 3);

-- Inserting data into the Patients table
INSERT INTO Patients (PatientID, FirstName, LastName, DateOfBirth, Gender, Phone, AdmissionDate, ReleaseDate, Address, DepartmentID) VALUES
(1, 'David', 'Smith', TO_DATE('1990-04-12', 'YYYY-MM-DD'), 'M', '0587677618', TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-10', 'YYYY-MM-DD'), '123 Elm St', 1);
INSERT INTO Patients (PatientID, FirstName, LastName, DateOfBirth, Gender, Phone, AdmissionDate, ReleaseDate, Address, DepartmentID) VALUES
(2, 'Eva', 'Green', TO_DATE('1985-08-15', 'YYYY-MM-DD'), 'F', '0587677619', TO_DATE('2024-06-20', 'YYYY-MM-DD'), TO_DATE('2024-07-05', 'YYYY-MM-DD'), '456 Oak St', 2);
INSERT INTO Patients (PatientID, FirstName, LastName, DateOfBirth, Gender, Phone, AdmissionDate, ReleaseDate, Address, DepartmentID) VALUES
(3, 'Frank', 'White', TO_DATE('1978-12-22', 'YYYY-MM-DD'), 'M', '0587677620', TO_DATE('2024-05-10', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), '789 Pine St', 3);

-- Inserting data into the PatientDoctor table
INSERT INTO PatientDoctor (PatientID, DoctorID) VALUES
(1, 1);
INSERT INTO PatientDoctor (PatientID, DoctorID) VALUES
(2, 2);
INSERT INTO PatientDoctor (PatientID, DoctorID) VALUES
(3, 3);
COMMIT;
