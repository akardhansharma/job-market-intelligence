SELECT TOP 10 skill, COUNT(DISTINCT job_id) as demand
FROM job_skills_exploded
WHERE skill IN (
    'sql','python','excel','tableau','power bi','power_bi',
    'r','sas','spark','aws','azure','gcp','snowflake',
    'databricks','airflow','pyspark','pandas','numpy',
    'matplotlib','seaborn','scikit-learn','tensorflow',
    'pytorch','keras','docker','git','dbt','looker',
    'bigquery','redshift','mongodb','postgresql'
)
GROUP BY skill
ORDER BY demand DESC;