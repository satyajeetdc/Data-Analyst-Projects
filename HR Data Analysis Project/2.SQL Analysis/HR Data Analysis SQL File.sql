/* --------------- Checking the data --------------- */

SELECT * FROM hrdata

/* --------------- Checking the employee count --------------- */

SELECT COUNT(emp_no) FROM hrdata

/* --------------- Checking the attrition count --------------- */

SELECT COUNT(attrition) FROM hrdata 
WHERE attrition = 'Yes'

/* --------------- Checking the attrition rate --------------- */

SELECT ROUND((SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes')*100
/SUM(employee_count), 2) AS attrition_rate FROM hrdata

/* --------------- Checking the Active employees --------------- */

SELECT SUM(active_employee) FROM hrdata

/* --------------- Checking the Average age of employees --------------- */

SELECT ROUND(AVG(age),0) FROM hrdata

/* --------------- Checking the attrition by age --------------- */

SELECT gender, COUNT(attrition) AS attrition_count 
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY gender
ORDER BY COUNT(attrition) DESC;

/* --------------- Checking the attrition by department --------------- */

SELECT department, COUNT(attrition) AS attrition_count 
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY COUNT(attrition) DESC

/* --------------- Checking the attrition by education field --------------- */

SELECT education_field, COUNT(attrition) AS attrition_count 
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC

/* --------------- Checking the attrition by age group --------------- */

SELECT age_band AS age_group, COUNT(attrition) AS attrition_count 
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY age_band
ORDER BY COUNT(attrition) DESC

/* --------------- Checking the count of employees by age group --------------- */

SELECT age_band AS age_group, SUM(employee_count) AS employee_count
FROM hrdata
GROUP BY age_band
ORDER BY employee_count DESC

/* --------------- Checking the attrition rate by gender of diferent age groups --------------- */

SELECT age_band AS age_group, gender, COUNT(attrition) AS attrition, 
ROUND((CAST(COUNT(attrition) as NUMERIC) / 
(SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes')) * 100, 2) AS percentage
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY age_band, gender
ORDER BY age_band, gender DESC;

/* --------------- Checking the attrition rate by gender of diferent departments --------------- */

SELECT department, gender, COUNT(attrition) AS attrition, 
ROUND((CAST(COUNT(attrition) as NUMERIC) / 
(SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes')) * 100, 2) AS percentage
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY department, gender
ORDER BY department, gender DESC;

/* --------------- Checking the job satisfaction rating --------------- */

-- activating the cosstab() function

CREATE EXTENSION IF NOT EXISTS tablefunc

-- now the process

SELECT *
FROM crosstab(
  'SELECT job_role, job_satisfaction, sum(employee_count)
   FROM hrdata
   GROUP BY job_role, job_satisfaction
   ORDER BY job_role, job_satisfaction'
	) AS CT(job_role VARCHAR(50), one NUMERIC, two NUMERIC, three NUMERIC, four NUMERIC)
ORDER BY job_role
