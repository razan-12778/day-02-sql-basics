WITH target_film AS (
    SELECT to_tsvector('english', description) AS description_vector
    FROM film
    WHERE title = 'APOCALYPSE FLAMINGOS'
)
SELECT film.title
FROM film
CROSS JOIN target_film
WHERE film.title <> 'APOCALYPSE FLAMINGOS'
ORDER BY ts_rank(
    to_tsvector('english', film.description),
    plainto_tsquery(
        'english',
        'APOCALYPSE FLAMINGOS'
    )
) ASC;
