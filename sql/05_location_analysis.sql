USE JobMarketIntelligence;

-- Top 15 hiring cities
SELECT TOP 15
    location,
    COUNT(*)                                        AS total_jobs,
    ROUND(AVG(CAST(salary_avg AS FLOAT)), 0)        AS avg_salary
FROM job_postings
WHERE location != 'Unknown'
AND location != 'Anywhere'
AND location != 'United States'
GROUP BY location
ORDER BY total_jobs DESC;

-- Top 10 highest paying cities
SELECT TOP 10
    location,
    ROUND(AVG(CAST(salary_avg AS FLOAT)), 0)        AS avg_salary,
    COUNT(*)                                        AS jobs_with_salary
FROM job_postings
WHERE salary_avg IS NOT NULL
AND location != 'Unknown'
AND location != 'Anywhere'
AND location != 'United States'
GROUP BY location
HAVING COUNT(*) > 10
ORDER BY avg_salary DESC;

-- Remote jobs by search location
SELECT TOP 10
    search_location,
    COUNT(*)                                        AS remote_jobs
FROM job_postings
WHERE work_from_home = 'Yes'
GROUP BY search_location
ORDER BY remote_jobs DESC;