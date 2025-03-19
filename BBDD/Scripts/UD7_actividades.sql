USE JARDINERIA

						---------------------------
						-- EJERCICIOS UD7 - TSQL -- 
						---------------------------
-------------------------------------------------------------------------------------------
-- NOTA: Recuerda cuidar la limpieza del código (tabulaciones, nombres de tablas en mayúscula,
--		nombres de variables en minúscula, poner comentarios sin excederse, código organizado y fácil de seguir, etc.)
-------------------------------------------------------------------------------------------
-- 1. Crea un script que use un bucle para calcular la potencia de un número.
--		Tendremos dos variables: el número y la potencia
--
--		Ejemplo.
--		Número = 3		Potencia = 4		Resultado = 3*3*3*3 = 81
--
--		Si el número o la potencia son 0 o <0 devolverá el mensaje: “La operación no se puede realizar.
-------------------------------------------------------------------------------------------
DECLARE @numero INT = 2,
        @potencia INT = 5,
		@resultado INT = 1,
		@cadena VARCHAR(20)

IF @potencia <= 0
BEGIN
	PRINT 'La operación no se puede realizar'
	RETURN 
END
IF @potencia = 0
BEGIN 
	PRINT 'El resultado es 1'
END
WHILE @potencia > 0
BEGIN
	SET @resultado *= @numero
	IF @potencia <> 1
	BEGIN 
	SET @cadena = CONCAT(@cadena , @numero, '*')
	END ELSE
	BEGIN
	SET @cadena = CONCAT(@cadena , @numero)
	END
	SET @potencia -= 1
END
SET @cadena = CONCAT(@cadena, ' = ')
PRINT CONCAT(@cadena , @resultado)


-------------------------------------------------------------------------------------------
-- 2. Crea un script que calcule las soluciones de una ecuación de segundo grado ax^2 + bx + c = 0
--
--	Debes crear variables para los valores a, b y c.
--  Al principio debe comprobarse que los tres valores son positivos, en otro caso, 
--		se devolverá el mensaje 'Cálculo no implementado'
--	
--	Consulta esta página para obtener la fórmula a implementar (recuerda que habrá DOS soluciones): 
--		http://recursostic.educacion.es/descartes/web/Descartes1/4a_eso/Ecuacion_de_segundo_grado/Ecua_seg.htm#solgen

--	Salida esperada para los valores: a=3, b=-4, c=1 --> sol1= 1 y sol2= 0.33
--	
--	NOTA: Si no sale lo mismo, te recomiendo revisar bien el orden de prioridad de los operadores... ()
-------------------------------------------------------------------------------------------
DECLARE @a DECIMAL = 3.0,
        @b DECIMAL = 4.0,
		@c DECIMAL = 1.0,
		@sol1 DECIMAL(5,2),
		@sol2 DECIMAL(5,2)

IF (@a < 0) OR (SQRT(POWER(@b, 2) - 4 * @a * @c) < 0)
BEGIN
	PRINT 'Cálculo no implementado'
	RETURN
END

SET @sol1 = (@b + SQRT(POWER(@b, 2) - 4 * @a * @c)) / (@a * 2)
SET @sol2 = (@b - SQRT(POWER(@b, 2) - 4 * @a * @c)) / (@a * 2)
PRINT CONCAT('Para los valores: a = ', @a,', b = ',@b , ' y c = ', @c, CHAR(10),
			 'Solución 1: ', @sol1, CHAR(10),
			 'Solución 2: ', @sol2)


-------------------------------------------------------------------------------------------
-- 3. Crea un script que calcule la serie de Fibonacci para un número dado.

-- La sucesión es: 1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597...
-- Si te fijas, se calcula sumando el número anterior al siguiente:
--	Ejemplo. Si se introduce el numero 3 significa que tendremos que hacer 3 iteraciones:
--			ini = 1
--			0+1 = 1
--			1+1 = 2
--			2+1 = 3
--			3+2 = 5
--			5+3 = 8
--			...
-- 
--	Ayuda: Quizás necesites guardar en algún sitio el valor actual de la serie antes de sumarlo...
-------------------------------------------------------------------------------------------
DECLARE @contador INT = 10,
		@a INT = 0, 
		@b INT = 1,
		@auxiliar INT,
		@cadena VARCHAR(100) =  ' '

SET @cadena = CONCAT(@cadena, @a, ',', @b )

WHILE @contador > 0
BEGIN
    SET @auxiliar = @a + @b
    SET @a = 0 + @b
    SET @b = 0+ @auxiliar
	SET @cadena = CONCAT(@cadena, ',', @auxiliar)
    SET @contador = @contador - 1
END
PRINT @cadena

-------------------------------------------------------------------------------------------
-- 4. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Obtén el nombre del cliente con código 3 y guárdalo en una variable
--		Obtén el número de pedidos realizados por dicho cliente y guárdalo en una variable
--		Muestra por pantalla el mensaje: 'El cliente XXXX ha realizado YYYY pedidos.'
--		
--		Resultado esperado: El cliente Gardening Associates ha realizado 9 pedidos.
--
--	    Reto opcional: Implementa el script utilizando una única consulta.
-------------------------------------------------------------------------------------------
USE JARDINERIA

DECLARE @codCliente INT = 3,
		@nomCliente VARCHAR(50),
		@numPedidos INT

SELECT @nomCliente = nombre_cliente,
	   @numPedidos = COUNT(p.codCliente)
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND c.codCliente = @codCliente
 GROUP BY c.nombre_cliente

PRINT CONCAT('El cliente ', @nomCliente, ' ha realizado ', @numPedidos, ' pedidos')



-------------------------------------------------------------------------------------------
-- 5. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Obtén el nombre y los apellidos de todos los empleados de la empresa
--		Deberás mostrar cada uno de ellos línea a línea utilizando PRINT
--		
--		Salida esperada:
--			Magaña Perez, Marcos
--			López Martinez, Ruben
--			Soria Carrasco, Alberto
--			Solís Jerez, Maria
--			...
DECLARE @contador INT = 0,
		@cantEmpleados INT,
		@nomCompleto VARCHAR(152)

SET @cantEmpleados = (SELECT COUNT(*) 
					   FROM EMPLEADOS) 
WHILE  @contador < @cantEmpleados
BEGIN
	SELECT @nomCompleto = CONCAT(apellido1, ' ', apellido2, ', ', nombre) 
	  FROM EMPLEADOS
	 ORDER BY codEmpleado ASC
	 OFFSET @contador ROWS 
	 FETCH NEXT 1 ROWS ONLY

	 PRINT @nomCompleto
	 SET @contador += 1
END

--		Reto opcional: Modifica el script anterior para que muestre sólo los que trabajen en la oficina de Londres
--		Salida esperada:
--			Johnson , Amy
--			Westfalls , Larry
--			Walton , John
-------------------------------------------------------------------------------------------
DECLARE @contador INT = 0,
		@cantEmpleados INT,
		@nomCompleto VARCHAR(152),
		@ciudad CHAR(6) = (SELECT codOficina
							FROM OFICINAS
						   WHERE ciudad = 'Londres')

SET @cantEmpleados = (SELECT COUNT(*) 
					   FROM EMPLEADOS
					   WHERE codOficina = @ciudad)
WHILE  @contador < @cantEmpleados
BEGIN
	SELECT @nomCompleto = CONCAT(apellido1, ' ', apellido2, ', ', nombre) 
	  FROM EMPLEADOS
	 WHERE codOficina = @ciudad
	 ORDER BY codEmpleado ASC 
	 OFFSET @contador ROWS 
	 FETCH NEXT 1 ROWS ONLY

	 PRINT @nomCompleto
	 SET @contador += 1
END

-------------------------------------------------------------------------------------------
-- 6. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Reutilizando el script del ejercicio 4, agrega la siguiente información a la salida:
--			Número de pedidos realizados por cada cliente
--			NOTA: Realízalo utilizando una consulta específica para obtener el número de pedidos de cada cliente.

--		Salida esperada:
--			El cliente GoldFish Garden ha realizado 11 pedidos.
--			El cliente Gardening Associates ha realizado 9 pedidos.
--			El cliente Gerudo Valley ha realizado 5 pedidos.
--			El cliente Tendo Garden ha realizado 5 pedidos.
--			El cliente Lasas S.A. ha realizado 0 pedidos.
--			...

DECLARE	@nomCliente VARCHAR(50),
		@numPedidos INT,
		@cantClientes INT = (SELECT COUNT(codCliente)
							   FROM CLIENTES),
		@contador INT = 0,
		@codCliente INT

WHILE @contador < @cantClientes
BEGIN
	SELECT @nomCliente = nombre_cliente,
		   @numPedidos = COUNT(p.codCliente)
	  FROM CLIENTES c LEFT JOIN PEDIDOS p
	    ON c.codCliente = p.codCliente
	 GROUP BY c.nombre_cliente, c.codCliente
	 ORDER BY c.codCliente ASC 
	  OFFSET @contador ROWS 
	 FETCH NEXT 1 ROWS ONLY
	 PRINT CONCAT('El cliente ', @nomCliente, ' ha realizado ', @numPedidos, ' pedidos')
	 SET @contador += 1
END
--		Reto opcional:
--		Muestra también el coste total de todos los pedidos para cada cliente.
--
--		Salida esperada:
--			El cliente GoldFish Garden ha realizado 11 pedidos por un coste total de 10365.00.
--			El cliente Gardening Associates ha realizado 9 pedidos por un coste total de 13726.00.
--			El cliente Gerudo Valley ha realizado 5 pedidos por un coste total de 81849.00.
--			El cliente Tendo Garden ha realizado 5 pedidos por un coste total de 23794.00.
--			El cliente Lasas S.A. ha realizado 0 pedidos por un coste total de 0.00.
--			...
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
-- 7. Utilizando la BD JARDINERIA, crea un script que realice las siguientes operaciones:
--	Importante: debes utilizar TRY/CATCH y Transacciones si fueran necesarias.

--		Crea una nueva oficina (datos inventados)
--		Crea un nuevo empleado con datos inventados (el codEmpleado a insertar debes obtenerlo automáticamente)
--		Crea un nuevo cliente (datos inventados) (el codCliente a insertar debes obtenerlo automáticamente)
--		Asigna como representante de ventas el cliente anterior
-------------------------------------------------------------------------------------------


DECLARE @codEmpleado INT, @codCliente INT

SET IMPLICIT_TRANSACTIONS OFF
BEGIN TRY 
	--Obtenemos el nuevo código de empleado
	SET @codEmpleado = (SELECT MAX(codEmpleado) + 1
						  FROM EMPLEADOS)

	--Obtenemos el nuevo código de cliente
	SET @codCliente = (SELECT MAX(codCliente) + 1
	                     FROM CLIENTES)
	BEGIN TRAN
	--Creo nueva oficina
	INSERT INTO OFICINAS 
	VALUES ('COL-BG', 'Bogota', 'Colombia', '11011', '+57 234 456780',
			'Avenida el dorado ', NULL)

	--Creo nuevo empleado
	INSERT INTO EMPLEADOS
	VALUES (@codEmpleado, 'Cristian', 'Rojas', 'Rocha',
			'2442', 'crisrojroc@ghotmail.com', 'Representante Ventas',
			1700, 'MAD-ES', 7)

	--Creo nuevo cliente 
	INSERT INTO CLIENTES
	VALUES (@codCliente, 'Club Flowers', 'Eduardo', 'Ruiz',
		   '34678541267', 'edu.flw@clubflowers.com', 'C/ Pintor Gastón',
		   null, 'Madrid', 'Spain', 
		   '03013', @codEmpleado, 12500)
	COMMIT 
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
				 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
				 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
				 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
				 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
END CATCH
SET IMPLICIT_TRANSACTIONS ON

select * from OFICINAS
-------------------------------------------------------------------------------------------
-- 8. Utilizando la BD JARDINERIA, crea un script que realice las siguientes operaciones:
--	Importante: debes utilizar TRY/CATCH y Transacciones si fueran necesarias.
--
--		Debes eliminar la oficina, el empleado y el cliente creados en el apartado anterior.
--		Debes crear variables con los identificadores de clave primaria para eliminar
--			todos los datos de cada una de las tablas en una sola ejecución
-------------------------------------------------------------------------------------------

DECLARE @codOficinas CHAR(5) = 'COL-BG',
		@codEmpleado INT = (SELECT MAX(codEmpleado)
						      FROM EMPLEADOS),
		@codCliente INT = (SELECT MAX(codCliente)
		                      FROM CLIENTES)

SET IMPLICIT_TRANSACTIONS OFF
BEGIN TRY
	BEGIN TRAN 
	--Eliminar oficina
	DELETE FROM OFICINAS
	WHERE codOficina = @codOficinas

	--Eliminar cliente
	DELETE FROM CLIENTES
	WHERE codCliente = @codCliente

	--Eliminar empleado
	DELETE FROM EMPLEADOS
	WHERE codEmpleado = @codEmpleado

	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
				 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
				 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
				 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
				 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
END CATCH
SET IMPLICIT_TRANSACTIONS ON


-------------------------------------------------------------------------------------------
-- 9. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Crea un nuevo cliente (invéntate los datos). No debes indicar directamente el código, 
--			sino buscar cuál le tocaría con una SELECT y guardarlo en una variable.

--		Crea un nuevo pedido para dicho cliente (fechaPedido será la fecha actual, fecha esperada 10 días 
--				después de la fecha de pedido, fecha entrega y comentarios a NULL y estado PENDIENTE)
--			Dicho pedido debe constar de dos productos (los códigos de producto se declaran como variables y se utilizan después)
--			El precio de cada producto debes obtenerlo utilizando SELECT antes de insertarlo en DETALLE_PEDIDOS,
--			de tal manera que, si modificamos los códigos de producto, el script seguirá funcionando.
--			La cantidad de los productos comprados puede ser la que tú quieras.

--		Recuerda que debes utilizar TRANSACCIONES (si fueran necesarias) y TRY/CATCH

--		Reto opcional:
--			Crea también un nuevo pago para dicho cliente cuyo importe coincida con lo que cuesta el pedido completo
--				Puedes indicar directamente el idtransaccion como 'ak-std-000026', aunque es mejor que lo obtengas dinámicante
--				utilizando funciones de SQL Server (piensa que los 6 últimos caracteres son números...)
--				Forma de pago debe ser: 'PayPal' y Fechapago la del día
-------------------------------------------------------------------------------------------

DECLARE @codCliente INT,
		@codPedido INT,
		@producto1 INT = 12,
		@producto2 INT = 15,
		@precio1 DECIMAL(9,2),
		@precio2 DECIMAL(9,2)

IF (@producto1 <= 0 OR @producto2 <= 0)
BEGIN 
	PRINT('No existe el alguno de los productos')
	RETURN
END

SET IMPLICIT_TRANSACTIONS OFF
BEGIN TRY

	--Obtener codigo de cliente
	SET @codCliente = (SELECT MAX(codCliente) + 1
	                     FROM CLIENTES)
	--Obtener codigo de pedido
	SET @codPedido = (SELECT MAX(codPedido) + 1
	                    FROM PEDIDOS)

	--Obtener precio de producto
	SELECT @precio1 = precio_venta
	  FROM PRODUCTOS
	 WHERE codProducto = @producto1

	SELECT @precio2 = precio_venta
	  FROM PRODUCTOS
	WHERE codProducto = @producto2

	BEGIN TRAN
	--Añadir cliente
	INSERT INTO CLIENTES
	VALUES (@codCliente, 'Club Trees', 'Sandra', 'Rocha',
		   '34678541269', 'sandra123@clubflowers.com', 'C/ Pintor Gastón2',
		   null, 'Granada', 'Spain', 
		   '03013', 19, 12550)

	--Añadir pedido
	INSERT INTO PEDIDOS
	VALUES(@codPedido, GETDATE(), DATEADD(DAY, 10, GETDATE()),
	       null, 'P', null, @codCliente)

    --Insertar a detalles
	INSERT INTO DETALLE_PEDIDOS
	VALUES (@codPedido, @producto1, 2, @precio1, 1),
	       (@codPedido, @producto2, 3, @precio2, 2)
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
				 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
				 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
				 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
				 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
END CATCH
SET IMPLICIT_TRANSACTIONS ON
