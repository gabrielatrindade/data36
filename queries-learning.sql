-- WORK WITH TEST

SELECT * FROM TEST;

-- WORK WITH PLAYLIST AND TOPLIST

SELECT
   toplist.tophit,
   toplist.play,
   playlist.artist
FROM toplist
RIGHT JOIN playlist
  ON toplist.tophit = playlist.song;

SELECT
   playlist.artist,
   SUM(toplist.play)
FROM toplist
FULL JOIN playlist
  ON toplist.tophit = playlist.song
GROUP BY playlist.artist;

SELECT
  playlist.artist, 
  playlist.song,
  toplist.play
FROM playlist
FULL JOIN toplist
  ON playlist.song = toplist.tophit
WHERE playlist.artist = 'ABBA'
ORDER BY toplist.play DESC
LIMIT 5;

-- WORK WITH FLIGHT_DELAYS

/*Select the average departure delay by tail numbers (or, in other words, by plane) 
from the table - and return the tail numbers (and only the tail numbers) of the planes 
that have the top 10 average delay times.*/
SELECT
  tailnum
FROM
  (SELECT 
    tailnum,
    AVG(depdelay) AS mean_depdelay
  FROM flight_delays
  GROUP BY tailnum
  ORDER BY mean_depdelay DESC
  LIMIT 10) AS my_original_query;

/* Print: 
the top 10 destinations
where the planes with the top 10 average departure delays (see previous example)
showed up the most */
SELECT
  dest,
  COUNT(tailnum)
FROM flight_delays
WHERE tailnum IN
  (SELECT
    tailnum
   FROM
     (SELECT 
       tailnum,
       AVG(depdelay) AS mean_depdelay
     FROM flight_delays
     GROUP BY tailnum
     ORDER BY mean_depdelay DESC
     LIMIT 10) AS my_original_query)
GROUP BY dest
ORDER BY count DESC
LIMIT 10;

SELECT COUNT(*)
FROM flight_delays
WHERE depdelay > 0
LIMIT 10;

SELECT COUNT(*),
CASE WHEN depdelay > 0 THEN 'late'
     WHEN depdelay < 0 THEN 'early'
     ELSE 'on time'
END AS segment
FROM flight_delays
GROUP BY segment;

SELECT COUNT(*) as nmbr,
       dest
FROM flight_delays
GROUP BY dest
-- WHERE nmbr > 10000;
HAVING COUNT(*) > 10000;

