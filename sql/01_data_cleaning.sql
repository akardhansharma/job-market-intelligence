USE JobMarketIntelligence;

-- Standardize NULLs in location
UPDATE job_postings
SET location = 'Unknown'
WHERE location IS NULL OR location = '';

-- Standardize work_from_home
UPDATE job_postings
SET work_from_home = 'Yes'
WHERE work_from_home = 'True';

UPDATE job_postings
SET work_from_home = 'No'
WHERE work_from_home = 'False';

-- Add clean date column
ALTER TABLE job_postings
ADD posted_date DATE;



USE JobMarketIntelligence;

UPDATE job_postings
SET posted_date = TRY_CAST(date_time AS DATE);

SELECT 
    COUNT(*)                                        AS total_rows,
    SUM(CASE WHEN salary_avg IS NOT NULL 
        THEN 1 ELSE 0 END)                          AS rows_with_salary,
    SUM(CASE WHEN work_from_home = 'Yes' 
        THEN 1 ELSE 0 END)                          AS remote_jobs,
    SUM(CASE WHEN posted_date IS NULL 
        THEN 1 ELSE 0 END)                          AS null_dates
FROM job_postings;