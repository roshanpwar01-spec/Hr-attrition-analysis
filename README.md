# HR Employee Attrition Analysis — SQL + Power BI

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=flat&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-FFA500?style=flat)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

An end-to-end data analytics project on the IBM HR Employee Attrition dataset — data cleaning and feature engineering in MySQL, exploratory analysis with SQL, and an interactive multi-page Power BI dashboard surfacing the key drivers of employee attrition.

## Table of Contents
- [Overview](#overview)
- [Tools & Tech Stack](#tools--tech-stack)
- [Project Structure](#project-structure)
- [Dataset](#dataset)
- [Data Cleaning & Feature Engineering](#data-cleaning--feature-engineering)
- [SQL Analysis](#sql-analysis)
- [Key Findings](#key-findings)
- [Power BI Dashboard](#power-bi-dashboard)
- [Skills Demonstrated](#skills-demonstrated)
- [Author](#author)

## Overview

This project walks through a full analyst workflow on 1,470 employee records: querying and profiling the raw data in SQL, engineering new features to support segmentation, and building a dashboard that lets a stakeholder explore attrition by department, compensation, tenure, satisfaction, and demographics.

| Phase | Description | Status |
|---|---|---|
| 1 | Dataset selection (IBM HR Employee Attrition) | ✅ Done |
| 2 | SQL exploratory analysis | ✅ Done |
| 3 | Data cleaning & feature engineering | ✅ Done |
| 4 | Power BI dashboard | ✅ Done |
| 5 | Documentation & publishing | ✅ This README |

## Tools & Tech Stack

- **MySQL / MySQL Workbench** — data cleaning, feature engineering, exploratory SQL analysis
- **Power BI Desktop** — data modelling, DAX measures, multi-page interactive dashboard
- **DAX** — calculated KPI measures (headcount, attrition rate, average income, average tenure)

## Project Structure

```
hr-attrition-analysis/
├── README.md
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_feature_engineering.sql
│   └── 03_exploratory_analysis.sql
├── powerbi/
│   └── HR_Attrition_Dashboard.pbix
├── images/
│   ├── overview_page.png
│   ├── deep_dive_page.png
│   └── satisfaction_page.png
└── data/
    └── HR-Employee-Attrition.csv
```

## Dataset

[IBM HR Employee Attrition Dataset](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset) — 1,470 employee records with demographic, compensation, satisfaction, and tenure attributes, plus a binary `Attrition` flag (Yes/No).

## Data Cleaning & Feature Engineering

The raw dataset had no missing values or duplicate records. Cleaning focused on removing zero-variance columns and engineering categorical features to support dashboard segmentation:

- Dropped 3 constant columns with no analytical value: `EmployeeCount`, `StandardHours`, `Over18`
- Resolved MySQL Safe Update Mode (`SET SQL_SAFE_UPDATES = 0`) to allow `UPDATE` statements without a key-based `WHERE` clause
- Engineered `EducationLevel` — mapped the numeric `Education` codes (1–5) to readable labels (Below College → Doctor)
- Engineered `SalaryBand` — Low (<3,000), Medium (3,000–6,999), High (7,000–12,999), Very High (13,000+)
- Engineered `TenureBand` — 0–2 years, 3–5 years, 6–10 years, 10+ years

```sql
-- Drop constant columns
ALTER TABLE mydb.hr_employee_attrition
  DROP COLUMN EmployeeCount,
  DROP COLUMN StandardHours,
  DROP COLUMN Over18;

-- Engineer a salary band feature
ALTER TABLE mydb.hr_employee_attrition ADD COLUMN SalaryBand VARCHAR(20);

UPDATE mydb.hr_employee_attrition
SET SalaryBand = CASE
    WHEN MonthlyIncome < 3000 THEN 'Low (<3000)'
    WHEN MonthlyIncome BETWEEN 3000 AND 6999 THEN 'Medium (3000-6999)'
    WHEN MonthlyIncome BETWEEN 7000 AND 12999 THEN 'High (7000-12999)'
    ELSE 'Very High (13000+)'
END;
```

## SQL Analysis

Exploratory analysis covered attrition breakdowns, compensation patterns, and demographic distributions. A few representative queries (full set in [`/sql`](./sql)):

```sql
-- Overall attrition rate
SELECT Attrition, COUNT(*) AS Count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM mydb.hr_employee_attrition), 2) AS Percentage
FROM mydb.hr_employee_attrition
GROUP BY Attrition;

-- Attrition by department
SELECT Department, Attrition, COUNT(*) AS Count
FROM mydb.hr_employee_attrition
GROUP BY Department, Attrition
ORDER BY Department;

-- Average income: employees who left vs. stayed
SELECT Attrition, ROUND(AVG(MonthlyIncome), 2) AS AvgIncome
FROM mydb.hr_employee_attrition
GROUP BY Attrition;
```

Other query groups included attrition by gender, job role, business travel, overtime, and marital status; average income by department and job role; and distribution breakdowns by age group, education field, and job level.

## Key Findings

- Overall attrition rate is **16.1%** (237 of 1,470 employees)
- **Overtime** is the single strongest driver: employees who work overtime leave at **30.5%**, nearly 3x the rate of those who don't (10.4%)
- **Sales** has the highest departmental attrition (20.6%), ahead of HR (19.0%) and R&D (13.8%) — despite R&D being by far the largest department
- **Compensation gap**: employees who left earned $4,787 on average vs. $6,833 for those who stayed — roughly 30% less
- **Low earners in their first two years** are the highest-risk group: the Low salary band (<$3,000) has 28.6% attrition overall, climbing to 38.1% for employees with 0–2 years of tenure. The Very High band sits at just 4.9%
- **Marital status matters**: Single employees attrite at 25.5%, more than double Married (12.5%) and Divorced (10.1%) employees
- **Sales Representative** is the highest-risk role at 39.8% attrition, followed by Laboratory Technician at 23.9% — well above Research Scientist (16.1%) and Sales Executive (17.5%)
- **Satisfaction scores** show a consistent gradient: attrition drops as Job Satisfaction (22.8% → 11.3%), Environment Satisfaction (25.4% → 13.5%), and Relationship Satisfaction (20.7% → 14.8%) scores rise from 1 to 4
- **Education field**: Human Resources (25.9%) and Technical Degree (24.2%) backgrounds show the highest attrition; Medical and Other fields are lowest (~13–14%)
- **Age**: attrition is sharply elevated among employees under 20 and ticks back up near retirement age (~58–59), with a stable, lower-attrition band through the middle of employees' careers
- **Pay reflects seniority more than department**: Managers average $17,182/month vs. $2,626 for Sales Representatives — a wider gap than seen across departments

## Power BI Dashboard

A 3-page interactive report built on the cleaned dataset.

### 1. Overview
KPI cards for headcount, attrition rate, average monthly income, and average tenure; attrition rate by department; attrition rate by age trend; a hierarchy slicer (Department → Gender → Age) for cross-filtering.

![overview] imagesoverview_page.png.png

### 2. Attrition Deep Dive
Income vs. tenure scatter plot colored by attrition; a Salary Band × Tenure Band matrix highlighting the highest-risk segments; attrition by marital status; attrition by work-life balance rating.

![Attrition Deep Dive page]imagesdeep_dive_page.png.png

### 3. Satisfaction & Demographics
Attrition by gender and education field; attrition broken out by job, environment, and relationship satisfaction scores.

![Satisfaction & Demographics page]imagessatisfaction_page.png.png

KPI cards and attrition-rate visuals are powered by DAX measures; pages support drill-through navigation between the summary view and detail pages.

## Skills Demonstrated

- SQL (aggregation, `CASE` logic, schema alteration, feature engineering)
- Data cleaning
- Power BI (data modeling, DAX, multi-page report design, drill-through navigation)
- Data storytelling and insight generation from raw HR data

## Author

**Roshan Panwar**
MSc Data Science & Statistics, Graphic Era Hill University

[LinkedIn](#) · [GitHub](#)

