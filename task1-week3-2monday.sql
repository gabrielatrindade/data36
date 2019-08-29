-- TASK1 WEEK3 MONDAY
/*What's the total revenue for the invitation program?
What's the total revenue by phone_type? And by birth_year?
What's the total revenue for Android users, from Germany, from the invitation program? */

-- What's the total revenue for the invitation program?
SELECT SUM(revenue)
FROM
    (
      SELECT
        COUNT(*)-1 as revenue           -- less -1 because the first send is free 
      FROM super_tree
      WHERE
          super_tree.user_id IN
            (
            SELECT
              registrations.user_id
            FROM registrations
            WHERE source = 'invite_a_friend'
            )
      GROUP BY super_tree.user_id
      HAVING COUNT(*) > 1             -- removing people who didn't spend anything by sending a tree // desnecessário
     ) AS test;
     
-- RESOLUTION using INNER JOIN
SELECT
  SUM(revenue)
FROM
    (
    SELECT
      registrations.user_id,
      registrations.source,
      COUNT(*)-1 AS revenue             -- não ficará -1 (para aqueles que não enviaram) porque está vindo da super-tree, então tem pelo menos uma enviada
    FROM super_tree
    INNER JOIN registrations
      ON registrations.user_id = super_tree.user_id
    GROUP BY registrations.user_id, registrations.source
    HAVING registrations.source = 'invite_a_friend'
    ) AS invite_a_friend_paid_tree_revenue;

-- What's the total revenue by phone_type? And by birth_year?
-- SOLUÇÃO ERRADA!!!!!!! POR QUE?
SELECT
  device_type_paid_tree_revenue.device_type,
  SUM(revenue)
FROM
    (
    SELECT
      registrations.user_id,
      registrations.device_type,
      COUNT(*)-1 AS revenue
    FROM registrations
    WHERE                           --it can be a INNER JOIN
        registrations.user_id IN
          (
          SELECT 
            super_tree.user_id
          FROM super_tree
          )
    GROUP BY registrations.user_id, registrations.device_type
    ) AS device_type_paid_tree_revenue
GROUP BY device_type_paid_tree_revenue.device_type;

-- RESOLUTION using INNER JOIN
-- SOLUÇÃO CORRETAA!
SELECT
  device_type_revenue.device_type,
  SUM(revenue)
FROM
    (
    SELECT
      registrations.user_id,
      registrations.device_type,
      COUNT(*) -1 AS revenue
    FROM registrations
    INNER JOIN super_tree
      ON registrations.user_id = super_tree.user_id
    GROUP BY registrations.user_id, registrations.device_type
    ) AS device_type_revenue
GROUP BY device_type_revenue.device_type;

-- just compare to
SELECT device_type, COUNT(*)
FROM registrations
GROUP BY device_type;

-- birth_year
-- SOLUÇÃO ERRADA!!!!!!! POR QUE?
SELECT
    birth_year_revenue.birth_year,
    SUM(revenue)
FROM
    (
    SELECT 
      registrations.user_id,
      registrations.birth_year,
      COUNT(*)-1 AS revenue
    FROM registrations
    WHERE registrations.user_id IN 
            (
            SELECT
              super_tree.user_id
            FROM super_tree
            )
    GROUP BY registrations.birth_year, registrations.user_id
    ) AS birth_year_revenue
GROUP BY birth_year_revenue.birth_year
ORDER BY birth_year_revenue.birth_year;

-- RESOLUTION using INNER JOIN
-- SOLUÇÃO CORRETA!!!!!!
SELECT
  birth_year_paid_revenue.birth_year,
  SUM(revenue)
FROM
    (
    SELECT
      registrations.user_id,
      registrations.birth_year,
      COUNT(*) -1 AS revenue
    FROM registrations
    INNER JOIN super_tree
      ON registrations.user_id = super_tree.user_id
    GROUP BY registrations.user_id, registrations.birth_year
    ) AS birth_year_paid_revenue
GROUP BY birth_year_paid_revenue.birth_year
ORDER BY birth_year_paid_revenue.birth_year;

-- What's the total revenue for Android users, from Germany, from the invitation program?
SELECT
  COUNT(*) -1 AS count
FROM registrations
WHERE 
  registrations.device_type = 'android'
  AND registrations.country = 'germany'
  AND registrations.source = 'invite_a_friend'
  AND registrations.user_id IN
        (
        SELECT
          super_tree.user_id
        FROM super_tree
        );
        
SELECT 
* 
FROM registrations r
INNER JOIN super_tree st ON st.user_id = r.user_id
WHERE r.country = 'germany' 
AND r.device_type = 'android'
AND r.source = 'invite_a_friend';

-- What's the segment that returns the best revenue?
SELECT
  birth_year,
  device_type,
  source,
  SUM(revenue)
FROM
    (
    SELECT
      registrations.user_id,
      registrations.birth_year,
      registrations.device_type,
      registrations.source,
      COUNT(*) -1 AS revenue
    FROM registrations
    INNER JOIN super_tree
      ON registrations.user_id = super_tree.user_id
    GROUP BY registrations.user_id, registrations.birth_year,
             registrations.device_type, registrations.source
    ) AS revenue_tab
GROUP BY birth_year, device_type, source
ORDER BY sum DESC;
