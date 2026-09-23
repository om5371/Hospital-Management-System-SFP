-- HOSPITAL MANAGEMENT SYSTEM

DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB;

USE HospitalDB;



-- 1. PATIENTS TABLE


CREATE TABLE Patients
(
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(200),
    registration_date DATE
);


-- =====================================================
-- 2. DOCTORS TABLE
-- =====================================================

CREATE TABLE Doctors
(
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    available_days VARCHAR(100),
    consultation_fee DECIMAL(10,2),
    experience_years INT
);


-- =====================================================
-- 3. APPOINTMENTS TABLE
-- =====================================================

CREATE TABLE Appointments
(
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),

    FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id)
);


-- =====================================================
-- 4. MEDICAL RECORDS TABLE
-- =====================================================

CREATE TABLE Medical_Records
(
    record_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    diagnosis VARCHAR(200),
    prescription VARCHAR(300),
    treatment_date DATE,
    admission_date DATE,
    discharge_date DATE,

    FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id)
);


-- =====================================================
-- 5. BILLING TABLE
-- =====================================================

CREATE TABLE Billing
(
    invoice_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    payment_date DATE,

    FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id),

    FOREIGN KEY (appointment_id)
    REFERENCES Appointments(appointment_id)
);


-- =====================================================
-- 6. DEPARTMENTS TABLE
-- =====================================================

CREATE TABLE Departments
(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);


-- =====================================================
-- 7. DOCTOR_DEPARTMENT TABLE
-- =====================================================

CREATE TABLE Doctor_Department
(
    doctor_id INT,
    department_id INT,

    PRIMARY KEY (doctor_id, department_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id),

    FOREIGN KEY (department_id)
    REFERENCES Departments(department_id)
);


-- =====================================================
-- INSERT PATIENTS
-- =====================================================

INSERT INTO Patients
(patient_id, name, dob, gender, phone_number, email, address, registration_date)
VALUES
(1, 'Rahul Patel', '2000-05-10', 'Male', '9876543210',
 'rahul@gmail.com', 'Ahmedabad', '2025-01-15'),

(2, 'Priya Shah', '1998-08-20', 'Female', '9876543211',
 'priya@gmail.com', 'Surat', '2025-03-10'),

(3, 'Amit Joshi', '1995-02-15', 'Male', '9876543212',
 'amit@gmail.com', 'Ahmedabad', '2025-05-20'),

(4, 'Neha Mehta', '2001-11-12', 'Female', '9876543213',
 'neha@gmail.com', 'Vadodara', '2025-07-05'),

(5, 'Karan Patel', '1990-01-25', 'Male', '9876543214',
 'karan@gmail.com', 'Rajkot', '2025-08-12'),

(6, 'Riya Shah', '2002-04-18', 'Female', '9876543215',
 'riya@gmail.com', 'Ahmedabad', '2026-01-10'),

(7, 'Vivek Desai', '1988-09-30', 'Male', NULL,
 'vivek@gmail.com', 'Gandhinagar', '2026-02-15'),

(8, 'Pooja Joshi', '1999-12-05', 'Female', '9876543217',
 'pooja@gmail.com', 'Ahmedabad', '2026-03-12');


-- =====================================================
-- INSERT DOCTORS
-- =====================================================

INSERT INTO Doctors
(doctor_id, name, specialization, phone_number, email,
 available_days, consultation_fee, experience_years)
VALUES
(1, 'Dr. Raj Patel', 'Cardiology', '9000000001',
 'raj@hospital.com', 'Mon,Wed,Fri', 1500, 18),

(2, 'Dr. Neha Shah', 'Dermatology', '9000000002',
 'neha@hospital.com', 'Tue,Thu,Sat', 1200, 8),

(3, 'Dr. Amit Mehta', 'Neurology', '9000000003',
 'amit@hospital.com', 'Mon,Tue,Thu', 1800, 20),

(4, 'Dr. Priya Desai', 'Orthopedics', '9000000004',
 'priya@hospital.com', 'Wed,Fri,Sat', 1000, 12),

(5, 'Dr. Karan Shah', 'General Medicine', '9000000005',
 'karan@hospital.com', 'Mon,Wed,Sat', 800, 3),

(6, 'Dr. Riya Patel', 'ENT', '9000000006',
 'riya@hospital.com', 'Tue,Fri', 700, 2);



-- INSERT APPOINTMENTS


INSERT INTO Appointments
(appointment_id, patient_id, doctor_id, appointment_date, status)
VALUES
(101, 1, 1, '2025-02-10', 'Completed'),
(102, 2, 2, '2025-03-15', 'Completed'),
(103, 3, 3, '2025-06-20', 'Completed'),
(104, 4, 4, '2025-07-10', 'Cancelled'),
(105, 5, 1, '2025-08-20', 'Completed'),
(106, 1, 2, '2025-09-05', 'Completed'),
(107, 2, 3, '2025-10-12', 'Completed'),
(108, 3, 1, '2025-11-18', 'Completed'),
(109, 6, 5, '2026-01-15', 'Scheduled'),
(110, 7, 4, '2026-02-20', 'Completed'),
(111, 8, 2, '2026-03-15', 'Completed'),
(112, 1, 3, '2026-04-10', 'Completed'),
(113, 2, 1, '2026-05-12', 'Scheduled'),
(114, 3, 2, '2026-06-18', 'Completed'),
(115, 5, 1, '2026-07-20', 'Completed');



-- INSERT MEDICAL RECORDS


INSERT INTO Medical_Records
(record_id, patient_id, doctor_id, diagnosis, prescription,
 treatment_date, admission_date, discharge_date)
VALUES
(201, 1, 1, 'Heart Problem', 'Medicine A',
 '2025-02-10', '2025-02-10', '2025-02-15'),

(202, 2, 2, 'Skin Allergy', 'Cream B',
 '2025-03-15', '2025-03-15', '2025-03-17'),

(203, 3, 3, 'Migraine', 'Medicine C',
 '2025-06-20', '2025-06-20', '2025-06-22'),

(204, 5, 1, 'Blood Pressure', 'Medicine D',
 '2025-08-20', '2025-08-20', '2025-08-25'),

(205, 1, 2, 'Skin Problem', 'Cream E',
 '2025-09-05', '2025-09-05', '2025-09-07'),

(206, 2, 3, 'Headache', 'Medicine F',
 '2025-10-12', '2025-10-12', '2025-10-14'),

(207, 3, 1, 'Heart Checkup', 'Medicine G',
 '2025-11-18', '2025-11-18', '2025-11-20'),

(208, 6, 5, 'Fever', 'Medicine H',
 '2026-01-15', '2026-01-15', '2026-01-17'),

(209, 7, 4, 'Bone Pain', 'Medicine I',
 '2026-02-20', '2026-02-20', '2026-02-25'),

(210, 8, 2, 'Acne', 'Cream J',
 '2026-03-15', '2026-03-15', '2026-03-18'),

(211, 1, 3, 'Migraine', 'Medicine K',
 '2026-04-10', '2026-04-10', '2026-04-12');



-- INSERT BILLING


INSERT INTO Billing
(invoice_id, patient_id, appointment_id, amount,
 payment_status, payment_date)
VALUES
(301, 1, 101, 5000, 'Paid', '2025-02-15'),
(302, 2, 102, 3000, 'Paid', '2025-03-17'),
(303, 3, 103, 4500, 'Paid', '2025-06-22'),
(304, 5, 105, 6000, 'Paid', '2025-08-25'),
(305, 1, 106, 2500, 'Paid', '2025-09-07'),
(306, 2, 107, 4000, 'Pending', NULL),
(307, 3, 108, 5500, 'Paid', '2025-11-20'),
(308, 6, 109, 1500, 'Pending', NULL),
(309, 7, 110, 3500, 'Paid', '2026-02-25'),
(310, 8, 111, 2500, 'Paid', '2026-03-18'),
(311, 1, 112, 4500, 'Paid', '2026-04-12'),
(312, 2, 113, 5000, 'Pending', NULL),
(313, 3, 114, 3000, 'Paid', '2026-06-20'),
(314, 5, 115, 6500, 'Paid', '2026-07-25');



-- INSERT DEPARTMENTS


INSERT INTO Departments
(department_id, department_name)
VALUES
(1, 'Cardiology'),
(2, 'Dermatology'),
(3, 'Neurology'),
(4, 'Orthopedics'),
(5, 'General Medicine'),
(6, 'ENT');



-- INSERT DOCTOR DEPARTMENT


INSERT INTO Doctor_Department
(doctor_id, department_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);



-- 1. CRUD OPERATIONS


-- INSERT
INSERT INTO Patients
VALUES
(9, 'Test Patient', '2003-05-10', 'Male',
 '9999999999', 'test@gmail.com', 'Ahmedabad', CURDATE());


-- SELECT
SELECT *
FROM Patients
WHERE patient_id = 9;


-- UPDATE
UPDATE Patients
SET phone_number = '8888888888'
WHERE patient_id = 9;


-- DELETE
DELETE FROM Patients
WHERE patient_id = 9;



-- 2. WHERE, HAVING, LIMIT


-- Patients registered in last one year
SELECT *
FROM Patients
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);


-- Top 5 highest-paying patients
SELECT
    patient_id,
    SUM(amount) AS total_payment
FROM Billing
GROUP BY patient_id
ORDER BY total_payment DESC
LIMIT 5;


-- Doctors charging more than 1000
SELECT *
FROM Doctors
WHERE consultation_fee > 1000;



-- 3. AND, OR, NOT


-- Scheduled appointments for doctor 3
SELECT *
FROM Appointments
WHERE status = 'Scheduled'
AND doctor_id = 3;


-- Cardiology OR Neurology doctors
SELECT *
FROM Doctors
WHERE specialization = 'Cardiology'
OR specialization = 'Neurology';


-- Patients who have NOT visited in last one year
SELECT *
FROM Patients
WHERE patient_id NOT IN
(
    SELECT DISTINCT patient_id
    FROM Appointments
    WHERE appointment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);



-- 4. ORDER BY AND GROUP BY


-- Doctors sorted by specialization
SELECT *
FROM Doctors
ORDER BY specialization ASC;


-- Number of patients assigned to each doctor
SELECT
    doctor_id,
    COUNT(DISTINCT patient_id) AS total_patients
FROM Appointments
GROUP BY doctor_id;


-- Total revenue generated by each doctor
SELECT
    a.doctor_id,
    SUM(b.amount) AS total_revenue
FROM Appointments a
JOIN Billing b
ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Paid'
GROUP BY a.doctor_id;



-- 5. AGGREGATE FUNCTIONS


-- Total revenue
SELECT
    SUM(amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';


-- Most visited doctor
SELECT
    doctor_id,
    COUNT(*) AS total_visits
FROM Appointments
WHERE status = 'Completed'
GROUP BY doctor_id
ORDER BY total_visits DESC
LIMIT 1;


-- Average consultation fee
SELECT
    AVG(consultation_fee) AS average_fee
FROM Doctors;


-- Maximum consultation fee
SELECT
    MAX(consultation_fee) AS maximum_fee
FROM Doctors;


-- Minimum consultation fee
SELECT
    MIN(consultation_fee) AS minimum_fee
FROM Doctors;


-- Total patients
SELECT
    COUNT(*) AS total_patients
FROM Patients;



-- 6. PRIMARY KEY AND FOREIGN KEY RELATIONSHIPS


-- Medical records with patient and doctor
SELECT
    m.record_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    m.diagnosis,
    m.prescription
FROM Medical_Records m
JOIN Patients p
ON m.patient_id = p.patient_id
JOIN Doctors d
ON m.doctor_id = d.doctor_id;


-- Invoice and appointment relationship
SELECT
    b.invoice_id,
    b.amount,
    b.payment_status,
    a.appointment_date
FROM Billing b
JOIN Appointments a
ON b.appointment_id = a.appointment_id;



-- 7. INNER JOIN


SELECT
    d.name AS doctor_name,
    dp.department_name
FROM Doctors d
INNER JOIN Doctor_Department dd
ON d.doctor_id = dd.doctor_id
INNER JOIN Departments dp
ON dd.department_id = dp.department_id;



-- 8. LEFT JOIN


SELECT
    p.patient_id,
    p.name,
    a.appointment_id,
    a.status
FROM Patients p
LEFT JOIN Appointments a
ON p.patient_id = a.patient_id
WHERE a.status = 'Completed'
OR a.status IS NULL;


-- 9. RIGHT JOIN

SELECT
    p.patient_id,
    p.name,
    a.appointment_id
FROM Appointments a
RIGHT JOIN Patients p
ON a.patient_id = p.patient_id;



-- 10. FULL OUTER JOIN
-- MySQL does not directly support FULL OUTER JOIN


SELECT
    p.patient_id,
    p.name,
    a.appointment_id
FROM Patients p
LEFT JOIN Appointments a
ON p.patient_id = a.patient_id

UNION

SELECT
    p.patient_id,
    p.name,
    a.appointment_id
FROM Patients p
RIGHT JOIN Appointments a
ON p.patient_id = a.patient_id;



-- 11. SUBQUERIES


-- Doctors who handled more than 50 patients
SELECT *
FROM Doctors
WHERE doctor_id IN
(
    SELECT doctor_id
    FROM Appointments
    GROUP BY doctor_id
    HAVING COUNT(DISTINCT patient_id) > 50
);


-- Patient who spent the most
SELECT
    patient_id,
    SUM(amount) AS total_spent
FROM Billing
GROUP BY patient_id
ORDER BY total_spent DESC
LIMIT 1;


-- Appointments for Dermatology doctors
SELECT *
FROM Appointments
WHERE doctor_id IN
(
    SELECT doctor_id
    FROM Doctors
    WHERE specialization = 'Dermatology'
);



-- 12. DATE AND TIME FUNCTIONS


-- Count visits by month
SELECT
    MONTH(appointment_date) AS month_number,
    COUNT(*) AS total_visits
FROM Appointments
GROUP BY MONTH(appointment_date)
ORDER BY month_number;


-- Hospital stay duration
SELECT
    record_id,
    patient_id,
    DATEDIFF(discharge_date, admission_date) AS stay_days
FROM Medical_Records;


-- DD-MM-YYYY format
SELECT
    record_id,
    DATE_FORMAT(treatment_date, '%d-%m-%Y') AS treatment_date
FROM Medical_Records;



-- 13. STRING FUNCTIONS

-- Patient names in uppercase
SELECT
    UPPER(name) AS patient_name
FROM Patients;


-- Remove spaces from doctor names
SELECT
    TRIM(name) AS doctor_name
FROM Doctors;


-- Missing phone number
SELECT
    name,
    COALESCE(phone_number, 'Not Available') AS phone_number
FROM Patients;



-- 14. WINDOW FUNCTIONS


-- Rank doctors according to patients treated
SELECT
    doctor_id,
    total_patients,
    RANK() OVER (ORDER BY total_patients DESC) AS doctor_rank
FROM
(
    SELECT
        doctor_id,
        COUNT(DISTINCT patient_id) AS total_patients
    FROM Appointments
    WHERE status = 'Completed'
    GROUP BY doctor_id
) AS doctor_data;


-- Monthly revenue
SELECT
    MONTH(payment_date) AS month_number,
    SUM(amount) AS monthly_revenue
FROM Billing
WHERE payment_status = 'Paid'
GROUP BY MONTH(payment_date)
ORDER BY month_number;


-- Running total of revenue
SELECT
    month_number,
    monthly_revenue,
    SUM(monthly_revenue) OVER
    (
        ORDER BY month_number
    ) AS running_revenue
FROM
(
    SELECT
        MONTH(payment_date) AS month_number,
        SUM(amount) AS monthly_revenue
    FROM Billing
    WHERE payment_status = 'Paid'
    GROUP BY MONTH(payment_date)
) AS revenue_data;


-- Running total of appointments
SELECT
    appointment_id,
    appointment_date,
    COUNT(*) OVER
    (
        ORDER BY appointment_date
    ) AS total_appointments
FROM Appointments
ORDER BY appointment_date;



-- 15. CASE EXPRESSION


-- Patient Risk Level
SELECT
    p.patient_id,
    p.name,
    COUNT(m.record_id) AS total_records,

    CASE
        WHEN COUNT(m.record_id) > 5 THEN 'High'
        WHEN COUNT(m.record_id) BETWEEN 3 AND 5 THEN 'Medium'
        ELSE 'Low'
    END AS Patient_Risk_Level

FROM Patients p
LEFT JOIN Medical_Records m
ON p.patient_id = m.patient_id

GROUP BY
    p.patient_id,
    p.name;



-- 16. DOCTOR EXPERIENCE LEVEL


SELECT
    doctor_id,
    name,
    experience_years,

    CASE
        WHEN experience_years > 15 THEN 'Senior'
        WHEN experience_years BETWEEN 5 AND 15 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS experience_level

FROM Doctors;



-- EXTRA USEFUL QUERIES

-- Patient + Doctor + Appointment
SELECT
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.status
FROM Appointments a
JOIN Patients p
ON a.patient_id = p.patient_id
JOIN Doctors d
ON a.doctor_id = d.doctor_id;


-- Patient billing details
SELECT
    p.name AS patient_name,
    b.invoice_id,
    b.amount,
    b.payment_status
FROM Patients p
JOIN Billing b
ON p.patient_id = b.patient_id;


-- Patients having more than one medical record
SELECT
    patient_id,
    COUNT(*) AS total_records
FROM Medical_Records
GROUP BY patient_id
HAVING COUNT(*) > 1;