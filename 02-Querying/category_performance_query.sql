-- YOUR CODE HERE
SELECT
    c.name,
    SUM(p.amount) AS revenue,
    CASE
        WHEN SUM(p.amount) > 1000 THEN 'High'
        WHEN SUM(p.amount) > 500 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_category
FROM category c
JOIN film_category fc
    ON c.category_id = fc.category_id
JOIN inventory i
    ON fc.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
JOIN payment p
    ON r.rental_id = p.rental_id
GROUP BY c.category_id, c.name
ORDER BY revenue DESC;