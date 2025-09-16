CREATE SCHEMA IF NOT EXISTS STELLA_APIS_BBDD;
USE stella_apis_bbdd;
SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY','')); -- EJECUTAR PARA EVITAR PROBLEMAS CON EL GROUP BY

-- LIMPIEZA Y NORMALIZACIÓN
/* RENOMBRAR BIO_ARTISTAS*/

ALTER TABLE bio_artistas_v2
RENAME COLUMN `nombre artista` TO artist_name;

ALTER TABLE bio_artistas_v2
RENAME COLUMN `Reproducciones` TO streams;

ALTER TABLE bio_artistas_v2
RENAME COLUMN `Oyentes` TO listeners;

ALTER TABLE bio_artistas_v2
RENAME COLUMN `Artistas Similares` TO similar_artists;

ALTER TABLE bio_artistas_v2
RENAME TO bio_artists;

/* RENOMBRAR ALBUMS */
ALTER TABLE albums_v2
RENAME TO albums;

ALTER TABLE albums
RENAME COLUMN `artists_album` TO artist_name;

ALTER TABLE albums
RENAME COLUMN `album_id` TO code_id;

/* RENOMBRAR CANCIONES */
ALTER TABLE songs_v2
RENAME TO songs;

ALTER TABLE songs
RENAME COLUMN `artists_track` TO artist_name;

-- MODIFICAR VALORES
ALTER TABLE bio_artists
MODIFY COLUMN artist_name VARCHAR(200) PRIMARY KEY;
--
ALTER TABLE albums
MODIFY COLUMN artist_name VARCHAR(250);
--
ALTER TABLE bio_artists
ADD CONSTRAINT uq_nombre_artista UNIQUE (artist_name);



-- CONSULTAS SOBRE ARTISTAS

-- 1. ¿Qué album es de cada artista?
SELECT b.artist_name, a.album_name
FROM bio_artists b
INNER JOIN albums a
ON b.artist_name = a.artist_name;

-- 2. Que tres artistas han sacado más álbumes por género. Lo hacemos de forma independiente por cada género
SELECT COUNT(artist_name) AS total_albums, artist_name
FROM albums
WHERE genre = 'Rock'
GROUP BY artist_name 
ORDER BY total_albums DESC
LIMIT 3;

SELECT COUNT(artist_name) AS total_albums, artist_name
FROM albums
WHERE genre = 'pop'
GROUP BY artist_name 
ORDER BY total_albums DESC
LIMIT 3;

SELECT COUNT(artist_name) AS total_albums, artist_name
FROM albums
WHERE genre = 'r&b'
GROUP BY artist_name 
ORDER BY total_albums DESC
LIMIT 3;

SELECT COUNT(artist_name) AS total_albums, artist_name
FROM albums
WHERE genre = 'indie'
GROUP BY artist_name 
ORDER BY total_albums DESC
LIMIT 3;

-- 3. ¿Cuál es el artista con más valoración?
SELECT artist_name, SUM(popularity) AS popularidad
FROM songs
GROUP BY artist_name
ORDER BY popularidad DESC
LIMIT 1;

-- 3.1. ¿Y los tres con mayor valoración?
SELECT artist_name, SUM(popularity) AS popularidad
FROM songs
GROUP BY artist_name
ORDER BY popularidad DESC
LIMIT 5;

-- 4. ¿Qué artista tiene más oyentes?
SELECT listeners, artist_name
FROM bio_artists
ORDER BY listeners DESC
LIMIT 1;

-- 4.1. Top 3 artistas con más oyentes
SELECT listeners, artist_name
FROM bio_artists
ORDER BY listeners DESC
LIMIT 5;

-- 5. ¿Cuál es el artista con más canciones? 
SELECT count(artist_name) as NumeroCanciones, artist_name Artista, genre Género
FROM songs
GROUP BY artist_name
ORDER BY count(artist_name) desc
LIMIT 5;

-- 6. ¿Cuáles son los artistas más escuchados de cada género?
SELECT DISTINCT b.artist_name, b.listeners, a.genre
FROM bio_artists b
INNER JOIN albums a
ON b.artist_name = a.artist_name
WHERE a.genre = "Rock"
ORDER BY b.listeners DESC
LIMIT 5;

SELECT DISTINCT b.artist_name, b.listeners, a.genre
FROM bio_artists b
INNER JOIN albums a
ON b.artist_name = a.artist_name
WHERE a.genre = "Pop"
ORDER BY b.listeners DESC
LIMIT 5;

SELECT DISTINCT b.artist_name, b.listeners, a.genre
FROM bio_artists b
INNER JOIN albums a
ON b.artist_name = a.artist_name
WHERE a.genre = "r&b"
ORDER BY b.listeners DESC
LIMIT 5;

SELECT DISTINCT b.artist_name, b.listeners, a.genre
FROM bio_artists b
INNER JOIN albums a
ON b.artist_name = a.artist_name
WHERE a.genre = "Indie"
ORDER BY b.listeners DESC
LIMIT 5;

-- 7. ¿Cuál es la canción mas larga de artistas de pop, rock, indie y r&b?
SELECT DISTINCT artist_name, track_name, duration_ms
FROM songs
WHERE genre = "rock"
ORDER BY duration_ms DESC
LIMIT 1; 

SELECT DISTINCT artist_name, track_name, duration_ms
FROM songs
WHERE genre = "pop"
ORDER BY duration_ms DESC
LIMIT 1; 

SELECT DISTINCT artist_name, track_name, duration_ms
FROM songs
WHERE genre = "r&b"
ORDER BY duration_ms DESC
LIMIT 1; 

SELECT DISTINCT artist_name, track_name, duration_ms
FROM songs
WHERE genre = "indie"
ORDER BY duration_ms DESC
LIMIT 1; 

-- 8. ¿Cuál es el nombre, número de oyentes y género musical de cada artista registrado en bio_artists?
SELECT b.artist_name,
       b.listeners,
       (SELECT a.genre
        FROM songs a
        WHERE a.artist_name = b.artist_name
        LIMIT 1) AS genre
FROM bio_artists b;

-- 9. ¿Cuál es la bio de los tres artistas más reproducidos?
SELECT artist_name, streams, biografia
FROM bio_artists
GROUP BY streams
ORDER BY streams DESC
LIMIT 3;



-- CONSULTAS SOBRE ALBUMES

-- 10. ¿Cuál es el álbum más valorado de los años seleccionados (en este caso, de 2010 a 2012)?
SELECT DISTINCT artist_name, album_name, popularity, release_date -- ponemos DISTINCT porque al estar en dos géneros, si no, lo saca 2 veces
FROM albums
WHERE release_date REGEXP '^201[0-2]'	
  AND popularity = (
    SELECT MAX(popularity)
    FROM albums
    WHERE release_date REGEXP '^201[0-2]'
	  );
      
-- 11. ¿Cuál es el álbum más reciente lanzado?
SELECT album_name, release_date
FROM albums
ORDER BY release_date DESC
LIMIT 1;

-- 12. ¿Cuál es el álbum más valorado de los años que tengo en mi BBDD?      
SELECT DISTINCT artist_name, album_name, popularity, release_date -- ponemos DISTINCT porque al estar en dos géneros, si no, lo saca 2 veces
FROM albums
WHERE popularity = (
    SELECT MAX(popularity)
    FROM albums);



-- CONSULTAS SOBRE CANCIONES

-- 13. ¿Cuál es la canción más popular?
SELECT artist_name Artista, track_name Canción, album_name Album, popularity Popularidad, release_date FechaLanzamiento 
FROM songs 
WHERE popularity = 
	(SELECT MAX(popularity) 
    FROM songs);

-- 14. ¿Cuales son las 5 canciones mejor valoradas en ese rango de años?
SELECT artist_name Artista, track_name Canción, album_name Album, popularity Popularidad, release_date FechaLanzamiento
FROM songs
ORDER BY popularity DESC
LIMIT 5;

-- 14.1. ¿Coinciden las escuchas con la popularidad?
SELECT ba.streams, s.track_name, s.artist_name, s.popularity
FROM bio_artists ba
INNER JOIN songs s
ON ba.artist_name = s.artist_name
ORDER BY ba.streams DESC
LIMIT 5;

-- 15. ¿Cuáles son las 5 canciones mejor valoradas, por cada género?
/* Hacemos consultas por cada género y lo juntamos con UNION (no con UNION ALL, porque así nos evitamos duplicados)
Tenemos que hacer la consulta real en una subconsulta para poder aplicar el orderby y limit */
SELECT * 
FROM (
    SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'rock'
    ORDER BY popularity DESC
    LIMIT 5) AS top_rock
UNION
SELECT * 
FROM (
	SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'indie'
    ORDER BY popularity DESC
    LIMIT 5) AS top_indie
UNION
SELECT * 
FROM (
    SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'pop'
    ORDER BY popularity DESC
    LIMIT 5) AS top_pop
UNION
SELECT * 
FROM (
    SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'r&b'
    ORDER BY popularity DESC
    LIMIT 5) AS top_rnb;

-- 15.1. Cual es la que más popularidad tiene por cada género
SELECT * 
FROM (
    SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'rock'
    ORDER BY popularity DESC
    LIMIT 1) AS top_rock
UNION
SELECT * 
FROM (
	SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'indie'
    ORDER BY popularity DESC
    LIMIT 1) AS top_indie
UNION
SELECT * 
FROM (
    SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'pop'
    ORDER BY popularity DESC
    LIMIT 1) AS top_pop
UNION
SELECT * 
FROM (
    SELECT artist_name AS Artista, track_name AS Canción, genre AS Género, popularity AS Popularidad, release_date AS FechaLanzamiento
    FROM songs
    WHERE genre = 'r&b'
    ORDER BY popularity DESC
    LIMIT 1) AS top_rnb;

-- CONSULTAS SOBRE GÉNEROS

-- 16. Número de oyentes por género
SELECT SUM(b.listeners) Oyentes, s.genre Género
FROM bio_artists b
INNER JOIN songs s -- utilizo un INNER para que no aparezcan valores nulos y aparezcan solo las filas que tengan coincidencia
ON b.artist_name = s.artist_name
GROUP BY s.genre
ORDER BY Oyentes DESC;

-- 17. ¿Cuántas canciones hay por género -que tengan coincidencia con mi tabla de artistas-?
-- HACEMOS LOS JOINS YA QUE SI NO, ME SACARÍA 250 CANCIONES DE CADA GÉNERO, QUE ES LO QUE LE PEDIMOS A PYTHON
-- Así que me interesa sólo saber si tienen coincidencia con mi tabla de artistas
SELECT COUNT(s.track_name) Canciones, s.genre Género
FROM bio_artists b
INNER JOIN songs s
ON b.artist_name = s.artist_name
GROUP BY s.genre
ORDER BY Canciones DESC;

-- 17.1. ¿Cuál es el género con más canciones -que tengan coincidencia con mi tabla de artistas-?
-- HACEMOS LOS JOINS YA QUE SI NO, ME SACARÍA 250 CANCIONES DE CADA GÉNERO, QUE ES LO QUE LE PEDIMOS A PYTHON
-- Así que me interesa sólo saber si tienen coincidencia con mi tabla de artistas
SELECT COUNT(s.track_name) Canciones, s.genre Género
FROM bio_artists b
INNER JOIN songs s
ON b.artist_name = s.artist_name
GROUP BY s.genre
ORDER BY canciones DESC
LIMIT 1;

-- Ejemplo sin el join
SELECT COUNT(track_name) Canciones, genre Género
FROM songs
GROUP BY genre
ORDER BY canciones DESC
LIMIT 1;

-- 18. ¿A qué género pertenece el album con mayor valoración?
-- el género con el álbum más exitoso
SELECT genre Género, popularity Popularidad, album_name Album, artist_name Artista
FROM albums
WHERE popularity = 
	(SELECT MAX(popularity) 
    FROM albums);

-- 19. ¿A qué género pertenece el album con menor valoración?
SELECT DISTINCT genre Género, popularity Popularidad, album_name Album, artist_name Artista
FROM albums
WHERE popularity = 
	(SELECT MIN(popularity) 
    FROM albums);

-- 20. ¿Cuál es el género con mejor promedio de popularidad entre todos sus álbumes?
-- el género más consistentemente valorado
SELECT genre Género, AVG(popularity) AS PromedioPopularidad
FROM albums
GROUP BY genre
ORDER BY AVG(popularity) DESC;


-- CONSULTAS EXTRAS 
-- ¿Qué canciones tienen álbumes registrados en la tabla albums?
SELECT DISTINCT s.track_name AS Canción, s.artist_name AS Artista
FROM albums a
INNER JOIN songs s
ON a.artist_name = s.artist_name;

-- ¿Qué artistas tienen canciones en más de un género?
SELECT DISTINCT artist_name, genre
FROM songs
WHERE artist_name IN (
    SELECT artist_name
    FROM songs
    GROUP BY artist_name
    HAVING COUNT(DISTINCT genre) > 1)
ORDER BY artist_name, genre;

-- ¿Cuál es el género predominante entre los artistas más populares? 
SELECT s.genre, AVG(s.popularity) AS avg_popularity
FROM songs s
INNER JOIN 
	(SELECT artist_name
    FROM albums
    ORDER BY popularity DESC
    LIMIT 20) AS top_artists
ON s.artist_name = top_artists.artist_name
GROUP BY s.genre
ORDER BY avg_popularity DESC;

-- ¿En qué año se lanzaron más álbumes?
SELECT LEFT(release_date, 4) AS año, COUNT(*) AS total_albums, genre AS genero
FROM albums
GROUP BY año
ORDER BY total_albums DESC
LIMIT 1;
/* el left es un método que nos ayuda a ser exactas, ya que extrae los cuatro primeros caracteres, aunque sean un string
otra opción sería convertir el release_date a DATE, pero el problema es que hay veces que son YYYY-MM-DD y otros solo YYYY
por lo que la solución más rápida y fácil sería esta del LEFT*/ 

-- Canciones más populares de cada artista
SELECT artist_name artista, track_name cancion, popularity popularidad
FROM songs
WHERE (artist_name, popularity) IN 
	(SELECT artist_name, MAX(popularity)
    FROM songs
    GROUP BY artist_name)
ORDER BY popularity DESC
LIMIT 10;

-- Número total de reproducciones por artista y género
SELECT s.artist_name artista, s.genre genero, SUM(b.listeners) oyentes
FROM songs s
JOIN bio_artists b
ON s.artist_name = b.artist_name
GROUP BY s.artist_name, s.genre
ORDER BY oyentes DESC;

-- Comprobar a qué tags pertenece el artista y si está activo en tour
SELECT artist_name Artista, tags OtrosGeneros, ontour EnTour
FROM bio_artists
WHERE artist_name IN ('Arctic Monkeys', 'Tame Impala', 'Izal', 'Supersubmarina', 'Radiohead');
