--P.1-Esquema de la BBDD creado en archivo adjunto Esquema.png

--P.2-Nombres de todas las películas con una clasificación por edades de 'R'
SELECT FILM_ID, 
	TITLE, 
	RATING 
FROM FILM AS F 
WHERE RATING = 'R';

--P.3-Nombre de los actores que tengan un "actor_id" entre 30 y 40
SELECT ACTOR_ID,
		CONCAT(FIRST_NAME,' ',LAST_NAME) as "Actor name"
FROM ACTOR AS A
WHERE ACTOR_ID >=30 AND ACTOR_ID <=40;

--P.4-Películas cuyo idioma coincide con el idioma original.
SELECT FILM_ID, 
	TITLE,
	LANGUAGE_ID,
	ORIGINAL_LANGUAGE_ID 
FROM FILM AS F 
WHERE LANGUAGE_ID = ORIGINAL_LANGUAGE_ID ;

/*Hago un select mas genérico para ver porque no aparece ninguna pélicula. 
 * Al ejecutar consulta se puede ver que toda la columna original_language_id 
 * no tiene valores y todos los resgistros son NULL
 */
SELECT FILM_ID ,
		LANGUAGE_ID, 
		ORIGINAL_LANGUAGE_ID 
FROM FILM AS F ;

--P.5-Películas por duración de forma ascendente.
SELECT FILM_ID, 
	TITLE,
	LENGTH 
FROM FILM AS F 
order by LENGTH; --no marco "asc" porque por defecto ya me lo hace de manera ascendente

--P.6-Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
SELECT 
	ACTOR_ID ,
	CONCAT(FIRST_NAME,' ',LAST_NAME) 
FROM ACTOR AS A 
WHERE LAST_NAME = 'ALLEN';

/*--P.7-Encuentra la cantidad total de películas en cada clasificación de la tabla 
“filmˮ y muestra la clasificación junto con el recuento.*/
SELECT RATING, 
		count(RATING) as numero_peliculas
FROM FILM AS F
group by RATING 
order by numero_peliculas ;

/*--P.8-Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una 
duración mayor a 3 horas en la tabla film.*/
SELECT 	TITLE ,
		RATING ,
		LENGTH 
FROM FILM AS F 
WHERE RATING = 'PG-13' OR LENGTH > 270; 
--en la consulta no ha aparecido ninguna pélicula con duración mayor a 3 horas, por tanto todas son de rating PG-13

--P.9-Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT ROUND(STDDEV("replacement_cost"), 2) as variabilidad_reemplazo_pelicula
FROM FILM AS F ;
--he redondeado el calculo de la variació dels coste de reemplazo respecto a la media a 2 decimales

--P.10-Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT 	MIN(LENGTH) as minima_duracion,
		MAX(LENGTH) as maxima_duracion
FROM FILM AS F;


--P.11-Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT 	RENTAL_ID ,
		RENTAL_DATE 
FROM RENTAL AS R
order by RENTAL_DATE desc
limit 1
OFFSET 2;

/*--P.12-Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC- 17ʼ
  ni ‘Gʼ en cuanto a su clasificación.*/
SELECT FILM_ID ,
		TITLE ,
		RATING 
FROM FILM AS F 
WHERE RATING not in ('G', 'NC-17');	

/*--P.13-Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.*/
select
	RATING ,
	ROUND(AVG(LENGTH), 2) as duracion_media
FROM FILM AS F 
group by RATING;

/*--P.14-Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos.*/
SELECT 
	TITLE ,
	LENGTH 
FROM FILM AS F 
WHERE LENGTH > 180;

--P.15-¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(AMOUNT) facturacion_total
FROM PAYMENT AS P ;

--P.16-Muestra los 10 clientes con mayor valor de id.
SELECT CUSTOMER_ID 
FROM CUSTOMER AS C
order by CUSTOMER_ID DESC 
LIMIT 10;

--P.17-Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
select F.TITLE ,
	CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) as actor_name
FROM ACTOR AS A 
JOIN FILM_ACTOR AS FA on A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM AS F on FA.FILM_ID = F.FILM_ID 
WHERE F.TITLE = 'EGG IGBY';

--P.18-Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT (TITLE)
FROM FILM AS F ;
--Al no haber ningún titulo con valor NULL, el número de películas es igual a pedir todos los titulos de películas sin el DISTINCT.

--P.19-Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”
SELECT 	F.TITLE,
		F.LENGTH,
		C.NAME
FROM FILM AS F
JOIN FILM_CATEGORY AS FC on F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C on FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C.NAME = 'Comedy' and F.LENGTH > 180;

/*20. Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración.*/
SELECT 	C.NAME as category,
		ROUND(AVG(F.LENGTH), 2) as length_average
FROM FILM AS F
JOIN FILM_CATEGORY AS FC on F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C on FC.CATEGORY_ID = C.CATEGORY_ID
GROUP BY C.NAME
HAVING AVG(F.LENGTH) > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(R.RETURN_DATE  - R.RENTAL_DATE) as rental_duration
FROM RENTAL as R;
--A posteriori he visto que en tabla 'FILM' tenemos 'RENTAL_DURATION', por tanto la consulta sería...
SELECT AVG(F.RENTAL_DURATION) AS rental_duration
FROM FILM AS F 

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME )
FROM ACTOR AS A;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT
  DATE_TRUNC('day', R.RENTAL_DATE) AS dia_alquiler,
  COUNT(*)                         AS num_alquileres
FROM RENTAL AS R
GROUP BY DATE_TRUNC('day', R.RENTAL_DATE)
ORDER BY num_alquileres DESC;

--24. Encuentra las películas con una duración superior al promedio.
--CALCULO DE LA MEDIA DE DURACIÓN DE LAS PELICULAS DE LA BBDD
SELECT AVG(F.LENGTH)
FROM FILM AS F;
--CONSULTA
SELECT F.LENGTH,
		F.TITLE
FROM FILM AS F 
WHERE F.LENGTH > (SELECT AVG(LENGTH) FROM FILM)
ORDER BY F.LENGTH DESC;

--25. Averigua el número de alquileres registrados por mes.
--formula igual a las pregunta 23, modificando day por month
SELECT  DATE_TRUNC('MONTH', R.RENTAL_DATE) AS mes_alquiler,
  		COUNT(*) AS num_alquileres
FROM RENTAL AS R
GROUP BY DATE_TRUNC('MONTH', R.RENTAL_DATE)
ORDER BY num_alquileres;

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT ROUND(AVG(AMOUNT), 2) as average, 
		ROUND(STDDEV(AMOUNT), 2) as standard_desviation, 
		ROUND(VARIANCE(AMOUNT), 2) as 
FROM PAYMENT AS P;

--27. ¿Qué películas se alquilan por encima del precio medio?
SELECT F.TITLE,
		P.AMOUNT
FROM FILM F
JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID 
WHERE P.AMOUNT > (SELECT AVG(AMOUNT) FROM PAYMENT)
ORDER BY P.AMOUNT DESC;

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT A.ACTOR_ID,
		COUNT(FA.FILM_ID) as total_peliculas
FROM ACTOR AS A
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY A.ACTOR_ID 
HAVING COUNT(FA.FILM_ID) > 40
ORDER BY total_peliculas desc;

--29. Obtener todas las películas y, si están disponibles en el inventario,mostrar la cantidad disponible.

SELECT F.FILM_ID,
	F.TITLE,
	COUNT(I.INVENTORY_ID) AS inventory_available
FROM FILM AS F 
LEFT JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
LEFT JOIN RENTAL AS R ON I.INVENTORY_ID = R.INVENTORY_ID
	AND R.RETURN_DATE IS NULL 
WHERE R.RETURN_DATE IS NULL OR I.INVENTORY_ID IS NULL
GROUP BY F.FILM_ID, F.TITLE
ORDER BY F.TITLE;

--30. Obtener los actores y el número de películas en las que ha actuado.
SELECT 	CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) AS actor_name,
		COUNT(FA.FILM_ID) AS film_number
FROM ACTOR AS A 
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY A.ACTOR_ID
ORDER by film_number desc;

/*31. Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados.*/
SELECT F.TITLE,
		CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) AS actor_name
FROM FILM AS F 
LEFT JOIN FILM_ACTOR AS FA ON F.FILM_ID = FA.FILM_ID
LEFT JOIN ACTOR AS A ON FA.ACTOR_ID = A.ACTOR_ID
order by F.TITLE, actor_name;
--Marco un left join, para que se muestren películas incluso si no tienen actores asociados, como se pide.

/*32. Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película.*/
SELECT A.ACTOR_ID,
		CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) AS actor_name,
		F.TITLE
FROM ACTOR AS A 
LEFT JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
LEFT JOIN FILM AS F ON FA.FILM_ID = F.FILM_ID 
ORDER BY A.ACTOR_ID, F.TITLE;

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT F.TITLE,
		COUNT(R.RENTAL_DATE) AS rental_register
FROM FILM AS F 
LEFT JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
LEFT JOIN RENTAL AS R ON I.INVENTORY_ID = R.INVENTORY_ID
GROUP BY F.TITLE
ORDER BY rental_register;
--volvemos a left join para no perder las películas que nunca se han alquilado.

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT C.CUSTOMER_ID,
		CONCAT(C.FIRST_NAME, ' ', C.LAST_NAME) AS customer_nanme,
		SUM(P.AMOUNT) AS customer_expenditure
FROM CUSTOMER AS C 
JOIN PAYMENT AS P ON C.CUSTOMER_ID  = P.CUSTOMER_ID 
GROUP BY C.CUSTOMER_ID
ORDER by customer_expenditure DESC
limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT A.FIRST_NAME,
	A.LAST_NAME
FROM ACTOR AS A
WHERE A.FIRST_NAME = 'JOHNNY';
--hay que tener cuidado porque el motor de consulta discrimina entre minuscula y mayuscula y por tanto ponemos 'JOHNNY'

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT A.FIRST_NAME AS nombre,
	A.LAST_NAME AS apellido
FROM ACTOR AS A
WHERE A.FIRST_NAME = 'JOHNNY';

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN(A.ACTOR_ID),
	MAX(A.ACTOR_ID)
FROM ACTOR AS A;

--38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(A.ACTOR_ID)
FROM ACTOR AS A ;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT A.FIRST_NAME AS nombre,
	A.LAST_NAME AS apellido
FROM ACTOR AS A
ORDER BY apellido desc;

--40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT F.TITLE
FROM FILM AS F 
LIMIT 5;

/*41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido?*/
SELECT A.FIRST_NAME AS nombre,
		COUNT(A.FIRST_NAME) AS number_actors
FROM ACTOR AS A 
GROUP BY A.FIRST_NAME
ORDER BY number_actors DESC; 
--Existen 3 nombres que son los que mas se repiten: Kenneth, Penelope y Julia

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT R.RENTAL_ID,
		CONCAT(C.FIRST_NAME, ' ', C.LAST_NAME) 
FROM RENTAL AS R
JOIN CUSTOMER AS C ON R.CUSTOMER_ID  = C.CUSTOMER_ID;

/*43. Muestra todos los clientes y sus alquileres si existen, incluyendo
aquellos que no tienen alquileres.*/
SELECT CONCAT(C.FIRST_NAME, ' ', C.LAST_NAME) AS customer,
		R.RENTAL_ID,  
FROM CUSTOMER AS C 
LEFT JOIN RENTAL AS R ON C.CUSTOMER_ID = R.CUSTOMER_ID
ORDER BY customer;


/*44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
esta consulta? ¿Por qué? Deja después de la consulta la contestación.*/
SELECT *
FROM FILM AS F 
CROSS JOIN CATEGORY AS C;
/*No aporta valor, ya que se repiten muchas filas que no dan ninguna información extra qualitativa. El cross join puede ser utila para
hacer combinación sobre tablas que tengan un componente mas númerico y no tan categórico, como en esta BBDD.*/

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) as actor_name
FROM ACTOR AS A  
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM AS F ON FA.FILM_ID = F.FILM_ID
JOIN FILM_CATEGORY AS FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Action';

--46. Encuentra todos los actores que no han participado en películas.
SELECT CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) as actor_without_fims
FROM ACTOR AS A 
LEFT JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
WHERE FA.FILM_ID is null;
--No existen actores sin películas en esta BBDD

/*47. Selecciona el nombre de los actores y la cantidad de películas en las
que han participado.*/
SELECT CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) AS actor,
		COUNT(FA.FILM_ID) AS film_number
FROM ACTOR AS A 
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY actor
ORDER BY film_number DESC ;

/*48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
de los actores y el número de películas en las que han participado.*/
/*Al tener hecha la consulta, que debemos introducir en la vista en la 
consulta consulta 47, creamos la vista y pegamos esa consulta:*/
CREATE VIEW actor_num_peliculas AS
SELECT CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) AS actor,
		COUNT(FA.FILM_ID) AS film_number
FROM ACTOR AS A 
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY actor;
/*Llamamos a la función con la query y en Proyectos en DBeaver tendremos 
 * siempre esta disponible esta vista:*/
SELECT *
FROM actor_num_peliculas;

--49. Calcula el número total de alquileres realizados por cada cliente.
SELECT CONCAT(C.FIRST_NAME, ' ', C.LAST_NAME) AS customer,
		COUNT(R.RENTAL_ID) AS rental_number
FROM CUSTOMER AS C 
JOIN RENTAL AS R ON C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY customer
ORDER BY rental_number DESC ;

--50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(F.LENGTH) total_action_length
FROM FILM AS F 
JOIN FILM_CATEGORY AS FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Action';

/*51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
almacenar el total de alquileres por cliente.*/
/*Al tener hecha la consulta que debemos introducir en la tabla temporal en la 
consulta consulta 49, creamos la tabla y pegamos esa consulta*/
CREATE TEMPORARY TABLE cliente_rentas_temporal AS 
SELECT CONCAT(C.FIRST_NAME, ' ', C.LAST_NAME) AS customer,
		COUNT(R.RENTAL_ID) AS rental_number
FROM CUSTOMER AS C 
JOIN RENTAL AS R ON C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY customer
ORDER BY rental_number DESC ;
/*Consultamos la tabla temporal mediante la query y la tenemos disponible durante
la sesión, para poder hacer otras consultas a partir de esta tabla:*/
SELECT * FROM cliente_rentas_temporal;

/*52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
películas que han sido alquiladas al menos 10 veces.*/
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT F.TITLE,	
		COUNT(R.RENTAL_ID) as rental_number
FROM FILM AS F
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL AS R ON I.INVENTORY_ID = R.INVENTORY_ID
GROUP BY F.TITLE
HAVING COUNT(R.RENTAL_ID) >= 10
ORDER BY F.TITLE;

SELECT * FROM peliculas_alquiladas;

/*53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película.*/
SELECT F.TITLE AS not_returned_film
FROM FILM AS F 
JOIN INVENTORY AS I ON f.FILM_ID = I.FILM_ID
JOIN RENTAL AS R ON i.INVENTORY_ID = r.INVENTORY_ID
JOIN CUSTOMER AS C ON r.CUSTOMER_ID = c.CUSTOMER_ID
WHERE C.FIRST_NAME = 'TAMMY'
  AND C.LAST_NAME = 'SANDERS'
  AND R.RETURN_DATE IS NULL
ORDER BY not_returned_film;

--obtenemos que 'Tammy Sanders' no ha devuelto 3 peliculas: LUST LOCK, SLEEPY JAPANESE y TROUBLE DATE

/*54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido.*/
SELECT DISTINCT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR AS A 
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM AS F ON FA.FILM_ID = F.FILM_ID
JOIN FILM_CATEGORY AS FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Sci-Fi'
ORDER BY A.LAST_NAME;
--marcamos DISTINCT par que no me duplique actores que han actuado en mas de una pélicula de Sci-Fi.

/*55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.*/

--Podemos hacer una estructura CTE
WITH primer_alquiler_Spartacus_Cheaper AS (
  SELECT MIN(R.RENTAL_DATE) AS first_date
  FROM RENTAL AS R 
  JOIN INVENTORY AS I ON R.INVENTORY_ID = I.INVENTORY_ID
  JOIN FILM AS F  ON I.FILM_ID = F.FILM_ID
  WHERE F.TITLE = 'SPARTACUS CHEAPER'
)
SELECT DISTINCT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR AS A
JOIN FILM_ACTOR AS FA ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM AS F ON FA.FILM_ID = F.FILM_ID
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL AS R ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN primer_alquiler_Spartacus_Cheaper AS paSC ON R.RENTAL_DATE > paSC.first_date
ORDER BY A.LAST_NAME;

/*56. Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Music’.*/

--Lo hago a través de subconsulta en where
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR AS  A
WHERE A.ACTOR_ID NOT IN (
  SELECT DISTINCT A2.ACTOR_ID
  FROM ACTOR AS A2
  JOIN FILM_ACTOR AS FA ON A2.ACTOR_ID = FA.ACTOR_ID
  JOIN FILM AS F ON FA.FILM_ID = F.FILM_ID
  JOIN FILM_CATEGORY AS FC ON F.FILM_ID = FC.FILM_ID
  JOIN CATEGORY AS C ON FC.CATEGORY_ID = C.CATEGORY_ID
  WHERE C."name" = 'MUSIC'
)
ORDER BY A.LAST_NAME, A.FIRST_NAME;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT F.TITLE 
FROM FILM AS F 
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID 
JOIN RENTAL AS R ON I.INVENTORY_ID = R.INVENTORY_ID
WHERE  R.RETURN_DATE IS NOT NULL
AND R.RETURN_DATE - R.RENTAL_DATE > INTERVAL '8 DAYS'
ORDER BY F.TITLE;
/*He buscado la solución "INTERVAL", que es un operador que me permite restar dos valores de variables
TIMESTAMP dando como resulta un intervalo que acoto a '8 days', pudiendo buscar intervalos de meses, 
años, días, horas, minutos y segundos, si fuera necesario*/ 

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT F.TITLE 
FROM FILM AS F
JOIN FILM_CATEGORY AS FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C.CATEGORY_ID = (
  SELECT CATEGORY_ID
  FROM CATEGORY AS C2
  WHERE C2."name" = 'Animation'
)
ORDER BY F.TITLE;
--Realizo una subquery desde Where para acotar la busqueda en la categoría 'Animation'


/*59. Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película.*/
SELECT F.TITLE
FROM FILM AS F 
WHERE F.LENGTH = (
	SELECT F.LENGTH 
	FROM FILM AS F 
	WHERE F.TITLE  = 'DANCING FEVER'
)
ORDER BY F.TITLE;

/*60. Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido.*/
SELECT
  C.FIRST_NAME,
  C.LAST_NAME,
  COUNT(DISTINCT I.FILM_ID) AS distinct_films
FROM CUSTOMER AS C
JOIN RENTAL AS R ON C.CUSTOMER_ID = R.CUSTOMER_ID
JOIN INVENTORY AS I ON R.INVENTORY_ID = I.INVENTORY_ID
GROUP BY C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME
HAVING COUNT(DISTINCT I.FILM_ID) >= 7
ORDER BY C.LAST_NAME;

/*61. Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres.*/
SELECT C.NAME AS category, COUNT(R.RENTAL_ID) AS total_rentals
FROM RENTAL AS R
JOIN INVENTORY AS I ON R.INVENTORY_ID = I.INVENTORY_ID
JOIN FILM AS F ON I.FILM_ID = F.FILM_ID
JOIN FILM_CATEGORY AS FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C ON FC.CATEGORY_ID = C.CATEGORY_ID
GROUP BY C."name" 
ORDER BY total_rentals DESC;

/*62. Encuentra el número de películas por categoría estrenadas en 2006.*/
SELECT C."name" AS category, COUNT(F.FILM_ID) AS total_films
FROM FILM AS F
JOIN FILM_CATEGORY AS FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY AS C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE F.RELEASE_YEAR = 2006
GROUP BY C."name" 
ORDER BY total_films DESC;

/*63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
que tenemos.*/
SELECT S.FIRST_NAME AS EMPLEADO_NOMBRE,
       S.LAST_NAME AS EMPLEADO_APELLIDO,
       ST.STORE_ID AS TIENDA_ID
FROM STAFF AS S
CROSS JOIN STORE AS ST
ORDER BY S.LAST_NAME, S.FIRST_NAME, ST.STORE_ID;
--Vemos que los dos únicos miembros del Staff, se encuentran en las dos tiendas

/*64. Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.*/
SELECT C.CUSTOMER_ID,
		C.FIRST_NAME,
		C.LAST_NAME, 
    		COUNT(R.RENTAL_ID) AS total_rentals
FROM CUSTOMER AS C
JOIN RENTAL AS R ON C.CUSTOMER_ID = R.CUSTOMER_ID 
GROUP BY C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME
ORDER BY total_rentals DESC; 


