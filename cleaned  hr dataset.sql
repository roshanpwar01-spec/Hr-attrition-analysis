-- The dataset was largely clean with no missing values or duplicates. Cleaning focused on removing 3 constant columns with zero analytical value, 
-- and engineering new categorical features (salary bands, tenure bands, satisfaction labels) to support dashboard segmentation.
select * from mydb.hr_employee_attrition;
-- Drop constant columns
ALTER TABLE mydb.hr_employee_attrition
DROP COLUMN EmployeeCount,
DROP COLUMN StandardHours,
DROP COLUMN Over18;

-- Convert numeric flags into readable categories
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE mydb.hr_employee_attrition
ADD COLUMN EducationLevel VARCHAR(20);

UPDATE mydb.hr_employee_attrition
SET EducationLevel = CASE Education
    WHEN 1 THEN 'Below College'
    WHEN 2 THEN 'College'
    WHEN 3 THEN 'Bachelor'
    WHEN 4 THEN 'Master'
    WHEN 5 THEN 'Doctor'
END;

-- Create a salary band column (useful for grouping in charts)

ALTER TABLE mydb.hr_employee_attrition
ADD COLUMN SalaryBand VARCHAR(20);

UPDATE mydb.hr_employee_attrition
SET SalaryBand = CASE
    WHEN MonthlyIncome < 3000 THEN 'Low (<3000)'
    WHEN MonthlyIncome BETWEEN 3000 AND 6999 THEN 'Medium (3000-6999)'
    WHEN MonthlyIncome BETWEEN 7000 AND 12999 THEN 'High (7000-12999)'
    ELSE 'Very High (13000+)'
END;

select salaryband from mydb.hr_employee_attrition;

 -- Create a tenure band (useful for attrition analysis)
ALTER TABLE mydb.hr_employee_attrition
ADD COLUMN TenureBand VARCHAR(20);

UPDATE mydb.hr_employee_attrition
SET TenureBand = CASE
    WHEN YearsAtCompany <= 2 THEN '0-2 years'
    WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5 years'
    WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 years'
    ELSE '10+ years'
END;

select * from mydb.hr_employee_attrition;
show variables like 'port' ;
SHOW VARIABLES LIKE 'bind_address';
SELECT user, host, plugin FROM mysql.user WHERE user = 'root';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Roshan@03';
FLUSH PRIVILEGES;
SELECT user, host, plugin FROM mysql.user WHERE user = 'root';