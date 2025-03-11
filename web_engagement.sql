USE WEB;
CREATE TABLE WebAnalytics (
    web_date date,
    Page_Views INT,
    Unique_Visitors INT,
    Bounce_Rate DECIMAL(5,2),
    Avg_Session_Duration DECIMAL(5,2),
    Traffic_Source VARCHAR(50),
    Device_Type ENUM('Desktop', 'Mobile', 'Tablet'),
    Region VARCHAR(100)
);

-- Total Unique Visitors --

SELECT SUM(Unique_Visitors) AS Total_Unique_Visitors
FROM webanalytics;

-- Average Bounce Rate --

SELECT AVG(Bounce_Rate) AS Avg_Bounce_Rate
FROM webanalytics;


-- Average Session Duration --

SELECT AVG(Avg_Session_Duration) AS Avg_Session_Duration
FROM webanalytics;

-- Traffic Source Breakdown --

SELECT Traffic_Source , COUNT(*) AS Traffic_Count
FROM webanalytics
GROUP BY Traffic_Source
ORDER BY Traffic_Count DESC;

-- Device Usage Share --

SELECT Device_Type, COUNT(*) AS Device_Count
FROM webanalytics
GROUP BY Device_Type
ORDER BY Device_Count DESC;

-- Top 5 Regions by Unique Visitors --

SELECT Region, SUM(Unique_Visitors) AS Total_Visitors
FROM webanalytics
GROUP BY Region
ORDER BY Total_Visitors DESC
LIMIT 5;

-- Engagement by Date --

SELECT web_date, SUM(Page_Views) AS Total_Page_Views, SUM(Unique_Visitors) AS Total_Unique_Visitors
FROM webanalytics
GROUP BY web_date
ORDER BY web_date ASC;