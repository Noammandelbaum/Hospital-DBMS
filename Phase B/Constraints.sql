-- 1: Ensure OccupiedBeds does not exceed TotalBeds in Departments
ALTER TABLE Departments
ADD CONSTRAINT chk_beds CHECK (TotalBeds >= OccupiedBeds);

-- 2: Set default Salary to 5000 in Doctors
ALTER TABLE Doctors
MODIFY Salary DEFAULT 5000;

-- 3: Ensure Salary is greater than 0 in Doctors
ALTER TABLE Doctors
ADD CONSTRAINT chk_salary CHECK (Salary > 0);

-- 4: Ensure DistanceFromHospital is 100 km or less in Doctors
ALTER TABLE Doctors
ADD CONSTRAINT chk_doctor_distance CHECK (
    DistanceFromHospital <= 100
);

-- 5: Ensure doctor is at least 18 years old at hire in Doctors
ALTER TABLE Doctors
ADD CONSTRAINT chk_doctor_age CHECK (
    (HireDate - DateOfBirth) / 365 >= 18
);

-- 6: Ensure ReleaseDate >= AdmissionDate or is NULL in Patients
ALTER TABLE Patients
ADD CONSTRAINT chk_release_date CHECK (ReleaseDate >= AdmissionDate OR ReleaseDate IS NULL);


-- 7: Modify PatientDoctor to cascade delete related records when a patient is deleted.
ALTER TABLE PatientDoctor
DROP CONSTRAINT fk_patient; 

ALTER TABLE PatientDoctor
ADD CONSTRAINT fk_patient FOREIGN KEY (PatientID)
REFERENCES Patients(PatientID) ON DELETE CASCADE;
