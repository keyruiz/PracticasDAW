USE JARDINERIA

						---------------------------
						-- EJERCICIOS UD7 - TSQL -- 
						---------------------------
-------------------------------------------------------------------------------------------
-- NOTA: Recuerda cuidar la limpieza del código (tabulaciones, nombres de tablas en mayúscula,
--		nombres de variables en minúscula, poner comentarios sin excederse, código organizado y fácil de seguir, etc.)
-------------------------------------------------------------------------------------------
-- ¡IMPORTANTE! Siempre que sea posible deberás utilizar variables 	(no es correcto indicar directamente el valor en una SELECT)
--  Esta práctica incorrecta se conoce como "hardcoding" y genera muchos problemas en el código y en su depuración
--  Aquí tenéis más información: https://es.wikipedia.org/wiki/Hard_code
-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
-- 1. Crea un script que obtenga el nombre de la gama que tenga más cantidad de productos diferentes
--
-- Salida: 'La gama que más productos tiene es Ornamentales'
-------------------------------------------------------------------------------------------
DECLARE @categoria VARCHAR(50)
SELECT @categoria = cp.nombre
  FROM CATEGORIA_PRODUCTOS cp, PRODUCTOS p
 WHERE cp.codCategoria = p.codCategoria
 GROUP BY p.codCategoria, cp.nombre
HAVING COUNT(codProducto) IN (SELECT MAX(codProducto)
                                FROM PRODUCTOS
								GROUP BY codCategoria)

PRINT CONCAT('La gama que más productos tiene es ', @categoria)


DECLARE @codCategoria CHAR(2),
		@nomCategoria VARCHAR(50)

SELECT TOP(1) @codCategoria = codCategoria
  FROM PRODUCTOS
 GROUP BY codCategoria
 ORDER BY COUNT(codProducto)
EXEC sp_columns CATEGORIA_PRODUCTOS

SELECT nombre 
  FROM CATEGORIA_PRODUCTOS
 WHERE codCategoria = @codCategoria


-------------------------------------------------------------------------------------------
-- 2. Crea un script que obtenga el nombre del empleado con id 7 y el nombre de su jefe
--
-- Salida: 'El empleado Carlos Soria Jimenez tiene como jefe al empleado Alberto Soria Carrasco'
-------------------------------------------------------------------------------------------
DECLARE @codEmpleado INT = -1,
		@nombreEmpleado VARCHAR(150),
        @nomJefe VARCHAR(152)

IF NOT EXISTS (SELECT *
                 FROM EMPLEADOS
				WHERE codEmpleado = @codEmpleado)
BEGIN
	PRINT 'NO EXISTE'
	RETURN
END
	SELECT @nombreEmpleado = CONCAT(e.nombre,' ', e.apellido1, ' ', e.apellido2),
		   @nomJefe = CONCAT(ej.nombre,' ', ej.apellido1, ' ', ej.apellido2)
	  FROM EMPLEADOS e, EMPLEADOS ej
	 WHERE e.codEmplJefe = ej.codEmpleado
	   AND e.codEmpleado = @codEmpleado

	PRINT CONCAT('El empleado ',@nombreEmpleado ,' tiene como jefe al empleado ',@nomJefe)


-------------------------------------------------------------------------------------------
-- 3. Crea un script que devuelva el número de pedidos realizados por el cliente 9
--
-- Salida: 'El cliente Naturagua ha realizado 5 pedido/s'
-------------------------------------------------------------------------------------------
DECLARE @codCliente INT = 9,
		@nombreCliente VARCHAR(50),
		@numPedidos INT

SELECT @nombreCliente = c.nombre_cliente,
	   @numPedidos = COUNT(p.codPedido)
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = @codCliente
 GROUP BY p.codCliente, c.nombre_cliente

PRINT CONCAT('El cliente ', @nombreCliente, ' realizado ', @numPedidos, ' pedido/s')


---en dos consultas <---MEJOR OPCIÓN EN ESTE CASO, ya que se agrupaba en la anterior

SELECT @codCliente = nombre_cliente
  FROM CLIENTES
 WHERE codCliente = @codCliente

SELECT @numPedidos = COUNT(codPedido)
  FROM PEDIDOS
 WHERE codCliente = @codCliente

EXEC sp_columns EMPLEADOS

-------------------------------------------------------------------------------------------
-- 4. Crea un script que dado un codPedido en una variable, obtenga la siguiente información:
--		nombre_cliente, Fecha pedido, estado
--
-- Salida: 'El pedido XXXX realizado por el cliente YYYYYYY se realizó el ZZ/ZZ/ZZZZ y su estado es EEEEEEEE
-------------------------------------------------------------------------------------------
DECLARE @codPedido INT = 10,
		@nomCliente VARCHAR(50),
		@fechaPedido DATE,
		@estado VARCHAR(15)

SELECT @nomCliente = c.nombre_cliente,
	   @fechaPedido = p.fecha_pedido,
	   @estado = ep.descripcion
  FROM CLIENTES c, PEDIDOS p, ESTADOS_PEDIDO ep
 WHERE c.codCliente = p.codCliente
   AND codPedido = @codPedido 

PRINT CONCAT('El pedido ', @codPedido, ' realizado por el cliente ', @nomCliente, ' se realizó el ', @fechaPedido, ' y su estado es ', @estado)

EXEC sp_columns ESTADOS_PEDIDO

-------------------------------------------------------------------------------------------
-- 5. Crea un script que dadas dos variables: porcentaje y gama
--		Incremente el precio de los productos de dicha gama en el porcentaje que se le pasa
--
-- Salida: 'Se ha aumentado el precio un XXXX% de la gama YYYY'
-------------------------------------------------------------------------------------------
DECLARE @porcentaje TINYINT = 15,
		@codCategoria CHAR(2) = 'FR',
        @gama VARCHAR(50) = (SELECT nombre
							   FROM CATEGORIA_PRODUCTOS
							  WHERE codCategoria = @codCategoria)

UPDATE PRODUCTOS
SET precio_venta = precio_venta * ((@porcentaje/100.0) + 1)
WHERE codCategoria = @codCategoria

PRINT CONCAT('Se ha aumentado el precio un ', @porcentaje, '% de la gama', @gama)
EXEC sp_columns CATEGORIA_PRODUCTOS

-----CREAR BACKOUT DE TABLA, COPIA
---Select *
-----INTO PRODUCTOS_BACKOUT
  ---FROM PRODUCTOS
-------------------------------------------------------------------------------------------
-- 6. Crea un script que devuelva cuántos clientes han realizado algún pedido de
--   al menos 3 productos (siendo el número de productos una variable).
--	
-- Salida: 'Existen XXXX clientes en la BD que han realizado pedidos de al menos YYYY productos'
-------------------------------------------------------------------------------------------
DECLARE @numProductos INT = 3,
		@cantClientes INT

IF ISNULL(@numProductos, 0) < 0
BEGIN
	PRINT ('Número de productos incorrecto')	
	RETURN
END

SELECT @cantClientes = COUNT(DISTINCT codCliente) --OJO CON EL DISTINCT 
  FROM PEDIDOS
 WHERE codPedido IN (SELECT codPedido
					   FROM DETALLE_PEDIDOS
					  GROUP BY codPedido
					 HAVING COUNT(numeroLinea) >= @numProductos)
 
 PRINT CONCAT('Existen ', @cantClientes, ' clientes en la BD que han realizado pedidos de al menos ', @numProductos, ' productos')

------58 PEDIDOS CON MAS IGUAL DE 3 LINEAS

-------------------------------------------------------------------------------------------
-- 7. Crea un script que a partir de una variable codCliente devuelva el nombre completo de su
-- 		representante de ventas y la ciudad de la oficina en la que trabaja.
--	
-- Salida: 'El cliente XXXX tiene como representante a YYYY y trabaja en la ciudad de ZZZZ'
-------------------------------------------------------------------------------------------

DECLARE @codCliente INT = 2,
		@nomCliente VARCHAR(50),
		@nomRepVentas VARCHAR(102),
		@ciudadOfi VARCHAR(40)

IF ISNULL(@codCliente, 0) <= 0
	OR NOT EXISTS (SELECT 1
					 FROM CLIENTES
					WHERE codCliente = @codCliente)
BEGIN
	PRINT('NO EXISTE')
	RETURN
END

SELECT @nomCliente = c.nombre_cliente,
	   @nomRepVentas = CONCAT(e.nombre,' ', e.apellido1),
	   @ciudadOfi = o.ciudad
  FROM CLIENTES c, EMPLEADOS e, OFICINAS o
 WHERE c.codEmpl_ventas = e.codEmpleado
   AND e.codOficina = o.codOficina
   AND c.codCliente = @codCliente


 
 PRINT CONCAT('El cliente ', @nomCliente,
			  ' tiene como representante a ', @nomRepVentas,
			  ' y trabaja en la ciudad de ', @ciudadOfi)

EXEC sp_help CLIENTES

SELECT codCliente from CLIENTES
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
  FROM CLIENTES c, EMPLEADOS e, OFICINAS o
 WHERE c.codEmpl_ventas = e.codEmpleado AND e.codOficina = o.codOficina AND codCliente = 12
