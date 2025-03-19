		-----------------------------------------------------
		-- Ejercicio 5.4. Escribe las siguientes consultas
		--					utilizando la BD JARDINERIA
		-----------------------------------------------------

					--------------------------
					--		CONSULTAS	    --
					--------------------------

---------------------------------------
-- A) Consultas sobre una tabla (16) --
---------------------------------------

-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
SELECT codOficina, ciudad
  FROM OFICINAS ;


-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas del país España.
SELECT ciudad, telefono
  FROM OFICINAS
 WHERE pais = 'España';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
SELECT nombre, apellido1, apellido2, email
  FROM EMPLEADOS
 WHERE codEmplJefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del empleado que NO tiene ningún jefe/a
SELECT puesto_cargo, nombre, apellido1, apellido2, email
  FROM EMPLEADOS
 WHERE codEmplJefe IS NULL;

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
SELECT nombre, apellido1, apellido2, puesto_cargo
  FROM EMPLEADOS
 WHERE puesto_cargo <> 'representante Ventas';


-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente
  FROM CLIENTES
 WHERE pais = 'Spain';


-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
SELECT DISTINCT descripcion
  FROM ESTADOS_PEDIDO;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2023.
-- Ten en cuenta que deberás eliminar aquellos códigos de cliente que aparezcan repetidos.
SELECT DISTINCT c.codCliente
  FROM CLIENTES c,
       PAGOS p
 WHERE C.codCliente = p.codCliente 
    AND YEAR(fechaHora_pago) = 2023;

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
SELECT codPedido, codCliente, fecha_esperada, fecha_entrega
  FROM PEDIDOS
 WHERE fecha_esperada < fecha_entrega;

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los 
-- pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.

-- Utilizando la función DATEADD
SELECT codPedido, codCliente, fecha_esperada, fecha_entrega
  FROM PEDIDOS
 WHERE DATEADD(DAY, 2, fecha_entrega) = fecha_esperada
	OR  DATEADD(DAY, 2, fecha_entrega) < fecha_esperada 

-- 11. Misma consulta pero utilizando la función DATEDIFF
SELECT codPedido, codCliente, fecha_esperada, fecha_entrega
  FROM PEDIDOS
 WHERE DATEDIFF(DAY, fecha_entrega, fecha_esperada) >= 2;

-- 12. Devuelve un listado de todos los pedidos que fueron rechazados en 2022
SELECT *
  FROM PEDIDOS
 WHERE codEstado = 'R' AND
		YEAR(fecha_pedido) = '2022';


-- 13. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año
SELECT *
  FROM PEDIDOS
 WHERE MONTH(fecha_entrega) = 01;

-- 14. Devuelve un listado con todos los pagos que se realizaron en el año 2022 mediante Paypal. Ordena el resultado de mayor a menor
SELECT *
  FROM PAGOS
 WHERE YEAR(fechaHora_pago) = 2022
   AND codFormaPago = 'P'


-- 15. Devuelve un listado con todas las formas de pago que aparecen en la tabla PAGOS. Ten en cuenta que no deben aparecer formas de pago repetidas.
SELECT DISTINCT codFormaPago
  FROM PAGOS;


-- 16. Devuelve un listado con todos los productos que pertenecen a la categoría Ornamentales y que tienen más de 100 unidades en stock.
-- El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.
SELECT *
  FROM PRODUCTOS
 WHERE codCategoria = 'OR'
   AND cantidad_en_stock > 100
 ORDER BY precio_venta DESC;
-- 17. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30
SELECT *
  FROM CLIENTES
 WHERE ciudad = 'Madrid'
   AND codEmpl_ventas IN (11, 30);

----------------------------------------------------------------
-- B) Consultas de agrupación o de funciones de agregado (18) --
----------------------------------------------------------------

-- 18. ¿Cuántos empleados hay en la compañía?
SELECT COUNT(codEmpleado)
  FROM EMPLEADOS;

-- 19. ¿Cuántos clientes tiene cada país?
SELECT pais, COUNT(codCliente)
  FROM CLIENTES
 GROUP BY pais;

-- 20. ¿Cuál fue el pago medio de 2022?
SELECT AVG(importe_pago)
  FROM PAGOS;

-- 21. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.
SELECT codEstado, COUNT(codPedido)
  FROM PEDIDOS
 GROUP BY codEstado
 ORDER BY COUNT(codPedido) DESC;

-- 22. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
SELECT MAX(precio_venta), MIN(precio_venta)
  FROM PRODUCTOS;

-- 23. ¿Cuántos clientes tiene la ciudad de Madrid?
SELECT COUNT(codCliente)
  FROM CLIENTES
 WHERE ciudad = 'Madrid';

-- 24. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
SELECT ciudad, COUNT(codCliente)
  FROM CLIENTES
 WHERE ciudad LIKE 'M%'
 GROUP BY ciudad;

-- 25. Devuelve el código de los representantes de ventas y el número de clientes al que atiende cada uno.
SELECT codEmpl_ventas, COUNT(codCliente)
  FROM CLIENTES
 GROUP BY codEmpl_ventas;

-- 26. Calcula el número de clientes que no tiene asignado representante de ventas.
SELECT COUNT(codCliente)
  FROM CLIENTES
 WHERE codEmpl_ventas IS NULL;

-- 27. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
SELECT codPedido, COUNT(codProducto)
  FROM DETALLE_PEDIDOS
 GROUP BY codPedido;

-- 28. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos
SELECT codPedido, SUM(cantidad)
  FROM DETALLE_PEDIDOS
 GROUP BY (codPedido)

-- 29. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno.
-- El listado deberá estar ordenado por el número total de unidades vendidas.
SELECT TOP(20) codProducto, SUM(cantidad)
 FROM DETALLE_PEDIDOS
GROUP BY codProducto
ORDER BY SUM(cantidad) DESC;

-- 30. Obtener el número de empleados por oficina, siempre que el número de empleados sea mayor que 4.
SELECT codOficina, COUNT(codEmpleado)
  FROM EMPLEADOS
 GROUP BY codOficina
HAVING COUNT(codEmpleado) > 4;

-- 31. Obtener los clientes que hayan realizado más de dos pagos de mínimo 1000 euros.
-- Mostrar también el número de pagos realizados.
SELECT codCliente
  FROM PAGOS
 WHERE importe_pago >= 1000
 GROUP BY codCliente
HAVING COUNT(codCliente) > 2;


----------------------------------------------------------------
--				C) Consultas multitabla (10)				  --
----------------------------------------------------------------

-- 32. Obtén los nombres de los productos, la cantidad y el precio para los productos incluidos en los pedidos 3 y 5. Ordénalo por número de pedido y número de producto ascendentemente.
SELECT p.nombre, d.cantidad, d.precio_unidad
  FROM PRODUCTOS p, DETALLE_PEDIDOS d
 WHERE p.codProducto = d.codProducto
   AND d.codPedido IN (3, 5)
 ORDER BY d.codPedido, p.codProducto ASC;

-- 33. Obtén un listado con los nombres de los clientes que han realizado algún pago. Deben aparecer los campos nombre cliente, fecha de pago y total ordenado ascendentemente por cliente y fecha.
SELECT c.nombre_cliente, p.fechaHora_pago, p.importe_pago
  FROM CLIENTES c, PAGOS p
 WHERE c.codCliente = p.codCliente
 ORDER BY c.nombre_cliente, fechaHora_pago ASC;

-- 34. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
SELECT c.nombre_cliente, e.nombre, e.apellido1
  FROM CLIENTES c, EMPLEADOS e
 WHERE c.codEmpl_ventas = e.codEmpleado;

-- 35. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas. Solo deben aparecer una vez.
SELECT DISTINCT c.nombre_cliente, e.nombre
  FROM CLIENTES c, PAGOS p, EMPLEADOS e
 WHERE c.codCliente = p.codCliente
   AND c.codEmpl_ventas = e.codEmpleado;

-- 36. Devuelve el nombre de los clientes que han hecho pedidos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre, o.ciudad
  FROM CLIENTES c, EMPLEADOS e, PEDIDOS p, OFICINAS O
 WHERE c.codEmpl_ventas = e.codEmpleado
   AND c.codCliente = p.codCliente
   AND e.codOficina = o.codOficina;


-- 37. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT o.linea_direccion1
  FROM OFICINAS o, CLIENTES c, EMPLEADOS e
 WHERE c.codEmpl_ventas = e.codEmpleado
   AND e.codOficina = o.codOficina
   AND c.ciudad = 'Fuenlabrada'

-- 38. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes (debes utilizar dos alias para la tabla EMPLEADOS).
SELECT e.nombre AS nombreEmpleado, ej.nombre AS nombreJefe
  FROM EMPLEADOS e, EMPLEADOS ej
 WHERE e.codEmplJefe = ej.codEmpleado;


-- 39. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido. Si se han retrasado varios pedidos, el cliente solo debe aparecer una vez.
SELECT c.nombre_cliente
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND p.fecha_entrega > p.fecha_esperada 
 GROUP BY c.codCliente, c.nombre_cliente;

-- 40. Muestra el nombre de los clientes y el número de pagos que han realizado.
-- Deben aparecer todos, independientemente de si han realizado un pago o no.
SELECT c.nombre_cliente, COUNT(p.codCliente)
  FROM CLIENTES c LEFT JOIN PAGOS p
    ON c.codCliente = p.codCliente
 GROUP BY c.codCliente, c.nombre_cliente;


-- 41. Muestra el nombre de los clientes y el número de pedidos que han sido Entregados.
-- Deben aparecer todos, independientemente de si han realizado un pedido o no.
SELECT c.nombre_cliente, COUNT(p.codPedido)
  FROM CLIENTES c LEFT JOIN PEDIDOS p
    ON c.codCliente = p.codCliente
   AND p.codEstado = 'E'
 GROUP BY c.codCliente, c.nombre_cliente;


