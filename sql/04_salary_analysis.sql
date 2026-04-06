USE JobMarketIntelligence;

-- Average salary by role
SELECT 
    title,
    ROUND(AVG(CAST(salary_avg AS FLOAT)), 0)  AS avg_salary,
    ROUND(MIN(CAST(salary_avg AS FLOAT)), 0)  AS min_salary,
    ROUND(MAX(CAST(salary_avg AS FLOAT)), 0)  AS max_salary,
    COUNT(*)                                   AS postings_with_salary
FROM job_postings
WHERE salary_avg IS NOT NULL
GROUP BY title
ORDER BY avg_salary DESC;

-- Top paying skills
SELECT TOP 20
    s.skill,
    ROUND(AVG(CAST(j.salary_avg AS FLOAT)), 0) AS avg_salary,
    COUNT(*)                                    AS job_count
FROM job_postings j
JOIN job_skills_exploded s ON j.job_id = s.job_id
WHERE j.salary_avg IS NOT NULL
GROUP BY s.skill
HAVING COUNT(*) > 10
ORDER BY avg_salary DESC;

-- Salary by remote vs onsite
SELECT 
    work_from_home,
    ROUND(AVG(CAST(salary_avg AS FLOAT)), 0) AS avg_salary,
    COUNT(*)                                  AS job_count
FROM job_postings
WHERE salary_avg IS NOT NULL
GROUP BY work_from_home;