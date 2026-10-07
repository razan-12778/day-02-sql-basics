-- YOUR CODE HERE
WITH weekly AS (
    SELECT
        DATE_TRUNC('week', rental_date) AS week,
        COUNT(*) AS rentals
    FROM rental
    GROUP BY 1
),
trends AS (
    SELECT
        week,
        rentals,
        AVG(rentals) OVER (
            ORDER BY week
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS moving_avg_3weeks,
        rentals - LAG(rentals) OVER (ORDER BY week) AS difference
    FROM weekly
)
SELECT
    week,
    rentals,
    moving_avg_3weeks,
    difference,
    rentals - moving_avg_3weeks AS deviation_from_avg
FROM trends
ORDER BY week;