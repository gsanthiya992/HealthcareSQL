create database healthcare;
use healthcare;
CREATE DATABASE healthcare_db;
USE healthcare_db;
-- alter table
ALTER TABLE appointments_sql
CHANGE COLUMN `ï»¿appointment_id` appointment_id INT;
ALTER TABLE patients_sql
CHANGE COLUMN `ï»¿patient_id` patient_id INT;
ALTER TABLE doctors_sql
CHANGE COLUMN `ï»¿doctor_id` doctor_id INT;
ALTER TABLE diagnoses_sql
CHANGE COLUMN `ï»¿diagnosis_id` diagnosis_id INT;
ALTER TABLE medications_sql
CHANGE COLUMN `ï»¿medication_id` medication_id INT;
-- Verify Data
SELECT COUNT(*) FROM patients_sql;
SELECT COUNT(*) FROM doctors_sql;
SELECT COUNT(*) FROM appointments_sql;
SELECT COUNT(*) FROM diagnoses_sql;
SELECT COUNT(*) FROM medications_sql;
DESCRIBE appointments_sql;
DESCRIBE patients_sql;
DESCRIBE doctors_sql;
DESCRIBE diagnoses_sql;
DESCRIBE medications_sql;
SELECT COUNT(*) AS total_appointments
FROM appointments_sql;
SELECT * FROM appointments_sql
LIMIT 5;

-- Task 1
SELECT
    a.appointment_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.appointment_date
FROM appointments_sql AS a
INNER JOIN patients_sql AS p
    ON a.patient_id = p.patient_id
INNER JOIN doctors_sql AS d
    ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed';

-- Task 2
SELECT
    p.patient_id,
    p.name,
    p.contact_number,
    p.address
FROM patients_sql p
LEFT JOIN appointments_sql a
    ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

-- Task 3
SELECT
    d.doctor_id,
    d.name,
    d.specialization,
    COUNT(di.diagnosis_id) AS total_diagnoses
FROM doctors_sql d
LEFT JOIN diagnoses_sql di
    ON d.doctor_id = di.doctor_id
GROUP BY d.doctor_id,d.name,d.specialization;

-- Task 4
SELECT
    a.patient_id,
    a.doctor_id,
    a.appointment_id,
    di.diagnosis_id
FROM appointments_sql a
LEFT JOIN diagnoses_sql di
    ON a.patient_id = di.patient_id
    AND a.doctor_id = di.doctor_id

UNION

SELECT
    a.patient_id,
    a.doctor_id,
    a.appointment_id,
    di.diagnosis_id
FROM appointments_sql a
RIGHT JOIN diagnoses_sql di
    ON a.patient_id = di.patient_id
    AND a.doctor_id = di.doctor_id;
    
-- Task 5
SELECT
    doctor_id,
    patient_id,
    COUNT(*) AS total_appointments,
    RANK() OVER(
        PARTITION BY doctor_id
        ORDER BY COUNT(*) DESC
    ) AS patient_rank
FROM appointments_sql
GROUP BY doctor_id, patient_id;

-- Task 6
SELECT
CASE
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 50 THEN '31-50'
    ELSE '51+'
END AS age_group,
COUNT(*) AS total_patients
FROM patients_sql
GROUP BY age_group;

-- Task 7
SELECT
UPPER(name) AS patient_name,
contact_number
FROM patients_sql
WHERE contact_number LIKE '%1234';

-- Task 8
SELECT DISTINCT patient_id
FROM diagnoses_sql
WHERE diagnosis_id IN (
    SELECT diagnosis_id
    FROM medications_sql
    WHERE medication_name='Insulin'
)
AND patient_id NOT IN (
    SELECT DISTINCT d.patient_id
    FROM diagnoses_sql d
    JOIN medications_sql m
    ON d.diagnosis_id = m.diagnosis_id
    WHERE m.medication_name <> 'Insulin'
);

-- Task 9
SELECT
    diagnosis_id,
    AVG(DATEDIFF(end_date,start_date)) AS avg_days
FROM medications_sql
GROUP BY diagnosis_id;

-- Task 10
SELECT
    d.doctor_id,
    d.name,
    d.specialization,
    COUNT(DISTINCT a.patient_id) AS unique_patients
FROM doctors_sql d
JOIN appointments_sql a
    ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id,d.name,d.specialization
ORDER BY unique_patients DESC
LIMIT 1;