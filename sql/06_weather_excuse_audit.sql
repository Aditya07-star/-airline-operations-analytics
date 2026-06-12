WITH delay_breakdown AS (
    SELECT
        SUM(CARRIER_DELAY) + SUM(LATE_AIRCRAFT_DELAY) AS controllable_delay,

        SUM(WEATHER_DELAY) + 
        SUM(NAS_DELAY) + 
        SUM(SECURITY_DELAY) AS uncontrollable_delay
    FROM flights
)

SELECT
    controllable_delay,
    uncontrollable_delay,

    ROUND(
        controllable_delay * 100.0 /
        (controllable_delay + uncontrollable_delay),
        2
    ) AS controllable_pct,

    ROUND(
        uncontrollable_delay * 100.0 /
        (controllable_delay + uncontrollable_delay),
        2
    ) AS uncontrollable_pct

FROM delay_breakdown;