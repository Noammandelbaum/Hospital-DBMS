CREATE TABLE Departments (
    DepartmentID INT NOT NULL,
    DepartmentName VARCHAR2(15) NOT NULL,
    BuildingName VARCHAR2(15) NOT NULL,
    Floor INT NOT NULL,
    Phone VARCHAR2(13) NOT NULL,
    TotalBeds INT,
    OccupiedBeds INT,
    HeadOfDepartment VARCHAR2(15) NOT NULL,
    PRIMARY KEY (DepartmentID)
);

CREATE TABLE Doctors (
    DoctorID INT NOT NULL,
    FirstName VARCHAR2(15) NOT NULL,
    LastName VARCHAR2(15) NOT NULL,
    Specialty VARCHAR2(15) NOT NULL,
    Phone VARCHAR2(13) NOT NULL,
    DateOfBirth DATE NOT NULL,
    HireDate DATE NOT NULL,
    Salary INT NOT NULL,
    DistanceFromHospital FLOAT NOT NULL,
    DepartmentID INT NOT NULL,
    PRIMARY KEY (DoctorID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Patients (
    PatientID INT NOT NULL,
    FirstName VARCHAR2(15) NOT NULL,
    LastName VARCHAR2(15) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    Phone VARCHAR2(13) NOT NULL,
    AdmissionDate DATE NOT NULL,
    ReleaseDate DATE,
    Address VARCHAR2(15) NOT NULL,
    DepartmentID INT NOT NULL,
    PRIMARY KEY (PatientID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE PatientDoctor (
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    PRIMARY KEY (PatientID, DoctorID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
