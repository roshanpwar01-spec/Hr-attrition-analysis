select * from mydb.hr_employee_attrition;
# 2 total employees
select count(*) as total_emp from mydb.hr_employee_attrition;
# 3 Attrition count and percentage
SELECT Attrition,
       COUNT(*) AS Count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM mydb.hr_employee_attrition), 2) AS Percentage
FROM mydb.hr_employee_attrition
GROUP BY Attrition;
# 4 ATTRITION ANALYSIS
## 4.1. Attrition by Department
SELECT Department, Attrition, COUNT(*) AS Count
FROM mydb.hr_employee_attrition GROUP BY Department, Attrition ORDER BY Department;
## 4.2. attrition by gender
select gender , attrition,count(*) as count
from mydb.hr_employee_attrition group by gender,Attrition order by gender;
# 4.3. attrition by job role
select jobrole,attrition,count(*) as count
from mydb.hr_employee_attrition group by JobRole,Attrition order by JobRole;
# 4.4. attrition by business travel
select businesstravel,attrition,count(*)as count
from mydb.hr_employee_attrition group by BusinessTravel,Attrition order by BusinessTravel;
# 4.5. attrition by overtime
select overtime,attrition,count(*)as count
from mydb.hr_employee_attrition group by overtime,Attrition order by overtime;
-- 4.6. Attrition by Marital Status
SELECT MaritalStatus, Attrition, COUNT(*) AS Count
FROM mydb.hr_employee_attrition GROUP BY MaritalStatus, Attrition;

