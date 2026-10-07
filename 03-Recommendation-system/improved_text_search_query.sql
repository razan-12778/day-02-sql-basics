SELECT
    title,
    ts_rank_cd(
        to_tsvector('english', description),
        to_tsquery('english', 'Cat & Dog')
    ) AS rank
FROM film
WHERE to_tsvector('english', description)
      @@ to_tsquery('english', 'Cat & Dog')
ORDER BY rank DESC;