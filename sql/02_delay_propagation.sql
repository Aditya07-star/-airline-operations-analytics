-- Query 2: Delay Propagation Analysis
-- Business Question: How much of a previous flight's delay 
-- transfers to the next flight on the same aircraft?

WITH flight_sequence AS (
    SELECT
        OP_UNIQUE_CARRIER,
        TAIL_NUM,
        FL_DATE,
        ORIGIN,
        DEST,
        DEP_TIME,
        DEP_DELAY_NEW,
        ARR_DELAY,
        LAG(ARR_DELAY) OVER (
            PARTITION BY TAIL_NUM, FL_DATE
            ORDER BY DEP_TIME
        ) AS prev_flight_arr_delay
    FROM flights
    WHERE CANCELLED = 0
    AND TAIL_NUM IS NOT NULL
),
propagation AS (
    SELECT
        OP_UNIQUE_CARRIER,
        ORIGIN,
        DEST,
        DEP_DELAY_NEW,
        prev_flight_arr_delay,
        CASE
            WHEN prev_flight_arr_delay > 0 AND DEP_DELAY_NEW > 0
            THEN ROUND((DEP_DELAY_NEW / prev_flight_arr_delay) * 100, 2)
            ELSE 0
        END AS propagation_rate
    FROM flight_sequence
    WHERE prev_flight_arr_delay IS NOT NULL
)
SELECT
    OP_UNIQUE_CARRIER,
    ORIGIN,
    DEST,
    ROUND(AVG(propagation_rate), 2) AS avg_propagation_rate,
    COUNT(*) AS affected_flights
FROM propagation
WHERE propagation_rate > 0
GROUP BY OP_UNIQUE_CARRIER, ORIGIN, DEST
ORDER BY avg_propagation_rate DESC
LIMIT 20;