-- QUESTIONS
USE hr;
-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*)  AS gender_breakdown
FROM human_resource_staging2
WHERE age >= 18
GROUP BY gender;
-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS race_breakdown
FROM human_resource_staging2
WHERE age >= 18
GROUP BY race
ORDER BY COUNT(*) DESC;
-- 3. What is the age distribution of employees in the company?
SELECT MAX(age), MIN(age)
FROM human_resource_staging2
WHERE age >= 18 ;

SELECT CASE 
	WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
ELSE '65+'
END AS age_group, gender,
COUNT(*) AS count
FROM human_resource_staging2
WHERE age >= 18
GROUP BY age_group, gender
ORDER by age_group, gender;
-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS location_breakdown
FROM human_resource_staging2
WHERE age >= 18
GROUP BY location;
-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
	AVG(DATEDIFF(termdate, hire_date)) / 365 AS avg_length_employment
FROM human_resource_staging2
WHERE termdate <= CURRENT_DATE() AND age >= 18;
-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*)
FROM human_resource_staging2
WHERE age >= 18
GROUP BY department, gender;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*)
FROM human_resource_staging2
WHERE age >= 18
GROUP BY jobtitle;


-- 8. Which department has the highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (SELECT department, COUNT(*) AS total_count,
SUM(CASE WHEN termdate != '0000-00-00'AND termdate <= CURRENT_DATE() THEN 1 ELSE 0 END ) AS terminated_count
FROM human_resource_staging2
WHERE age >= 18
GROUP BY department) AS subquery;
-- 9. What is the distribution of employees across locations by city and state?
SELECT  location_state, COUNT(*) AS count
FROM human_resource_staging2
WHERE age >= 18
GROUP BY  location_state
;
-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT year, hires, termination, hires-termination AS net_change,
ROUND((hires-termination)/hires *100,2) AS net_change_percent
FROM (SELECT year(hire_date) AS year,
COUNT(*) AS hires,
SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= CURRENT_DATE() THEN 1 ELSE 0 END) AS termination
FROM human_resource_staging2
WHERE age >= 18
GROUP BY year(hire_date)
) AS subquery;
-- 11. What is the tenure distribution for each department?
SELECT department, AVG(DATEDIFF(termdate, hire_date)/365) AS avg_tenure
FROM human_resource_staging2
WHERE termdate <= CURRENT_DATE() AND termdate != '0000-00-00' AND age >= 18
GROUP by department
;

-- total employee
SELECT  COUNT(*)
FROM human_resource_staging2
WHERE age >= 18
;
