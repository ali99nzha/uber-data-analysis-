/* =========================================================
   File: 04_cancellation_analysis.sql
   Project: Uber Data Analysis
   Description: This file focuses on understanding cancellations,
                their reasons, patterns, and revenue impact.
   Database: SQL Server
   Table: uber_data
   ========================================================= */


/* =========================================================
   1. Total Cancelled Rides
   Description: Counts all cancelled rides (by customer or driver).
   ========================================================= */
SELECT COUNT(*) AS total_cancelled_rides
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes';


/* =========================================================
   2. Customer vs Driver Cancellations
   Description: Compares how many cancellations are from customers
                vs drivers.
   ========================================================= */
SELECT 
    CASE 
        WHEN [Cancelled Rides by Customer] = 'Yes' THEN 'Customer'
        WHEN [Cancelled Rides by Driver] = 'Yes' THEN 'Driver'
    END AS cancelled_by,
    COUNT(*) AS total_cancellations
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
GROUP BY 
    CASE 
        WHEN [Cancelled Rides by Customer] = 'Yes' THEN 'Customer'
        WHEN [Cancelled Rides by Driver] = 'Yes' THEN 'Driver'
    END;


/* =========================================================
   3. Cancellation Rate
   Description: Calculates the overall cancellation rate.
   ========================================================= */
SELECT 
    CAST(SUM(CASE 
        WHEN [Cancelled Rides by Customer] = 'Yes'
          OR [Cancelled Rides by Driver] = 'Yes'
        THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*) * 100 AS cancellation_rate
FROM uber_data;


/* =========================================================
   4. Cancellation Rate by Vehicle Type
   Description: Shows which vehicle types have the highest
                cancellation rates.
   ========================================================= */
SELECT 
    [Vehicle Type],
    CAST(SUM(CASE 
        WHEN [Cancelled Rides by Customer] = 'Yes'
          OR [Cancelled Rides by Driver] = 'Yes'
        THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*) * 100 AS cancellation_rate
FROM uber_data
GROUP BY [Vehicle Type]
ORDER BY cancellation_rate DESC;


/* =========================================================
   5. Cancellation Rate by Pickup Location
   Description: Identifies locations with high cancellation rates.
   ========================================================= */
SELECT 
    [Pickup Location],
    CAST(SUM(CASE 
        WHEN [Cancelled Rides by Customer] = 'Yes'
          OR [Cancelled Rides by Driver] = 'Yes'
        THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*) * 100 AS cancellation_rate
FROM uber_data
GROUP BY [Pickup Location]
ORDER BY cancellation_rate DESC;


/* =========================================================
   6. Most Common Customer Cancellation Reasons
   Description: Shows why customers cancel most often.
   ========================================================= */
SELECT 
    [Reason for cancelling by Customer],
    COUNT(*) AS total_cancellations
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
GROUP BY [Reason for cancelling by Customer]
ORDER BY total_cancellations DESC;


/* =========================================================
   7. Most Common Driver Cancellation Reasons
   Description: Shows why drivers cancel most often.
   ========================================================= */
SELECT 
    [Driver Cancellation Reason],
    COUNT(*) AS total_cancellations
FROM uber_data
WHERE [Cancelled Rides by Driver] = 'Yes'
GROUP BY [Driver Cancellation Reason]
ORDER BY total_cancellations DESC;


/* =========================================================
   8. Lost Revenue Due to Cancellations
   Description: Calculates how much revenue is lost because
                of cancellations.
   ========================================================= */
SELECT 
    SUM([Booking Value]) AS lost_revenue
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes';


/* =========================================================
   9. Lost Revenue by Vehicle Type
   Description: Shows which vehicle types lose the most money
                due to cancellations.
   ========================================================= */
SELECT 
    [Vehicle Type],
    SUM([Booking Value]) AS lost_revenue
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
GROUP BY [Vehicle Type]
ORDER BY lost_revenue DESC;


/* =========================================================
   10. Lost Revenue by Pickup Location
   Description: Shows which locations cause the most lost revenue.
   ========================================================= */
SELECT 
    [Pickup Location],
    SUM([Booking Value]) AS lost_revenue
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
GROUP BY [Pickup Location]
ORDER BY lost_revenue DESC;


/* =========================================================
   11. Cancellation by Hour
   Description: Identifies at which hours cancellations are highest.
   ========================================================= */
SELECT 
    DATEPART(HOUR, [Time]) AS hour_of_day,
    COUNT(*) AS total_cancellations
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
GROUP BY DATEPART(HOUR, [Time])
ORDER BY total_cancellations DESC;


/* =========================================================
   12. Cancellation by Day of Week
   Description: Shows which days have the most cancellations.
   ========================================================= */
SELECT 
    DATENAME(WEEKDAY, [Date]) AS day_name,
    COUNT(*) AS total_cancellations
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
GROUP BY DATENAME(WEEKDAY, [Date]);


/* =========================================================
   13. Cancellation vs Completed Rides
   Description: Compares completed rides vs cancelled rides.
   ========================================================= */
SELECT 
    CASE 
        WHEN [Booking Status] = 'Completed' THEN 'Completed'
        WHEN [Cancelled Rides by Customer] = 'Yes'
          OR [Cancelled Rides by Driver] = 'Yes' THEN 'Cancelled'
    END AS ride_status,
    COUNT(*) AS total_rides
FROM uber_data
GROUP BY 
    CASE 
        WHEN [Booking Status] = 'Completed' THEN 'Completed'
        WHEN [Cancelled Rides by Customer] = 'Yes'
          OR [Cancelled Rides by Driver] = 'Yes' THEN 'Cancelled'
    END;


/* =========================================================
   14. Cancellation Rate by Time Bucket
   Description: Shows cancellation patterns by time of day.
   ========================================================= */
SELECT 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END AS time_bucket,
    COUNT(*) AS total_cancellations
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, [Time]) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, [Time]) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END
ORDER BY total_cancellations DESC;


/* =========================================================
   15. Cancellation Funnel
   Description: Shows how many rides are completed, cancelled,
                or incomplete.
   ========================================================= */
SELECT 
    'Completed' AS ride_status,
    COUNT(*) AS total
FROM uber_data
WHERE [Booking Status] = 'Completed'

UNION ALL

SELECT 
    'Cancelled' AS ride_status,
    COUNT(*) AS total
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'

UNION ALL

SELECT 
    'Incomplete' AS ride_status,
    COUNT(*) AS total
FROM uber_data
WHERE [Incomplete Rides] = 'Yes';
