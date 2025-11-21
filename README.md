# 📊 New Zealand Annual Enterprise Survey 2024 - SQL Analysis

Advanced SQL queries analyzing financial performance across New Zealand industries.

## 📋 Project Overview

This project demonstrates advanced SQL techniques to analyze the **New Zealand Annual Enterprise Survey 2024** dataset. The analysis covers financial performance, profitability metrics, and industry comparisons across various sectors including Agriculture, Mining, Manufacturing, and more.

## 🗂️ Database Schema

```sql
CREATE TABLE annual_survey_2024 (
  Year INT NOT NULL,
  Industry_aggregation_NZSIOC VARCHAR(10),
  Industry_code_NZSIOC VARCHAR(10),
  Industry_name_NZSIOC VARCHAR(100),
  Units VARCHAR(50),
  Variable_code VARCHAR(5),
  Variable_name VARCHAR(70),
  Variable_category VARCHAR(80),
  Value INT,
  Industry_code_ANZSIC06 VARCHAR(200)
);
```

### Key Columns:
- **Industry_aggregation_NZSIOC**: Hierarchy level (Level 1, 3, or 4)
- **Variable_code**: Financial metric identifier (H01-H41)
- **Variable_category**: Financial performance, Financial position, or Financial ratios
- **Value**: Numeric value in millions (for currency) or percentage

## 🔍 Variable Codes Reference

| Code | Variable Name | Category |
|------|--------------|----------|
| H01 | Total income | Financial performance |
| H08 | Total expenditure | Financial performance |
| H11 | Depreciation | Financial performance |
| H12 | Salaries and wages paid | Financial performance |
| H23 | Surplus before income tax | Financial performance |
| H24 | Total assets | Financial position |
| H25 | Current assets | Financial position |
| H26 | Fixed tangible assets | Financial position |
| H31 | Shareholders funds or owners equity | Financial position |
| H32 | Current liabilities | Financial position |
| H33 | Other liabilities | Financial position |
| H34 | Total income per employee count | Financial ratios |
| H36 | Current ratio | Financial ratios |
| H39 | Return on equity | Financial ratios |
| H40 | Return on total assets | Financial ratios |

## 💡 SQL Concepts Demonstrated

### Basic Queries
- ✅ SELECT, WHERE, ORDER BY
- ✅ DISTINCT values
- ✅ COUNT, SUM, AVG, MAX, MIN aggregations
- ✅ GROUP BY with aggregations

### Intermediate Queries
- ✅ Self-JOINs for comparing metrics
- ✅ CASE statements for conditional logic
- ✅ String functions (SPLIT_PART)
- ✅ Type casting (::INT)

### Advanced Queries
- ✅ Window Functions (RANK(), OVER())
- ✅ Multiple JOINs
- ✅ NULLIF for division safety
- ✅ Complex calculations with ROUND()
- ✅ Subqueries and derived columns

## 📊 Sample Queries

### 1. Basic Exploration
```sql
-- Welche verschiedenen Variable_categories gibt es?
SELECT DISTINCT Variable_category 
FROM annual_survey_2024;
```

### 2. Industry-Specific Analysis
```sql
-- Alle Einträge für "Horticulture and Fruit Growing"
SELECT * 
FROM annual_survey_2024 
WHERE Industry_name_NZSIOC = 'Horticulture and Fruit Growing';
```

### 3. Aggregation Queries
```sql
-- Top 5 Industries mit höchsten Current Liabilities
SELECT 
  Industry_name_NZSIOC, 
  SUM(Value) AS current_liabilities
FROM annual_survey_2024
WHERE Variable_code = 'H32'
GROUP BY Industry_name_NZSIOC 
ORDER BY current_liabilities DESC
LIMIT 5;
```

### 4. Advanced Analysis with JOINs
```sql
-- Vergleich: Current Assets vs Current Liabilities
SELECT 
  a.Industry_name_NZSIOC,
  a.Value AS current_assets,
  l.Value AS current_liabilities,
  (a.Value - l.Value) AS differenz
FROM annual_survey_2024 a
JOIN annual_survey_2024 l 
  ON a.Industry_name_NZSIOC = l.Industry_name_NZSIOC
WHERE a.Variable_code = 'H25' 
  AND l.Variable_code = 'H32'
  AND a.Industry_aggregation_NZSIOC = 'Level 1'
  AND a.Value > l.Value
ORDER BY differenz DESC;
```

### 5. Profit Margin Calculation with CASE
```sql
-- Profit Margin (%) für Level 1 Industries
SELECT 
  Industry_name_NZSIOC,
  SUM(CASE WHEN Variable_code = 'H23' THEN Value END) AS surplus,
  SUM(CASE WHEN Variable_code = 'H01' THEN Value END) AS total_income,
  ROUND((SUM(CASE WHEN Variable_code = 'H23' THEN Value END) * 100.0 / 
         NULLIF(SUM(CASE WHEN Variable_code = 'H01' THEN Value END), 0)), 2) AS profit_margin_percent
FROM annual_survey_2024
WHERE Industry_aggregation_NZSIOC = 'Level 1'
  AND Variable_code IN ('H01', 'H23')
GROUP BY Industry_name_NZSIOC
ORDER BY profit_margin_percent DESC;
```

### 6. Ranking with Window Functions
```sql
-- Ranking nach "Total income per employee"
SELECT 
  Industry_name_NZSIOC,
  Value AS income_per_employee,
  RANK() OVER (ORDER BY Value DESC) AS ranking
FROM annual_survey_2024
WHERE Variable_code = 'H34'
ORDER BY ranking;
```

### 7. Financial Ratio Analysis
```sql
-- Industries mit Return on Equity > 10%
SELECT 
  Industry_name_NZSIOC,
  Value AS return_on_equity_percent
FROM annual_survey_2024
WHERE Variable_code = 'H39'
  AND Value > 10
  AND Industry_aggregation_NZSIOC = 'Level 1'
ORDER BY Value DESC;
```

## 🎯 Key Insights

### Query Categories:
1. **Data Exploration** (Queries 1-4): Understanding the dataset structure
2. **Aggregation Analysis** (Queries 5-8): Statistical summaries
3. **Advanced Calculations** (Queries 9-14): Complex financial metrics
4. **Comparative Analysis** (Queries 15-18): Industry comparisons using JOINs and CASE statements

## 🛠️ Technologies Used

- **SQL** (PostgreSQL syntax)
- **Window Functions** for ranking and percentages
- **Self-JOINs** for metric comparisons
- **CASE Statements** for conditional aggregations

## 📂 Project Structure

```
project-sql-annual-survey/
│
├── SQL_annual_survey_2024.sql    # Main SQL queries
├── README.md                     # This file
└── data/                         # Dataset (if included)
```

## 🚀 How to Use

1. **Setup Database:**
   ```sql
   -- Create table
   CREATE TABLE annual_survey_2024 (...);
   
   -- Import data
   COPY annual_survey_2024 FROM 'path/to/dataset.csv' 
   DELIMITER ';' CSV HEADER;
   ```

2. **Run Queries:**
   - Execute queries individually or in sequence
   - Modify `Industry_aggregation_NZSIOC` filters for different analysis levels

3. **Customize Analysis:**
   - Change `Variable_code` values to analyze different metrics
   - Adjust `WHERE` clauses for specific industries

## 📈 Sample Results

**Top Industries by Return on Equity:**
- All industries: 12%
- Manufacturing: 14%
- Mining: 13%

**Industries with Positive Liquidity (Assets > Liabilities):**
- Agriculture, Forestry and Fishing
- Manufacturing
- All industries aggregate

## 👨‍💻 Author

Advanced SQL Project - New Zealand Industry Financial Analysis

## 📝 License

Educational project for SQL demonstration purposes.

---

⭐ **Star this repository if you find it helpful!**
