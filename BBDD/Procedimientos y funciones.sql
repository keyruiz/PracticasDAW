USE JARDINERIA

				---------------------------
				--   UD8  -  PROC & FUNC -- 
				---------------------------
-------------------------------------------------------------------------------------------
-- NOTA: Recuerda cuidar la limpieza del código (tabulaciones, nombres de tablas en mayúscula,
--		nombres de variables en minúscula, poner comentarios sin excederse, código organizado y fácil de seguir, etc.)
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
-- 1. Implementa un procedimiento llamado 'getNombreCliente' que devuelva el nombre de un cliente a partir de su código.
--		Parámetros de entrada:  codCliente INT
--		Parámetros de salida:   nombreCliente VARCHAR(50)
--		Tabla:                  CLIENTES
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--      Recuerda utilizar en el script:
--              EXEC @ret = getNombreCliente @codCliente, @nombreCliente OUTPUT
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------
GO

CREATE OR ALTER PROCEDURE getNombreCliente (@codCliente INT, @nombre VARCHAR(50) OUTPUT)
AS
BEGIN
	BEGIN TRY
		IF ISNULL(@codCliente, 0) <= 0
		BEGIN
			PRINT 'Código inválido'
			RETURN -1
		END
		SELECT @nombre = nombre_cliente 
		  FROM CLIENTES
		 WHERE codCliente = @codCliente

		 IF @nombre IS NULL
		 BEGIN
			PRINT CONCAT('El cliente ', @codCliente, ' no existe')
			RETURN -1
		 END
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
					 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
					 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
					 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
					 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

GO 

DECLARE @ret INT,
		@codCliente INT = 4,
		@nombreCliente VARCHAR(50)

EXEC @ret = getNombreCliente @codCliente, @nombreCliente OUTPUT
IF @ret <> 0 
BEGIN
	PRINT CONCAT('Error en getNombreCliente, código: ', @codCliente)
	RETURN
END




-------------------------------------------------------------------------------------------
-- 2. Implementa un procedimiento llamado 'getPedidosPagosCliente' que devuelva el número de pedidos y de pagos a partir de un código de cliente.
--		Parámetros de entrada:  codCliente INT
--		Parámetros de salida:   numPedidos INT
--                              numPagos INT
--		Tabla:                  CLIENTES
--		
-------------------------------------------------------------------------------------------
GO

CREATE OR ALTER PROCEDURE getPedidosPagosCliente (@codCliente INT, 
												  @numPedidos INT OUTPUT,
												  @numPagos INT OUTPUT)
AS
BEGIN
	BEGIN TRY
		IF ISNULL(@codCliente, 0) <= 0 OR NOT EXISTS (SELECT *
														FROM CLIENTES
													   WHERE codCliente = @codCliente )
		BEGIN
			PRINT 'Código inválido'
			RETURN -1
		END

		SELECT @numPedidos = COUNT(codPedido)
		  FROM PEDIDOS
		 WHERE codCliente = @codCliente

		 SELECT @numPagos = COUNT(id_transaccion)
		   FROM PAGOS
		  WHERE codCliente = @codCliente
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
					 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
					 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
					 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
					 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

GO
DECLARE @ret INT,
		@codCliente INT = 15,
		@numPedidos INT,
		@numPagos INT

EXEC @ret = getPedidosPagosCliente @codCliente, @numPedidos OUTPUT, @numPagos OUTPUT
IF @ret <> 0
BEGIN
	PRINT CONCAT('Error en getNombreCliente, código: ', @codCliente)
	RETURN
END
PRINT CONCAT('El cliente ', @codCliente, ' ha hecho ', @numPedidos, ' pedidos y ', @numPagos, ' pagos')

-------------------------------------------------------------------------------------------
-- 3. Implementa un procedimiento llamado 'crearCategoriaProducto' que inserte una nueva categoría de producto en la base de datos JARDINERIA.
--		Parámetros de entrada: codCategoria CHAR(2),
--							   nombre VARCHAR(50),
--                             descripcion_texto VARCHAR(MAX), 
--                             descripcion_html VARCHAR(MAX),
--                             imagen VARCHAR(256)

--		Parámetros de salida: <ninguno>
--		Tabla: CATEGORIA_PRODUCTOS
--		
--		# Se debe comprobar que todos los parámetros obligatorios están informados. Si falta alguno, devolver -1 y finalizar.
--		# Se debe comprobar que la categoría no exista previamente en la tabla. Si ya existe, imprimir mensaje indicándolo, devolver -1 y finalizar.
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--      Recuerda utilizar en el script:
--              EXEC @ret = crearCategoriaProducto ...
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------
--USE JARDINERIA
GO
CREATE OR ALTER PROCEDURE crearCategoriaProducto (@codCategoria CHAR(2),
												  @nombre VARCHAR(50),
												  @descripcion_texto VARCHAR(100),
												  @descripcion_html VARCHAR(100),
												  @imagen VARCHAR(255))
AS
BEGIN
	BEGIN TRY
		IF @codCategoria IS NULL OR EXISTS (SELECT *
											  FROM CATEGORIA_PRODUCTOS
											 WHERE codCategoria = @codCategoria)
		BEGIN
			PRINT 'Código de la categoría inválido'
			RETURN -1
		END
		IF @nombre IS NULL OR EXISTS (SELECT *
		                                FROM CATEGORIA_PRODUCTOS
									   WHERE nombre = @nombre)
		BEGIN
			PRINT 'Nombre ya existe'
			RETURN -1
		END
		INSERT INTO CATEGORIA_PRODUCTOS (codCategoria, nombre, descripcion_texto,
										 descripcion_html, imagen)
		VALUES (@codCategoria, @nombre, @descripcion_texto,
				@descripcion_html, @imagen)
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
				 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
				 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
				 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
				 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

GO

DECLARE @codCategoria CHAR(2) = 'ZZ',
		@nombre VARCHAR(50) = 'Frutales',
		@descripcion_texto VARCHAR(100),
		@descripcion_html VARCHAR(100),
		@imagen VARCHAR(255),
		@ret INT

--BEGIN TRAN
EXEC @ret = crearCategoriaProducto @codCategoria, @nombre, @descripcion_texto, @descripcion_html, @imagen
IF @ret <> 0
BEGIN
	--ROLLBACK
	PRINT 'Fallo en la transacción'
END
--COMMIT


-------------------------------------------------------------------------------------------
-- 4. Implementa un procedimiento llamado 'acuseRecepcionPedidosCliente' que actualice la fecha de entrega de los pedidos
--      a la fecha del momento actual y su estado a 'Entregado' para el codCliente pasado por parámetro y solo para los 
--      pedidos que estén en estado 'Pendiente' y no tengan fecha de entrega.

--		Parámetros de entrada: codCliente INT
--		Parámetros de salida:  numPedidosAct INT
--		Tabla: PEDIDOS

--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--
--      Ayuda: Recuerda utilizar:
--              EXEC @ret = acuseRecepcionPedidosCliente ...
--              IF @ret <> 0 ...
--
--	  * Ayuda para obtener el número de registros actualizados:
--		Se puede hacer una SELECT antes de ejecutar la sentencia de actualización o bien utilizar la variable @@ROWCOUNT
--
-------------------------------------------------------------------------------------------
GO
CREATE OR ALTER PROCEDURE acuseRecepcionPedidosCliente (@codCliente INT,
														@numPedidosAct INT OUTPUT)
AS
BEGIN
	BEGIN TRY
		IF ISNULL(@codCliente, 0) <= 0 OR NOT EXISTS (SELECT *
		                                                FROM CLIENTES
													   WHERE codCliente = @codCliente)
		BEGIN
			PRINT 'No existe el cliente o código invalido'
			RETURN -1
		END

		UPDATE PEDIDOS
		  SET fecha_entrega = GETDATE(),
			  codEstado = 'E'
		WHERE codCliente = @codCliente
		  AND fecha_entrega IS NULL 
		  AND codEstado = 'P'

		SET @numPedidosAct = @@ROWCOUNT 
		IF @numPedidosAct = 0
			PRINT 'No ha habido ningún cambio'
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
					 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
					 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
					 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
					 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

GO

DECLARE @codCliente INT = 6,
		@numPedidosAct INT,
		@ret INT

--BEGIN TRAN
EXEC @ret = acuseRecepcionPedidosCliente @codCliente, @numPedidosAct OUTPUT
IF @ret <> 0
BEGIN
	--ROLLBACK
	PRINT 'Fallo en la transacción'
END
ELSE
	PRINT CONCAT(@numPedidosAct, ' actualizaciones')
--COMMIT

SELECT * FROM PEDIDOS  where codCliente = 6
select * from CLIENTES

-------------------------------------------------------------------------------------------
-- 5. Implementa un procedimiento llamado 'crearOficina' que inserte una nueva oficina en JARDINERIA.
--		Parámetros de entrada: codOficina CHAR(6)
--                             ciudad VARCHAR(40)
--                             pais VARCHAR(50)
--                             codigo_postal CHAR(5)
--                             telefono VARCHAR(15)
--                             linea_direccion1 VARCHAR(100)
--                             linea_direccion2 VARCHAR(100) (no obligatorio)

--		Parámetros de salida: <ninguno>
--		Tabla: OFICINAS
--		
--		# Se debe comprobar que todos los parámetros obligatorios están informados, sino devolver -1 y finalizar
--		# Se debe comprobar que el codOficina no exista previamente en la tabla, y si así fuera, 
--			imprimir un mensaje indicándolo y se devolverá -1
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--
--      Ayuda: Recuerda utilizar:
--              EXEC @ret = crearOficina ...
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------

GO

CREATE OR ALTER PROCEDURE crearOficina(@codOficina CHAR(6),
									   @ciudad VARCHAR(40),
									   @pais VARCHAR(50),
									   @codPostal CHAR(5),
									   @telefono VARCHAR(12),
									   @linea_direccion1 VARCHAR(100),
									   @linea_direccion2 VARCHAR(100))
AS
BEGIN
	BEGIN TRY
		IF @codOficina IS NULL OR EXISTS (SELECT *
											FROM OFICINAS
										   WHERE codOficina = @codOficina)
		BEGIN
			PRINT 'Código de la categoría inválido'
			RETURN -1
		END
		IF @ciudad IS NULL OR @pais IS NULL OR 
		   @codPostal IS NULL OR @telefono IS NULL OR 
		   @linea_direccion1 IS NULL
		BEGIN
			PRINT 'Algun dato es inválido'
			RETURN -1
		END
		INSERT INTO OFICINAS(codOficina, ciudad, pais,
							 codPostal, telefono, linea_direccion1, linea_direccion2)
		VALUES (@codOficina, @ciudad , @pais,
				@codPostal,	@telefono, @linea_direccion1,
				@linea_direccion2)
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
					 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
					 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
					 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
					 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

GO 

DECLARE @codOficina CHAR(6) = 'SCR-BOL',
		@ciudad VARCHAR(40) = 'Santa Cruz',
		@pais VARCHAR(50) = 'Bolivia',
		@codPostal CHAR(5) = '0220',
		@telefono VARCHAR(12) = '+59199878056',
		@linea_direccion1 VARCHAR(100) = 'calle Riveralta',
		@linea_direccion2 VARCHAR(100),
		@ret INT


--BEGIN TRAN
EXEC @ret = crearOficina @codOficina,@ciudad, @pais,
						 @codPostal, @telefono, @linea_direccion1,
						 @linea_direccion2
IF @ret <> 0
BEGIN
	--ROLLBACK
	PRINT 'Fallo en la transacción'
END
ELSE
	PRINT 'Oficina creada'
--COMMIT

-------------------------------------------------------------------------------------------
-- 6. Implementa un procedimiento llamado 'cambioJefes' que actualice el jefe/a de los empleados/as del
--      que tuvieran inicialmente (ant_codEmplJefe) al nuevo/a (des_codEmplJefe)
--    NOTA: Es un proceso que ocurre si alguien asciende de categoría.

--		Parámetros de entrada: ant_codEmplJefe INT
--                             des_codEmplJefe INT

--		Parámetros de salida: numEmpleados INT (número de empleados que han actualizado su jefe)
--		Tabla: EMPLEADOS

--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--
--      Ayuda: Recuerda utilizar:
--              EXEC @ret = cambioJefes ...
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------
GO

CREATE OR ALTER PROCEDURE cambioJefes (@ant_codEmplJefe INT,
									  @des_codEmplJefe INT,
									  @numEmpleados INT OUTPUT)
AS
BEGIN
	BEGIN TRY
		--Comprobar código del jefe anterior
		IF ISNULL(@ant_codEmplJefe, 0) <= 0 OR NOT EXISTS (SELECT *
															 FROM EMPLEADOS
															WHERE codEmplJefe = @ant_codEmplJefe)
		BEGIN
		PRINT CONCAT('Codigo', @ant_codEmplJefe, ' código inválido')
		RETURN -1
		END
		--Comprobar código del feje nuevo
		IF ISNULL(@des_codEmplJefe, 0) <= 0 OR NOT EXISTS (SELECT *
															 FROM EMPLEADOS
															WHERE codEmpleado = @des_codEmplJefe)
		BEGIN
		PRINT 'No existe el empleado'
		RETURN -1
		END

		UPDATE EMPLEADOS
		   SET codEmplJefe = @des_codEmplJefe
		 WHERE codEmplJefe = @ant_codEmplJefe

		SET @numEmpleados = @@ROWCOUNT 

	END TRY
	BEGIN CATCH
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
					 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
					 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
					 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
					 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

GO

DECLARE @ant_codEmplJefe INT = 3,
		@des_codEmplJefe INT = 33,
		@numEmpleados INT,
		@ret int

--BEGIN TRAN
EXEC @ret = cambioJefes @ant_codEmplJefe, @des_codEmplJefe, @numEmpleados OUTPUT

IF @ret <> 0
BEGIN
	--ROLLBACK
	PRINT 'Fallo en la transacción'
END
ELSE
	PRINT CONCAT(@numEmpleados, ' empleados han cambiado de jefe')
--COMMIT

SELECT * FROM EMPLEADOS
GO
-------------------------------------------------------------------------------------------
-- 7. Implementa una función llamada getCostePedidos que reciba como parámetro un codCliente y devuelva
--		el coste de todos los pedidos realizados por dicho cliente.
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------
CREATE OR ALTER FUNCTION getCostPedidos(@codCliente INT)
RETURNS DECIMAL(11,2)
AS
BEGIN
	RETURN (SELECT ISNULL(SUM(dbo.costePedido(codPedido)), 0)
			  FROM PEDIDOS
			 WHERE codCliente = @codCliente)
END
GO

SELECT codCliente, dbo.getCostPedidos(codCliente)
  FROM CLIENTES
GO
-------------------------------------------------------------------------------------------
-- 8. Implementa una función llamada numEmpleadosOfic que reciba como parámetro un codOficina y devuelva
--		el número de empleados que trabajan en ella
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------
CREATE OR ALTER FUNCTION numEmpleadosOfic (@codOficina CHAR(6))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(codEmpleado)
			   FROM EMPLEADOS
			  WHERE codOficina = @codOficina)
END
GO

SELECT dbo.numEmpleadosOfic(codOficina)
  FROM OFICINAS

GO
-------------------------------------------------------------------------------------------
-- 9. Implementa una función llamada clientePagos_SN que reciba como parámetro un codCliente y devuelva
--		'S' si ha realizado pagos y 'N' si no ha realizado ningún pago.
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------
CREATE OR ALTER FUNCTION clientePagos_SN(@codCliente INT)
RETURNS CHAR(1)
AS
BEGIN
	RETURN (SELECT ISNULL(MAX('S'), 'N')
			  FROM PAGOS
			 WHERE codCliente = @codCliente)
END
GO

SELECT codCliente, dbo.clientePagos_SN(codCliente)
  FROM CLIENTES

GO
-------------------------------------------------------------------------------------------
-- 10. Implementa una función llamada pedidosPendientesAnyo que reciba como parámetros 'estado' y 'anyo'
--	    y devuelva una TABLA con los pedidos pendientes del año 2009 (estos datos deben ponerse directamente en la SELECT, NO son dinámicos)

--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------
CREATE OR ALTER FUNCTION pedidosPendientesAnyo(@estado CHAR(1), @anyo CHAR(4))
RETURNS TABLE
AS
	RETURN (SELECT * 
			  FROM PEDIDOS
			 WHERE codEstado = @estado
			   AND YEAR(fecha_pedido) = @anyo)
GO

SELECT *
  FROM dbo.pedidosPendientesAnyo('P', '2023')
GO
-------------------------------------------------------------------------------------------
-- 11. Implementa un procedimiento que reciba como parámetro de entrada "numPedidos",
--     recorra la tabla CLIENTES y para cada uno de ellos se compruebe que si el número
--     de pedidos que ha realizado supera ese parámetro de entrada, se aumente su límite de crédito
--     en un 5%.
--     Si se actualiza el limite de crédito del cliente, se deberá mostrar una línea informando
--     del nombre del cliente, del valor actual del limite de credito y del valor actualizado.
--
--     Deberás utilizar un parámetro de salida en el que almacenes el número de cambios que se ha realizado.
--     
--     Recuerda llamar al procedimiento y gestionar correctamente su finalización
-------------------------------------------------------------------------------------------
GO

CREATE OR ALTER FUNCTION contPedidos(@codCliente INT)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(codCliente)
			  FROM PEDIDOS
			 WHERE codCliente = @codCliente)
END
GO
/*
SELECT * FROM PEDIDOS WHERE codCliente = 4
SELECT dbo.contPedidos(4)
*/ SELECT * FROM CLIENTES /*4 -->12000, 5 -->600000*/
GO
CREATE OR ALTER PROCEDURE agregarLimCredito(@numPedidos INT, @numCambios INT OUTPUT)
AS
BEGIN
	IF @numPedidos < 0
		RETURN -1
	SET @numCambios = 0
	BEGIN TRY
		DECLARE Cur_Cliente CURSOR FOR
		SELECT codCliente, limite_credito
		  FROM CLIENTES
		  DECLARE @codCliente AS INT, @limiteCredito AS DECIMAL(18,2)
		  --BEGIN TRAN

		  --Cursor que recorre todos los clientes
		  OPEN Cur_Cliente
		  FETCH NEXT FROM Cur_Cliente INTO @codCliente, @limiteCredito
		  WHILE @@FETCH_STATUS = 0
		  BEGIN
			--Si el número de pedidos que ha realizado cada cliente
			IF dbo.contPedidos(@codCliente) > @numPedidos
			BEGIN
				DECLARE @limAct DECIMAL(18,2),
						@limAnt DECIMAL(18,2) = @limiteCredito
				
				--Actualizo
				UPDATE CLIENTES
				   SET limite_credito = limite_credito * 1.05
				WHERE codCliente = @codCliente

				--Guardo el límite de crédito actualizado
				SET @limAct = (SELECT limite_credito
							     FROM CLIENTES
								WHERE codCliente = @codCliente)

				SET @numCambios += 1;

				PRINT CONCAT('El cliente ', @codCliente, ' antes tenia ', @limAnt, ' de límite de crédito y ahora ', @limAct)
			END
		  FETCH NEXT FROM Cur_Cliente INTO @codCliente, @limiteCredito
		  END
		  --COMMIT
		  CLOSE Cur_Cliente
		  DEALLOCATE Cur_Cliente
	END TRY
	BEGIN CATCH
		--ROLLBACK
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
					 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
					 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
					 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
					 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

ALTER TABLE CLIENTES
ALTER COLUMN limite_credito NUMERIC(18, 2);

GO
DECLARE @ret INT,
		@numCambios INT,
		@numPedidos INT = 4

EXEC @ret = agregarLimCredito @numPedidos, @numCambios OUTPUT
IF @ret <> 0
	BEGIN
	PRINT 'Algo fallo'
	RETURN
	END
PRINT CONCAT('Se han realizado ',@numCambios,' cambios') 


-------------------------------------------------------------------------------------------
-- 12. Implementa un procedimiento almacenado que reciba como parámetro un código de pedido
--     y para ese pedido se recorrerán sus detalles y se irán cambiando de modo inverso.
--     
--     Es decir, si el pedido tiene 5 líneas, la línea 1 será la 5, la línea 4 la 2 y así sucesivamente.
--     (el cambio afectará solo al campo numeroLinea)
--
--     Deberás utilizar un parámetro de salida en el que almacenes el número de cambios que se ha realizado
--
--     Recuerda llamar al procedimiento y gestionar correctamente su finalización
-------------------------------------------------------------------------------------------
GO
CREATE OR ALTER PROCEDURE swapLineas(@codPedido INT)
AS
BEGIN
	BEGIN TRY
		IF @codPedido <= 0 OR NOT EXISTS(SELECT *
		                                   FROM PEDIDOS
										  WHERE codPedido = @codPedido)
		BEGIN
			PRINT 'No existe el pedido'
			RETURN -1
		END
		DECLARE @codPedido INT = 4
		DECLARE @cont INT = (SELECT COUNT(numeroLinea)
						   	   FROM DETALLE_PEDIDOS
					     	  WHERE codPedido = @codPedido)

		WHILE @cont >= 0
		BEGIN
		SELECT numeroLinea
		 FROM DETALLE_PEDIDOS
		WHERE codPedido = @codPedido
	    ORDER BY numeroLinea ASC
	   OFFSET  @cont ROWS 
	    FETCH NEXT 1 ROWS ONLY
		print @cont
		SET @cont -=1
		END
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Fecha/hora: ', GETDATE(), CHAR(10),
					 'ERROR_NUM: ', ERROR_NUMBER(),CHAR(10),
					 'ERROR_MESSAGE: ', ERROR_MESSAGE(),CHAR(10),
					 'ERROR_LINE: ', ERROR_LINE(), CHAR(10),
					 'ERROR_PROCEDURE: ', ERROR_PROCEDURE())
	END CATCH
END

/*

DECLARE Cur_Producto CURSOR FOR
SELECT nombre
 FROM PRODUCTO;

DECLARE @nomProducto AS VARCHAR(100);

OPEN Cur_Producto;
FETCH NEXT FROM Cur_Producto INTO @nomProducto;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @nomProducto
	FETCH NEXT FROM Cur_Producto INTO @nomProducto;
END

CLOSE Cur_Producto;
DEALLOCATE Cur_Producto;
*/



