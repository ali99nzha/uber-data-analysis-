/* =========================================================
   File: 06_location_analysis.sql
   Project: Uber Data Analysis
   Description: This file focuses on location-based analysis
                to understand demand, revenue, and efficiency
                across different pickup and drop areas.
   Database: SQL Server
   Table: uber_data
   ========================================================= */


/* =========================================================
   1. Total Bookings by Pickup Location
   Description: Shows how many rides start from each pickup location.
   ========================================================= */
SELECT 
    [Pickup Location],
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY [Pickup Location]
ORDER BY total_bookings DESC;


/* =========================================================
   2. Total Bookings by Drop Location
   Description: Shows how many rides end at each drop location.
   ========================================================= */
SELECT 
    [Drop Location],
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY [Drop Location]
ORDER BY total_bookings DESC;


/* =========================================================
   3. Revenue by Pickup Location
   Description: Shows total revenue generated from each pickup location.
   ========================================================= */
SELECT 
    [Pickup Location],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
ORDER BY total_revenue DESC;


/* =========================================================
   4. Revenue by Drop Location
   Description: Shows total revenue generated for each drop location.
   ========================================================= */
SELECT 
    [Drop Location],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Drop Location]
ORDER BY total_revenue DESC;


/* =========================================================
   5. Average Revenue per Ride by Pickup Location
   Description: Shows how much revenue each ride generates on average
                for each pickup area.
   ========================================================= */
SELECT 
    [Pickup Location],
    AVG([Booking Value]) AS avg_revenue_per_ride
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
ORDER BY avg_revenue_per_ride DESC;


/* =========================================================
   6. Average Distance by Pickup Location
   Description: Shows the average distance per ride for each pickup area.
   ========================================================= */
SELECT 
    [Pickup Location],
    AVG([Ride Distance]) AS avg_distance
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
ORDER BY avg_distance DESC;


/* =========================================================
   7. High Demand but Low Revenue Areas
   Description: Finds areas with many bookings but low total revenue.
   ========================================================= */
SELECT 
    [Pickup Location],
    COUNT(*) AS total_bookings,
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
HAVING COUNT(*) > 100
ORDER BY total_revenue ASC;


/* =========================================================
   8. Most Profitable Areas
   Description: Shows areas with highest revenue per ride.
   ========================================================= */
SELECT 
    [Pickup Location],
    SUM([Booking Value]) * 1.0 / COUNT(*) AS revenue_per_ride
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
ORDER BY revenue_per_ride DESC;


/* =========================================================
   9. Cancellation Rate by Pickup Location
   Description: Identifies areas with the highest cancellation rates.
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
   10. Lost Revenue by Pickup Location
   Description: Shows how much revenue is lost due to cancellations
                per area.
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
   11. Busiest Pickup Locations
   Description: Shows the top 10 busiest pickup areas.
   ========================================================= */
SELECT TOP 10
    [Pickup Location],
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY [Pickup Location]
ORDER BY total_bookings DESC;


/* =========================================================
   12. Busiest Drop Locations
   Description: Shows the top 10 busiest drop areas.
   ========================================================= */
SELECT TOP 10
    [Drop Location],
    COUNT(*) AS total_bookings
FROM uber_data
GROUP BY [Drop Location]
ORDER BY total_bookings DESC;


/* =========================================================
   13. Distance vs Revenue by Pickup Location
   Description: Shows relationship between distance and revenue per area.
   ========================================================= */
SELECT 
    [Pickup Location],
    AVG([Ride Distance]) AS avg_distance,
    AVG([Booking Value]) AS avg_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
ORDER BY avg_revenue DESC;


/* =========================================================
   14. Pickup vs Drop Flow
   Description: Shows the most common pickup-drop pairs.
   ========================================================= */
SELECT 
    [Pickup Location],
    [Drop Location],
    COUNT(*) AS total_trips
FROM uber_data
GROUP BY [Pickup Location], [Drop Location]
ORDER BY total_trips DESC;


/* =========================================================
   15. High Cancellation & High Demand Areas
   Description: Finds areas with many bookings and high cancellations.
   ========================================================= */
SELECT 
    [Pickup Location],
    COUNT(*) AS total_bookings,
    SUM(CASE 
        WHEN [Cancelled Rides by Customer] = 'Yes'
          OR [Cancelled Rides by Driver] = 'Yes'
        THEN 1 ELSE 0 END) AS total_cancellations
FROM uber_data
GROUP BY [Pickup Location]
HAVING COUNT(*) > 100
ORDER BY total_cancellations DESC;
