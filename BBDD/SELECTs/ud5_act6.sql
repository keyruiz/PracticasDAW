		--------------------------------------------------------
		-- Ejercicio de ampliación 5.6. Escribe las siguientes--
		--	consultas utilizando la base de datos SUPERTIENDA---
		--------------------------------------------------------

				--------------------------
				--		CONSULTAS		--
				--------------------------

-------------------------
-- 		CONSULTAS
-------------------------
-- 1. Obtener todos los productos ordenados alfabéticamente por el nombre 
SELECT *
  FROM PRODUCTOS
 ORDER BY TRIM(nombre) ASC;


-- 2. Obtener todos los campos de todos los clientes que pertenezcan a la provincia de Madrid y sean del municipio de Alcorcón
SELECT c.*, m.nombre
  FROM CLIENTES c, MUNICIPIOS m
 WHERE c.codMuni = m.codMuni
   AND c.codProv = m.codProv
   AND m.nombre = 'Alcorcón';

-- 3. Obtener los productos que tengan un precio entre 20 y 22 € y cuyo IVA sea del 10%
SELECT * 
  FROM PRODUCTOS
 WHERE precioUnitario BETWEEN 20 AND 22
   AND IVA = 10;

-- 4. Devuelve las tiendas que pertenezcan a la Comunidad Valenciana.
SELECT nombre
  FROM TIENDAS 
 WHERE codProv IN (3, 12, 46);

-- 5. Devuelve el número de clientes cuyo nombre empiece por JOSE
SELECT COUNT(codCliente)
  FROM CLIENTES
 WHERE nombre LIKE 'JOSE%';

SELECT COUNT(codCliente)
  FROM CLIENTES
 WHERE LEFT(nombre, 4) = 'JOSE';

-- 6. Devuelve el número de empresas dadas de alta utilizando el campo NIFCIF



-- 7. Devuelve el nombre y apellidos (en una sola columna) de los empleados que trabajan en la tienda 7
SELECT CONCAT(nombre, ' ', apellidos)
  FROM VENDEDORES
 WHERE codTienda = 7;


-- 8. Devuelve el nombre los/as jefes/as de las tiendas ubicadas en la Comunidad Valenciana
SELECT vj.nombre
  FROM VENDEDORES v, VENDEDORES vj
 WHERE v.codVendedor = vj.codVendedor
   AND v.codTienda IN (SELECT codTienda
						 FROM TIENDAS 
						WHERE codProv IN (3, 12, 46));


-- 9. Devuelve el nombre los/as jefes/as de las tiendas ubicadas de la Comunidad Valenciana y además el nombre de la tienda
SELECT vj.nombre, t.nombre
  FROM VENDEDORES v, VENDEDORES vj, TIENDAS t
 WHERE v.codVendedor = vj.codVendedor
   AND v.codTienda = t.codTienda
   AND t.codProv IN (3, 12, 46)



-- 10. Devuelve los municipios de la provincia de alicante ordenados alfabéticamente de mayor a menor
SELECT nombre
  FROM MUNICIPIOS 
 WHERE codProv = 3
 ORDER BY nombre ASC;


-- 11. Obtener las provincias cuyo nombre NO contiene ninguna 'o'
SELECT nombre
  FROM PROVINCIAS
 WHERE nombre NOT LIKE '%o%';

 
-- 12. Obtener las provincias cuyo nombre NO contiene ninguna 'o' NI NINGUNA 'e'
SELECT nombre
  FROM PROVINCIAS
 WHERE nombre NOT LIKE '%o%'
   AND nombre NOT LIKE '%e%';


-- 13. Disponemos de una tabla para almacenar el periodo de las campañas de marketing de la empresa.
-- Obtén qué campaña teníamos activa el día 22 de diciembre
SELECT *
  FROM CAMPANYAS
 WHERE DAY(fechaInicio) = 22
   AND MONTH(fechaInicio) = 12 ;


-- 14. Obtén la información de los 5 primeros clientes cuyo nombre empiece por la letra 'A' y su primer apellido por la 'B'
SELECT TOP(5) *
  FROM CLIENTES
 WHERE LEFT(nombre, 1) = 'A'
   AND LEFT(apellidos, 1) = 'B';


-- 15. Obtén la información de los 5 primeros clientes cuyo nombre empiece por la letra 'A', su primer apellido por la 'B'
--		y el segundo apellido por L (suponemos que el segundo apellido es el que viene después del primer espacio en blanco en los apellidos)
SELECT  TOP(5)*
  FROM CLIENTES
 WHERE LEFT(nombre, 1) = 'A'
   AND LEFT(apellidos, 1) = 'B'
   AND SUBSTRING(apellidos, CHARINDEX(' ', apellidos) + 1, 1) = 'L';


-- 16. Devuelve el precio del producto más barato y el más caro en la misma consulta
SELECT MAX(precioUnitario), MIN(precioUnitario)
  FROM PRODUCTOS;


-- 17. Devuelve el número de productos totales que tengan un precio entre 100€ y 200€ (ambos inclusive) -> 
SELECT COUNT(codProducto)
  FROM PRODUCTOS
 WHERE precioUnitario BETWEEN 100 and 200;

-- 18. Disponemos de una tabla para almacenar qué compañías de transporte trabajan con la empresa y su estado.
-- Obtén cuántas empresas de transporte tenemos en cada estado.
SELECT estadoAlta, COUNT(codTransportista)
  FROM COMPANYIAS_TRANSPORTE
 GROUP BY(estadoAlta);


-- 19. Obtén él número de municipios que tenemos en cada provincia (ordenado de mayor a menor)
SELECT COUNT(codMuni)
  FROM MUNICIPIOS
 GROUP BY(codProv);

-- 20. Modifica la consulta anterior para que solo aparezcan aquellas provincias que AL MENOS tengan 250 municipios
SELECT COUNT(codMuni)
  FROM MUNICIPIOS
 GROUP BY(codProv)
 HAVING COUNT(codMuni) >= 250;

-- 21. Modifica la consulta anterior para que en lugar del código de la provincia aparezca su nombre
SELECT p.nombre, COUNT(m.codMuni)
  FROM MUNICIPIOS m, PROVINCIAS p
 WHERE m.codProv = p.codProv
 GROUP BY m.codProv, p.nombre
 HAVING COUNT(codMuni) >= 250;


-- 22. Modifica la consulta anterior para que en lugar de aparecer los que tengan más de 250 municipios, aparezcan los que tengan
--		entre 50 y 75 municipios
SELECT p.nombre, COUNT(m.codMuni)  
  FROM MUNICIPIOS m, PROVINCIAS p
 WHERE m.codProv = p.codProv
 GROUP BY m.codProv, p.nombre
 HAVING COUNT(codMuni) BETWEEN 50 AND 70;



-- 23. Obtén el nombre de las subcategorías incluidas dentro de la categoría principal 'Series y películas'
-- NOTA: Deberá aparecer tanto el nombre de la categoría principal como el nombre de todas las subcategorías
--			Los nombres de las columnas serán: nombreCat y nombreSubCat
--			Ordena el resultado alfabéticamente de menor a mayor por el nombre de la subcategoría
SELECT c.nombre AS nombreCat, sc.nombre AS nombreSubCat
  FROM SUBCATEGORIAS sc, CATEGORIAS c
 WHERE sc.codCategoria = c.codCategoria
   AND sc.codCategoria = 'SP'
 ORDER BY sc.nombre DESC;

-- 24. Obtener el nombre de las tiendas y la cantidad en stock, en las que el juego 
--'PS5 The Eternal Cylinder' se encuentra en stock
-- Ordénalo por el que tenga mayor cantidad en stock primero
SELECT t.nombre, s.stock
  FROM TIENDAS t, STOCK_PRODUCTOS s
 WHERE t.codTienda = s.codTienda
   AND s.codProducto = 53
 ORDER BY s.stock DESC;

select * from PRODUCTOS where nombre = 'PS5 The Eternal Cylinder'

-- 25. A partir de la consulta anterior, obtén qué tiendas necesitan solicitar unidades de ese juego a la central
SELECT t.nombre, s.stock
  FROM TIENDAS t, STOCK_PRODUCTOS s
 WHERE t.codTienda = s.codTienda
   AND s.codProducto = 53
   AND stock = 0;


-- 26. Obtén el coste medio de los envíos realizados por cada transportista, obteniendo el nombre del transportista y el coste medio
SELECT ct.nombre, AVG(p.costeEnvio)
  FROM PEDIDOS p, COMPANYIAS_TRANSPORTE ct
 WHERE p.codTransportista = ct.codTransportista
 GROUP BY p.codTransportista, ct.nombre;


 ---------------------------------------------------------------------------------------
-- 27. Obtener los pedidos que se hayan entregado a través de cualquier agencia de transporte en un plazo no superior a 3 días
--	Los campos que deben salir son:
--		idPedido, plazo, fecHoraPedido, fecEntrega, datosCliente, datosVendedor
--		- datosCliente se forma concatenando el nombre y los apellidos del cliente
--		- datosVendedor se forma concatenando el nombre y los apellidos del vendedor
--
--  Se debe ordenar ascendentemente por codPedido
---------------------------------------------------------------------------------------
SELECT  p.codPedido, p.fecPrevEntrega, fecHoraPedido,
		fecEntrega, CONCAT(c.nombre, ' ', c.apellidos) AS datosCliente,
		CONCAT(v.nombre, ' ', v.apellidos) AS datosVendedos
  FROM PEDIDOS p, CLIENTES c, VENDEDORES v
 WHERE p.codCliente = c.codCliente
   AND p.codVendedor = v.codVendedor
   AND DATEDIFF(DAY, fecHoraPedido, fecEntrega)  BETWEEN 0 AND 3;

-- 29. Obtén el número de pedidos realizados por cada cliente (si un cliente no ha realizado ningún pedido no aparecerá en la consulta)
-- Deberá devolver el codCliente, el nombre completo del cliente y el número de pedidos realizados por cada uno de ellos
SELECT c.codCliente, COUNT(p.codPedido)
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
 GROUP BY c.codCliente;

 select count(codPedido) from pedidos where codCliente = 1

-- 29. Obtén el número de pedidos realizados por cada cliente
-- IMPORTANTE: si un cliente no ha realizado ningún pedido aparecerá igualmente con 0 pedidos
-- Los campos a obtener en la consulta son los mismos que los de la consulta anterior.
SELECT c.codCliente, COUNT(p.codPedido)
  FROM CLIENTES c LEFT JOIN PEDIDOS p
    ON c.codCliente = p.codCliente
 GROUP BY c.codCliente;

-- NOTA: Las consultas RIGHT/LEFT JOIN a veces no funcionan porque hay que mostrar el campo de la tabla que aparece en la LEFT (c.idCliente)





-- 30. Obtén el número de pedidos realizados por cada cliente y el total gastado en todos los pedidos
-- IMPORTANTE: si un cliente no ha realizado ningún pedido aparecerá igualmente con 0 pedidos y 0 € gastados
-- Los campos a obtener en la consulta son los mismos que los de la consulta anterior.
-- Nivel: DIFICIL

-- Ayuda: al introducir la tabla LINEA_PEDIDO es posible que el mismo codPedido se cuente varias veces (uno por línea)
--		por lo que sería interesante que te asegures de que sean DIFERENTES antes de CONTARLOS ;-)

-- Ayuda2: piensa que si el cliente NO ha hecho pedidos, tampoco tendrá registros en LINEA_PEDIDO (por lo que INNER JOIN no es una buena opción)
--			para unir las tablas PEDIDO y LINEA_PEDIDO

-- Ayuda3: si en gasto te aparece NULL, seguro que hay una función que puede cambiar el NULL por un 0 dentro de una SELECT...

SELECT c.codCliente, COUNT(DISTINCT p.codPedido) AS numeroPedidos, ISNULL (SUM(lp.totalLinea), 0) AS gastoTotal 
 FROM CLIENTES c LEFT JOIN PEDIDOS p ON c.codCliente = p.codCliente
		         LEFT JOIN LINEAS_PEDIDOS lp ON p.codPedido = lp.codPedido
GROUP BY c.codCliente;


-- SUBCONSULTAS (operadores básicos de comparación)
------------------------------------------------------------------------------------------------------------------
-- 30. Devuelve el nombre y el precio del producto que tenga el precio de venta más caro.
-- Evidentemente, no se puede introducir un codProducto directamente, habrá que obtenerlo mediante una subconsulta
------------------------------------------------------------------------------------------------------------------
SELECT codProducto, precioUnitario
  FROM PRODUCTOS
 WHERE precioUnitario = (SELECT MAX(precioUnitario)
						   FROM PRODUCTOS) ;



-- 31. Devuelve el codProducto que más unidades tiene en stock en la tienda con codTienda=1. Si salen varios, quédate solo con uno.
SELECT TOP(1) codProducto
  FROM STOCK_PRODUCTOS
 WHERE stock = (SELECT MAX(stock)
		          FROM STOCK_PRODUCTOS
				 WHERE codTienda = 1);


-----------------------------------------------------------------------------------------
-- 32. Modifica la consulta anterior y devuelve los datos de dicho producto (sin introducir el codProducto directamente, claro)
-----------------------------------------------------------------------------------------
SELECT TOP(1) *
  FROM STOCK_PRODUCTOS
 WHERE stock = (SELECT MAX(stock)
		          FROM STOCK_PRODUCTOS
				 WHERE codTienda = 1);


-----------------------------------------------------------------------------------------
-- 33. Devuelve el nombre y el precio de los productos cuyo precio sea MAYOR o IGUAL 
--		que la media del precio de todos los productos
-----------------------------------------------------------------------------------------
SELECT nombre, precioUnitario
  FROM PRODUCTOS
 WHERE precioUnitario >= (SELECT AVG(precioUnitario)
							FROM PRODUCTOS);


-- 34. Devuelve los vendedores que están a cargo de la vendedora con nombre 'EVA' y apellidos 'ALCAIDE MORILLA'
--	Debes utilizar una subconsulta para obtener los vendedores a su cargo
--  Devuelve los campos: NIF, nombre, apellidos y el nombre de la tienda en la que trabajan
SELECT v.NIF, v.nombre, v.apellidos, t.nombre 
  FROM TIENDAS t, VENDEDORES v
 WHERE t.codTienda = v.codTienda
   AND codVendedorJefe = (SELECT codVendedor
							FROM VENDEDORES
						   WHERE nombre = 'EVA'
						     AND apellidos = 'ALCAIDE MORILLA');



-- 35. Devuelve el nombre y el precio del producto que tenga el precio de venta más caro (utiliza ALL/ANY)
SELECT nombre, precioUnitario
  FROM PRODUCTOS
 WHERE precioUnitario  >= ALL(SELECT precioUnitario
					           FROM PRODUCTOS);


-- 36. Devuelve el nombre y el precio del producto que tenga el precio de venta más barato (utiliza ALL/ANY)
SELECT nombre, precioUnitario
  FROM PRODUCTOS
 WHERE precioUnitario  <= ALL(SELECT precioUnitario
					           FROM PRODUCTOS);


-- 37. Devuelve los pedidos que tengan un coste de envío igual o superior a TODOS los productos de la subcategoría 72
SELECT * 
  FROM PEDIDOS
 WHERE costeEnvio >= (SELECT MAX(precioUnitario)
						FROM PRODUCTOS
					   WHERE codSubcategoria = 72)

---ROLLUP
-- 38. Devuelve los pedidos que tengan un coste de envío MENOR que el precio unitario de cualquier producto de la subcategoría 72
SELECT *
  FROM PEDIDOS 
 WHERE costeEnvio <= ANY (SELECT precioUnitario
						    FROM PRODUCTOS
					       WHERE codSubcategoria = 72);
SELECT *
  FROM PEDIDOS 
 WHERE costeEnvio <= (SELECT MAX(precioUnitario)
						    FROM PRODUCTOS
					       WHERE codSubcategoria = 72);

-- 39. Contabiliza cuántos pedidos están sin entregar a la espera de recogerlos en las tiendas
-- Solo se deben contabilizar los pedidos que se recogen en tienda, no los que se envían online
SELECT COUNT(codPedido)
  FROM PEDIDOS
 WHERE fecEntrega IS NULL
   AND recogidaTiendaSN = 'S';



-- 40. Devuelve un listado que muestre los clientes que NUNCA hayan realizado ningún pedido.

-- 40.1) Utiliza IN / NOT IN
SELECT codCliente
  FROM CLIENTES
 WHERE codCliente NOT IN (SELECT c.codCliente
						FROM CLIENTES c, PEDIDOS p
					   WHERE c.codCliente = p.codCliente);


-- 40.2) Utiliza EXISTS / NOT EXISTS
SELECT codCliente
  FROM CLIENTES c
 WHERE NOT EXISTS (SELECT c.codCliente
					FROM  PEDIDOS p
					WHERE c.codCliente = p.codCliente);


-- 41. Devuelve un listado de los productos de la categoría 'SP' que nunca han aparecido en ningún pedido.
-- 41.1) Utiliza IN / NOT IN
SELECT *
  FROM PRODUCTOS
 WHERE codSubcategoria IN (SELECT codSubcategoria
							 FROM SUBCATEGORIAS
							WHERE codCategoria = 'SP')
   AND codProducto NOT IN (SELECT pr.codProducto
							FROM PRODUCTOS pr, PEDIDOS p
							WHERE pr.codProducto = p.codCliente); 

/*SELECT *
  FROM PRODUCTOS
 WHERE codSubcategoria IN (SELECT codSubcategoria
							 FROM SUBCATEGORIAS
							WHERE codCategoria = 'SP')
INTERSECT 
SELECT *
  FROM PRODUCTOS
WHERE codProducto NOT IN (SELECT pr.codProducto
							FROM PRODUCTOS pr, PEDIDOS p
							WHERE pr.codProducto = p.codCliente);*/

-- 41.2) Utiliza EXISTS / NOT EXISTS
SELECT *
  FROM PRODUCTOS pr
 WHERE EXISTS (SELECT codSubcategoria
				FROM SUBCATEGORIAS sc
				WHERE pr.codSubcategoria = sc.codSubcategoria 
				  AND codCategoria = 'SP')
  AND NOT EXISTS (SELECT pr.codProducto
					FROM  PEDIDOS p
		     		WHERE pr.codProducto = p.codCliente); 


-- 42. Obtén todos los campos del cliente que más unidades del juego Grand Theft Auto V de PS5 haya comprado 
--		(no en un solo pedido, sino en todos).
SELECT 
  FROM CLIENTES 
 WHERE codCliente IN (SELECT SUM(unidades) as total, codCliente
					   FROM LINEAS_PEDIDOS lp,  PEDIDOS p
					  WHERE p.codPedido IN (SELECT codPedido
										      FROM LINEAS_PEDIDOS
										     WHERE codProducto = 8)
					 GROUP BY p.codCliente);
SELECT codCliente, SUM(lp.unidades) 
 FROM PEDIDOS p, LINEAS_PEDIDOS lp  
WHERE p.codPedido = lp.codPedido
  AND lp.codProducto = 8 
GROUP BY  p.codCliente

select SUM(unidades)
from PEDIDOS p, LINEAS_PEDIDOS lp
where codCliente = 17
 and lp.codProducto = 8
/*(SELECT codProducto FROM PRODUCTOS WHERE nombre = 'PS5 Grand Theft Auto V')*/
-- 43.  Obtén todos los campos del cliente que más dinero haya gastado en cualquier tienda


-- 44.  Obtén los datos del cliente que ha realizado el pedido más caro
SELECT ;



-- 45. Obtén el coste para los pedidos comprendidos entre el 1 y el 5
-- Recuerda que cada pedido tiene una o más LINEAS_PEDIDOS.
-- Además se debe obtener el total para todos los pedidos.

-- Ayuda: Hay un operador que se pone con GROUP BY que permite totalizar los resultados
-- Ayuda2: El operador se llama ROLLUP
SELECT ;


-- 46. Obtener el total vendido por cada uno de los vendedores y el total para todos los vendedores
SELECT ;


-- 47. Obtener el total vendido por cada una de las tiendas, por cada vendedor y los subtotales
-- Utilizar el operador ROLLUP
SELECT ;


-- 48. Modifica la consulta anterior para que en lugar de aparecer NULL para el total por tienda aparezca 'Total tienda N'
--		Siendo N el cod de cada una de las tiendas
-- Ayuda: Debes utilizar la función COALESCE
-- Ayuda2: Si tras utilizar la función COALESCE devuelve error de conversión a data type int, puedes probar a hacer un CAST de codTienda e codVendedor a VARCHAR

SELECT ;



-- 49. Consulta con el operador CUBE
-- CUBE es un operador que se utiliza con GROUP BY para mostrar el resultado de la agrupación con todas las combinaciones posibles.
-- Es muy similar a hacer un producto cartesiano de los campos de la agrupación y mostrará los totales por cada uno de ellos.

-- Realiza una consulta que muestre por categorías y subcategorías la cantidad de productos (en función del stock) que tenemos almacenados.

SELECT ;



---- CONSULTAS DE CONJUNTOS
-- 50. Devolver la unión de dos consultas:
--		1) Selecciona los pedidos realizados en febrero de 2009
--		2) Selecciona los pedidos realizados en diciembre de 2009

SELECT codPedido
  FROM PEDIDOS
 WHERE YEAR(fecHoraPedido) = 2009
   AND MONTH(fecHoraPedido) = 02
UNION
SELECT codPedido
  FROM PEDIDOS
 WHERE YEAR(fecHoraPedido) = 2009
   AND MONTH(fecHoraPedido) = 12;


-- 51. Devuelve los códigos de los clientes que han realizado algún pedido en enero de 2019 pero NO han realizado ningún pedido en el año 2020
SELECT codCliente
  FROM PEDIDOS
 WHERE YEAR(fecHoraPedido) = 2019
   AND MONTH(fecHoraPedido) = 01
EXCEPT
SELECT codCliente
  FROM PEDIDOS
 WHERE YEAR(fecHoraPedido) = 2020;


-- 52. Modifica la consulta anterior para que se devuelvan los datos de los clientes
SELECT *
  FROM PEDIDOS
 WHERE YEAR(fecHoraPedido) = 2019
   AND MONTH(fecHoraPedido) = 01
EXCEPT
SELECT *
  FROM PEDIDOS
 WHERE YEAR(fecHoraPedido) = 2020;

-- 53. Realiza una consulta de INTERSECCION que:
--		Muestre los clientes que NO han realizado pedidos en 2021 ni tampoco en 2022, utilizando dos consultas
SELECT ;


-- 54. Muestra el número de clientes a los que les haya atendido el jefe de una tienda (mirando el PEDIDO) 
-- Ayuda: si no devuelve el número previsto, podrías ordenarlos para ver si son correctos...
SELECT ;


-----------------------------------------------------------------------------------
--  CREACION, CONSULTA Y ELIMINACION DE VISTAS
--  55. Crea una vista llamada 'V_SELECT' a partir una de las consultas realizadas.
--
--   Recuerda. En las VISTAS no se permite utilizar la cláusula ORDER BY.
-----------------------------------------------------------------------------------


-- 56. Utiliza la vista anterior. Debe devolver lo mismo que ejecutar la consulta que la contiene.
SELECT ;


-- 57. Elimina la vista creada




----------------------------------------------------------------------------------------------
-- CONSULTA TIPICA QUE SE UTILIZA EN UNA PÁGINA WEB PARA MOSTRAR LOS PRODUCTOS DISPONIBLES QUE BUSCA UN USUARIO CON PAGINACIÓN
-- 58. Consulta que devuelva los productos disponibles en una tienda concreta cuyo nombre coincida con una cadena introducida por el usuario,
--	  como por ejemplo. 'juego'
--    Se debe devolver: codProducto, nombre, precio, IVA, nombre de la subcategoría en la que se encuentra, el nombre de la categoría principal y
--		el precio SIN el IVA
--	  Debe aparecer ordenado ascendentemente por codProducto y limitar el número de elementos devueltos a 20.
-- 
--	Parámetros: codTienda, string con el nombre producto, elementos por página
----------------------------------------------------------------------------------------------
SELECT ;

----------------------------------------------------------------------------------------------
-- 59. Adapta la consulta anterior para que se puedan visualizar los siguientes 20 elementos 
--		(imagina que el usuario pincha en la página 2)
----------------------------------------------------------------------------------------------
SELECT ;


------------------------------------------------------------
-- 60. Obtén la facturación anual de cada una de las tiendas
-- Deben aparecer las columnas:
--	idTienda, nombre de la tienda, totalNeto, totalBruto (incluyendo IVA), unidades vendidas totales
-- 
-- Ayuda: Para que los importes aparezcan a dos decimales puedes utilizar la función CAST
-- Se debe ordenar por total neto descendente
------------------------------------------------------------
SELECT ;


------------------------------------------------------------
-- 61. Misma consulta anterior, pero deben aparecer únicamente las tiendas que hayan facturado un neto superior a 1.000.000€
------------------------------------------------------------
SELECT ;


------------------------------------------------------------
-- 62. Obtén el número de valoraciones tenemos en función de las estrellas que le haya dado el cliente
-- Ordena ascendentemente por las estrellas
------------------------------------------------------------
SELECT ;


-- 63. Obtén el producto que más valoraciones de 5 estrellas ha recibido
SELECT ;


-- 64. Obtén un TOP de los 10 vendedores que más importe en productos ha vendido (ordenado de mayor a menor)
-- de toda la historia de la tienda y el nombre de la tienda en la que trabaja
SELECT ;


-- 65. Obtén las tiendas que hayan vendido menos de 50.000€ en toda su historia
SELECT ;


-- 66. Obtén un TOP de los 5 vendedores que más importe en productos ha vendido (ordenado de mayor a menor)
-- de diciembre de 2019
SELECT ;


-------------------------------------------------------------
-- 67. Obtén las ganancias de todas las tiendas ordenado de menor a mayor por meses y años
-------------------------------------------------------------
SELECT ;


 -------------------------------------------------------------
-- 68. Realiza la misma consulta pero particularizándolo solo para una tienda (por ejemplo, codTienda = 6)
-------------------------------------------------------------
SELECT ;
 

