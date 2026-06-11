CREATE DATABASE airline_analytics;
USE airline_analytics;
SELECT COUNT(*) FROM flights;
SELECT 
    OP_UNIQUE_CARRIER,
    COUNT(*) as total_flights
FROM flights
GROUP BY OP_UNIQUE_CARRIER
ORDER BY total_flights DESC
LIMIT 5;


-- Query 1: On-Time Performance Summary by Carrier
-- Business Question: Which carriers have best/worst on-time performance?
-- Key Finding: HA best (88.61%), B6 worst (72.49%)

SELECT 
OP_UNIQUE_CARRIER,
COUNT(*) AS total_flight,
SUM(CASE WHEN IsDelayed = 1 THEN 1 ELSE 0 END) AS Delayed_Flight,
ROUND(SUM(CASE WHEN IsDelayed = 1 THEN 1 ELSE 0 END)* 100 / COUNT(*), 2) AS Delayed_rate,
ROUND(100 - SUM(CASE WHEN IsDelayed = 1 THEN 1 ELSE 0 END)* 100 / COUNT(*), 2) AS On_time_rate,
ROUND(AVG(DEP_DELAY_NEW), 2) AS avg_delay_mins
FROM flights
GROUP BY OP_UNIQUE_CARRIER
ORDER BY On_time_rate DESC;