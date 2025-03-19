USE TIENDA------------------------------------EJERCICO 1--------------------------------------
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
DEALLOCATE Cur_Producto;------------------------------------EJERCICO 2--------------------------------------

DECLARE Cur_ProductoPrecio CURSOR FOR
SELECT nombre, precio
 FROM PRODUCTO;


DECLARE @nomProducto VARCHAR(100),
		@precio DECIMAL(9,2)

OPEN Cur_ProductoPrecio;
FETCH NEXT FROM Cur_ProductoPrecio INTO @nomProducto, @precio;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CONCAT('El producto ', @nomProducto, ' tiene un precio de ', @precio,'€')
	FETCH NEXT FROM Cur_ProductoPrecio INTO @nomProducto, @precio;
END

CLOSE Cur_ProductoPrecio;
DEALLOCATE Cur_ProductoPrecio;---------------------------------------------CON OFFSETDECLARE @contador INT = 0,		@nomProducto VARCHAR(100),		@precio DECIMAL(9,2),		@numElementos INT = (SELECT COUNT(*)						   FROM PRODUCTO)		WHILE  @contador < @numElementos
BEGIN
	SELECT @nomProducto = nombre,
		   @precio = precio
	  FROM PRODUCTO
	 ORDER BY codigo ASC
	 OFFSET @contador ROWS 
	 FETCH NEXT 1 ROWS ONLY

	 PRINT CONCAT('El producto ', @nomProducto, ' tiene un precio de ', @precio,'€')
	 SET @contador += 1
END------------------------------------EJERCICO 3--------------------------------------

EXEC sp_columns FABRICANTE
DECLARE @nomFabricante VARCHAR(100),  @codFabricante INT

DECLARE Cur_Fabricante CURSOR FOR
SELECT nombre, codigo
 FROM FABRICANTE;

OPEN Cur_Fabricante;

FETCH NEXT FROM Cur_Fabricante INTO @nomFabricante, @codFabricante;

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE Cur_Productos CURSOR FOR
	SELECT precio
	 FROM PRODUCTO
	WHERE codigo_fabricante = @codFabricante;

	DECLARE @total DECIMAL(15,2), @acumulado DECIMAL(15,2)
	SET @acumulado = 0;
	
	OPEN Cur_Productos;
	FETCH NEXT FROM Cur_Productos INTO @total;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @acumulado = @acumulado + @total;
		FETCH NEXT FROM Cur_Productos INTO @total;
	END
	CLOSE Cur_Productos;
	DEALLOCATE Cur_Productos;
	PRINT CONCAT('El fabricante: ', @nomFabricante, ' tiene un total de ', @acumulado, ' € en productos');
	FETCH NEXT FROM Cur_Fabricante INTO @nomFabricante, @codFabricante;
END
CLOSE Cur_Fabricante;
DEALLOCATE Cur_FabricanteEXEC sp_columns EMPLEADOSUSE JARDINERIA------------------------------------EJERCICO 4--------------------------------------
DECLARE Cur_Empleados CURSOR FOR
SELECT nombre, apellido1, apellido2, email
 FROM EMPLEADOS;

DECLARE @nombre VARCHAR(100),
		@apellido1 VARCHAR(50),
		@apellido2 VARCHAR(50),
		@email VARCHAR(100)

OPEN Cur_Empleados;
FETCH NEXT FROM Cur_Empleados INTO @nombre, @apellido1, @apellido2, @email;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CONCAT('Empleado ', @nombre, ' ' ,@apellido1, ' ', @apellido2, ' con email: ', @email)
	FETCH NEXT FROM Cur_Empleados INTO @nombre, @apellido1, @apellido2, @email;
END

CLOSE Cur_Empleados;
DEALLOCATE Cur_Empleados;

----------------------------------
--CON OFFSET
DECLARE @nombre VARCHAR(100),
		@apellido1 VARCHAR(50),
		@apellido2 VARCHAR(50),
		@email VARCHAR(100),		@contador INT = 0,		@numEmpleados INT = (SELECT COUNT(*)						       FROM EMPLEADOS)		WHILE  @contador < @numEmpleados
BEGIN
	SELECT @nombre = nombre,
		   @apellido1 = apellido1,
		   @apellido2 = apellido2,
		   @email = email
	  FROM EMPLEADOS
	 ORDER BY codEmpleado ASC
	 OFFSET @contador ROWS 
	 FETCH NEXT 1 ROWS ONLY

	 PRINT CONCAT('Empleado ', @nombre, ' ' ,@apellido1, ' ', @apellido2, ' con email: ', @email)
	 SET @contador += 1
END

------------------------------------EJERCICO 5--------------------------------------

DECLARE @codPedido INT

DECLARE Cur_Pedidos CURSOR FOR
SELECT codPedido
 FROM PEDIDOS

OPEN Cur_Pedidos;
FETCH NEXT FROM Cur_Pedidos INTO @codPedido;
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE Cur_Detalle CURSOR FOR 
	SELECT precio_unidad, cantidad
	 FROM DETALLE_PEDIDOS
	WHERE codPedido = @codPedido;

	DECLARE @precio DECIMAL(15,2),
			@cantidad INT,
			@acumulador DECIMAL(15,2)

	SET @acumulador = 0;

	OPEN Cur_Detalle;
	FETCH NEXT FROM Cur_Detalle INTO  @precio, @cantidad;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @acumulador = @precio * @cantidad;
		FETCH NEXT FROM Cur_Detalle INTO   @precio, @cantidad;
	END
	CLOSE Cur_Detalle;
	DEALLOCATE Cur_Detalle;

	PRINT CONCAT('Nº Pedido ', @codPedido, ' tiene in coste total de ', @acumulador);

	FETCH NEXT FROM Cur_Pedidos INTO @codPedido;
END

CLOSE Cur_Pedidos;
DEALLOCATE Cur_Pedidos

