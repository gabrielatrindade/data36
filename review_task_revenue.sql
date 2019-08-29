SELECT * FROM registrations LIMIT 5;

-- What's the total revenue for the invitation program?
SELECT 
	SUM(revenue)
FROM 
	(
	SELECT registrations.user_id,
		registrations.source,
		COUNT(*) -1 AS revenue
	FROM super_tree
	INNER JOIN registrations
		ON registrations.user_id = super_tree.user_id
	GROUP BY registrations.user_id --, registrations.source
	HAVING registrations.source = 'invite_a_friend'
	) AS invite_a_friend_paid_tree_revenue;
	
-- What's the total revenue by phone_type?
SELECT device_type,
	SUM(revenue)
FROM
	(
		SELECT registrations.user_id,
			registrations.device_type,
			COUNT(*)-1 AS revenue
		FROM registrations
		INNER JOIN super_tree
			ON registrations.user_id = super_tree.user_id
		GROUP BY registrations.user_id, registrations.device_type
	) AS paid_tree_revenue_for_device_type
GROUP BY device_type;

-- What's the segment that returns the best revenue?
SELECT
	country,
  	birth_year,
  	device_type,
  	source,
  	SUM(revenue)
FROM
    (
    SELECT
      	registrations.user_id,
      	registrations.birth_year,
		registrations.country,
      	registrations.device_type,
      	registrations.source,
      	COUNT(*) -1 AS revenue
    FROM registrations
    INNER JOIN super_tree
      ON registrations.user_id = super_tree.user_id
    GROUP BY registrations.user_id, registrations.country, registrations.birth_year,
             registrations.device_type, registrations.source
    ) AS revenue_tab
GROUP BY country, birth_year, device_type, source
ORDER BY sum DESC;