WITH carrier_metrics AS (
    SELECT
        OP_UNIQUE_CARRIER,
        COUNT(*) AS total_flights,

        SUM(CASE
                WHEN DEP_DELAY_NEW >= 15
                THEN 1 ELSE 0
            END) AS delayed_flights,

        SUM(CASE
                WHEN CANCELLED = 1
                THEN 1 ELSE 0
            END) AS cancelled_flights,

        AVG(DEP_DELAY_NEW) AS avg_delay

    FROM flights
    GROUP BY OP_UNIQUE_CARRIER
),

rates AS (
    SELECT
        *,
        ROUND(delayed_flights * 100.0 / total_flights,2)
            AS delay_rate,

        ROUND(cancelled_flights * 100.0 / total_flights,2)
            AS cancel_rate
    FROM carrier_metrics
),

revenue_risk AS (
    SELECT
        *,
        ROUND(
            (delay_rate * 0.4) +
            (cancel_rate * 0.4) +
            (avg_delay * 0.2),
            2
        ) AS revenue_risk_index
    FROM rates
)

SELECT *
FROM revenue_risk
ORDER BY revenue_risk_index DESC;