SELECT 
	registrations_aux.date,
	registrations_aux.device_type,
	registrations_aux.source,
	registrations_aux.registrations_qty,
	free_tree_aux.free_tree_users,
	super_tree_aux.super_tree_users,
	super_tree_aux_paying_users.paying_super_tree_users

FROM 
-- NUMBER OF REGISTRATIONS
	(SELECT registrations.date, registrations.device_type, registrations.source, COUNT(*) AS registrations_qty
	 FROM registrations
	 GROUP BY registrations.date, registrations.device_type, registrations.source
	 ORDER BY registrations.date, registrations.device_type, registrations.source) AS registrations_aux

LEFT JOIN 
-- NUMBER OF FREE-TREE USERS
	(SELECT registrations.date, registrations.device_type, registrations.source, COUNT(DISTINCT free_tree.user_id) AS free_tree_users
	 FROM free_tree
	 INNER JOIN registrations ON registrations.user_id = free_tree.user_id
	 GROUP BY registrations.date, registrations.device_type, registrations.source
	 ORDER BY registrations.date, registrations.device_type, registrations.source) AS free_tree_aux
ON registrations_aux.date = free_tree_aux.date AND registrations_aux.device_type = free_tree_aux.device_type AND registrations_aux.source = free_tree_aux.source

LEFT JOIN 
-- NUMBER OF SUPER-TREE USERS
	(SELECT registrations.date, registrations.device_type, registrations.source, COUNT(DISTINCT super_tree.user_id) AS super_tree_users
	 FROM super_tree
	 INNER JOIN registrations ON registrations.user_id = super_tree.user_id
	 GROUP BY registrations.date, registrations.device_type, registrations.source
	 ORDER BY registrations.date, registrations.device_type, registrations.source) AS super_tree_aux
ON registrations_aux.date = super_tree_aux.date AND registrations_aux.device_type = super_tree_aux.device_type AND registrations_aux.source = super_tree_aux.source

LEFT JOIN
-- NUMBER OF PAID USERS
	(SELECT registrations.date, registrations.device_type, registrations.source, COUNT(DISTINCT paying_users_group.user_id) AS paying_super_tree_users
	 FROM 
	 	(SELECT super_tree.user_id, COUNT(*) AS paying_users 
		 FROM super_tree
		 GROUP BY super_tree.user_id
		 HAVING COUNT(*)>1) AS paying_users_group
	 INNER JOIN registrations ON registrations.user_id = paying_users_group.user_id
	 GROUP BY registrations.date, registrations.device_type, registrations.source
	 ORDER BY registrations.date, registrations.device_type, registrations.source) AS super_tree_aux_paying_users
ON registrations_aux.date = super_tree_aux_paying_users.date AND registrations_aux.device_type = super_tree_aux_paying_users.device_type AND registrations_aux.source = super_tree_aux_paying_users.source;