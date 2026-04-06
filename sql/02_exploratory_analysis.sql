USE JobMarketIntelligence;

-- Total postings by role
SELECT title, COUNT(*) AS total_postings
FROM job_postings
GROUP BY title
ORDER BY total_postings DESC;

-- Remote vs on-site split
SELECT 
    work_from_home,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct
FROM job_postings
GROUP BY work_from_home;

-- Monthly posting volume
SELECT 
    posted_month,
    COUNT(*) AS postings
FROM job_postings
GROUP BY posted_month
ORDER BY posted_month;

-- Top 10 hiring companies
SELECT TOP 10
    company_name,
    COUNT(*) AS job_postings
FROM job_postings
GROUP BY company_name
ORDER BY job_postings DESC;