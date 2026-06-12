WITH time_of_day AS (
    SELECT
        CASE
            WHEN DepartureHour BETWEEN 5 AND 11 THEN 'Morning'
            WHEN DepartureHour BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN DepartureHour BETWEEN 18 AND 23 THEN 'Evening'
            ELSE 'Night'
        END AS time_period,

        DEP_DELAY_NEW
    FROM flights
)

SELECT
    time_period,
    COUNT(*) AS total_flights,
    ROUND(AVG(DEP_DELAY_NEW), 2) AS avg_departure_delay,

    RANK() OVER (
        ORDER BY AVG(DEP_DELAY_NEW) DESC
    ) AS delay_rank

FROM time_of_day
GROUP BY time_period
ORDER BY avg_departure_delay DESC;
