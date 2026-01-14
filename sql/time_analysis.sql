/* =========================================================
   File: 03_time_analysis.sql
   Project: Uber Data Analysis
   Description: This file focuses on time-based analysis
                to understand demand patterns, peak hours,
                seasonality, and trends.
   Database: SQL Server
   Table: uber_data
   ========================================================= */


/* =========================================================
   1. Bookings by Hour
   Description: Shows how many rides happen at each hour of the day.
   ========================================================= */
SELECT 
    DATEPART(HOUR, [Time]) AS hour_of_day,
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY DATEPART(HOUR, [Time])
ORDER BY hour_of_day;


/* =========================================================
   2. Revenue by Hour
   Description: Shows how revenue is distributed across hours.
   ========================================================= */
SELECT 
    DATEPART(HOUR, [Time]) AS hour_of_day,
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY DATEPART(HOUR, [Time])
ORDER BY hour_of_day;


/* =========================================================
   3. Peak Hours
   Description: Identifies the busiest hours based on number of rides.
   ========================================================= */
SELECT TOP 5
    DATEPART(HOUR, [Time]) AS hour_of_day,
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY DATEPART(HOUR, [Time])
ORDER BY total_bookings DESC;


/* =========================================================
   4. Bookings by Day of Week
   Description: Shows ride distribution across weekdays.
   ========================================================= */
SELECT 
    DATENAME(WEEKDAY, [Date]) AS day_name,
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY DATENAME(WEEKDAY, [Date]);


/* =========================================================
   5. Revenue by Day of Week
   Description: Shows how revenue varies by weekday.
   ========================================================= */
SELECT 
    DATENAME(WEEKDAY, [Date]) AS day_name,
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY DATENAME(WEEKDAY, [Date]);


/* =========================================================
   6. Weekday vs Weekend Bookings
   Description: Compares total bookings on weekdays vs weekends.
   ========================================================= */
SELECT 
    CASE 
        WHEN DATENAME(WEEKDAY, [Date]) IN ('Saturday', 'Sunday') 
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY 
    CASE 
        WHEN DATENAME(WEEKDAY, [Date]) IN ('Saturday', 'Sunday') 
        THEN 'Weekend'
        ELSE 'Weekday'
    END;


/* =========================================================
   7. Weekday vs Weekend Revenue
   Description: Compares revenue on weekdays vs weekends.
   ========================================================= */
SELECT 
    CASE 
        WHEN DATENAME(WEEKDAY, [Date]) IN ('Saturday', 'Sunday') 
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY 
    CASE 
        WHEN DATENAME(WEEKDAY, [Date]) IN ('Saturday', 'Sunday') 
        THEN 'Weekend'
        ELSE 'Weekday'
    END;


/* =========================================================
   8. Monthly Bookings
   Description: Shows how bookings change month over month.
   ========================================================= */
SELECT 
    YEAR([Date]) AS year,
    MONTH([Date]) AS month,
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY YEAR([Date]), MONTH([Date])
ORDER BY year, month;


/* =========================================================
   9. Monthly Revenue
   Description: Shows revenue trend over months.
   ========================================================= */
SELECT 
    YEAR([Date]) AS year,
    MONTH([Date]) AS month,
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY YEAR([Date]), MONTH([Date])
ORDER BY year, month;


/* =========================================================
   10. Busiest Days
   Description: Finds the top 10 busiest dates by number of rides.
   ========================================================= */
SELECT TOP 10
    [Date],
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY [Date]
ORDER BY total_bookings DESC;


/* =========================================================
   11. Highest Revenue Days
   Description: Finds the days that generated the most revenue.
   ========================================================= */
SELECT TOP 10
    [Date],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Date]
ORDER BY total_revenue DESC;


/* =========================================================
   12. Morning vs Afternoon vs Evening vs Night
   Description: Categorizes rides into time buckets.
   ========================================================= */
SELECT 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END AS time_bucket,
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END;


/* =========================================================
   13. Revenue by Time Bucket
   Description: Shows revenue for each part of the day.
   ========================================================= */
SELECT 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END AS time_bucket,
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END;


/* =========================================================
   14. Average Distance by Hour
   Description: Shows how ride distance changes by hour.
   ========================================================= */
SELECT 
    DATEPART(HOUR, [Time]) AS hour_of_day,
    AVG([Ride Distance]) AS avg_distance
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY DATEPART(HOUR, [Time])
ORDER BY hour_of_day;


/* =========================================================
   15. Average Revenue by Hour
   Description: Shows average revenue per ride by hour.
   ========================================================= */
SELECT 
    DATEPART(HOUR, [Time]) AS hour_of_day,
    AVG([Booking Value]) AS avg_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY DATEPART(HOUR, [Time])
ORDER BY hour_of_day;
