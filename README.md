# Hospital Database Management System (DBMS)

## Overview
This project is a **Database Management System (DBMS)** developed in **Oracle SQL** to optimize hospital operations. The system manages patients, doctors, and departments, facilitating efficient data handling, analysis, and decision-making.

## Features
- **Visual Database Design**:
  - Developed detailed **Entity-Relationship Diagrams (ERD)** to plan database structure.
  - Created **Data Structure Diagrams (DSD)** to define logical relationships and ensure normalization.
- **Relational Database Design**: 
  - Fully normalized database structure (up to 3NF).
  - Ensures data integrity and optimized storage.

- **Core Functionalities**:
  - Patient admissions and discharges.
  - Doctor performance tracking and departmental analysis.
  - Management of occupied and available hospital beds.
  - Modular system to ensure ease of maintenance and scalability.

- **Advanced Query Implementation**:
  - Complex `SELECT`, `INSERT`, `UPDATE`, and `DELETE` queries.
  - Includes advanced calculations such as doctor performance metrics and percentile evaluations.

- **Performance Metrics**:
  - Developed a robust system for analyzing doctor performance based on treatment times and patient loads.
  - Implemented percentile-based classification (e.g., Top 10%, 20%) with automated salary adjustments for top performers.
  - Clear and detailed reporting of results.

- **Automation**:
  - Python scripts for data population and validation, ensuring efficient system setup and scalability.

- **Exception Handling**:
  - Designed functions and procedures to address errors and ensure seamless operation during outlier scenarios.- **Visual Database Design**:
  - Developed detailed **Entity-Relationship Diagrams (ERD)** to plan database structure.
  - Created **Data Structure Diagrams (DSD)** to define logical relationships and ensure normalization.
- **Relational Database Design**: 
  - Fully normalized database structure (up to 3NF).
  - Ensures data integrity and optimized storage.

- **Core Functionalities**:
  - Patient admissions and discharges.
  - Doctor performance tracking and departmental analysis.
  - Management of occupied and available hospital beds.

- **Advanced Query Implementation**:
  - Complex `SELECT`, `INSERT`, `UPDATE`, and `DELETE` queries.
  - Support for real-time data analysis and reporting.

- **Performance Metrics**:
  - Calculation of doctor performance metrics, including percentile-based evaluations.
  - Identification of underperforming or overloaded departments.

- **Automation**:
  - Python scripts for data population and validation, ensuring efficient system setup and scalability.

## Schema Overview
The database consists of four main entities:
1. **Departments**:
   - Attributes: DepartmentID, Name, Building, Floor, TotalBeds, OccupiedBeds, etc.
2. **Doctors**:
   - Attributes: DoctorID, Name, Specialty, Salary, DistanceFromHospital, etc.
3. **Patients**:
   - Attributes: PatientID, Name, Gender, AdmissionDate, ReleaseDate, etc.
4. **PatientDoctor** (junction table):
   - Manages relationships between patients and doctors.

## Technology Stack
- **Database**: Oracle SQL, PL/SQL
- **Scripting**: Python for automation

## Getting Started
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/Hospital-DBMS.git
   ```

2. Import the SQL scripts into your Oracle database.
3. Execute the provided Python scripts to populate initial data.

## Key Scripts
- **Schema Definition**:
  - SQL scripts for creating tables and relationships.
- **Data Manipulation**:
  - Queries for adding, updating, and analyzing data.
- **Python Automation**:
  - Scripts for automating data population and validation.

## Example Queries
Here are some example queries implemented in the project:
1. **Analyze department workload and efficiency**:
   ```sql
   SELECT dp.DepartmentID, dp.DepartmentName, dp.TotalBeds, dp.OccupiedBeds,
          COUNT(DISTINCT d.DoctorID) AS NumberOfNearbyDoctors,
          COUNT(DISTINCT p.PatientID) AS NumberOfPatients,
          (COUNT(DISTINCT p.PatientID) / NULLIF(COUNT(DISTINCT d.DoctorID), 0)) AS PatientsPerDoctor,
          (dp.OccupiedBeds / NULLIF(dp.TotalBeds, 0)) * 100 AS OccupancyRate,
          dp.HeadOfDepartment, dp.Phone
   FROM Departments dp
   LEFT JOIN Doctors d ON dp.DepartmentID = d.DepartmentID AND d.DistanceFromHospital <= 20
   LEFT JOIN Patients p ON dp.DepartmentID = p.DepartmentID AND p.ReleaseDate IS NULL
   WHERE dp.TotalBeds IS NOT NULL AND dp.OccupiedBeds IS NOT NULL
   GROUP BY dp.DepartmentID, dp.DepartmentName, dp.TotalBeds, dp.OccupiedBeds, dp.HeadOfDepartment, dp.Phone
   HAVING COUNT(DISTINCT d.DoctorID) = 0 OR 
          ((COUNT(DISTINCT p.PatientID) / NULLIF(COUNT(DISTINCT d.DoctorID), 0)) > 5)
   ORDER BY OccupancyRate DESC, PatientsPerDoctor DESC;
   ```

2. **Delete inactive patients with specific conditions**:
   ```sql
   DELETE FROM Patients p
   WHERE p.ReleaseDate < ADD_MONTHS(SYSDATE, -36)
     AND NOT EXISTS (
       SELECT 1
       FROM PatientDoctor pd
       WHERE pd.PatientID = p.PatientID
     )
     AND NOT EXISTS (
       SELECT 1
       FROM PatientDoctor pd2
       JOIN Patients p2 ON pd2.PatientID = p2.PatientID
       WHERE p2.AdmissionDate > p.ReleaseDate
     );
   ```

3. **Update salaries for top-performing doctors**:
   ```sql
   UPDATE Doctors
   SET Salary = Salary * 1.1
   WHERE DoctorID IN (
     SELECT DoctorID
     FROM (
       SELECT d.DoctorID, COUNT(p.PatientID) AS NumPatients
       FROM Doctors d
       JOIN PatientDoctor pd ON pd.DoctorID = d.DoctorID
       JOIN Patients p ON pd.PatientID = p.PatientID
       WHERE EXTRACT(YEAR FROM p.AdmissionDate) BETWEEN EXTRACT(YEAR FROM SYSDATE) - 3 AND EXTRACT(YEAR FROM SYSDATE)
       GROUP BY d.DoctorID
       ORDER BY NumPatients DESC
       FETCH FIRST 10 ROWS ONLY
     )
   );
  
## Contributions
Contributions are welcome! If you have ideas for improvement or additional features, feel free to submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contact
For questions or feedback, please contact:
**Noam Mandelbaum**
- Email: [noam.mandelbaum@gmail.com](mailto:noam.mandelbaum@gmail.com)
- GitHub: [github.com/Noammandelbaum](https://github.com/Noammandelbaum)
