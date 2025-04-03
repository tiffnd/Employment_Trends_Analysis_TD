-- Employment Trends Analysis (2014–2024)

-- This is a walkthrough I created using SQL to show how I would analyze U.S. national employment trends 
-- using monthly data from the Bureau of Labor Statistics (BLS).
-- The goal here is to better understand how employment levels have changed over time, both month-to-month and year-over-year.
-- The queries demonstrate how I would approach the analysis if the data were loaded into a live SQL database.

-- Working with the following columns: year, month, label, employment value, and 1-month net change.

-- 1. Creating the table structure for the employment trends data

CREATE TABLE employment_trends (
    series_id VARCHAR(20),
    year INT,
    period VARCHAR(5),
    label VARCHAR(20),
    value INT, -- total employment for the month
    net_change INT, -- 1-month change in employment
    avg_employment FLOAT,
    max_employment INT,
    min_employment INT,
    avg_monthly_net_change FLOAT,
    monthly_percent_change FLOAT,
    yoy_change INT,
    yoy_percent_change FLOAT
);

-- 2. Just adding a few example rows here.
-- Normally the full dataset would be imported from a CSV or another file.

INSERT INTO employment_trends (series_id, year, period, label, value, net_change)
VALUES 
    ('CES0000000001', 2023, 'M12', '2023 Dec', 156930, 269),
    ('CES0000000001', 2024, 'M01', '2024 Jan', 157049, 119),
    ('CES0000000001', 2024, 'M02', '2024 Feb', 157271, 222),
    ('CES0000000001', 2024, 'M03', '2024 Mar', 157517, 246);

-- 3. Viewing employment trends in order by year and month

SELECT 
    year,
    period,
    label,
    value AS employment_value,
    net_change AS one_month_change
FROM 
    employment_trends
ORDER BY 
    year ASC, period ASC;

-- 4. Calculating the average monthly employment change

SELECT 
    ROUND(AVG(net_change), 1) AS avg_monthly_change
FROM 
    employment_trends;

-- 5. Calculating year-over-year employment change

SELECT 
    curr.year,
    curr.label,
    curr.value AS current_value,
    prev.value AS prior_year_value,
    (curr.value - prev.value) AS yoy_change,
    ROUND(((curr.value - prev.value) / prev.value) * 100, 1) AS yoy_percent_change
FROM 
    employment_trends curr
JOIN 
    employment_trends prev
    ON curr.period = prev.period AND curr.year = prev.year + 1
ORDER BY 
    curr.year ASC, curr.period ASC;

-- 6. Finding the highest and lowest total employment values in the dataset

SELECT 
    MAX(value) AS max_employment,
    MIN(value) AS min_employment
FROM 
    employment_trends;

-- 7. Looking at the employment drop during the COVID-19 pandemic (April 2020)

SELECT 
    label,
    value AS employment_value,
    net_change AS one_month_drop
FROM 
    employment_trends
WHERE 
    label = '2020 Apr';

-- 8. Total YOY employment changes by year
-- This gives a quick look at how much employment shifted each year overall.

SELECT 
    curr.year,
    SUM(curr.value - prev.value) AS total_yoy_change
FROM 
    employment_trends curr
JOIN 
    employment_trends prev
    ON curr.period = prev.period AND curr.year = prev.year + 1
GROUP BY 
    curr.year
ORDER BY 
    curr.year;

-- That's a wrap on the key insights I chose to pull from the dataset.