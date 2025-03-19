USE JARDINERIA

---------------------------
-- Actividad. Jardinería --
---------------------------

-- 1. Inserta una nueva oficina en Alicante.
INSERT INTO OFICINAS (codOficina, ciudad, pais,
                      codPostal, telefono, linea_direccion1)
VALUES ('ALC-ES', 'Alicante', 'España',
        '03013', '+34 645 70696', 'calle Italia, 14')

-- 2. Inserta un nuevo empleado para la oficina de Alicante que sea representante de ventas.
DECLARE @cod INT
SET @cod = (SELECT MAX(codEmpleado)
              FROM EMPLEADOS)
INSERT INTO EMPLEADOS (codEmpleado, nombre, apellido1,
                      apellido2, tlf_extension_ofi, email,
                      puesto_cargo, salario, codOficina,
                      codEmplJefe)
VALUES (@cod + 1, 'Keyra', 'Ruiz',
        'Zerda', '1234', 'keyra@gmail.com',
        'Representante Ventas', '1450', 'ALC-ES',
        7)


--3. Inserta un cliente que tenga como representante de ventas el empleado que creamos en el paso anterior.
DECLARE @codCliente INT
SET @codCliente = (SELECT MAX(codEmpleado)
              FROM EMPLEADOS)
INSERT INTO CLIENTES (codCliente, nombre_cliente, nombre_contacto,
                      apellido_contacto, telefono, email,
                      linea_direccion1, linea_direccion2, ciudad,
                      pais, codPostal, codEmpl_ventas, 
                      limite_credito)
VALUES (39, 'Melanie Rojas', 'Melanie',
       'Rojas', 34645986703, 'melanie_rojas@garden.com',
       'C/ Felipe Herrero nº31', null, 'Alicante',
       'Spain', '03013', 8,
       100002.50)

-- 4. Inserta un pedido que contenga al menos tres productos para el cliente que acabamos de crear.
DECLARE @codPedido INT
SET @codPedido = (SELECT MAX(codPedido)
              FROM PEDIDOS)
INSERT INTO PEDIDOS (codPedido, fecha_pedido, fecha_esperada,
                     fecha_entrega, codEstado, comentarios,
                     codCliente)
VALUES (129 , '2024-04-17', '2024-04-30', '2024-04-27', 'E', 'El producto llego 3 dias antes de lo esperado',
        39)
INSERT INTO DETALLE_PEDIDOS (codPedido, codProducto, cantidad,
                             precio_unidad, numeroLinea)
VALUES (129, 77, 3,
         11.0, 1),
        (129, 97, 5,
         49, 2),
        (129, 1, 10,
         14.0, 3)

--5. Actualiza y/o borra el código del cliente que creamos en el paso anterior. ¿Ha sido posible
--actualizarlo o borrarlo? ¿Por qué? Averigua si hubo cambios en las tablas relacionadas.
UPDATE CLIENTES
SET codCliente = 40
WHERE codCliente = 39
/*No se pudo actualizar ya que es una FK en LA TABLA PEDIDOS*/

--6. Actualiza la cantidad de unidades solicitadas en el pedido que has creado del siguiente modo:
-- para el 1er producto serán 3 unidades, para el producto 2 serán 2 unidades y el tercero 1 unidad.
UPDATE DETALLE_PEDIDOS
SET cantidad = 3
WHERE codPedido = 129
  AND numeroLinea = 1

UPDATE DETALLE_PEDIDOS
SET cantidad = 2
WHERE codPedido = 129
  AND numeroLinea = 2

UPDATE DETALLE_PEDIDOS
SET cantidad = 1
WHERE codPedido = 129
  AND numeroLinea = 3

--7. Modifica la fecha del pedido que hemos creado a la fecha y hora actuales.
UPDATE PEDIDOS
SET fecha_pedido = GETDATE()
WHERE codPedido = 129

--8. Incrementa en un 5% el precio de los productos que están incluidos en el pedido que has creado (solo en ese pedido).
-- Si una vez realizada la operación vieras que aparecen ceros no significativos en los decimales, podrías utilizar la función CAST (XXX as FLOAT).
UPDATE DETALLE_PEDIDOS
SET precio_unidad = precio_unidad * 1.05
WHERE codPedido = 129

--9. Vuelve a dejar el precio de dichos productos como estaba anteriormente.
UPDATE DETALLE_PEDIDOS
SET precio_unidad = precio_unidad / 1.05
WHERE codPedido =129


--10. ¿Cuál sería la secuencia de borrado de registros de tablas hasta que finalmente se pueda borrar la oficina de Alicante que creamos en el apartado 1?
--    Una vez tengas el script, comprueba que se puede eliminar.
DELETE FROM DETALLE_PEDIDOS
WHERE codPedido = 129

DELETE FROM PEDIDOS
WHERE codPedido = 129

DELETE FROM CLIENTES
WHERE codCliente = 39

DELETE FROM EMPLEADOS
WHERE codEmpleado = 32

DELETE FROM OFICINAS
WHERE codOficina = 'ALC-ES'


--11. Incrementa en un 20% el precio de los productos que NO estén incluidos en ningún pedido.
-- Si una vez realizada la operación vieras que aparecen ceros no significativos en los decimales, podrías utilizar la función CAST (XXX as FLOAT).
UPDATE PRODUCTOS
SET precio_venta = precio_venta * 1.20
WHERE codProducto NOT IN (SELECT DISTINCT codProducto
						   FROM DETALLE_PEDIDOS) /*148*/
						 

/*SELECT MAX(codProducto)
 from PRODUCTOS 276*/

--12. Vuelve a dejar el precio de los productos como estaba anteriormente.
UPDATE PRODUCTOS
SET precio_venta = precio_venta / 1.20
WHERE codProducto NOT IN (SELECT DISTINCT codProducto
						   FROM DETALLE_PEDIDOS)


--13. Elimina los clientes que no hayan realizado ningún pago.
DELETE CLIENTES
WHERE codCliente NOT IN (SELECT DISTINCT codCliente
							FROM PAGOS) --19
							/*SELECT DISTINCT c.codCliente
							FROM CLIENTES c, PAGOS p
							WHERE c.codCliente = p.codCliente*/


--14. Elimina los clientes que no hayan realizado un mínimo de 2 pedidos (NOTA: al ejecutar la sentencia fallará por la integridad referencial, es decir, porque hay tablas que tiene relacionado el idCliente como FK).
DELETE CLIENTES
WHERE codCliente NOT IN (SELECT codCliente, COUNT(codCliente)
						   FROM PAGOS
						  GROUP BY codCliente
						 HAVING COUNT(codCliente) >= 2)


--15. Borra los pagos del cliente con menor límite de crédito.
DELETE PAGOS
WHERE  codCliente = (SELECT codCliente
					   FROM CLIENTES
					  WHERE limite_credito = (SELECT MIN(limite_credito)
												FROM CLIENTES)

--16. Actualiza la ciudad a Alicante para aquellos clientes que tengan un límite de crédito inferior a TODOS los precios de los productos de la categoría Ornamentales (puede que no haya ninguno).
UPDATE CLIENTES
SET ciudad = 'Alicante'
WHERE limite_credito < (SELECT MIN(precio_venta)
						  FROM PRODUCTOS
						 WHERE codCategoria = 'OR')


--17. Actualiza la ciudad a Madrid para aquellos clientes que tengan un límite de crédito mensual inferior a ALGUNO de los precios de los productos de la categoría Ornamentales.
UPDATE CLIENTES
SET ciudad = 'Madrid'
WHERE limite_credito < (SELECT MAX(precio_venta)
						  FROM PRODUCTOS
						 WHERE codCategoria = 'OR')


--18. Establece a 0 el límite de crédito del cliente que menos unidades pedidas del producto con referencia interna OR-179.
UPDATE CLIENTES
SET limite_credito = 0
	WHERE codCliente = (SELECT TOP(1) p.codCliente
						  FROM PEDIDOS p, DETALLE_PEDIDOS dp, PRODUCTOS pr
						 WHERE p.codPedido = dp.codPedido
						   AND dp.codProducto = pr.codProducto
						   AND pr.refInterna = 'OR-179'
						 GROUP BY p.codCliente)

--19. Modifica la tabla DETALLE_PEDIDOS para insertar un campo numérico llamado IVA. Establece el
--valor de ese campo a 1.18 para aquellos registros cuyo pedido tenga fecha de pedido a partir de Enero de 2022
-- A continuación, actualiza el resto de pedidos estableciendo el IVA al 1.21
ALTER TABLE DETALLE_PEDIDOS
ADD IVA NUMERIC(3,2)

UPDATE DETALLE_PEDIDOS
SET IVA = 1.18
WHERE codPedido IN (SELECT codPedido
					  FROM PEDIDOS
					 WHERE fecha_pedido >= '01-01-2022')

UPDATE DETALLE_PEDIDOS
SET IVA = 1.21
WHERE codPedido NOT IN (SELECT codPedido
					      FROM PEDIDOS
					     WHERE fecha_pedido >= '01-01-2022')


-- Extra: Pon una restricción que solo permita actualizar el valor de la columna IVA a 1.04, 1.10, 1.18 o 1.21
ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT CK_IVA CHECK (IVA IN (1.04, 1.10, 1.18, 1.21))



--20. Modifica la tabla DETALLE_PEDIDOS para incorporar un campo numérico llamado total_linea y
--actualiza todos sus registros para calcular su valor con la fórmula:
--total_linea = precio_unidad * cantidad * IVA
ALTER TABLE DETALLE_PEDIDOS
ADD  total_linea AS (precio_unidad * cantidad * IVA) 

--21. Crea una tabla llamada HISTORICO_CLIENTES que tenga la misma estructura que CLIENTES y además un campo llamado fechaAlta de tipo DATE.
--Deberás insertar en una única sentencia los clientes cuyo nombre contenga la letra ‘s’ e informar el campo fechaAlta como la fecha/hora del momento en el que se inserta.

CREATE TABLE HISTORICO_CLIENTES (
  codCliente 		INT,
  nombre_cliente 	VARCHAR(50) NOT NULL,
  nombre_contacto 	VARCHAR(50) NOT NULL,
  apellido_contacto VARCHAR(50),
  telefono 			VARCHAR(15) NOT NULL,
  email				VARCHAR(100),
  linea_direccion1 	VARCHAR(100) NOT NULL,
  linea_direccion2 	VARCHAR(100),
  ciudad 			VARCHAR(50) NOT NULL,
  pais 				VARCHAR(50),
  codPostal 		CHAR(5),
  codEmpl_ventas	INT,
  limite_credito	DECIMAL(9,2),
  fechaAlta			DATE
  CONSTRAINT PK_CLIENTES_HISTORICO PRIMARY KEY (codCliente),
  CONSTRAINT FK_CLIENTES_EMPLEADOS_HISTORICO FOREIGN KEY (codEmpl_ventas) 
  REFERENCES EMPLEADOS (codEmpleado)
);

INSERT INTO HISTORICO_CLIENTES
SELECT *, GETDATE()
 FROM CLIENTES
 WHERE nombre_cliente LIKE '%s%'

--22. Actualiza a NULL los campos region, pais y codigo_postal en la tabla CLIENTES para todos los registros. Utiliza una sentencia de actualización en la que se actualicen estos 3 campos a partir de los datos existentes en la tabla HISTORICO_CLIENTES. Comprueba que los datos se han trasladado correctamente.

ALTER TABLE CLIENTES
ALTER COLUMN ciudad VARCHAR(50) NULL

UPDATE CLIENTES 
SET ciudad = NULL,
	pais = NULL,
	codPostal = NULL

UPDATE c
SET c.ciudad = hc.ciudad,
	c.pais = hc.pais,
	c.codPostal = hc.codPostal
FROM CLIENTES c INNER JOIN HISTORICO_CLIENTES hc
  ON  c.codCliente = hc.codCliente
