/*

Questions: 
- What are the top-paying data engineer jobs?
- Identify the top 10 highest-paying Data Engineer roles.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Engineer.
*/

--Top 10 highest paying data analyst roles that are either remote or local
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
LIMIT 10;