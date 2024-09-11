create database project3;
use project3;

CREATE TABLE job_data (
    job_id INT,
    actor_id INT,
    event VARCHAR(20),
    language VARCHAR(50),
    time_spent INT,
    org VARCHAR(100),
    ds VARCHAR(10)
);

INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
VALUES
    ('2020/11/30', 21, 1001, 'skip', 'English', 15, 'A'),
    ('2020/11/30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
    ('2020/11/29', 23, 1003, 'decision', 'Persian', 20, 'C'),
    ('2020/11/28', 23, 1005, 'transfer', 'Persian', 22, 'D'),
    ('2020/11/28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
    ('2020/11/27', 11, 1007, 'decision', 'French', 104, 'D'),
    ('2020/11/26', 23, 1004, 'skip', 'Persian', 56, 'A'),
    ('2020/11/25', 20, 1003, 'transfer', 'Italian', 45, 'C');
    
SELECT
    DATE(ds_date) AS review_date,
    HOUR(ds_date) AS review_hour,
    COUNT(*) AS jobs_reviewed
FROM (
    SELECT STR_TO_DATE(ds, '%Y/%m/%d') AS ds_date, job_id
    FROM job_data
    WHERE ds LIKE '2020/11%'
) AS filtered_data
GROUP BY review_date, review_hour
ORDER BY review_date, review_hour;



SELECT
    language,
    COUNT(*) * 100.0 / (
        SELECT COUNT(*)
        FROM job_data
        WHERE ds >= '2020/11/01' AND ds <= '2020/11/30'
    ) AS language_share_percentage
FROM job_data
WHERE ds >= '2020/11/01' AND ds <= '2020/11/30'
GROUP BY language
ORDER BY language_share_percentage DESC;


SELECT
    language,
    COUNT(*) * 100.0 / (
        SELECT COUNT(*)
        FROM job_data
        WHERE STR_TO_DATE(ds, '%Y/%m/%d') >= CURDATE() - INTERVAL 30 DAY
    ) AS language_share_percentage
FROM job_data
WHERE STR_TO_DATE(ds, '%Y/%m/%d') >= CURDATE() - INTERVAL 30 DAY
GROUP BY language
ORDER BY language_share_percentage DESC;



SELECT
    job_id,
    actor_id,
    event,
    language,
    time_spent,
    org,
    ds,
    COUNT(*) AS duplicate_count
FROM job_data
GROUP BY
    job_id,
    actor_id,
    event,
    language,
    time_spent,
    org,
    ds
HAVING COUNT(*) > 1;


# Case Study 2

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    created_at varchar(100),
    company_id INT,
    language VARCHAR(50),
    activated_at varchar(100),
    state VARCHAR(50)
);

show variables LIKE 'secure_file_priv';

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from users

ALTER TABLE USERS ADD COLUMN temp_created_at datetime;
UPDATE users SET temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;

# table 2 
create table events(
user_id int, 
event_type varchar(50), 
event_name varchar(100), 
location varchar(100) ,
device varchar(50) ,
user_type int,
occurred_at varchar(100)
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

desc events;
select * from events

ALTER TABLE events ADD COLUMN temp_created_at datetime;
UPDATE events SET temp_created_at = STR_TO_DATE(ocurred_at_at, '%d-%m-%Y %H:%i');
alter table events drop column occured_at;
alter table events change column temp_created_at occured_at datetime;

create table email_events (
user_id int, 
action varchar(100), 
user_type int, 
occurred_at varchar(100)
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events

ALTER TABLE email_events ADD COLUMN temp_created_at datetime;
UPDATE email_events SET temp_created_at = STR_TO_DATE(ocurred_at_at, '%d-%m-%Y %H:%i');
alter table email_events drop column occured_at;
alter table email_events change column temp_created_at occured_at datetime;

#Tasks:

/* A: 
Weekly User Engagement:
Objective: Measure the activeness of users on a weekly basis.
Your Task: Write an SQL query to calculate the weekly user engagement.*/

select * from events
SELECT YEAR(occurred_at) AS year,
       WEEK(occurred_at) AS week_number,
       COUNT(DISTINCT user_id) AS active_users
FROM events
GROUP BY year, week_number
ORDER BY year, week_number;



/* B: 
User Growth Analysis:
Objective: Analyze the growth of users over time for a product.
Your Task: Write an SQL query to calculate the user growth for the product.*/

select * from users

SELECT DATE_FORMAT(created_at, '%Y-%m') AS month,
       COUNT(DISTINCT user_id) AS new_users
FROM users
GROUP BY month
ORDER BY month;


/* C:
Weekly Retention Analysis:
Objective: Analyze the retention of users on a weekly basis after signing up for a product.
Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.*/

select * from email_events

SELECT DATE_FORMAT(created_at, '%Y-%m-%d') AS cohort_week,
       YEAR(created_at) AS year,
       WEEK(created_at) AS week_number,
       COUNT(DISTINCT u.user_id) AS cohort_size,
       COUNT(DISTINCT CASE WHEN DATEDIFF(e.occurred_at, u.created_at) BETWEEN 0 AND 6 THEN e.user_id END) AS retained_users
FROM users u
LEFT JOIN events e ON u.user_id = e.user_id
GROUP BY cohort_week, year, week_number
ORDER BY cohort_week, year, week_number;


/* D:
Weekly Engagement Per Device:
Objective: Measure the activeness of users on a weekly basis per device.
Your Task: Write an SQL query to calculate the weekly engagement per device.*/



/* C: 
Email Engagement Analysis:
Objective: Analyze how users are engaging with the email service.
Your Task: Write an SQL query to calculate the email engagement metrics.*/


















