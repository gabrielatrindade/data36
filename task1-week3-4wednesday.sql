-- METRICS - task1-week3-4wednesday

SELECT 
	registrations.date,
	COUNT(*)
FROM registrations
GROUP BY registrations.date
ORDER BY registrations.date;

SELECT COUNT(*)
FROM registrations;

SELECT COUNT(*)
FROM free_tree;

SELECT COUNT(*)
FROM super_tree;

SELECT 
	free_tree.date,
	COUNT(*)
FROM free_tree
GROUP BY free_tree.date
ORDER BY free_tree.date;

SELECT 
	super_tree.date,
	COUNT(*)
FROM super_tree
GROUP BY super_tree.date
ORDER BY super_tree.date;

-- qty_registrations / qty_*super_tree_sent* PER DAY
SELECT
	date,
	SUM(qty_registrations / qty_super_tree_sent)
FROM
	(
	SELECT 
		registrations.date,
		COUNT(*) AS qty_registrations,
		qty_super_tree_sent
	FROM registrations
	LEFT JOIN
		(
		SELECT
			super_tree.date,
			COUNT(*) AS qty_super_tree_sent
		FROM super_tree
		GROUP BY super_tree.date
		) AS query_super_tree
		ON registrations.date = query_super_tree.date
	GROUP BY registrations.date, qty_super_tree_sent
	ORDER BY registrations.date
) AS average_registrations_super_tree_sent_by_day
GROUP BY date;

-- qty_registrations and qty_*users_sent*_super_tree by day
-- problema: no outro dia pode ter o mesmo usuário que enviou tree no dia anterior
-- faria mais sentido calcular qty_registrations and qty_users_*que ainda não*_sent_super_tree by day
SELECT
	registrations.date,
	COUNT(*) AS qty_registrations,
	query_qty_users_sent_super_tree_per_day.qty_users_sent_super_tree
FROM registrations
LEFT JOIN
	(
		SELECT
			super_tree.date,
			COUNT(DISTINCT(super_tree.user_id)) AS qty_users_sent_super_tree
		FROM super_tree
		GROUP BY super_tree.date
		ORDER BY super_tree.date
	) AS query_qty_users_sent_super_tree_per_day
	ON registrations.date = query_qty_users_sent_super_tree_per_day.date
GROUP BY registrations.date, 
		query_qty_users_sent_super_tree_per_day.qty_users_sent_super_tree
ORDER BY registrations.date;

-- qty_registrations / qty_*users_sent*_tree >1 super_tree sends
-- enviando somente primeira super tree que é de graça,
-- por isso calcula somente aqueles que enviaram no mínimo duas vezes
SELECT 
	COUNT(DISTINCT registrations.user_id) AS qty_registrations,
	COUNT(DISTINCT free_tree.user_id) AS qty_free_tree,
	COUNT(DISTINCT users_who_sent_more_than_one_super_tree.user_id) AS qty_super_tree,
	ROUND(COUNT(DISTINCT registrations.user_id) / COUNT(DISTINCT free_tree.user_id)::numeric, 3) AS free_tree_to_registrations_rate,
	ROUND(COUNT(DISTINCT registrations.user_id) / COUNT(DISTINCT users_who_sent_more_than_one_super_tree.user_id)::numeric,3) AS super_tree_to_registrations_rate
FROM registrations
LEFT JOIN free_tree 
	ON free_tree.user_id = registrations.user_id
LEFT JOIN
	(
	SELECT 
		super_tree.user_id,
		COUNT(*)
	FROM super_tree
	GROUP BY super_tree.user_id
	HAVING COUNT(*) > 1
	) AS users_who_sent_more_than_one_super_tree
	ON users_who_sent_more_than_one_super_tree.user_id = registrations.user_id;

--just the super_tree_to_registrations_rate column
SELECT
	current_date - 1 AS date,
	ROUND(COUNT(DISTINCT registrations.user_id) / COUNT(DISTINCT users_who_sent_more_than_one_super_tree.user_id)::numeric,3) AS super_tree_to_registrations_rate
FROM registrations
LEFT JOIN 
	(
	SELECT 
		super_tree.user_id,
		COUNT(*)
	FROM super_tree
	GROUP BY super_tree.user_id
	HAVING COUNT(*) > 1
	) AS users_who_sent_more_than_one_super_tree
	ON users_who_sent_more_than_one_super_tree.user_id = registrations.user_id;