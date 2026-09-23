# Hospital Management System 

## Project Objective

Design and query a relational database for a hospital that tracks patients, doctors, appointments, medical records, billing and departments, and demonstrate core SQL competencies against it: CRUD operations, filtering, sorting, grouping, aggregate functions, all four join types, subqueries, date/string functions, window functions, and `CASE` expressions.

## Database Schema

| Table | Purpose | Primary Key | Foreign Keys |
|---|---|---|---|
| `Patients` | Every registered patient and their contact details. | `patient_id` | - |
| `Doctors` | Every doctor, their specialization, fee and experience. | `doctor_id` | - |
| `Appointments` | Links a patient to a doctor for a given date and status. | `appointment_id` | `patient_id` -> Patients, `doctor_id` -> Doctors |
| `Medical_Records` | Diagnosis/prescription history tied to a patient and doctor. | `record_id` | `patient_id` -> Patients, `doctor_id` -> Doctors |
| `Billing` | Invoices tied to a patient and an appointment. | `invoice_id` | `patient_id` -> Patients, `appointment_id` -> Appointments |
| `Departments` | The hospital's departments. | `department_id` | - |
| `Doctor_Department` | Bridge table connecting doctors to departments. | `(doctor_id, department_id)` | `doctor_id` -> Doctors, `department_id` -> Departments |

**Relationships:** `Appointments` and `Medical_Records` both connect a `Patient` to a `Doctor`; `Billing` connects a `Patient` to the `Appointment` being invoiced; `Doctor_Department` is a many-to-many bridge between `Doctors` and `Departments`.

## Seed Data

Each table is pre-loaded with sample rows via `INSERT` statements before any of the queries below run:

| Table | Rows inserted |
|---|---|
| `Patients` | 8 |
| `Doctors` | 6 |
| `Appointments` | 15 |
| `Medical_Records` | 11 |
| `Billing` | 14 |
| `Departments` | 6 |
| `Doctor_Department` | 6 |


## Contents

- [Database Schema](#database-schema)
- [Seed Data](#seed-data)
- [1. CRUD OPERATIONS](#1-crud-operations)
- [2. WHERE, HAVING, LIMIT](#2-where-having-limit)
- [3. AND, OR, NOT](#3-and-or-not)
- [4. ORDER BY AND GROUP BY](#4-order-by-and-group-by)
- [5. AGGREGATE FUNCTIONS](#5-aggregate-functions)
- [6. PRIMARY KEY AND FOREIGN KEY RELATIONSHIPS](#6-primary-key-and-foreign-key-relationships)
- [7. INNER JOIN](#7-inner-join)
- [8. LEFT JOIN](#8-left-join)
- [9. RIGHT JOIN](#9-right-join)
- [10. FULL OUTER JOIN](#10-full-outer-join)
- [11. SUBQUERIES](#11-subqueries)
- [12. DATE AND TIME FUNCTIONS](#12-date-and-time-functions)
- [13. STRING FUNCTIONS](#13-string-functions)
- [14. WINDOW FUNCTIONS](#14-window-functions)
- [15. CASE EXPRESSION](#15-case-expression)
- [16. DOCTOR EXPERIENCE LEVEL](#16-doctor-experience-level)
- [17. EXTRA USEFUL QUERIES](#17-extra-useful-queries)


## 1. CRUD OPERATIONS

The four basic data-manipulation operations -- Create, Read, Update, Delete.

### 1. INSERT

**Objective:** Add a brand-new patient record to the table.

**Explanation:** A single-row `INSERT` with an explicit column list writes one new patient into `Patients`. Using `CURDATE()` for `registration_date` stamps the row with today's date automatically instead of a hard-coded value.

**Query:**

```sql
INSERT INTO Patients
VALUES
(9, 'Test Patient', '2003-05-10', 'Male',
 '9999999999', 'test@gmail.com', 'Ahmedabad', CURDATE());
```

**Output:**

_Statement executed successfully (no rows affected)._

### 2. SELECT

**Objective:** Confirm that the newly inserted row exists and holds the correct values.

**Explanation:** A filtered `SELECT ... WHERE patient_id = 9` reads back exactly the row that was just inserted, which is the standard way to verify a write succeeded.

**Query:**

```sql
SELECT *
FROM Patients
WHERE patient_id = 9;
```

**Output:**

|   patient_id | name         | dob        | gender   |   phone_number | email          | address   | registration_date   |
|-------------:|:-------------|:-----------|:---------|---------------:|:---------------|:----------|:--------------------|
|            9 | Test Patient | 2003-05-10 | Male     |     9999999999 | test@gmail.com | Ahmedabad | 2026-09-23          |

### 3. UPDATE

**Objective:** Modify one column of an existing row without touching the rest of it.

**Explanation:** `UPDATE ... SET ... WHERE` changes only the `phone_number` field for patient 9, leaving every other column untouched. The `WHERE` clause is what keeps the update scoped to a single row.

**Query:**

```sql
UPDATE Patients
SET phone_number = '8888888888'
WHERE patient_id = 9;
```

**Output:**

_Statement executed successfully (no rows affected)._

### 4. DELETE

**Objective:** Remove a row from the table once it is no longer needed.

**Explanation:** `DELETE FROM ... WHERE` deletes the test patient created above, restoring the table to its original state. Omitting the `WHERE` clause here would wipe every row in `Patients`.

**Query:**

```sql
DELETE FROM Patients
WHERE patient_id = 9;
```

**Output:**

_Statement executed successfully (no rows affected)._


## 2. WHERE, HAVING, LIMIT

Filtering rows, filtering aggregated groups, and capping result size.

### 5. Patients registered in last one year

**Objective:** Find every patient who registered within the past 12 months.

**Explanation:** `DATE_SUB(CURDATE(), INTERVAL 1 YEAR)` computes the date exactly one year before today, and the `WHERE` clause keeps only rows whose `registration_date` is on or after that cut-off.

**Query:**

```sql
SELECT *
FROM Patients
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
```

**Output:**

|   patient_id | name        | dob        | gender   |   phone_number | email           | address     | registration_date   |
|-------------:|:------------|:-----------|:---------|---------------:|:----------------|:------------|:--------------------|
|            6 | Riya Shah   | 2002-04-18 | Female   |    9.87654e+09 | riya@gmail.com  | Ahmedabad   | 2026-01-10          |
|            7 | Vivek Desai | 1988-09-30 | Male     |  nan           | vivek@gmail.com | Gandhinagar | 2026-02-15          |
|            8 | Pooja Joshi | 1999-12-05 | Female   |    9.87654e+09 | pooja@gmail.com | Ahmedabad   | 2026-03-12          |

### 6. Top 5 highest-paying patients

**Objective:** Rank patients by how much they have paid the hospital and return the top 5.

**Explanation:** `GROUP BY patient_id` collapses all of a patient's invoices into one row, `SUM(amount)` totals their spend, `ORDER BY ... DESC` puts the biggest spenders first, and `LIMIT 5` trims the list to the top 5.

**Query:**

```sql
SELECT
    patient_id,
    SUM(amount) AS total_payment
FROM Billing
GROUP BY patient_id
ORDER BY total_payment DESC
LIMIT 5;
```

**Output:**

|   patient_id |   total_payment |
|-------------:|----------------:|
|            3 |           13000 |
|            5 |           12500 |
|            2 |           12000 |
|            1 |           12000 |
|            7 |            3500 |

### 7. Doctors charging more than 1000

**Objective:** List doctors whose consultation fee is above a set threshold.

**Explanation:** A plain `WHERE consultation_fee > 1000` filter returns only the rows that satisfy the numeric condition.

**Query:**

```sql
SELECT *
FROM Doctors
WHERE consultation_fee > 1000;
```

**Output:**

|   doctor_id | name           | specialization   |   phone_number | email             | available_days   |   consultation_fee |   experience_years |
|------------:|:---------------|:-----------------|---------------:|:------------------|:-----------------|-------------------:|-------------------:|
|           1 | Dr. Raj Patel  | Cardiology       |     9000000001 | raj@hospital.com  | Mon,Wed,Fri      |               1500 |                 18 |
|           2 | Dr. Neha Shah  | Dermatology      |     9000000002 | neha@hospital.com | Tue,Thu,Sat      |               1200 |                  8 |
|           3 | Dr. Amit Mehta | Neurology        |     9000000003 | amit@hospital.com | Mon,Tue,Thu      |               1800 |                 20 |


## 3. AND, OR, NOT

Combining multiple filter conditions in a single `WHERE` clause.

### 8. Scheduled appointments for doctor 3

**Objective:** Find every appointment for one specific doctor that is still scheduled.

**Explanation:** Combining two conditions with `AND` means a row is only returned when *both* `status = 'Scheduled'` and `doctor_id = 3` are true.

**Query:**

```sql
SELECT *
FROM Appointments
WHERE status = 'Scheduled'
AND doctor_id = 3;
```

**Output:**

_(no rows returned)_

### 9. Cardiology OR Neurology doctors

**Objective:** List doctors who belong to either of two specializations.

**Explanation:** `OR` returns a row if at least one of the two `specialization` conditions is true, which is how a query matches more than one acceptable value.

**Query:**

```sql
SELECT *
FROM Doctors
WHERE specialization = 'Cardiology'
OR specialization = 'Neurology';
```

**Output:**

|   doctor_id | name           | specialization   |   phone_number | email             | available_days   |   consultation_fee |   experience_years |
|------------:|:---------------|:-----------------|---------------:|:------------------|:-----------------|-------------------:|-------------------:|
|           1 | Dr. Raj Patel  | Cardiology       |     9000000001 | raj@hospital.com  | Mon,Wed,Fri      |               1500 |                 18 |
|           3 | Dr. Amit Mehta | Neurology        |     9000000003 | amit@hospital.com | Mon,Tue,Thu      |               1800 |                 20 |

### 10. Patients who have NOT visited in last one year

**Objective:** Find patients with no appointments in the last 12 months.

**Explanation:** A subquery first collects the distinct `patient_id`s that *do* have a recent appointment; the outer query then uses `NOT IN` to return every patient whose id is absent from that list.

**Query:**

```sql
SELECT *
FROM Patients
WHERE patient_id NOT IN
(
    SELECT DISTINCT patient_id
    FROM Appointments
    WHERE appointment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);
```

**Output:**

|   patient_id | name       | dob        | gender   |   phone_number | email          | address   | registration_date   |
|-------------:|:-----------|:-----------|:---------|---------------:|:---------------|:----------|:--------------------|
|            4 | Neha Mehta | 2001-11-12 | Female   |     9876543213 | neha@gmail.com | Vadodara  | 2025-07-05          |


## 4. ORDER BY AND GROUP BY

Sorting result rows and bucketing rows into per-key groups.

### 11. Doctors sorted by specialization

**Objective:** Present the doctor list grouped visually by specialization.

**Explanation:** `ORDER BY specialization ASC` sorts the result set alphabetically by that column; no rows are removed, only reordered.

**Query:**

```sql
SELECT *
FROM Doctors
ORDER BY specialization ASC;
```

**Output:**

|   doctor_id | name            | specialization   |   phone_number | email              | available_days   |   consultation_fee |   experience_years |
|------------:|:----------------|:-----------------|---------------:|:-------------------|:-----------------|-------------------:|-------------------:|
|           1 | Dr. Raj Patel   | Cardiology       |     9000000001 | raj@hospital.com   | Mon,Wed,Fri      |               1500 |                 18 |
|           2 | Dr. Neha Shah   | Dermatology      |     9000000002 | neha@hospital.com  | Tue,Thu,Sat      |               1200 |                  8 |
|           6 | Dr. Riya Patel  | ENT              |     9000000006 | riya@hospital.com  | Tue,Fri          |                700 |                  2 |
|           5 | Dr. Karan Shah  | General Medicine |     9000000005 | karan@hospital.com | Mon,Wed,Sat      |                800 |                  3 |
|           3 | Dr. Amit Mehta  | Neurology        |     9000000003 | amit@hospital.com  | Mon,Tue,Thu      |               1800 |                 20 |
|           4 | Dr. Priya Desai | Orthopedics      |     9000000004 | priya@hospital.com | Wed,Fri,Sat      |               1000 |                 12 |

### 12. Number of patients assigned to each doctor

**Objective:** Count how many distinct patients each doctor has seen.

**Explanation:** `GROUP BY doctor_id` buckets appointment rows per doctor, and `COUNT(DISTINCT patient_id)` counts unique patients within each bucket so repeat visits by the same patient aren't double-counted.

**Query:**

```sql
SELECT
    doctor_id,
    COUNT(DISTINCT patient_id) AS total_patients
FROM Appointments
GROUP BY doctor_id;
```

**Output:**

|   doctor_id |   total_patients |
|------------:|-----------------:|
|           1 |                4 |
|           2 |                4 |
|           3 |                3 |
|           4 |                2 |
|           5 |                1 |

### 13. Total revenue generated by each doctor

**Objective:** Work out how much paid revenue each doctor has brought in.

**Explanation:** Joining `Appointments` to `Billing` links each visit to its invoice; filtering to `payment_status = 'Paid'` excludes unpaid invoices, and `SUM(amount)` grouped by `doctor_id` totals the rest.

**Query:**

```sql
SELECT
    a.doctor_id,
    SUM(b.amount) AS total_revenue
FROM Appointments a
JOIN Billing b
ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Paid'
GROUP BY a.doctor_id;
```

**Output:**

|   doctor_id |   total_revenue |
|------------:|----------------:|
|           1 |           23000 |
|           2 |           11000 |
|           3 |            9000 |
|           4 |            3500 |


## 5. AGGREGATE FUNCTIONS

Built-in functions (`SUM`, `COUNT`, `AVG`, `MAX`, `MIN`) that reduce many rows to one summary value.

### 14. Total revenue

**Objective:** Calculate the hospital's total collected revenue.

**Explanation:** `SUM(amount)` over every `Billing` row where `payment_status = 'Paid'` adds up all successfully collected payments into one figure.

**Query:**

```sql
SELECT
    SUM(amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';
```

**Output:**

|   total_revenue |
|----------------:|
|           46500 |

### 15. Most visited doctor

**Objective:** Identify the doctor with the most completed appointments.

**Explanation:** Appointments are grouped by `doctor_id`, `COUNT(*)` tallies visits per doctor, the busiest doctor is sorted to the top with `ORDER BY ... DESC`, and `LIMIT 1` keeps only that one row.

**Query:**

```sql
SELECT
    doctor_id,
    COUNT(*) AS total_visits
FROM Appointments
WHERE status = 'Completed'
GROUP BY doctor_id
ORDER BY total_visits DESC
LIMIT 1;
```

**Output:**

|   doctor_id |   total_visits |
|------------:|---------------:|
|           2 |              4 |

### 16. Average consultation fee

**Objective:** Find the average consultation fee across all doctors.

**Explanation:** `AVG(consultation_fee)` is a straightforward aggregate over the entire `Doctors` table.

**Query:**

```sql
SELECT
    AVG(consultation_fee) AS average_fee
FROM Doctors;
```

**Output:**

|   average_fee |
|--------------:|
|       1166.67 |

### 17. Maximum consultation fee

**Objective:** Find the single highest consultation fee charged.

**Explanation:** `MAX(consultation_fee)` scans the column and returns its largest value.

**Query:**

```sql
SELECT
    MAX(consultation_fee) AS maximum_fee
FROM Doctors;
```

**Output:**

|   maximum_fee |
|--------------:|
|          1800 |

### 18. Minimum consultation fee

**Objective:** Find the single lowest consultation fee charged.

**Explanation:** `MIN(consultation_fee)` scans the column and returns its smallest value.

**Query:**

```sql
SELECT
    MIN(consultation_fee) AS minimum_fee
FROM Doctors;
```

**Output:**

|   minimum_fee |
|--------------:|
|           700 |

### 19. Total patients

**Objective:** Count how many patients are registered in the system.

**Explanation:** `COUNT(*)` on `Patients` simply returns the number of rows in the table.

**Query:**

```sql
SELECT
    COUNT(*) AS total_patients
FROM Patients;
```

**Output:**

|   total_patients |
|-----------------:|
|                8 |


## 6. PRIMARY KEY AND FOREIGN KEY RELATIONSHIPS

Using the foreign keys defined in the schema to join related tables together.

### 20. Medical records with patient and doctor

**Objective:** Show each medical record alongside the readable patient and doctor names.

**Explanation:** `Medical_Records` only stores foreign keys (`patient_id`, `doctor_id`); joining it to `Patients` and `Doctors` on those keys pulls in the human-readable names for the report.

**Query:**

```sql
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
```

**Output:**

|   record_id | patient_name   | doctor_name     | diagnosis      | prescription   |
|------------:|:---------------|:----------------|:---------------|:---------------|
|         201 | Rahul Patel    | Dr. Raj Patel   | Heart Problem  | Medicine A     |
|         202 | Priya Shah     | Dr. Neha Shah   | Skin Allergy   | Cream B        |
|         203 | Amit Joshi     | Dr. Amit Mehta  | Migraine       | Medicine C     |
|         204 | Karan Patel    | Dr. Raj Patel   | Blood Pressure | Medicine D     |
|         205 | Rahul Patel    | Dr. Neha Shah   | Skin Problem   | Cream E        |
|         206 | Priya Shah     | Dr. Amit Mehta  | Headache       | Medicine F     |
|         207 | Amit Joshi     | Dr. Raj Patel   | Heart Checkup  | Medicine G     |
|         208 | Riya Shah      | Dr. Karan Shah  | Fever          | Medicine H     |
|         209 | Vivek Desai    | Dr. Priya Desai | Bone Pain      | Medicine I     |
|         210 | Pooja Joshi    | Dr. Neha Shah   | Acne           | Cream J        |
|         211 | Rahul Patel    | Dr. Amit Mehta  | Migraine       | Medicine K     |

### 21. Invoice and appointment relationship

**Objective:** Show each invoice next to the appointment date it was billed for.

**Explanation:** `Billing.appointment_id` is a foreign key into `Appointments`; the join resolves it into the actual `appointment_date` for that invoice.

**Query:**

```sql
SELECT
    b.invoice_id,
    b.amount,
    b.payment_status,
    a.appointment_date
FROM Billing b
JOIN Appointments a
ON b.appointment_id = a.appointment_id;
```

**Output:**

|   invoice_id |   amount | payment_status   | appointment_date   |
|-------------:|---------:|:-----------------|:-------------------|
|          301 |     5000 | Paid             | 2025-02-10         |
|          302 |     3000 | Paid             | 2025-03-15         |
|          303 |     4500 | Paid             | 2025-06-20         |
|          304 |     6000 | Paid             | 2025-08-20         |
|          305 |     2500 | Paid             | 2025-09-05         |
|          306 |     4000 | Pending          | 2025-10-12         |
|          307 |     5500 | Paid             | 2025-11-18         |
|          308 |     1500 | Pending          | 2026-01-15         |
|          309 |     3500 | Paid             | 2026-02-20         |
|          310 |     2500 | Paid             | 2026-03-15         |
|          311 |     4500 | Paid             | 2026-04-10         |
|          312 |     5000 | Pending          | 2026-05-12         |
|          313 |     3000 | Paid             | 2026-06-18         |
|          314 |     6500 | Paid             | 2026-07-20         |


## 7. INNER JOIN

Returning only rows that have a match on both sides of the join.

### 22. Doctors and their departments (INNER JOIN)

**Objective:** List every doctor together with the department(s) they belong to.

**Explanation:** `Doctor_Department` is a bridge table connecting `Doctors` to `Departments` (a many-to-many relationship). Two `INNER JOIN`s walk doctor -> bridge -> department, and rows only survive when a match exists on both sides of both joins.

**Query:**

```sql
SELECT
    d.name AS doctor_name,
    dp.department_name
FROM Doctors d
INNER JOIN Doctor_Department dd
ON d.doctor_id = dd.doctor_id
INNER JOIN Departments dp
ON dd.department_id = dp.department_id;
```

**Output:**

| doctor_name     | department_name   |
|:----------------|:------------------|
| Dr. Raj Patel   | Cardiology        |
| Dr. Neha Shah   | Dermatology       |
| Dr. Amit Mehta  | Neurology         |
| Dr. Priya Desai | Orthopedics       |
| Dr. Karan Shah  | General Medicine  |
| Dr. Riya Patel  | ENT               |


## 8. LEFT JOIN

Returning every row from the left table, matched or not.

### 23. Patients with their completed appointments (LEFT JOIN)

**Objective:** List every patient together with their completed appointments, including patients who have none.

**Explanation:** `LEFT JOIN` keeps every row from `Patients` even when there is no matching row in `Appointments`; the `WHERE ... OR a.status IS NULL` clause then keeps completed visits plus the patients that had no match at all (where the joined columns come back as NULL).

**Query:**

```sql
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
```

**Output:**

|   patient_id | name        |   appointment_id | status    |
|-------------:|:------------|-----------------:|:----------|
|            1 | Rahul Patel |              101 | Completed |
|            1 | Rahul Patel |              106 | Completed |
|            1 | Rahul Patel |              112 | Completed |
|            2 | Priya Shah  |              102 | Completed |
|            2 | Priya Shah  |              107 | Completed |
|            3 | Amit Joshi  |              103 | Completed |
|            3 | Amit Joshi  |              108 | Completed |
|            3 | Amit Joshi  |              114 | Completed |
|            5 | Karan Patel |              105 | Completed |
|            5 | Karan Patel |              115 | Completed |
|            7 | Vivek Desai |              110 | Completed |
|            8 | Pooja Joshi |              111 | Completed |


## 9. RIGHT JOIN

Returning every row from the right table, matched or not.

### 24. Every patient, matched or not (RIGHT JOIN)

**Objective:** List every patient together with any appointment id they have, keeping patients with zero appointments.

**Explanation:** `RIGHT JOIN` keeps every row from the table on the right (`Patients`) regardless of whether `Appointments` has a match -- the mirror image of a `LEFT JOIN`.

**Query:**

```sql
SELECT
    p.patient_id,
    p.name,
    a.appointment_id
FROM Appointments a
RIGHT JOIN Patients p
ON a.patient_id = p.patient_id;
```

**Output:**

|   patient_id | name        |   appointment_id |
|-------------:|:------------|-----------------:|
|            1 | Rahul Patel |              101 |
|            2 | Priya Shah  |              102 |
|            3 | Amit Joshi  |              103 |
|            4 | Neha Mehta  |              104 |
|            5 | Karan Patel |              105 |
|            1 | Rahul Patel |              106 |
|            2 | Priya Shah  |              107 |
|            3 | Amit Joshi  |              108 |
|            6 | Riya Shah   |              109 |
|            7 | Vivek Desai |              110 |
|            8 | Pooja Joshi |              111 |
|            1 | Rahul Patel |              112 |
|            2 | Priya Shah  |              113 |
|            3 | Amit Joshi  |              114 |
|            5 | Karan Patel |              115 |


## 10. FULL OUTER JOIN

Returning every row from both tables, matched or not.

### 25. Patients and appointments, matched or not (FULL OUTER JOIN)

**Objective:** Combine patients and appointments so that unmatched rows from *either* side are kept.

**Explanation:** MySQL has no native `FULL OUTER JOIN`, so the same effect is built by `UNION`-ing a `LEFT JOIN` (keeps unmatched patients) with a `RIGHT JOIN` (keeps unmatched appointments); `UNION` then removes the duplicate rows that matched on both sides.

**Query:**

```sql
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
```

**Output:**

|   patient_id | name        |   appointment_id |
|-------------:|:------------|-----------------:|
|            1 | Rahul Patel |              101 |
|            1 | Rahul Patel |              106 |
|            1 | Rahul Patel |              112 |
|            2 | Priya Shah  |              102 |
|            2 | Priya Shah  |              107 |
|            2 | Priya Shah  |              113 |
|            3 | Amit Joshi  |              103 |
|            3 | Amit Joshi  |              108 |
|            3 | Amit Joshi  |              114 |
|            4 | Neha Mehta  |              104 |
|            5 | Karan Patel |              105 |
|            5 | Karan Patel |              115 |
|            6 | Riya Shah   |              109 |
|            7 | Vivek Desai |              110 |
|            8 | Pooja Joshi |              111 |


## 11. SUBQUERIES

A query nested inside another query, used to feed a computed set of values into an outer filter.

### 26. Doctors who handled more than 50 patients

**Objective:** Find any doctor whose distinct patient count crosses a high-volume threshold.

**Explanation:** The inner query groups `Appointments` by `doctor_id` and uses `HAVING COUNT(DISTINCT patient_id) > 50` to keep only high-volume doctors; the outer query then looks up their full details from `Doctors` using `IN`.

**Query:**

```sql
SELECT *
FROM Doctors
WHERE doctor_id IN
(
    SELECT doctor_id
    FROM Appointments
    GROUP BY doctor_id
    HAVING COUNT(DISTINCT patient_id) > 50
);
```

**Output:**

_(no rows returned)_

### 27. Patient who spent the most

**Objective:** Identify the single biggest-spending patient.

**Explanation:** Billing rows are grouped and summed per patient, sorted highest first, and `LIMIT 1` keeps just the top spender -- the same pattern as the top-5 query above but capped to one row.

**Query:**

```sql
SELECT
    patient_id,
    SUM(amount) AS total_spent
FROM Billing
GROUP BY patient_id
ORDER BY total_spent DESC
LIMIT 1;
```

**Output:**

|   patient_id |   total_spent |
|-------------:|--------------:|
|            3 |         13000 |

### 28. Appointments for Dermatology doctors

**Objective:** List every appointment that belongs to a Dermatology doctor.

**Explanation:** The subquery finds the `doctor_id`s where `specialization = 'Dermatology'`, and the outer query filters `Appointments` to only those doctor ids with `IN`.

**Query:**

```sql
SELECT *
FROM Appointments
WHERE doctor_id IN
(
    SELECT doctor_id
    FROM Doctors
    WHERE specialization = 'Dermatology'
);
```

**Output:**

|   appointment_id |   patient_id |   doctor_id | appointment_date   | status    |
|-----------------:|-------------:|------------:|:-------------------|:----------|
|              102 |            2 |           2 | 2025-03-15         | Completed |
|              106 |            1 |           2 | 2025-09-05         | Completed |
|              111 |            8 |           2 | 2026-03-15         | Completed |
|              114 |            3 |           2 | 2026-06-18         | Completed |


## 12. DATE AND TIME FUNCTIONS

Extracting, comparing, and reformatting date values.

### 29. Count visits by month

**Objective:** See how appointment volume is distributed across the calendar year.

**Explanation:** `MONTH(appointment_date)` extracts just the month number from each date, and grouping by it counts how many appointments fall in each month.

**Query:**

```sql
SELECT
    MONTH(appointment_date) AS month_number,
    COUNT(*) AS total_visits
FROM Appointments
GROUP BY MONTH(appointment_date)
ORDER BY month_number;
```

**Output:**

|   month_number |   total_visits |
|---------------:|---------------:|
|              1 |              1 |
|              2 |              2 |
|              3 |              2 |
|              4 |              1 |
|              5 |              1 |
|              6 |              2 |
|              7 |              2 |
|              8 |              1 |
|              9 |              1 |
|             10 |              1 |
|             11 |              1 |

### 30. Hospital stay duration

**Objective:** Calculate how many days each patient was admitted for.

**Explanation:** `DATEDIFF(discharge_date, admission_date)` subtracts the two dates to give a whole number of days for each medical record.

**Query:**

```sql
SELECT
    record_id,
    patient_id,
    DATEDIFF(discharge_date, admission_date) AS stay_days
FROM Medical_Records;
```

**Output:**

|   record_id |   patient_id |   stay_days |
|------------:|-------------:|------------:|
|         201 |            1 |           5 |
|         202 |            2 |           2 |
|         203 |            3 |           2 |
|         204 |            5 |           5 |
|         205 |            1 |           2 |
|         206 |            2 |           2 |
|         207 |            3 |           2 |
|         208 |            6 |           2 |
|         209 |            7 |           5 |
|         210 |            8 |           3 |
|         211 |            1 |           2 |

### 31. DD-MM-YYYY format

**Objective:** Present treatment dates in a human-friendly DD-MM-YYYY layout.

**Explanation:** `DATE_FORMAT` reformats the stored ISO date into the requested display pattern without changing the underlying stored value.

**Query:**

```sql
SELECT
    record_id,
    DATE_FORMAT(treatment_date, '%d-%m-%Y') AS treatment_date
FROM Medical_Records;
```

**Output:**

|   record_id | treatment_date   |
|------------:|:-----------------|
|         201 | 10-02-2025       |
|         202 | 15-03-2025       |
|         203 | 20-06-2025       |
|         204 | 20-08-2025       |
|         205 | 05-09-2025       |
|         206 | 12-10-2025       |
|         207 | 18-11-2025       |
|         208 | 15-01-2026       |
|         209 | 20-02-2026       |
|         210 | 15-03-2026       |
|         211 | 10-04-2026       |


## 13. STRING FUNCTIONS

Cleaning and transforming text columns.

### 32. Patient names in uppercase

**Objective:** Normalize patient names to uppercase for display.

**Explanation:** `UPPER(name)` converts every character in the string to its uppercase form.

**Query:**

```sql
SELECT
    UPPER(name) AS patient_name
FROM Patients;
```

**Output:**

| patient_name   |
|:---------------|
| RAHUL PATEL    |
| PRIYA SHAH     |
| AMIT JOSHI     |
| NEHA MEHTA     |
| KARAN PATEL    |
| RIYA SHAH      |
| VIVEK DESAI    |
| POOJA JOSHI    |

### 33. Remove spaces from doctor names

**Objective:** Clean up any accidental leading/trailing whitespace in doctor names.

**Explanation:** `TRIM(name)` strips whitespace from both ends of the string, which guards against messy data entry.

**Query:**

```sql
SELECT
    TRIM(name) AS doctor_name
FROM Doctors;
```

**Output:**

| doctor_name     |
|:----------------|
| Dr. Raj Patel   |
| Dr. Neha Shah   |
| Dr. Amit Mehta  |
| Dr. Priya Desai |
| Dr. Karan Shah  |
| Dr. Riya Patel  |

### 34. Missing phone number

**Objective:** Display a friendly placeholder wherever a patient's phone number is missing.

**Explanation:** `COALESCE(phone_number, 'Not Available')` returns the first non-NULL value it's given, so a NULL phone number falls back to the placeholder text while real numbers pass through unchanged.

**Query:**

```sql
SELECT
    name,
    COALESCE(phone_number, 'Not Available') AS phone_number
FROM Patients;
```

**Output:**

| name        | phone_number   |
|:------------|:---------------|
| Rahul Patel | 9876543210     |
| Priya Shah  | 9876543211     |
| Amit Joshi  | 9876543212     |
| Neha Mehta  | 9876543213     |
| Karan Patel | 9876543214     |
| Riya Shah   | 9876543215     |
| Vivek Desai | Not Available  |
| Pooja Joshi | 9876543217     |


## 14. WINDOW FUNCTIONS

Calculations across a set of rows (rank, running total) without collapsing them like `GROUP BY` does.

### 35. Rank doctors according to patients treated

**Objective:** Rank doctors from busiest to least busy by distinct patients treated.

**Explanation:** An inner query first counts distinct completed-visit patients per doctor; the outer query applies the `RANK()` window function `OVER (ORDER BY total_patients DESC)` to assign a rank to each row without collapsing them the way `GROUP BY` would.

**Query:**

```sql
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
```

**Output:**

|   doctor_id |   total_patients |   doctor_rank |
|------------:|-----------------:|--------------:|
|           2 |                4 |             1 |
|           1 |                3 |             2 |
|           3 |                3 |             2 |
|           4 |                1 |             4 |

### 36. Monthly revenue

**Objective:** Total up paid revenue for each calendar month.

**Explanation:** Paid billing rows are grouped by `MONTH(payment_date)` and summed, the same pattern as the doctor-revenue query but bucketed by month instead of doctor.

**Query:**

```sql
SELECT
    MONTH(payment_date) AS month_number,
    SUM(amount) AS monthly_revenue
FROM Billing
WHERE payment_status = 'Paid'
GROUP BY MONTH(payment_date)
ORDER BY month_number;
```

**Output:**

|   month_number |   monthly_revenue |
|---------------:|------------------:|
|              2 |              8500 |
|              3 |              5500 |
|              4 |              4500 |
|              6 |              7500 |
|              7 |              6500 |
|              8 |              6000 |
|              9 |              2500 |
|             11 |              5500 |

### 37. Running total of revenue

**Objective:** Show revenue accumulating month over month across the year.

**Explanation:** The inner query first produces one row per month with that month's revenue; the outer query's window function `SUM(...) OVER (ORDER BY month_number)` adds each month's revenue to the running total of every month before it.

**Query:**

```sql
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
```

**Output:**

|   month_number |   monthly_revenue |   running_revenue |
|---------------:|------------------:|------------------:|
|              2 |              8500 |              8500 |
|              3 |              5500 |             14000 |
|              4 |              4500 |             18500 |
|              6 |              7500 |             26000 |
|              7 |              6500 |             32500 |
|              8 |              6000 |             38500 |
|              9 |              2500 |             41000 |
|             11 |              5500 |             46500 |

### 38. Running total of appointments

**Objective:** Track how the cumulative appointment count grows over time.

**Explanation:** `COUNT(*) OVER (ORDER BY appointment_date)` is a window function that, for every row, counts how many appointment rows have a date on or before it -- a running count rather than a single final total.

**Query:**

```sql
SELECT
    appointment_id,
    appointment_date,
    COUNT(*) OVER
    (
        ORDER BY appointment_date
    ) AS total_appointments
FROM Appointments
ORDER BY appointment_date;
```

**Output:**

|   appointment_id | appointment_date   |   total_appointments |
|-----------------:|:-------------------|---------------------:|
|              101 | 2025-02-10         |                    1 |
|              102 | 2025-03-15         |                    2 |
|              103 | 2025-06-20         |                    3 |
|              104 | 2025-07-10         |                    4 |
|              105 | 2025-08-20         |                    5 |
|              106 | 2025-09-05         |                    6 |
|              107 | 2025-10-12         |                    7 |
|              108 | 2025-11-18         |                    8 |
|              109 | 2026-01-15         |                    9 |
|              110 | 2026-02-20         |                   10 |
|              111 | 2026-03-15         |                   11 |
|              112 | 2026-04-10         |                   12 |
|              113 | 2026-05-12         |                   13 |
|              114 | 2026-06-18         |                   14 |
|              115 | 2026-07-20         |                   15 |


## 15. CASE EXPRESSION

Inline if/else logic that maps values into custom labels.

### 39. Patient Risk Level

**Objective:** Bucket each patient into a High/Medium/Low risk tier based on how many medical records they have.

**Explanation:** A `LEFT JOIN` to `Medical_Records` (so patients with zero records are still included) is grouped per patient, `COUNT(m.record_id)` counts their records, and a `CASE` expression maps that count into one of three text labels.

**Query:**

```sql
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
```

**Output:**

|   patient_id | name        |   total_records | Patient_Risk_Level   |
|-------------:|:------------|----------------:|:---------------------|
|            1 | Rahul Patel |               3 | Medium               |
|            2 | Priya Shah  |               2 | Low                  |
|            3 | Amit Joshi  |               2 | Low                  |
|            4 | Neha Mehta  |               0 | Low                  |
|            5 | Karan Patel |               1 | Low                  |
|            6 | Riya Shah   |               1 | Low                  |
|            7 | Vivek Desai |               1 | Low                  |
|            8 | Pooja Joshi |               1 | Low                  |


## 16. DOCTOR EXPERIENCE LEVEL

A second, standalone `CASE` example applied to the `Doctors` table.

### 40. Doctor experience level (CASE expression)

**Objective:** Bucket each doctor into a Senior/Mid-Level/Junior tier based on years of experience.

**Explanation:** A `CASE` expression evaluates `experience_years` against two thresholds and returns the matching text label as a new `experience_level` column, without altering the stored data.

**Query:**

```sql
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
```

**Output:**

|   doctor_id | name            |   experience_years | experience_level   |
|------------:|:----------------|-------------------:|:-------------------|
|           1 | Dr. Raj Patel   |                 18 | Senior             |
|           2 | Dr. Neha Shah   |                  8 | Mid-Level          |
|           3 | Dr. Amit Mehta  |                 20 | Senior             |
|           4 | Dr. Priya Desai |                 12 | Mid-Level          |
|           5 | Dr. Karan Shah  |                  3 | Junior             |
|           6 | Dr. Riya Patel  |                  2 | Junior             |


## 17. EXTRA USEFUL QUERIES

A few additional real-world reporting queries built on top of the schema.

### 41. Patient + Doctor + Appointment

**Objective:** Produce a single human-readable view of who saw which doctor, when, and with what outcome.

**Explanation:** Two joins pull the patient's name and the doctor's name/specialization into the appointment row, turning three tables of raw ids into one readable report.

**Query:**

```sql
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
```

**Output:**

| patient_name   | doctor_name     | specialization   | appointment_date   | status    |
|:---------------|:----------------|:-----------------|:-------------------|:----------|
| Rahul Patel    | Dr. Raj Patel   | Cardiology       | 2025-02-10         | Completed |
| Priya Shah     | Dr. Neha Shah   | Dermatology      | 2025-03-15         | Completed |
| Amit Joshi     | Dr. Amit Mehta  | Neurology        | 2025-06-20         | Completed |
| Neha Mehta     | Dr. Priya Desai | Orthopedics      | 2025-07-10         | Cancelled |
| Karan Patel    | Dr. Raj Patel   | Cardiology       | 2025-08-20         | Completed |
| Rahul Patel    | Dr. Neha Shah   | Dermatology      | 2025-09-05         | Completed |
| Priya Shah     | Dr. Amit Mehta  | Neurology        | 2025-10-12         | Completed |
| Amit Joshi     | Dr. Raj Patel   | Cardiology       | 2025-11-18         | Completed |
| Riya Shah      | Dr. Karan Shah  | General Medicine | 2026-01-15         | Scheduled |
| Vivek Desai    | Dr. Priya Desai | Orthopedics      | 2026-02-20         | Completed |
| Pooja Joshi    | Dr. Neha Shah   | Dermatology      | 2026-03-15         | Completed |
| Rahul Patel    | Dr. Amit Mehta  | Neurology        | 2026-04-10         | Completed |
| Priya Shah     | Dr. Raj Patel   | Cardiology       | 2026-05-12         | Scheduled |
| Amit Joshi     | Dr. Neha Shah   | Dermatology      | 2026-06-18         | Completed |
| Karan Patel    | Dr. Raj Patel   | Cardiology       | 2026-07-20         | Completed |

### 42. Patient billing details

**Objective:** Show each invoice together with the name of the patient it belongs to.

**Explanation:** Joining `Patients` to `Billing` on `patient_id` replaces the raw foreign key with the patient's actual name for the report.

**Query:**

```sql
SELECT
    p.name AS patient_name,
    b.invoice_id,
    b.amount,
    b.payment_status
FROM Patients p
JOIN Billing b
ON p.patient_id = b.patient_id;
```

**Output:**

| patient_name   |   invoice_id |   amount | payment_status   |
|:---------------|-------------:|---------:|:-----------------|
| Rahul Patel    |          301 |     5000 | Paid             |
| Priya Shah     |          302 |     3000 | Paid             |
| Amit Joshi     |          303 |     4500 | Paid             |
| Karan Patel    |          304 |     6000 | Paid             |
| Rahul Patel    |          305 |     2500 | Paid             |
| Priya Shah     |          306 |     4000 | Pending          |
| Amit Joshi     |          307 |     5500 | Paid             |
| Riya Shah      |          308 |     1500 | Pending          |
| Vivek Desai    |          309 |     3500 | Paid             |
| Pooja Joshi    |          310 |     2500 | Paid             |
| Rahul Patel    |          311 |     4500 | Paid             |
| Priya Shah     |          312 |     5000 | Pending          |
| Amit Joshi     |          313 |     3000 | Paid             |
| Karan Patel    |          314 |     6500 | Paid             |

### 43. Patients having more than one medical record

**Objective:** Find patients who have been treated more than once.

**Explanation:** `GROUP BY patient_id` buckets records per patient and `HAVING COUNT(*) > 1` keeps only the patients whose bucket has more than one row -- `HAVING` filters on the *aggregated* result, which is why it's used here instead of `WHERE`.

**Query:**

```sql
SELECT
    patient_id,
    COUNT(*) AS total_records
FROM Medical_Records
GROUP BY patient_id
HAVING COUNT(*) > 1;
```

**Output:**

|   patient_id |   total_records |
|-------------:|----------------:|
|            1 |               3 |
|            2 |               2 |
|            3 |               2 |

---
## 🎬 Project Demonstration
  <a href="https://drive.google.com/file/d/17eUwnqWvQ0KfVGGexT23ugcdpQ6gr_rj/view?usp=sharing">
    <img src="https://img.shields.io/badge/🎬%20Project%20Video-success?style=for-the-badge">
  </a>
</p>

---
