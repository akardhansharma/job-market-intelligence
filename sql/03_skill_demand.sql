USE JobMarketIntelligence;

-- Top 20 most in-demand skills
SELECT TOP 20
    skill,
    COUNT(*) AS demand_count
FROM job_skills_exploded
GROUP BY skill
ORDER BY demand_count DESC;

-- Top 5 skills per role
SELECT *
FROM (
    SELECT 
        j.title,
        s.skill,
        COUNT(*) AS count,
        ROW_NUMBER() OVER (
            PARTITION BY j.title 
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM job_postings j
    JOIN job_skills_exploded s ON j.job_id = s.job_id
    GROUP BY j.title, s.skill
) ranked
WHERE rn <= 5
ORDER BY title, rn;

-- Skill appearance rate (% of jobs requiring each skill)
SELECT TOP 20
    skill,
    COUNT(*) AS demand_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM job_postings), 2) AS pct_of_jobs
FROM job_skills_exploded
GROUP BY skill
ORDER BY demand_count DESC;