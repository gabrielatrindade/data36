-- TASK2 WEEK2 WEDNESDAY

SELECT COUNT(user_id) FROM registrations;
SELECT device_type, COUNT(file_name) FROM registrations GROUP BY device_type;
SELECT country, COUNT(file_name) FROM registrations GROUP BY country;
SELECT user_id, COUNT(file_name) FROM free_tree GROUP BY user_id ORDER BY count DESC LIMIT 10;
SELECT COUNT(user_id) FROM free_tree;
SELECT user_id, COUNT(file_name) FROM super_tree GROUP BY user_id ORDER BY count DESC LIMIT 10;
SELECT COUNT(user_id) FROM super_tree;
