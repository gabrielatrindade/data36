-- Tomi's solution : task1-week3-4wednesday-solution

-- DAU (Daily Active Users)
SELECT 
	COUNT(DISTINCT(user_id)) AS daily_active_users
FROM
	(
	SELECT * FROM free_tree
	UNION ALL
	SELECT * FROM super_tree
	) as free_super_tree
WHERE date = current_date-1;
 -- LAST 7 DAYS
SELECT
	free_super_tree.date,
	COUNT(DISTINCT(user_id)) AS daily_active_users
FROM
	(
	SELECT * FROM free_tree
	UNION ALL
	SELECT * FROM super_tree
	) as free_super_tree
GROUP BY free_super_tree.date
HAVING date > current_date-8;

-- Daily Revenue
-- remember, the first super_tree is free, then I need to check if it is the first one or not
SELECT
(-- it returns people who sent the first super tree yesterday (revenue=count-1)
SELECT SUM(super_tree_sends) FROM
	(SELECT 
		user_id, 
		MIN(super_tree.date) AS first_send
	FROM super_tree
	GROUP BY user_id
	HAVING MIN(super_tree.date) = current_date-1) AS first_send_yesterday
JOIN --*inner* join of two table:
	 -- aqueles que enviaram a primeira super tree ontem E quantidade do revenue por usuário (por isso '-1' no count)
-- it returns qty of super tree sends at yesterday by user
	(SELECT
		user_id,
		COUNT(*)-1 AS super_tree_sends
	FROM super_tree
	WHERE date = current_date-1
	GROUP BY user_id) AS revenue
ON first_send_yesterday.user_id = revenue.user_id)
+
(-- it returns people who sent the first super tree before yesterday (revenue=count)
SELECT SUM(super_tree_sends) FROM
	(SELECT 
		user_id, 
		MIN(super_tree.date) AS first_send
	FROM super_tree
	GROUP BY user_id
	HAVING MIN(super_tree.date) < current_date-1) AS first_send_before_yesterday
JOIN
	(SELECT
		user_id,
		COUNT(*) AS super_tree_sends
	FROM super_tree
	WHERE date = current_date-1
	GROUP BY user_id) AS revenue
ON first_send_before_yesterday.user_id = revenue.user_id)
AS daily_revenue;

-- Daily Revenue MY SOLUTION WRONG
SELECT
	SUM(super_tree_sends) - COUNT(period_sends='yesterday')
FROM
	(SELECT 
		user_id,
	 	MIN(super_tree.date) AS first_send,
	 	COUNT(*) AS super_tree_sends,
	 	CASE WHEN ((MIN(super_tree.date)) = current_date-1) THEN 'yesterday'
			 WHEN ((MIN(super_tree.date)) < current_date-1) THEN 'before_yesterday'
		END as period_sends
	FROM super_tree
	GROUP BY user_id) AS super_tree_sends_by_user
;

-- 'DAILY' REVENUE (ALTERNATIVE SOLUTION)
-- revenue de tudo - revenue de dias antes de ontem
SELECT
-- conta o revenue
(SELECT COUNT(*)-COUNT(DISTINCT(user_id))
FROM super_tree)
--WHERE date < (SELECT current_date as today)) 
-
--conta revenue onde a data é menor que ontem
(SELECT COUNT(*)-COUNT(DISTINCT(user_id))
FROM super_tree
WHERE date < (SELECT current_date-1 as yesterday));