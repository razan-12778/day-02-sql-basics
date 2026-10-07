WITH customer_durations AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        AVG(
            EXTRACT(EPOCH FROM (r.return_date - r.rental_date)) / 86400
        ) AS avg_duration
    FROM customer c
    JOIN rental r
        ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
ranked_customers AS (
    SELECT
        first_name,
        last_name,
        avg_duration,
        NTILE(4) OVER (ORDER BY avg_duration) AS quartile
    FROM customer_durations
),
overall_average AS (
    SELECT AVG(avg_duration) AS avg_duration
    FROM customer_durations
)

SELECT
    first_name,
    last_name,
    ROUND(avg_duration::numeric, 2) AS avg_duration,
    quartile
FROM ranked_customers
WHERE avg_duration > (SELECT avg_duration FROM overall_average)
ORDER BY ROUND(avg_duration::numeric, 2) DESC, first_name ASC;