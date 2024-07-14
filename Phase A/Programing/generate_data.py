import random
import csv
import os
from datetime import datetime, timedelta

# Define the output path
output_path = r"C:\Users\noamm\Desktop\לימודים\שנה ג\סמסטר ב\מיני פרוייקט בבסיסי נתונים\מיני פרוייקט\שלב 1\pythonDataGenerated"


# Function to generate a phone number
def generate_phone():
    return '05' + ''.join([str(random.randint(0, 9)) for _ in range(8)])


# Function to generate random names
def generate_name():
    first_names = ['John', 'Jane', 'Alice', 'David', 'Michael', 'Sara', 'James', 'Emily', 'Robert', 'Linda']
    last_names = ['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor']
    return random.choice(first_names), random.choice(last_names)


# Function to generate a random date between two dates
def generate_date(start_date, end_date):
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)


# Generate data for Departments table
with open(os.path.join(output_path, 'departments_data.txt'), 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['DepartmentID', 'DepartmentName', 'BuildingName', 'Floor', 'Phone', 'TotalBeds', 'OccupiedBeds',
                     'HeadOfDepartment'])

    department_names = ['Gen Medicine', 'Pediatrics', 'Emerg Med', 'Surgery', 'Orthopedics', 'Obstetrics', 'Psychiatry',
                        'Neurology', 'Cardiology', 'Oncology', 'Dermatology', 'Urology', 'Gastroentero',
                        'Ophthalmology', 'Pulmonology', 'Rheumatology', 'Nephrology', 'Endocrinol', 'Infect Dis',
                        'Geriatrics']
    building_names = ['Building A', 'Building B', 'Building C', 'Building D', 'Building E']

    for department_id in range(1, 401):  # Generate 400 sample records
        department_name = random.choice(department_names)
        building_name = random.choice(building_names)
        floor = random.randint(1, 10)
        phone = '02' + ''.join([str(random.randint(0, 9)) for _ in range(7)])
        total_beds = random.randint(20, 100)
        occupied_beds = random.randint(0, total_beds)
        head_of_department = random.choice(generate_name()[1])  # Last name only

        writer.writerow([department_id, department_name, building_name, floor, phone, total_beds, occupied_beds,
                         head_of_department])

# Generate data for Doctors table
with open(os.path.join(output_path, 'doctors_data.txt'), 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['DoctorID', 'FirstName', 'LastName', 'Specialty', 'Phone', 'DateOfBirth', 'HireDate', 'Salary',
                     'DistanceFromHospital', 'DepartmentID'])

    specialties = ['Cardiology', 'Neurology', 'Oncology', 'Pediatrics', 'Surgery', 'Orthopedics']
    for doctor_id in range(1, 401):  # Generate 400 sample records
        first_name, last_name = generate_name()
        specialty = random.choice(specialties)
        phone = generate_phone()
        date_of_birth = generate_date(datetime(1960, 1, 1), datetime(2000, 12, 31))
        hire_date = generate_date(date_of_birth + timedelta(days=6570),
                                  datetime(2023, 1, 1))  # Hire date is after 18 years old
        salary = random.randint(50000, 200000)
        distance_from_hospital = round(random.uniform(1, 100), 2)  # Max value of 100
        department_id = random.randint(1, 20)  # Assuming there are 20 departments

        writer.writerow([doctor_id, first_name, last_name, specialty, phone, date_of_birth.strftime('%Y-%m-%d'),
                         hire_date.strftime('%Y-%m-%d'), salary, distance_from_hospital, department_id])

# Generate data for Patients table
with open(os.path.join(output_path, 'patients_data.txt'), 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(
        ['PatientID', 'FirstName', 'LastName', 'DateOfBirth', 'Gender', 'Phone', 'AdmissionDate', 'ReleaseDate',
         'Address', 'DepartmentID'])

    genders = ['M', 'F']
    for patient_id in range(1, 401):  # Generate 400 sample records
        first_name, last_name = generate_name()
        date_of_birth = generate_date(datetime(1940, 1, 1), datetime(2020, 12, 31))
        gender = random.choice(genders)
        phone = generate_phone()
        admission_date = generate_date(datetime(2020, 1, 1), datetime(2024, 1, 1))
        release_date = admission_date + timedelta(days=random.randint(1, 30))
        address = f"{random.randint(1, 999)} Elm St"
        department_id = random.randint(1, 20)  # Assuming there are 20 departments

        writer.writerow([patient_id, first_name, last_name, date_of_birth.strftime('%Y-%m-%d'), gender, phone,
                         admission_date.strftime('%Y-%m-%d'),
                         release_date.strftime('%Y-%m-%d') if random.random() > 0.5 else '', address, department_id])

# Generate data for PatientDoctor table
with open(os.path.join(output_path, 'patientdoctor_data.txt'), 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['PatientID', 'DoctorID'])

    for patient_id in range(1, 401):  # Assuming each patient can have multiple doctors
        doctor_ids = random.sample(range(1, 401), random.randint(1, 3))  # Each patient can have 1 to 3 doctors
        for doctor_id in doctor_ids:
            writer.writerow([patient_id, doctor_id])

print(f"Data generation complete. Files created at: {output_path}")
