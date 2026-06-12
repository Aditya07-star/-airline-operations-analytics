WITH flight_order AS (
    SELECT
        TAIL_NUM,
        FL_DATE,
        DEP_DELAY_NEW,

        ROW_NUMBER() OVER (
            PARTITION BY TAIL_NUM, FL_DATE
            ORDER BY DEP_TIME
        ) AS flight_num

    FROM flights
)

SELECT
    CASE
        WHEN flight_num = 1
        THEN 'First Flight'
        ELSE 'Subsequent Flight'
    END AS flight_type,

    COUNT(*) AS total_flights,

    ROUND(
        AVG(DEP_DELAY_NEW),
        2
    ) AS avg_delay

FROM flight_order
GROUP BY flight_type;