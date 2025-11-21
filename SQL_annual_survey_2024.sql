-- New Project Advanced SQL --

DROP TABLE IF EXISTS annual_survey_2024;

-- CREATE NEW TABLE ---
CREATE TABLE annual_survey_2024 (
  Year INT NOT NULL,
  Industry_aggregation_NZSIOC VARCHAR(10),
  Industry_code_NZSIOC  VARCHAR(10) ,
  Industry_name_NZSIOC VARCHAR(100),
  Units VARCHAR(50),
  Variable_code VARCHAR(5),
  Variable_name VARCHAR(70),
  Variable_category VARCHAR(80),
  Value INT,
  Industry_code_ANZSIC06 VARCHAR(200)
);

/*Welche verschiedenen Variable_categories gibt es in der Tabelle?*/

SELECT DISTINCT Variable_category 
FROM annual_survey_2024 ; 

/* Zeige alle Einträge für "Horticulture and Fruit Growing" */

SELECT * 
FROM annual_survey_2024 
WHERE Industry_name_NZSIOC = 'Horticulture and Fruit Growing';

/* Welche Variable_names haben einen Value unter 100 */

SELECT Variable_name
FROM annual_survey_2024
WHERE Value < 100;

/* Wie viele Einträge gibt es für "Level 4" Industries? */

SELECT count (*)
FROM annual_survey_2024
WHERE  Industry_aggregation_NZSIOC = 'Level 4' ;

/* Zeige alle "Financial position" Variablen für "All industries" */

SELECT * 
FROM   annual_survey_2024
WHERE  Industry_name_NZSIOC = "Financial position"  AND Variable_category = "All industries" ; 

/*  Was ist der durchschnittliche Value für alle "Financial ratios" Variablen?*/
SELECT AVG(Value) :: INT  
FROM   annual_survey_2024
WHERE   Variable_category = 'Financial ratios' ;

/* Welche Industry hat die höchsten code_nummer  */

SELECT Industry_name_NZSIOC, 
MAX(SPLIT_PART(Variable_code,'H',2)::INT) AS max_code_number 
FROM   annual_survey_2024
GROUP BY Industry_name_NZSIOC;

/* Wie viele verschiedene Industry_name_NZSIOC gibt es */

SELECT COUNT(DISTINCT( Industry_name_NZSIOC ))
FROM annual_survey_2024;

/* Was ist der Minimum- und Maximum-Wert für "Depreciation" (H11) */

SELECT MAX(Value), MIN(Value) 
FROM annual_survey_2024
WHERE Variable_code = 'H11' ;

/*Summiere alle Values für Variable_code H31 (Shareholders funds)*/

SELECT SUM(Value) 
FROM annual_survey_2024
WHERE Variable_code = 'H11' ;

/*Gruppiere nach Industry_name und zeige die Summe der Total expenditure (H08) */

SELECT Industry_name_NZSIOC , SUM( Value) as Total_expenditure 
FROM annual_survey_2024
WHERE Variable_code = 'H20'
GROUP BY Industry_name_NZSIOC
ORDER BY Total_expenditure;

-- Wie viele verschiedene Variable_codes gibt es pro Variable_category?

SELECT  DISTINCT Variable_category , COUNT(DISTINCT(Variable_code)) as anzahl_variable  
FROM annual_survey_2024
GROUP BY Variable_category 
ORDER BY anzahl_variable ;

-- Durchschnittlicher Value pro Industry_aggregation_NZSIOC
SELECT DISTINCT Industry_aggregation_NZSIOC , AVG(Value)::INT as average_value  
FROM annual_survey_2024
GROUP BY Industry_aggregation_NZSIOC
ORDER BY average_value ;

-- Zeige die Top 5 Industries mit den höchsten Current liabilities (H32)

SELECT DISTINCT Industry_name_NZSIOC , SUM(Value) AS current_liabilities
FROM annual_survey_2024
WHERE Variable_code = 'H32'
GROUP BY Industry_name_NZSIOC 
ORDER BY current_liabilities ;

--Vergleiche für jede Level 1 Industry die "Current Assets" (H25) mit den "Current Liabilities" (H32). Welche Industries haben mehr Assets als Liabilities?
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

--Vergleiche für jede Level 1 Industry die "Current Assets" (H25) mit den "Current Liabilities" (H32). Welche Industries haben mehr Assets als Liabilities? Zeige die Differenz.

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

--Welche Industries haben einen Return on Equity (H39) von mehr als 10 Prozent? 

  SELECT 
  Industry_name_NZSIOC,
  Value AS return_on_equity_percent
  FROM annual_survey_2024
  WHERE Variable_code = 'H39'
  AND Value > 10
  AND Industry_aggregation_NZSIOC = 'Level 1'
  ORDER BY Value DESC;

-- Welche Industries haben einen Return on Equity (H39) von mehr als 10 Prozent?

  SELECT 
  Industry_name_NZSIOC,
  Value AS return_on_equity_percent
  FROM annual_survey_2024
  WHERE Variable_code = 'H39'
  AND Value > 10
  AND Industry_aggregation_NZSIOC = 'Level 1'
  ORDER BY Value DESC;

-- Erstelle ein Ranking aller Industries nach ihrem "Total income per employee" (H34). Welche Industry ist am produktivsten?

  SELECT 
  Industry_name_NZSIOC,
  Value AS income_per_employee,
  RANK() OVER (ORDER BY Value DESC) AS ranking
  FROM annual_survey_2024
  WHERE Variable_code = 'H34'
  ORDER BY ranking;