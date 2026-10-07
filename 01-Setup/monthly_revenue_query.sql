SELECT EXTRACT(MONTH FROM payment_date)::int AS month,
       SUM(amount) AS monthly_revenue
FROM payment
WHERE payment_date >= '2022-01-01'
  AND payment_date < '2023-01-01'
GROUP BY 1
ORDER BY 1;
