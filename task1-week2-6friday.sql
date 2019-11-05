-- TASK1 WEEK2 FRIDAY

-- REGISTRATON BY COUNTRY // maior numero de registro: EUA
SELECT country, COUNT(user_id) 
FROM registrations 
GROUP BY country
ORDER BY count DESC;

-- REGISTRATION BY DEVICE_TYPE // maior device usado: android
SELECT device_type, COUNT(user_id)
FROM registrations 
GROUP BY device_type
ORDER BY count DESC;

SELECT date, device_type, COUNT(user_id)
FROM registrations 
GROUP BY date, device_type
ORDER BY date;

-- REGISTRATION BY BIRTH_YEAR //
-- publico com maior número de registro: 1988, 1989, 1987, 1990, 1986, 1984 - até 5000
SELECT birth_year, COUNT(user_id)
FROM registrations
GROUP BY birth_year
ORDER BY birth_year;

-- REGISTRATION BY SOURCE //
-- maior source para registro: invite_a_friend > google > article > paid
SELECT source, COUNT(user_id)
FROM registrations
GROUP BY source
ORDER BY count DESC;

SELECT date, source, COUNT(user_id)
FROM registrations
GROUP BY date, source
ORDER BY date;

-- maior device nos EUA, Brazil, Sweden, Germany, Philippines : android
SELECT
  country,
  device_type,
  COUNT(user_id)
FROM registrations
--WHERE country = 'philippines'
GROUP BY country, device_type
ORDER BY country, count DESC;

-- maior device utilizado entre os birth_year com mais registros : android
SELECT
  device_type,
  COUNT(user_id)
FROM registrations
WHERE birth_year IN (1988, 1989, 1987, 1990, 1986, 1984)
GROUP BY device_type
ORDER BY count DESC;

-- país com mais registro entre os birth_year com mais registro: EUA
SELECT
  country,
  COUNT(user_id)
FROM registrations
WHERE birth_year IN (1988, 1989, 1987, 1990, 1986, 1984)
GROUP BY country
ORDER BY count DESC;

-- Trends on registrations by sources:
SELECT date, source, COUNT(*)
FROM registrations
GROUP BY date, source
ORDER by date;

-- A SIMPLE MICRO-SEGMENTATION EXAMPLE:
SELECT source, device_type, country, birth_year, COUNT(*)
FROM registrations
GROUP BY source, device_type, country, birth_year
ORDER BY count DESC;

-- FREE-TREE SENT BY COUNTRY // país com maior número de free-tree enviada : USA
SELECT
  registrations.country,
  COUNT(free_tree.user_id)
FROM free_tree
FULL JOIN registrations
  ON registrations.user_id = free_tree.user_id
GROUP BY registrations.country
ORDER BY count DESC;
  
-- FREE-TREE SENT BY DEVICE_TYPE // device com maior número de free-tree enviada : android
SELECT
  registrations.device_type,
  COUNT(free_tree.user_id)
FROM free_tree
FULL JOIN registrations
  ON registrations.user_id = free_tree.user_id
GROUP BY registrations.device_type
ORDER BY count DESC;

-- FREE-TREE SENT BY BIRTH-YEAR
-- birth_year com maior número de free-tree enviada : 1988 > 1989 > 1990 > 1987 > 1991 > 1986
SELECT
  registrations.birth_year,
  COUNT(free_tree.user_id)
FROM free_tree
FULL JOIN registrations
  ON registrations.user_id = free_tree.user_id
GROUP BY registrations.birth_year
ORDER BY birth_year;

-- FREE-TREE SENT BY SOURCE
-- source com maior número de free-tree enviada : invite_a_friend > google > article > paid
SELECT
  registrations.source,
  COUNT(free_tree.user_id)
FROM free_tree
FULL JOIN registrations
  ON registrations.user_id = free_tree.user_id
GROUP BY registrations.source
ORDER BY count DESC;

-- FREE_TREE SENT BY SOURCE, DEVICE_TYPE, COUNTRY
SELECT source, device_type, country, COUNT(*)
FROM free_tree
JOIN registrations
  ON registrations.user_id = free_tree.user_id
GROUP BY source, device_type, country
ORDER BY count DESC;

-- SUPER-TREE SENT BY COUNTRY // país com maior número de super-tree enviada : USA
SELECT
  registrations.country,
  COUNT(super_tree.user_id)
FROM super_tree
FULL JOIN registrations
  ON registrations.user_id = super_tree.user_id
GROUP BY registrations.country
ORDER BY count DESC;
  
-- SUPER-TREE SENT BY DEVICE_TYPE // device com maior número de super-tree enviada : android
SELECT
  registrations.device_type,
  COUNT(super_tree.user_id)
FROM super_tree
FULL JOIN registrations
  ON registrations.user_id = super_tree.user_id
GROUP BY registrations.device_type
ORDER BY count DESC;

-- SUPER-TREE SENT BY BIRTH_YEAR //
-- birth_year com maior número de super-tree enviada : 1993 > 1992 > 1991 > 1990 > 1994 > 1989
-- aqui percebe-se que o pessoal mais novo envia super-tree
SELECT
  registrations.birth_year,
  COUNT(super_tree.user_id)
FROM super_tree
FULL JOIN registrations
  ON registrations.user_id = super_tree.user_id
GROUP BY registrations.birth_year
ORDER BY birth_year;

-- SUPER-TREE SENT BY SOURCE //
--source com maior número de super-tree enviada : invite_a_friend > google > article > paid
SELECT
  registrations.source,
  COUNT(super_tree.user_id)
FROM super_tree
FULL JOIN registrations
  ON registrations.user_id = super_tree.user_id
GROUP BY registrations.source
ORDER BY count DESC;

-- SUPER_TREE SENT BY SOURCE, DEVICE_TYPE, COUNTRY
SELECT source, device_type, country, COUNT(*)
FROM super_tree
JOIN registrations
  ON registrations.user_id = super_tree.user_id
GROUP BY source, device_type, country
ORDER BY count DESC;
