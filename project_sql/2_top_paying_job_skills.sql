/*Question:
- What are the top-paying data analyst jobs, and what skills are required?
- Identify the top 10 highest-paying Data Analyst jobs and the specific skills 
required for these roles.
- Filters for roles with specified salaries that are remote.
- Why? It provides a detailed look at which high-paying jobs demand certain 
skills,helping job seekers understand which skills to develop that align 
with top salaries.

*/

-- Gets the top 10 paying Data Analyst jobs 

WITH top_paying_jobs_for_Data_Analyst AS (

SELECT
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name as company_name

FROM
	job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

)

SELECT 
    top_paying_jobs_for_Data_Analyst.job_id,
    top_paying_jobs_for_Data_Analyst.company_name,
    top_paying_jobs_for_Data_Analyst.job_title,
    top_paying_jobs_for_Data_Analyst.salary_year_avg,
    skills_dim.skills
FROM top_paying_jobs_for_Data_Analyst
INNER JOIN
    skills_job_dim ON top_paying_jobs_for_Data_Analyst.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_paying_jobs_for_Data_Analyst.salary_year_avg DESC;


WITH top_paying_jobs_for_Data_Engineer AS (

SELECT
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name as company_name

FROM
	job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Engineer'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

)

SELECT 
    top_paying_jobs_for_Data_Engineer.job_id,
    top_paying_jobs_for_Data_Engineer.company_name,
    top_paying_jobs_for_Data_Engineer.job_title,
    top_paying_jobs_for_Data_Engineer.salary_year_avg,
    skills_dim.skills
FROM top_paying_jobs_for_Data_Engineer
INNER JOIN
    skills_job_dim ON top_paying_jobs_for_Data_Engineer.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;

/*

Here are the insights from the "skills" column:

Top skills required:

SQL (mentioned 8 times) is the most in-demand skill.
Python (7 mentions) follows as a key programming skill.
Tableau (6 mentions) is highly sought for data visualization.
Other frequently mentioned skills:

R (4 mentions), Snowflake, Pandas, and Excel (3 mentions each) are also popular.
Cloud platforms like Azure and AWS are increasingly prominent (2 mentions each).
Diverse tools:

Tools for collaboration and workflow, such as Jira, Confluence, and Bitbucket, have multiple mentions.
Specialized tools like Power BI, Databricks, and SAP also make appearances.

*/