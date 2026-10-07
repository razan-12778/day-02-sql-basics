WITH last_rentals AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        MAX(r.rental_date) AS last_rental_date
    FROM customer c
    JOIN rental r
        ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    full_name,
    last_rental_date,
    CASE
        WHEN last_rental_date < CURRENT_DATE - INTERVAL '6 months'
            THEN 'Inactive'
        ELSE 'Active'
    END AS status
FROM last_rentals
WHERE last_rental_date < CURRENT_DATE - INTERVAL '3 months'
ORDER BY last_rental_date ASC;