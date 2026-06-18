select * from mydb.hr_employee_attrition;
-- 1 Avg Monthly Income by Department
SELECT Department,ROUND(AVG(MonthlyIncome), 2) AS AvgIncome,
MIN(MonthlyIncome) AS MinIncome,MAX(MonthlyIncome) AS MaxIncome
FROM mydb.`hr_employee_attrition` GROUP BY Department;
-- 2 Income by Attrition (left vs stayed)
select attrition , round(AVG(Monthlyincome),2)as avgincome
from mydb.hr_employee_attrition group by Attrition;
-- 3 income by jobrole
SELECT JobRole,ROUND(AVG(MonthlyIncome), 2) AS AvgIncome
FROM mydb.hr_employee_attrition GROUP BY JobRole ORDER BY AvgIncome DESC;
-- 4 salary hike vs performance
SELECT PerformanceRating, ROUND(AVG(PercentSalaryHike), 2) AS AvgHike
FROM mydb.hr_employee_attrition GROUP BY PerformanceRating;
-- workforce demography
ALTER TABLE mydb.hr_employee_attrition 
CHANGE COLUMN `ï»¿Age` `Age` INT;
-- 1 age group distribution
select case when age <25 then 'under25'
when age between 25 and 35 then '25-35'
when age between 36 and 46 then '36-46'
else 'above 45 'end as agegroup,
count(*) as count from mydb.hr_employee_attrition group by agegroup;
-- 2 Job Satisfaction vs Attrition
SELECT JobSatisfaction, Attrition, COUNT(*) AS Count
FROM mydb.hr_employee_attrition
GROUP BY JobSatisfaction, Attrition;
-- 3Environment Satisfaction vs Attrition
SELECT EnvironmentSatisfaction, Attrition, COUNT(*) AS Count
FROM mydb.hr_employee_attrition
GROUP BY EnvironmentSatisfaction, Attrition;
-- 4 Relationship Satisfaction vs Attrition
SELECT RelationshipSatisfaction, Attrition, COUNT(*) AS Count
FROM mydb.hr_employee_attrition
GROUP BY RelationshipSatisfaction, Attrition;