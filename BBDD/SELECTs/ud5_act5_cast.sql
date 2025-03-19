		-----------------------------------------------------
		-- Ejercicio 5.5. Escribe las siguientes consultas
		--					utilizando la BD JARDINERIA
		-----------------------------------------------------

					--------------------------
					--		CONSULTAS	    --
					--------------------------

-----------------------------------
-- A) Consultas de conjuntos (4) --
-----------------------------------

-- 1. Devuelve los códigos de los clientes que realizaron pedidos en 2022 y los clientes que realizaron pagos por transferencia. Utiliza la unión.
SELECT DISTINCT c.codCliente
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND YEAR(p.fecha_pedido) = 2022
UNION 
SELECT DISTINCT c.codCliente
  FROM PAGOS P, CLIENTES c
 WHERE p.codCliente = c.codCliente
   AND p.codFormaPago = 'T';



-- 2. Devuelve los códigos de los clientes que realizaron pedidos en 2022 y que también realizaron algún pago por transferencia. Utiliza la intersección.
SELECT DISTINCT c.codCliente
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND YEAR(p.fecha_pedido) = 2022
INTERSECT 
SELECT DISTINCT c.codCliente
  FROM PAGOS P, CLIENTES c
 WHERE p.codCliente = c.codCliente
   AND p.codFormaPago = 'T';

-- 3. Devuelve los códigos de los clientes que realizaron pedidos en 2022 PERO QUE NO los clientes que realizaron pagos por transferencia. Utiliza la diferencia.
SELECT DISTINCT c.codCliente
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND YEAR(p.fecha_pedido) = 2022
EXCEPT
SELECT DISTINCT c.codCliente
  FROM PAGOS P, CLIENTES c
 WHERE p.codCliente = c.codCliente
   AND p.codFormaPago = 'T';

-- 4. Propón el enunciado de una consulta de conjuntos y escribe la consulta SQL.
--Devuelve los codPedido y el nombre de los productos de los que la cantidad que se pide sea mayor o igual que 150 y que también empiecen por 'R' o 'K' 
SELECT dp.codPedido, p.nombre
  FROM PRODUCTOS p, DETALLE_PEDIDOS dp
 WHERE p.codProducto = dp.codProducto
   AND dp.cantidad >= 150
INTERSECT 
SELECT dp.codPedido, p.nombre
  FROM PRODUCTOS p, DETALLE_PEDIDOS dp
 WHERE p.codProducto = dp.codProducto
   AND LEFT(p.nombre, 1) = 'K';

----------------------------------
--    B) Subconsultas (20)      --
----------------------------------
-- Con operadores básicos de comparación

-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT MAX(limite_credito)
  FROM CLIENTES

SELECT nombre_cliente
 FROM CLIENTES
WHERE limite_credito =  (SELECT MAX(limite_credito) 
						   FROM CLIENTES)

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT MAX(precio_venta)
  FROM PRODUCTOS

SELECT nombre
  FROM PRODUCTOS
 WHERE precio_venta = (SELECT MAX(precio_venta)
						 FROM PRODUCTOS);

-- 3. Devuelve el producto que más unidades tiene en stock. Si salen varios, quédate solo con uno.
SELECT TOP(1) *
  FROM PRODUCTOS
 WHERE cantidad_en_stock = (SELECT MAX(cantidad_en_stock)
							  FROM PRODUCTOS);

-- 4. Devuelve el producto que menos unidades tiene en stock.
SELECT MIN(cantidad_en_stock)
  FROM PRODUCTOS;

SELECT * 
  FROM PRODUCTOS
 WHERE cantidad_en_stock = (SELECT MIN(cantidad_en_stock)
							FROM PRODUCTOS);

-- 5. Devuelve el nombre, los apellidos y el email de los empleados cuyo jefe es Alberto Soria.
SELECT codEmpleado
  FROM EMPLEADOS
 WHERE nombre = 'Alberto'
   AND apellido1 = 'Soria'
SELECT nombre, apellido1, apellido2, email
  FROM EMPLEADOS
 WHERE codEmplJefe = (SELECT codEmpleado
						FROM EMPLEADOS
					   WHERE nombre = 'Alberto'
						 AND apellido1 = 'Soria');

-- 6. Propón el enunciado de una consulta de conjuntos y escribe la consulta SQL (puede ser de cualquier tipo, con IN, NOT IN, ALL, ANY, etc).
--DEvuelve los codPedido que hayan sido entregados uno o dos dias antes a la fecha esperada 
SELECT codPedido
  FROM PEDIDOS
 WHERE codPedido IN (SELECT codPedido, codCliente, fecha_esperada, fecha_entrega
					   FROM PEDIDOS
					  WHERE DATEADD(DAY, 2, fecha_entrega) = fecha_esperada
						OR  DATEADD(DAY, 2, fecha_entrega) < fecha_esperada );

--------------------------------------------------------------------
--  Subconsultas con ALL y ANY  --
--  IMPORTANTE: NO UTILIZAR MAX o MIN en las subconsultas
--------------------------------------------------------------------

-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT nombre_cliente
  FROM CLIENTES
 WHERE limite_credito >= ALL(SELECT limite_credito
							   FROM CLIENTES)

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT nombre
  FROM PRODUCTOS
 WHERE precio_venta >= ALL(SELECT precio_venta
							   FROM PRODUCTOS);

-- 3. Devuelve el producto que menos unidades tiene en stock.
SELECT *
  FROM PRODUCTOS
 WHERE cantidad_en_stock <= ALL(SELECT cantidad_en_stock
							      FROM PRODUCTOS);


----------------------------------
-- Subconsultas con IN y NOT IN --
----------------------------------

-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT *
  FROM CLIENTES
 WHERE codCliente NOT IN (SELECT DISTINCT c.codCliente
							FROM CLIENTES c, PAGOS p
						   WHERE C.codCliente = p.codCliente);

-- 2. Devuelve un listado que muestre solamente los clientes que han realizado algún pago.
SELECT *
  FROM CLIENTES
 WHERE codCliente IN (SELECT c.codCliente
					    FROM CLIENTES c, PAGOS p
					   WHERE C.codCliente = p.codCliente);

-- 3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT nombre
  FROM PRODUCTOS
  WHERE codProducto NOT IN (SELECT p.codProducto
							  FROM DETALLE_PEDIDOS dp, PRODUCTOS p
							 WHERE dp.codProducto = p.codProducto);

-- 4. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
SELECT nombre, apellido1, apellido2, tlf_extension_ofi
  FROM EMPLEADOS
 WHERE codEmpleado NOT IN (SELECT codEmpleado
							  FROM EMPLEADOS e, CLIENTES c
							 WHERE c.codEmpl_ventas = e.codEmpleado);

-- 5. Devuelve las oficinas donde trabajan alguno de los empleados.
SELECT codOficina
  FROM OFICINAS
 WHERE codOficina IN (SELECT o.codOficina
				        FROM OFICINAS o, EMPLEADOS e
					   WHERE o.codOficina = e.codOficina);
				   
-- 6. Devuelve un listado con los clientes que han realizado algún pedido pero no que hayan realizado ningún pago.
SELECT *
  FROM CLIENTES
 WHERE codCliente IN (SELECT c.codCliente
					    FROM CLIENTES c, PAGOS p
					   WHERE C.codCliente = p.codCliente)
/* AND NOT IN (SELECT c.codCliente
					    FROM CLIENTES c, PAGOS p
					   WHERE C.codCliente = p.codCliente)*/
INTERSECT 
SELECT *
 FROM CLIENTES
 WHERE codCliente NOT IN (SELECT c.codCliente
					    FROM CLIENTES c, PAGOS p
					   WHERE C.codCliente = p.codCliente);


------------------------------------------
-- Subconsultas con EXISTS y NOT EXISTS --
------------------------------------------

-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT *
  FROM CLIENTES c
 WHERE NOT EXISTS (SELECT c.codCliente
					 FROM  PAGOS p
				    WHERE c.codCliente = p.codCliente);

-- 2. Devuelve un listado que muestre solamente los clientes que han realizado algún pago.
SELECT *
  FROM CLIENTES c
 WHERE EXISTS (SELECT c.codCliente
					    FROM PAGOS p
					   WHERE c.codCliente = p.codCliente);

-- 3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT *
  FROM PRODUCTOS p
  WHERE NOT EXISTS (SELECT p.codProducto
							  FROM DETALLE_PEDIDOS dp
							 WHERE dp.codProducto = p.codProducto);

-- 4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
SELECT *
  FROM PRODUCTOS p
  WHERE EXISTS (SELECT p.codProducto
				  FROM DETALLE_PEDIDOS dp
				 WHERE dp.codProducto = p.codProducto);


---------------------------
--		  Vistas		 --
---------------------------

-- 1. Crea una vista que devuelva los códigos de los clientes que realizaron pedidos en 2019 y los clientes que realizaron pagos por transferencia. Utiliza la unión.
CREATE VIEW VClientesTransacciones2019 AS
SELECT DISTINCT c.codCliente
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND YEAR(fecha_pedido) = 2019
UNION 
SELECT c.codCliente
  FROM PAGOS P, CLIENTES c
 WHERE p.codCliente = c.codCliente
   AND p.codFormaPago = 'T'
   
-- 2. Escribe el código SQL para realizar una consulta a dicha vista
SELECT *
  FROM VClientesTransacciones2019

-- 3. Escribe el código SQL para eliminar dicha vista.
DROP VIEW VClientesTransacciones2019