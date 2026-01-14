/* =========================================================
   Project: Uber Data Analysis
   Description: This file focuses on revenue performance,
                revenue drivers, and revenue loss analysis.
   Database: SQL Server
   Table: uber
   ========================================================= */


/* =========================================================
   1. Total Revenue
   Description: Calculates the total revenue from completed rides.
   ========================================================= */
SELECT SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed';


/* =========================================================
   2. Revenue by Vehicle Type
   Description: Shows how much revenue each vehicle type generates.
   ========================================================= */
SELECT 
    [Vehicle Type],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Vehicle Type]
ORDER BY total_revenue DESC;


/* =========================================================
   3. Revenue by Payment Method
   Description: Shows revenue contribution by each payment method.
   ========================================================= */
SELECT 
    [Payment Method],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Payment Method]
ORDER BY total_revenue DESC;


/* =========================================================
   4. Revenue by Pickup Location
   Description: Shows which pickup locations generate the most revenue.
   ========================================================= */
SELECT 
    [Pickup Location],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
ORDER BY total_revenue DESC;


/* =========================================================
   5. Revenue by Drop Location
   Description: Shows which drop locations generate the most revenue.
   ========================================================= */
SELECT 
    [Drop Location],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Drop Location]
ORDER BY total_revenue DESC;


/* =========================================================
   6. Monthly Revenue
   Description: Shows how revenue changes month over month.
   ========================================================= */
SELECT 
    YEAR([Date]) AS year,
    MONTH([Date]) AS month,
    SUM([Booking Value]) AS monthly_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY YEAR([Date]), MONTH([Date])
ORDER BY year, month;


/* =========================================================
   7. Revenue per Ride
   Description: Calculates the average revenue per completed ride.
   ========================================================= */
SELECT 
    SUM([Booking Value]) * 1.0 / COUNT(*) AS revenue_per_ride
FROM uber_data
WHERE [Booking Status] = 'Completed';


/* =========================================================
   8. Revenue per Kilometer
   Description: Measures how much revenue is generated per kilometer.
   ========================================================= */
SELECT 
    SUM([Booking Value]) / SUM([Ride Distance]) AS revenue_per_km
FROM uber_data
WHERE [Booking Status] = 'Completed';


/* =========================================================
   9. Lost Revenue (Cancelled & Incomplete)
   Description: Calculates how much revenue is lost due to cancellations
                and incomplete rides.
   ========================================================= */
SELECT 
    SUM([Booking Value]) AS lost_revenue
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
   OR [Incomplete Rides] = 'Yes';


/* =========================================================
   10. Lost Revenue by Vehicle Type
   Description: Shows which vehicle types lose the most revenue.
   ========================================================= */
SELECT 
    [Vehicle Type],
    SUM([Booking Value]) AS lost_revenue
FROM uber_data
WHERE [Cancelled Rides by Customer] = 'Yes'
   OR [Cancelled Rides by Driver] = 'Yes'
   OR [Incomplete Rides] = 'Yes'
GROUP BY [Vehicle Type]
ORDER BY lost_revenue DESC;


/* =========================================================
   11. Top 10 Highest Revenue Locations
   Description: Shows the top 10 locations generating the most revenue.
   ========================================================= */
SELECT TOP 10
    [Pickup Location],
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Pickup Location]
ORDER BY total_revenue DESC;


/* =========================================================
   12. Low Revenue but High Demand Locations
   Description: Finds locations with many bookings but low total revenue.
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
   13. Revenue Contribution by Vehicle Type (%)
   Description: Shows each vehicle type's share of total revenue.
   ========================================================= */
SELECT 
    [Vehicle Type],
    SUM([Booking Value]) AS vehicle_revenue,
    SUM([Booking Value]) * 100.0 / 
        (SELECT SUM([Booking Value]) 
         FROM uber_data 
         WHERE [Booking Status] = 'Completed') AS revenue_percentage
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Vehicle Type]
ORDER BY revenue_percentage DESC;


/* =========================================================
   14. Revenue vs Distance
   Description: Shows the relationship between total distance
                and total revenue by vehicle type.
   ========================================================= */
SELECT 
    [Vehicle Type],
    SUM([Ride Distance]) AS total_distance,
    SUM([Booking Value]) AS total_revenue
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Vehicle Type]
ORDER BY total_revenue DESC;


/* =========================================================
   15. Average Revenue per Vehicle Type
   Description: Calculates the average booking value per vehicle type.
   ========================================================= */
SELECT 
    [Vehicle Type],
    AVG([Booking Value]) AS avg_revenue_per_ride
FROM uber_data
WHERE [Booking Status] = 'Completed'
GROUP BY [Vehicle Type]
ORDER BY avg_revenue_per_ride DESC;
