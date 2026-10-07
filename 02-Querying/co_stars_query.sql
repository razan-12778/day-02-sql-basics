-- YOUR CODE HERE
SELECT
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2,
    COUNT(*) AS films_together
FROM film_actor fa1
JOIN film_actor fa2
    ON fa1.film_id = fa2.film_id
    AND fa1.actor_id < fa2.actor_id
JOIN actor a1
    ON fa1.actor_id = a1.actor_id
JOIN actor a2
    ON fa2.actor_id = a2.actor_id
GROUP BY
    a1.actor_id, a1.first_name, a1.last_name,
    a2.actor_id, a2.first_name, a2.last_name
HAVING COUNT(*) > 3
ORDER BY films_together DESC, actor1, actor2;