/*
CREACIÓN / MODIFICACIÓN DE TABLAS
NOTA: ANTES DE CREAR LAS TABLAS, MIRA MÁS ABAJO PARA VER QUÉ TIPOS DE DATOS DEBEN TENER

Crea las siguientes tablas:
STREAMERS (codStreamer, nombre, apellidos, pais, edad)
PK: codStreamer

TEMATICAS (codTematica, nombre)
PK: codTematica (se incrementa automáticamente)

STREAMERS_TEMATICAS (codStreamer, codTematica, idioma, medio, milesSeguidores)
PK: codStreamer, codTematica
FK: codStreamer -> STREAMERS
FK: codTematica -> TEMATICAS
*/
CREATE DATABASE STREAMERS

CREATE TABLE STREAMERS (
	codStreamer CHAR(3),
	nombre VARCHAR(100)NOT NULL,
	apellidos VARCHAR(300),
	pais VARCHAR(100),
	edad TINYINT

	CONSTRAINT PK_STREAMERS PRIMARY KEY(codStreamer)
)

CREATE TABLE TEMATICAS (
	codTematica INT IDENTITY,
	nombre VARCHAR(100) NOT NULL

	CONSTRAINT PK_TEMATICAS PRIMARY KEY(codTematica)
)

CREATE TABLE STREAMERS_TEMATICA (
	codStreamer CHAR(3),
	codTematica INT,
	idioma VARCHAR(100),
	medio VARCHAR(100),
	milesSeguidores INT

	CONSTRAINT PK_STREAMERS_TEMATICA PRIMARY KEY(codStreamer, codTematica),
	CONSTRAINT FK_ST_STREAMERS FOREIGN KEY(codStreamer)
	REFERENCES STREAMERS (codStreamer),
	CONSTRAINT FK_ST_TEMATICA FOREIGN KEY(codTematica)
	REFERENCES TEMATICAS (codTematica)
)

/*
GESTIÓN DE TABLAS
Inserta los siguientes STREAMERS:
    -	Ibai Llanos de España (código 'ill')
    -	AuronPlay de España (código 'ap')
    -	Nate Gentile de España (código 'ng')
    -	Linus Tech Tips de Canadá (código 'ltt')
    -	DYI Perks sin ningún país (código 'dyi')
    -	Alexandre Chappel de Noruega (código 'ach')
    -	Tekendo de España (código 'tek')
    -	Caddac Tech de ningún país (código 'ct')
*/
INSERT INTO STREAMERS (codStreamer, nombre, apellidos, pais)
VALUES ('ill', 'Ibai', 'Llanos', 'España'),
	   ('ap', 'AuronPlay', null, 'España'),
	   ('ng', 'Nate', 'Gentile', 'España'),
	   ('ltt', 'Linus Tech Tips', null, 'Canada'),
	   ('dyi', 'Perks', null, null),
	   ('ach', 'Alexandre', 'Chappel', 'Noruega'),
	   ('tek', 'Tekendo', null, 'España'),
	   ('ct', 'Caddac', 'Tech', null)
/*
Inserta los siguientes TEMAS:
    -	Informática
    -	Tecnología en general
    -	Gaming
    -	Variado
    -	Bricolaje
    -	Viajes
    -	Humor
*/
INSERT INTO TEMATICAS (nombre)
VALUES ('Informatica'), ('Tecnología en general'),
	   ('Gaming'), ('Variado'),
	   ('Bricolaje'),
	   ('Viajes'), ('Humor')
/*
Inserta las siguientes TEMATICAS de STREAMERS:
    NOMBRESTREAMER	    TEMATICA	    idioma	    medio	    milesSeguidores
    AuronPlay	        Gaming	        Español	    YouTube	    29200          
    Ibai Llanos	        Variado	        Español	    Twitch	    12800          
    AuronPlay	        Variado	        Español	    Twitch	    14900          
    Nate Gentile	    Informática	    Español	    YouTube	    2450           
    Linus Tech Tips	    Informática	    Inglés	    YouTube	    15200          
    DYI Perks	        Bricolaje	    Inglés	    YouTube	    4140           
    Alexandre Chappel	Bricolaje	    Inglés	    YouTube	    370            
    Caddac Tech	        Informática	    Inglés	    YouTube	    3       
*/
INSERT INTO STREAMERS_TEMATICA (codStreamer, codTematica, idioma, 
								medio, milesSeguidores)
VALUES ('ap', 3, 'Español',
		'Youtube', 29200),
	   ('ill', 4, 'Español',
		'Twitch', 12800),
	   ('ap', 4, 'Español',
	    'Twitch', 14900),
	   ('ng', 1, 'Español',
	    'Youtube', 2450),
	   ('ltt', 1, 'Ingles',
	    'Youtube', 15200),
	   ('dyi', 5, 'Ingles',
	    'Youtube', 4140),
	   ('ach', 5, 'Ingles',
	    'Youtube', 370),
	   ('ct', 1, 'Ingles',
	    'Youtube', 3)

-----------------
--  CONSULTAS  --
-----------------
-- 01. Nombre de las temáticas que tenemos almacenadas, ordenadas alfabéticamente.
SELECT nombre
  FROM TEMATICAS
 ORDER BY nombre ASC

-- 02. Cantidad de streamers cuyo país es "España".
SELECT COUNT(codStreamer)
  FROM STREAMERS
 WHERE pais = 'España'

-- 03, 04, 05. Nombres de streamers cuya segunda letra no sea una "B" (quizá en minúsculas), de 3 formas distintas.
SELECT nombre
  FROM STREAMERS
 WHERE RIGHT(LEFT(nombre, 2), 1) = 'b'

SELECT nombre
  FROM STREAMERS
 WHERE SUBSTRING(nombre, 2, 1) = 'b'

SELECT nombre
  FROM STREAMERS
 WHERE nombre LIKE '_b%'

-- 06. Media de suscriptores para los canales cuyo idioma es "Español".
SELECT AVG(milesSeguidores)
  FROM STREAMERS_TEMATICA
 WHERE idioma = 'Español'

-- 07. Media de seguidores para los canales cuyo streamer es del país "España".
SELECT AVG(st.milesSeguidores)
  FROM STREAMERS s, STREAMERS_TEMATICA st
 WHERE s.codStreamer = st.codStreamer
   AND s.pais = 'España'

SELECT AVG(milesSeguidores)
  FROM STREAMERS_TEMATICA
 WHERE codStreamer IN (SELECT codStreamer
                         FROM STREAMERS
						 WHERE pais = 'España')

-- 08. Nombre de cada streamer y medio en el que habla, para aquellos que tienen entre 5.000 y 15.000 miles de seguidores, usando BETWEEN.
SELECT s.nombre, st.medio
  FROM STREAMERS s JOIN STREAMERS_TEMATICA st 
    ON s.codStreamer = st.codStreamer
   AND st.milesSeguidores BETWEEN 5000 AND 15000

-- 09. Nombre de cada streamer y medio en el que habla, para aquellos que tienen entre 5.000 y 15.000 miles de seguidores, sin usar BETWEEN.
SELECT s.nombre, st.medio
  FROM STREAMERS s, STREAMERS_TEMATICA st
 WHERE s.codStreamer = st.codStreamer
   AND st.milesSeguidores >= 5000 
   AND st.milesSeguidores <= 15000

-- 10. Nombre de cada temática y nombre de los idiomas en que tenemos canales de esa temática (quizá ninguno), sin duplicados.
SELECT  DISTINCT t.nombre, st.idioma
  FROM TEMATICAS t LEFT JOIN  STREAMERS_TEMATICA st
    ON t.codTematica = st.codTematica

-- 11. Nombre de cada streamer, nombre de la temática de la que habla y del medio en el que habla de esa temática, usando INNER JOIN.
SELECT  s.nombre, t.nombre, st.medio
  FROM STREAMERS s INNER JOIN STREAMERS_TEMATICA st ON s.codStreamer = st.codStreamer
					INNER JOIN TEMATICAS t ON st.codTematica = t.codTematica

-- 12. Nombre de cada streamer, nombre de la temática de la que habla y del medio en el que habla de esa temática, usando WHERE.
SELECT s.nombre, t.nombre, st.medio
  FROM STREAMERS s, STREAMERS_TEMATICA st, TEMATICAS t
 WHERE s.codStreamer = st.codStreamer 
   AND st.codTematica = t.codTematica

-- 13. Nombre de cada streamer, del medio en el que habla y de la temática de la que habla en ese medio, incluso si de algún streamer no tenemos dato del medio o de la temática.
SELECT s.nombre, st.medio, t.nombre
  FROM STREAMERS s LEFT JOIN STREAMERS_TEMATICA st ON s.codStreamer = st.codStreamer
				   LEFT JOIN TEMATICAS t ON st.codTematica = t.codTematica

-- 14. Nombre de cada medio y cantidad de canales que tenemos anotados en él, ordenado alfabéticamente por el nombre del medio.
SELECT medio, COUNT(codStreamer)
  FROM STREAMERS_TEMATICA
 GROUP BY medio
 ORDER BY medio

-- 15, 16, 17, 18. Medio en el que se emite el canal de más seguidores, de 4 formas distintas.
SELECT medio
  FROM STREAMERS_TEMATICA
 WHERE milesSeguidores = (SELECT MAX(milesSeguidores)
                            FROM STREAMERS_TEMATICA)

SELECT TOP(1) medio
  FROM STREAMERS_TEMATICA
 ORDER BY milesSeguidores DESC

SELECT medio
  FROM STREAMERS_TEMATICA
 WHERE milesSeguidores >= ALL(SELECT milesSeguidores
								FROM STREAMERS_TEMATICA)


-- 19. Categorías de las que tenemos 2 o más canales.
SELECT nombre
  FROM TEMATICAS
 WHERE codTematica IN (SELECT codTematica
						 FROM STREAMERS_TEMATICA
					    GROUP BY codTematica
					   HAVING COUNT(codStreamer) >= 2)

SELECT t.nombre
  FROM TEMATICAS t, STREAMERS_TEMATICA st
 WHERE t.codTematica = st.codTematica
 GROUP BY t.nombre
HAVING COUNT(st.codStreamer) >= 2

-- 20. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, empleando COUNT.
SELECT t.nombre
  FROM TEMATICAS t LEFT JOIN STREAMERS_TEMATICA st
    ON t.codTematica = st.codTematica
 GROUP BY t.nombre, st.codTematica
HAVING COUNT(st.codStreamer) = 0
 ORDER BY t.nombre ASC

-- 21. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, empleando IN / NOT IN.
SELECT nombre
  FROM TEMATICAS
 WHERE codTematica NOT IN (SELECT codTematica
						     FROM STREAMERS_TEMATICA)
 ORDER BY nombre ASC

-- 22. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, empleando ALL / ANY.
SELECT t.nombre
  FROM TEMATICAS t LEFT JOIN STREAMERS_TEMATICA st
    ON t.codTematica = st.codTematica
 GROUP BY t.nombre
HAVING COUNT(st.codStreamer) < ALL (SELECT COUNT(codStreamer)
									   FROM STREAMERS_TEMATICA
									  GROUP BY codTematica)
-- 23. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, empleando EXISTS / NOT EXISTS.
SELECT t.nombre
  FROM TEMATICAS t
 WHERE NOT EXISTS (SELECT st.codTematica
					FROM STREAMERS_TEMATICA st
					WHERE t.codTematica = st.codTematica)
 ORDER BY nombre ASC;

-- 24. Tres primeras letras de cada país y tres primeras letras de cada idioma, en una misma lista.
SELECT CONCAT(LEFT(s.pais, 3), ' ', LEFT(st.idioma, 3))
  FROM STREAMERS s, STREAMERS_TEMATICA st
 WHERE s.codStreamer = st.codStreamer

-- 25, 26, 27, 28. Tres primeras letras de países que coincidan con las tres primeras letras de un idioma, sin duplicados, de cuatro formas distintas.
SELECT DISTINCT LEFT(pais, 3)
  FROM STREAMERS
WHERE LEFT(pais, 3) IN (SELECT LEFT(idioma, 3)
                         FROM STREAMERS_TEMATICA)

-- 29. Nombre de streamer, nombre de medio y nombre de temática, para los canales que están por encima de la media de suscriptores.
SELECT s.nombre, st.medio, t.nombre
  FROM STREAMERS s, STREAMERS_TEMATICA st, TEMATICAS t
 WHERE s.codStreamer = st.codStreamer
  AND st.codTematica = t.codTematica
  AND milesSeguidores > (SELECT AVG(milesSeguidores)
                           FROM STREAMERS_TEMATICA)

-- 30. Nombre de streamer y medio, para los canales que hablan de la temática "Bricolaje".
SELECT s.nombre, st.medio, t.nombre
  FROM STREAMERS s, STREAMERS_TEMATICA st,  TEMATICAS t
 WHERE s.codStreamer = st.codStreamer
   AND st.codTematica = t.codTematica
   AND t.nombre = 'Bricolaje'

-- 31. Crea una tabla de "juegos". Para cada juego querremos un código (clave primaria), un nombre (hasta 20 letras, no nulo)
--- y una referencia al streamer que más habla de él (clave ajena a la tabla "streamers").
CREATE TABLE JUEGOS (
	codJuego INT,
	nombre VARCHAR(20) NOT NULL,
	codStreamer CHAR(3)

	CONSTRAINT PK_JUEGOS PRIMARY KEY (codJuego)
	CONSTRAINT FK_JUEGOS_STREAMERS FOREIGN KEY (codStreamer)
	REFERENCES STREAMERS (codStreamer)
)
-- 32. Añade a la tabla de juegos la restricción de que el código debe ser 1000 o superior.
ALTER TABLE JUEGOS
 ADD CONSTRAINT CK_JUEGOS CHECK (codJuego >= 1000)

-- 33. Añade 3 datos de ejemplo en la tabla de juegos. Para uno indicarás todos los campos, para otro no indicarás el streamer, 
---ayudándote de NULL, y para el tercero no indicarás el streamer porque no detallarás todos los nombres de los campos.

INSERT INTO JUEGOS (codJuego, nombre, codStreamer)
VALUES (1000, 'Counter Strike', 'ap'),
       (1001, 'Fornite', null),
	   (1002, 'Tetris', null)
-- 34. Borra el segundo dato de ejemplo que has añadido en la tabla de juegos, a partir de su código.
DELETE FROM JUEGOS
  WHERE codStreamer = '1001'

-- 35. Muestra el nombre de cada juego junto al nombre del streamer que más habla de él, si existe. Los datos aparecerán ordenados por nombre de juego y, en caso de coincidir éste, por nombre de streamer.
SELECT j.nombre, s.nombre
  FROM JUEGOS j, STREAMERS s
 WHERE j.codStreamer = s.codStreamer

-- 36. Modifica el último dato de ejemplo que has añadido en la tabla de juegos, para que sí tenga asociado un streamer que hable de él.
UPDATE JUEGOS
SET codStreamer = 'ill'
WHERE codJuego = 1002
-- 37. Crea una tabla "juegosStreamers", volcando en ella el nombre de cada juego (con el alias "juego") y el nombre del streamer que habla de él (con el alias "streamer").
CREATE TABLE JUEGOS_STREAMERS(
	juegos VARCHAR(100),
	streamer VARCHAR(100)
)
INSERT INTO JUEGOS_STREAMERS
SELECT j.nombre, s.nombre
  FROM JUEGOS j, STREAMERS s
 WHERE j.codStreamer = s.codStreamer
-- 38. Añade a la tabla "juegosStreamers" un campo "fechaPrueba".

-- 39. Pon la fecha de hoy (prefijada, sin usar GetDate) en el campo "fechaPrueba" de todos los registros de la tabla "juegosStreamers".

-- 40. Muestra juego, streamer y fecha de ayer (día anterior al valor del campo "fechaPrueba") para todos los registros de la tabla "juegosStreamers".

-- 41. Muestra todos los datos de los registros de la tabla "juegosStreamers" que sean del año actual de 2 formas distintas (por ejemplo, usando comodines o funciones de cadenas).

-- 42. Elimina la columna "streamer" de la tabla "juegosStreamers".

-- 43. Vacía la tabla de "juegosStreamers", conservando su estructura.

-- 44. Elimina por completo la tabla de "juegosStreamers".

-- 45. Borra los canales del streamer "Caddac Tech".

-- 46. Muestra la diferencia entre el canal con más seguidores y la media, mostrada en millones de seguidores. Usa el alias "diferenciaMillones".

-- 47. Medios en los que tienen canales los creadores de código "ill", "ng" y "ltt", sin duplicados, usando IN (pero no en una subconsulta).

-- 48. Medios en los que tienen canales los creadores de código "ill", "ng" y "ltt", sin duplicados, sin usar IN.

-- 49. Nombre de streamer y nombre del medio en el que habla, para aquellos de los que no conocemos el país.

-- 50. Nombre del streamer y medio de los canales que sean del mismo medio que el canal de Ibai Llanos que tiene 12800 miles de seguidores (puede aparecer el propio Ibai Llanos).

-- 51. Nombre del streamer y medio de los canales que sean del mismo medio que el canal de Ibai Llanos que tiene 12800 miles de seguidores (sin incluir a Ibai Llanos).

-- 52. Nombre de cada streamer, medio y temática, incluso si para algún streamer no aparece ningún canal o para alguna temática no aparece ningún canal.

-- 53. Nombre de medio y nombre de cada temática, como parte de una única lista (quizá desordenada).

-- 54. Nombre de medio y nombre de cada temática, como parte de una única lista ordenada alfabéticamente.

-- 55. Nombre de medio y cantidad media de suscriptores en ese medio, para los que están por encima de la media de suscriptores de los canales.

-- 56. Nombre de los streamers que emiten en YouTube y que o bien hablan en español o bien sus miles de seguidores están por encima de 12.000.

-- 57. Añade información ficticia sobre ti: datos como streamer, temática sobre la que supuestamente y medio en el que hablas sobre ella, sin indicar cantidad de seguidores. Crea una consulta que muestre todos esos datos a partir de tu código.

-- 58. Muestra el nombre de cada streamer, medio en el que emite y cantidad de seguidores, en millones, redondeados a 1 decimal.

-- 59. Muestra el nombre de cada streamer y el país de origen. Si no se sabe este dato, deberá aparecer "(País desconocido)".

-- 60. Muestra, para cada streamer, su nombre, el medio en el que emite (precedido por "Emite en: ") y el idioma de su canal (precedido por "Idioma: ")

-- 61. Actualiza la edad del streamer Ibai Llanos a 24 y actualiza la de AuronPlay a 30.

-- 62. Devuelve el número de canales que tiene cada streamer, siempre y cuando, el número de seguidores sea superior a la media de seguidores.

-- 63. Amplía el campo "medio" de la tabla TEMATICAS de STREAMERS en 5 caracteres (a lo que ya tuvieras).

-- 64. Quita la restricción FK sobre el campo codStreamer de la tabla TEMATICAS de STREAMERS.

-- 65. Vuelve a dejar la restricción como estaba, es decir, activa.

-- 66. Crea una restricción check que impida introducir valores negativos en el campo "milesSeguidores".

-- 67. Crea una vista que devuelva todos los canales de cada streamer, incluyendo su nombre y el nombre de las temáticas

-- 68. Crea una copia de la tabla streamers llamada STREAMERS_BACKUP

-- 69. Inserta dos nuevos streamers en una única sentencia.

-- 70. Realiza el borrado de todos los registros de todas las tablas en su orden correcto.

-- 71. Elimina todas las tablas.
