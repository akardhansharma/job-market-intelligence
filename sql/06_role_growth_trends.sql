USE JobMarketIntelligence;

-- Monthly postings by role
SELECT 
    title,
    posted_month,
    COUNT(*) AS postings
FROM job_postings
WHERE title IN (
    'Data Analyst', 'Senior Data Analyst', 
    'Data Scientist', 'Data Engineer',
    'Business Data Analyst'
)
GROUP BY title, posted_month
ORDER BY title, posted_month;

-- Month over month growth by role
WITH monthly AS (
    SELECT 
        title,
        posted_month,
        COUNT(*) AS postings
    FROM job_postings
    WHERE title IN (
        'Data Analyst', 'Senior Data Analyst',
        'Data Scientist', 'Data Engineer',
        'Business Data Analyst'
    )
    GROUP BY title, posted_month
),
with_lag AS (
    SELECT *,
        LAG(postings) OVER (
            PARTITION BY title 
            ORDER BY posted_month
        ) AS prev_month
    FROM monthly
)
SELECT 
    title,
    posted_month,
    postings,
    prev_month,
    ROUND(
        (postings - prev_month) * 100.0 / NULLIF(prev_month, 0), 1
    ) AS mom_growth_pct
FROM with_lag
WHERE prev_month IS NOT NULL
ORDER BY title, posted_month;

-- Overall market growth first vs last month
SELECT 
    posted_month,
    COUNT(*) AS total_postings
FROM job_postings
GROUP BY posted_month
ORDER BY posted_month;