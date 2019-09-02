-- Daily tree send activity (both free and super-trees as well) by source
SELECT 
	union_free_super_tree.date,
	registrations.source,
	SUM(CASE WHEN union_free_super_tree.event='sent_a_free_tree' THEN 1 else 0 END) AS free_tree_sends,
	SUM(CASE WHEN union_free_super_tree.event='sent_a_super_tree' THEN 1 else 0 END)	AS super_tree_sends
FROM registrations
INNER JOIN 
	(SELECT * FROM free_tree
	UNION ALL
	SELECT * FROM super_tree) as union_free_super_tree
	ON union_free_super_tree.user_id = registrations.user_id
GROUP BY union_free_super_tree.date, registrations.source
ORDER BY union_free_super_tree.date;

--TOMI'S SOLUTION
SELECT registrations.user_id,
       free_and_super.date,
       registrations.source,
       free_and_super.event
FROM
  (SELECT * FROM free_tree
  UNION ALL
  SELECT * FROM super_tree) as free_and_super
JOIN registrations
ON registrations.user_id = free_and_super.user_id;