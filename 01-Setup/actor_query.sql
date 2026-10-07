SELECT actor_id, COUNT(*) AS total_films
FROM film_actor
GROUP BY actor_id
HAVING COUNT(*) > 5
ORDER BY total_films DESC;
