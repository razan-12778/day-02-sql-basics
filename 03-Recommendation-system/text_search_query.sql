SELECT
    title,
    ts_rank(
        to_tsvector('english', description),
        plainto_tsquery('english', 'Cat')
    ) AS rank
FROM film
WHERE to_tsvector('english', description)
      @@ plainto_tsquery('english', 'Cat')
ORDER BY rank DESC;