Finish your readme file on GitHub. You can include:

# Introduction 
This project focuses on uncovering the most lucrative roles in data analytics as a Data Analyst and Data Engineer, 
analyzing the skills in highest demand, and identifying where these two factors 
intersect,high-demand jobs with high salaries.

Our key objectives include:

- **Identifying Top-Paying Roles:** Analyzing job postings to find positions with the highest average salaries in the data analytics domain.

- **Highlighting In-Demand Skills:** Pinpointing the technical and soft skills most frequently required by employers.

- **Mapping the Demand-Salary Intersection:** Identifying jobs that are both in high demand and offer competitive salaries, providing insights into the most strategic career paths.

Check out my SQL queries here: [project_sql folder](/project_sql/).

# Background 
The growing significance of data in driving business decisions has made 
data-centric roles, such as data analysts and data engineers, pivotal in the modern workforce.
As someone keen on exploring these fields, my motivation to understand the job 
market for these roles stems from three core aspirations:

- 1.***Aligning Skills with Market Demand:***

The roles of data analysts and data engineers require a dynamic skillset that 
evolves with technology and industry needs. By analyzing the job market, 
I can identify the most in-demand tools, technologies, and qualifications, 
allowing me to tailor my learning and career development to stay competitive 
and relevant.

- 2.***Navigating Career Opportunities***

With a clear understanding of which roles offer the highest salaries, 
career growth potential, and job security, I can make informed decisions about 
my career trajectory. This knowledge is crucial in identifying paths that 
align with my personal goals, interests, and the value I wish to bring to 
organizations.

- 3.***Contributing to Data-Driven Transformation***

Data professionals play a critical role in solving complex problems, 
optimizing processes, and enabling innovation. By understanding the nuances 
of these roles, I aim to position myself not only as a competent professional 
but also as someone who can drive impactful change in organizations and 
industries.






The data for this analysis is from Luke Barousse’s SQL Course (https://lukebarousse.com/sql). This data includes details on job titles, salaries, locations, and 
required skills. 

## The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst and data engineer jobs working from a remote area?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts and data engineers?
4. Which skills are associated with higher salaries for both roles?
5. What are the most optimal skills to learn for a data analyst and a data engineer looking to maximize job market value?



# Tools 

In this project, I utilized a variety of tools to conduct my analysis:

- **SQL:** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL:** As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.


# How You Used the Tools or Analysis - Explain how you used the tools (get into the details of each query/analysis).

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1a. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
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
LIMIT 20;
```




![Top paying roles](assets/1a_data_analyst_top_paying_jobs.png) 


### 1a. Top Paying Data Engineer Jobs

This query highlights the high paying opportunities for the Data Engineer roles.
This time we only filtered the data by the average yearly salary.

```sql
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
    AND job_location IS NOT NULL
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

![Top paying roles](assets/1b_top_paying_data_engineer_roles.png)


### 2. Data Analyst Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with high salaries with the skills data, providing insights into what employers value for high-compensation roles.

```sql

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
```

![Top skills](assets/2_top_skills_2023.png)



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



### 3a. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, by filtering the average yearly salary and directing the focus to areas with high demand.

```sql
SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM
  job_postings_fact
  INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  -- Filters job titles for 'Data Analyst' roles
  job_postings_fact.job_title_short = 'Data Analyst'
  AND job_postings_fact.salary_year_avg > 70000
	-- AND job_work_from_home = True -- optional to filter for remote jobs
GROUP BY
  skills_dim.skills
ORDER BY
  demand_count DESC
LIMIT 5;
```
| skills  | demand_count |
| ------- | ------------ |
| sql     | 2455         |
| python  | 1532         |
| excel   | 1457         |
| tableau | 1349         |
| R       | 884          |

The table provided represents the demand for various skills in the job market based on their frequency of occurrence in job postings:

- **SQL:** 2,455 mentions, making it the most in-demand skill.
- **Python:** 1,532 mentions, indicating its prominence in data-related roles.
- **Excel:** 1,457 mentions, showing its continued relevance for data management.
- **Tableau:** 1,349 mentions, highlighting the demand for visualization tools.
- **R:** 884 mentions, indicating demand for statistical computing in specialized roles.


### 3b. In-Demand Skills for Data Engineers

This query helped identify the skills most frequently requested in job postings for Data Engineers, we filtered the data by the column work from home and the average yearly salaries. We show the areas with high demand.

```sql
SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM
  job_postings_fact
  INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  -- Filters job titles for 'Data Analyst' roles
  job_postings_fact.job_title_short = 'Data Engineer' 
  AND job_postings_fact.job_work_from_home = TRUE
  AND job_postings_fact.salary_year_avg > 70000
	-- AND job_work_from_home = True -- optional to filter for remote jobs
GROUP BY
  skills_dim.skills
ORDER BY
  demand_count DESC
LIMIT 5;
```

| skills | demand_count |
| ------ | ------------ |
| sql    | 544          |
| python | 504          |
| aws    | 345          |
| azure  | 242          |
| spark  | 223          |

Based on the table, here are the top 5 skills in-demand for data engineers:

***1.SQL:*** Continues to dominate as the most in-demand skill, reflecting its critical role in data querying and management.

***2.Python:*** A close second to SQL, Python remains a highly sought-after skill, especially for data analysis, machine learning, and automation.

***3.AWS:*** Highlights the growing importance of cloud computing in managing and processing data at scale.

***4.Azure:*** Indicates strong demand for Microsoft's cloud platform, complementing AWS in enterprise environments.

***5.Spark:*** Shows the need for distributed data processing frameworks, particularly in handling large-scale data.

### 4a. Data Analysts Skills Based on Salary

Gathering the average salaries associated with different skills to get which skills are the highest paying.

```sql
SELECT
  skills_dim.skills AS skill, 
  ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
  job_postings_fact
	INNER JOIN
	  skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	INNER JOIN
	  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_title_short = 'Data Analyst' 
  AND job_postings_fact.salary_year_avg IS NOT NULL 
GROUP BY
  skills_dim.skills 
ORDER BY
  avg_salary DESC
LIMIT 20 ; 
```
Here is the result:

| skill        | avg_salary |
| ------------ | ---------- |
| svn          | 400000     |
| solidity     | 179000     |
| couchbase    | 160515     |
| datarobot    | 155486     |
| golang       | 155000     |
| mxnet        | 149000     |
| dplyr        | 147633     |
| vmware       | 147500     |
| terraform    | 146734     |
| twilio       | 138500     |
| gitlab       | 134126     |
| kafka        | 129999     |
| puppet       | 129820     |
| keras        | 127013     |
| pytorch      | 125226     |
| perl         | 124686     |
| ansible      | 124370     |
| hugging face | 123950     |
| tensorflow   | 120647     |
| cassandra    | 118407     |


### 4b. Data Engineers Skills Based on Salary

```sql
SELECT
  skills_dim.skills AS skill, 
  ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
  job_postings_fact
	INNER JOIN
	  skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	INNER JOIN
	  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_title_short = 'Data Engineer' 
  AND job_postings_fact.salary_year_avg IS NOT NULL 
GROUP BY
  skills_dim.skills 
ORDER BY
  avg_salary DESC
LIMIT 20; 
```

Here are the result:

| skill      | avg_salary |
| ---------- | ---------- |
| node       | 181862     |
| mongo      | 179403     |
| ggplot2    | 176250     |
| solidity   | 166250     |
| vue        | 159375     |
| codecommit | 155000     |
| ubuntu     | 154455     |
| clojure    | 153663     |
| cassandra  | 150255     |
| rust       | 147771     |
| drupal     | 147500     |
| perl       | 145540     |
| next.js    | 145000     |
| angular    | 143319     |
| scala      | 143161     |
| kafka      | 143086     |
| gdpr       | 142369     |
| shell      | 141725     |
| macos      | 141617     |
| numpy      | 141605     |


### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS (
  SELECT
    skills_dim.skill_id,
		skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	  INNER JOIN
	    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
  GROUP BY
    skills_dim.skill_id
  HAVING
    COUNT(skills_job_dim.job_id) > 10  
)
, average_salary AS (
  SELECT
    skills_job_dim.skill_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
  GROUP BY
    skills_job_dim.skill_id
    
)

SELECT
  skills_demand.skill_id,
  skills_demand.skills,
  skills_demand.demand_count,
  ROUND(average_salary.avg_salary, 0) AS avg_salary 
FROM
  skills_demand
	INNER JOIN
	  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY  
	  avg_salary DESC,
    demand_count DESC
LIMIT 30;
```

| skill_id | skills     | demand_count | avg_salary |
| -------- | ---------- | ------------ | ---------- |
| 8        | go         | 27           | 115320     |
| 234      | confluence | 11           | 114210     |
| 97       | hadoop     | 22           | 113193     |
| 80       | snowflake  | 37           | 112948     |
| 74       | azure      | 34           | 111225     |
| 77       | bigquery   | 13           | 109654     |
| 76       | aws        | 32           | 108317     |
| 4        | java       | 17           | 106906     |
| 194      | ssis       | 12           | 106683     |
| 233      | jira       | 20           | 104918     |
| 79       | oracle     | 37           | 104534     |
| 185      | looker     | 49           | 103795     |
| 2        | nosql      | 13           | 101414     |
| 1        | python     | 236          | 101397     |
| 5        | r          | 148          | 100499     |
| 78       | redshift   | 16           | 99936      |
| 187      | qlik       | 13           | 99631      |
| 182      | tableau    | 230          | 99288      |
| 197      | ssrs       | 14           | 99171      |
| 92       | spark      | 13           | 99077      |
| 13       | c++        | 11           | 98958      |
| 186      | sas        | 63           | 98902      |
| 7        | sas        | 63           | 98902      |
| 61       | sql server | 35           | 97786      |
| 9        | javascript | 20           | 97587      |
| 183      | power bi   | 110          | 97431      |
| 0        | sql        | 398          | 97237      |
| 215      | flow       | 28           | 97200      |
| 201      | alteryx    | 17           | 94145      |
| 199      | spss       | 24           | 92170      |

# What You Learned - Specific techniques and skills you Learned

Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.


# Insights - The insights you got from each this analysis and what you would do with this information.

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

# Conclusion - Wrapping everything up.

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

