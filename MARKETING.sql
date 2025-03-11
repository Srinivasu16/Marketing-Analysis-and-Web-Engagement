create database marketing;
use marketing;

CREATE TABLE Campaigns (
    Campaign_ID varchar(20) PRIMARY KEY,
    Campaign_Name VARCHAR(255) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL
);

CREATE TABLE Emails (
    Email_ID VARCHAR(20) PRIMARY KEY,
    Campaign_ID VARCHAR(20),
    Email_Subject VARCHAR(255) NOT NULL,
    Email_Sent_Date DATE NOT NULL,
    FOREIGN KEY (Campaign_ID) REFERENCES Campaigns(Campaign_ID) ON DELETE CASCADE
);

CREATE TABLE Activities (
    Activity_ID VARCHAR(20) PRIMARY KEY,
    Email_ID VARCHAR(20),
    Activity_Type VARCHAR(100) NOT NULL,
    Activity_Date DATE NOT NULL,
    FOREIGN KEY (Email_ID) REFERENCES Emails(Email_ID) ON DELETE CASCADE
);

-- Q1 --

SELECT 
    (COUNT(CASE WHEN a.Activity_Type = 'Delivered' THEN 1 END) * 100.0) / COUNT(e.Email_ID) AS email_delivery_rate
FROM emails e
LEFT JOIN activities a ON e.Email_ID = a.Email_ID;

-- Q2 --

SELECT 
    (COUNT(CASE WHEN a.Activity_Type = 'Open' THEN 1 END) * 100.0) / 
    NULLIF(COUNT(CASE WHEN a.Activity_Type = 'Delivered' THEN 1 END), 0) AS open_rate
FROM emails e
LEFT JOIN activities a ON e.Email_ID = a.Email_ID;

-- Q3 --

SELECT 
    (COUNT(CASE WHEN a.Activity_Type = 'Click' THEN 1 END) * 100.0) / 
    NULLIF(COUNT(CASE WHEN a.Activity_Type = 'Open' THEN 1 END), 0) AS click_through_rate
FROM emails e
LEFT JOIN activities a ON e.Email_ID = a.Email_ID;

-- Q4 --

SELECT 
    c.Campaign_ID,
    c.Campaign_Name,
    (COUNT(a.Activity_ID) * 100.0) / (SELECT COUNT(*) FROM activities) AS engagement_rate
FROM campaigns c
JOIN emails e ON c.Campaign_ID = e.Campaign_ID
JOIN activities a ON e.Email_ID = a.Email_ID
GROUP BY c.Campaign_ID, c.Campaign_Name;

-- Q5 --

SELECT 
    c.Campaign_ID,
    c.Campaign_Name,
    COUNT(a.Activity_ID) AS total_activities
FROM campaigns c
JOIN emails e ON c.Campaign_ID = e.Campaign_ID
JOIN activities a ON e.Email_ID = a.Email_ID
GROUP BY c.Campaign_ID, c.Campaign_Name
ORDER BY total_activities DESC;

-- Q6 --

SELECT 
    (COUNT(a.Activity_ID) * 1.0) / COUNT(DISTINCT e.Email_ID) AS avg_activity_per_email
FROM emails e
LEFT JOIN activities a ON e.Email_ID = a.Email_ID;

-- Q7 --

SELECT 
    Activity_Type,
    COUNT(*) AS activity_count,
    (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM activities) AS percentage
FROM activities
GROUP BY Activity_Type;

-- Q8 --

SELECT 
    Date,
    SUM(email_count) AS total_emails_sent,
    SUM(activity_count) AS total_activities
FROM (
    SELECT 
        Email_Sent_Date AS Date,
        COUNT(*) AS email_count,
        0 AS activity_count
    FROM emails
    GROUP BY Email_Sent_Date
    
    UNION ALL
    
    SELECT 
        Activity_Date AS Date,
        0 AS email_count,
        COUNT(*) AS activity_count
    FROM activities
    GROUP BY Activity_Date
) AS combined_data
GROUP BY Date
ORDER BY Date;

