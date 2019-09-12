SELECT 
	registrations.date,
	registrations.device_type,
	registrations.source,
	COUNT(DISTINCT registrations.user_id) AS registrations,
	COUNT(DISTINCT free_tree.user_id) AS free_tree_users,
	COUNT(DISTINCT super_tree.user_id) AS super_tree_users,
	COUNT(DISTINCT paying_super_tree_users.user_id) AS paying_super_tree_users
FROM registrations
LEFT JOIN free_tree
	ON registrations.user_id = free_tree.user_id
LEFT JOIN super_tree
	ON registrations.user_id = super_tree.user_id
LEFT JOIN
-- group of users that have more than one super-tree send
	(SELECT super_tree.user_id, COUNT(*) AS paid
	 FROM super_tree
	 GROUP BY super_tree.user_id
	 HAVING COUNT(*)>1) AS paying_super_tree_users
	ON registrations.user_id = paying_super_tree_users.user_id
GROUP BY registrations.date, registrations.device_type, registrations.source
ORDER BY registrations.date, registrations.device_type, registrations.source;