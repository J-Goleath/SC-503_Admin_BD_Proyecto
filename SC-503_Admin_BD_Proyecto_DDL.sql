ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE TABLESPACE TBS_VETERINARIA1
DATAFILE 'TBS_VETERINARIA1.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 10M
MAXSIZE 500M
LOGGING;

CREATE TABLE Direccion(
    IDtabla_Direccion VARCHAR2(3) DEFAULT 'ZIP' NOT NULL,
    ID_Direccion NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Provincia VARCHAR2(100) NOT NULL,
    Canton VARCHAR2(100) NOT NULL,
    Distrito VARCHAR2(100) NOT NULL,
    Barrio VARCHAR2(100) NOT NULL,
    Direccion VARCHAR2(100) NOT NULL,
    PRIMARY KEY (IDtabla_Direccion, ID_Direccion)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Cliente(
    IDtabla_Cliente VARCHAR2(3) DEFAULT 'CLI' NOT NULL,
    ID_Cliente NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL,
    Apellido VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) NOT NULL,
    Telefono VARCHAR2(15) NOT NULL,
    Fk_Direccion NUMBER NOT NULL,
    PRIMARY KEY (IDtabla_Cliente, ID_Cliente)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Veterinario(
    IDtabla_Veterinario VARCHAR2(3) DEFAULT 'VET' NOT NULL,
    ID_Veterinario NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL,
    Apellido VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) NOT NULL,
    Telefono VARCHAR2(15) NOT NULL,
    Fk_Direccion NUMBER NOT NULL,
    PRIMARY KEY (IDtabla_Veterinario, ID_Veterinario)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Animal(
    IDtabla_Animal VARCHAR2(3) DEFAULT 'ANN' NOT NULL,
    ID_Animal NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Edad NUMBER NOT NULL,
    Peso NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Animal, ID_Animal)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Mascota(
    IDtabla_Mascota VARCHAR2(3) DEFAULT 'PET' NOT NULL,
    ID_Mascota NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Cliente NUMBER NOT NULL,
    Fk_Animal NUMBER NOT NULL,
    Edad NUMBER NOT NULL,
    Peso NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Mascota, ID_Mascota)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Canino(
    IDtabla_Canino VARCHAR2(3) DEFAULT 'CAN' NOT NULL,
    ID_Canino NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Raza VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Canino, ID_Canino)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Felino(
    IDtabla_Felino VARCHAR2(3) DEFAULT 'CAT' NOT NULL,
    ID_Felino NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Raza VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Felino, ID_Felino)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Granja(
    IDtabla_Granja VARCHAR2(3) DEFAULT 'GRA' NOT NULL,
    ID_Granja NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Especie VARCHAR2(100) NOT NULL,
    Raza VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Granja, ID_Granja)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Roedor(
    IDtabla_Roedor VARCHAR2(3) DEFAULT 'ROR' NOT NULL,
    ID_Roedor NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Especie VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Roedor, ID_Roedor)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Ave(
    IDtabla_Ave VARCHAR2(3) DEFAULT 'AVE' NOT NULL,
    ID_Ave NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Especie VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Ave, ID_Ave)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Pez(
    IDtabla_Pez VARCHAR2(3) DEFAULT 'PEZ' NOT NULL,
    ID_Pez NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Especie VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Temperatura NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Pez, ID_Pez)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Reptil(
    IDtabla_Reptil VARCHAR2(3) DEFAULT 'REP' NOT NULL,
    ID_Reptil NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Especie VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Temperatura NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Reptil, ID_Reptil)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Otros(
    IDtabla_Otro VARCHAR2(3) DEFAULT 'OTR' NOT NULL,
    ID_OtroINT NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Especie VARCHAR2(100) NOT NULL,
    Alimento VARCHAR2(100) NOT NULL,
    Medida_Alimento NUMBER NOT NULL,
    Notas VARCHAR2(200) NOT NULL,
    PRIMARY KEY (IDtabla_Otro, ID_OtroINT)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Historial(
    IDtabla_Historial VARCHAR2(3) DEFAULT 'HIS' NOT NULL,
    ID_Historial NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Mascota NUMBER NOT NULL,
    Fk_Veterinario NUMBER NOT NULL,
    Fk_Proceso NUMBER NOT NULL,
    Descripcion VARCHAR2(100) NOT NULL,
    Fecha DATE NOT NULL,
    PRIMARY KEY (IDtabla_Historial, ID_Historial)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Servicio(
    IDtabla_Servicio VARCHAR2(3) DEFAULT 'SER' NOT NULL,
    ID_Servicio NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL,
    Descripcion VARCHAR2(100) NOT NULL,
    Precio NUMBER NOT NULL,
    PRIMARY KEY (IDtabla_Servicio, ID_Servicio)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Cita(
    IDtabla_Cita VARCHAR2(3) DEFAULT 'CIT' NOT NULL,
    ID_Cita NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Mascota NUMBER NOT NULL,
    Fk_Veterinario NUMBER NOT NULL,
    Fk_Servicio NUMBER NOT NULL,
    Fecha_Cita DATE NOT NULL,
    Hora VARCHAR2(5) NOT NULL, -- Almacenado como 'HH:MI'
    PRIMARY KEY (IDtabla_Cita, ID_Cita)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Procedimiento(
    IDtabla_Procedimiento VARCHAR2(3) DEFAULT 'PCD' NOT NULL,
    ID_Procedimiento NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL,
    Descripcion VARCHAR2(100) NOT NULL,
    Internado NUMBER(1) NOT NULL, -- 0 o 1 en lugar de BIT
    PRIMARY KEY (IDtabla_Procedimiento, ID_Procedimiento)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Consulta(
    IDtabla_Consulta VARCHAR2(3) DEFAULT 'CON' NOT NULL,
    ID_Consulta NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Mascota NUMBER NOT NULL,
    Fk_Veterinario NUMBER NOT NULL,
    Fk_Procedimiento NUMBER NOT NULL,
    Dias_Internado NUMBER NOT NULL,
    Precio NUMBER NOT NULL,
    Fecha_Cita DATE NOT NULL,
    Hora VARCHAR2(5) NOT NULL, -- Almacenado como 'HH:MI'
    PRIMARY KEY (IDtabla_Consulta, ID_Consulta)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Producto(
    IDtabla_Producto VARCHAR2(3) DEFAULT 'PRO' NOT NULL,
    ID_Producto NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre_Producto VARCHAR2(100) NOT NULL,
    Descripcion VARCHAR2(100) NOT NULL,
    Fk_Stock NUMBER NOT NULL,
    PRIMARY KEY (IDtabla_Producto, ID_Producto)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Inventario(
    IDtabla_Stock VARCHAR2(3) DEFAULT 'INV' NOT NULL,
    ID_Stock NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    InStock NUMBER(1) NOT NULL, -- 0 o 1 en lugar de BIT
    Precio_U NUMBER NOT NULL,
    Cantidad NUMBER NOT NULL,
    PRIMARY KEY (IDtabla_Stock, ID_Stock)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Factura(
    IDtabla_Factura VARCHAR2(3) DEFAULT 'FFF' NOT NULL,
    ID_Factura NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Cliente NUMBER NOT NULL,
    Total NUMBER NOT NULL,
    Fecha_Factura DATE NOT NULL,
    PRIMARY KEY (IDtabla_Factura, ID_Factura)
) TABLESPACE TBS_VETERINARIA1;

CREATE TABLE Detalle_Factura(
    IDtabla_DetalleFactura VARCHAR2(3) DEFAULT 'DFF' NOT NULL,
    ID_DetalleFactura NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Factura NUMBER NOT NULL,
    Fk_Producto NUMBER NOT NULL,
    PrecioT NUMBER NOT NULL,
    Cantidad NUMBER NOT NULL,
    Precio_U NUMBER NOT NULL,
    PRIMARY KEY (IDtabla_DetalleFactura, ID_DetalleFactura)
) TABLESPACE TBS_VETERINARIA1;

SELECT * FROM dba_tablespaces
WHERE tablespace_name = 'TBS_VETERINARIA1'



-- ***********************************************************************************
-- Procedimientos Almacenados (PL/SQL)
-- Se usa CREATE OR REPLACE PROCEDURE y los parámetros son (p_nombre IN TIPO, ...)
-- ***********************************************************************************

-- Insertar un nuevo cliente en la tabla Cliente
CREATE OR REPLACE PROCEDURE InsertarCliente (
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Telefono IN VARCHAR2,
    p_Fk_Direccion IN NUMBER
)
AS
BEGIN
    INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion)
    VALUES (p_Nombre, p_Apellido, p_Email, p_Telefono, p_Fk_Direccion);
    COMMIT;
END;
/

-- Actualizar un cliente en la tabla Cliente
CREATE OR REPLACE PROCEDURE ActualizarCliente (
    p_ID_Cliente IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Telefono IN VARCHAR2,
    p_Fk_Direccion IN NUMBER
)
AS
BEGIN
    UPDATE Cliente
    SET Nombre = p_Nombre,
        Apellido = p_Apellido,
        Email = p_Email,
        Telefono = p_Telefono,
        Fk_Direccion = p_Fk_Direccion
    WHERE ID_Cliente = p_ID_Cliente;
    COMMIT;
END;
/

-- Eliminar un cliente en la tabla Cliente
CREATE OR REPLACE PROCEDURE EliminarCliente (
    p_ID_Cliente IN NUMBER
)
AS
BEGIN
    DELETE FROM Cliente WHERE ID_Cliente = p_ID_Cliente;
    COMMIT;
END;
/

-- Obtener informacion de un cliente en la tabla Cliente
-- En Oracle, los procedimientos que sólo devuelven datos usan un parámetro OUT de tipo REF CURSOR.
CREATE OR REPLACE PROCEDURE ObtenerCliente (
    p_ID_Cliente IN NUMBER,
    p_Resultado OUT SYS_REFCURSOR -- Tipo especial para devolver conjuntos de resultados
)
AS
BEGIN
    OPEN p_Resultado FOR
    SELECT * FROM Cliente WHERE ID_Cliente = p_ID_Cliente;
END;
/

-- Insertar una nueva mascota en la tabla Mascota
CREATE OR REPLACE PROCEDURE InsertarMascota (
    p_Fk_Cliente IN NUMBER,
    p_Fk_Animal IN NUMBER,
    p_Edad IN NUMBER,
    p_Peso IN NUMBER,
    p_Notas IN VARCHAR2
)
AS
BEGIN
    INSERT INTO Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas)
    VALUES (p_Fk_Cliente, p_Fk_Animal, p_Edad, p_Peso, p_Notas);
    COMMIT;
END;
/

-- Insertar una nueva cita en la tabla Cita
CREATE OR REPLACE PROCEDURE InsertarCita (
    p_Fk_Mascota IN NUMBER,
    p_Fk_Veterinario IN NUMBER,
    p_Fk_Servicio IN NUMBER,
    p_Fecha_Cita IN DATE,
    p_Hora IN VARCHAR2 -- En lugar de TIME
)
AS
BEGIN
    INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora)
    VALUES (p_Fk_Mascota, p_Fk_Veterinario, p_Fk_Servicio, p_Fecha_Cita, p_Hora);
    COMMIT;
END;
/

-- Listar historial medico
CREATE OR REPLACE PROCEDURE ListarHistorialMascota (
    p_IdMascota IN NUMBER,
    p_Resultado OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Resultado FOR
    SELECT * FROM Historial
    WHERE Fk_Mascota = p_IdMascota;
END;
/

-- Listar historial de citas
CREATE OR REPLACE PROCEDURE ListarHistorialCitas (
    p_IdMascota IN NUMBER,
    p_Resultado OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Resultado FOR
    SELECT * FROM Cita
    WHERE Fk_Mascota = p_IdMascota;
END;
/

-- ***********************************************************************************
-- Funciones (PL/SQL)
-- Se usa CREATE OR REPLACE FUNCTION y la sintaxis SELECT INTO para asignar valores
-- ***********************************************************************************

-- Calcular el precio de un servicio específico
CREATE OR REPLACE FUNCTION CalcularPrecioServicio (
    p_ID_Servicio IN NUMBER
)
RETURN NUMBER -- FLOAT en SQL Server es NUMBER en Oracle
AS
    v_Precio NUMBER;
BEGIN
    SELECT Precio
    INTO v_Precio
    FROM Servicio
    WHERE ID_Servicio = p_ID_Servicio;

    RETURN v_Precio;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- Retornar NULL si no se encuentra el servicio
END;
/

-- Obtener nombre de cliente usando ID
CREATE OR REPLACE FUNCTION ObtenerNombreCliente (
    p_ID_Cliente IN NUMBER
)
RETURN VARCHAR2 -- VARCHAR(201) en SQL Server es VARCHAR2 en Oracle
AS
    v_NombreCompleto VARCHAR2(201);
BEGIN
    SELECT Nombre || ' ' || Apellido -- Usamos || para concatenar en Oracle
    INTO v_NombreCompleto
    FROM Cliente
    WHERE ID_Cliente = p_ID_Cliente;

    RETURN v_NombreCompleto;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

-- Obtener cantidad de un producto del inventario
CREATE OR REPLACE FUNCTION ObtenerCantidadProducto (
    p_ID_Producto IN NUMBER
)
RETURN NUMBER -- INT en SQL Server es NUMBER en Oracle
AS
    v_Cantidad NUMBER;
BEGIN
    SELECT i.Cantidad
    INTO v_Cantidad
    FROM Producto p
    INNER JOIN Inventario i ON p.Fk_Stock = i.ID_Stock
    WHERE p.ID_Producto = p_ID_Producto;

    RETURN v_Cantidad;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Asumimos 0 si no se encuentra
END;
/

-- Calcular el total de una factura
CREATE OR REPLACE FUNCTION CalcularTotalFactura (
    p_ID_Factura IN NUMBER
)
RETURN NUMBER -- FLOAT en SQL Server es NUMBER en Oracle
AS
    v_Total NUMBER;
BEGIN
    SELECT SUM(df.Precio_U * df.Cantidad)
    INTO v_Total
    FROM Factura f
    INNER JOIN Detalle_Factura df ON f.ID_Factura = df.Fk_Factura
    WHERE f.ID_Factura = p_ID_Factura;

    RETURN v_Total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- ***********************************************************************************
-- Vistas
-- La sintaxis es muy similar
-- ***********************************************************************************

-- Mostrar clientes con sus mascotas
CREATE OR REPLACE VIEW MascotasClientes
AS
SELECT
    m.ID_Mascota,
    c.Nombre AS NombreCliente,
    c.Apellido AS ApellidoCliente,
    m.Edad AS EdadMascota,
    m.Peso AS PesoMascota,
    m.Notas AS NotasMascota
FROM Mascota m
INNER JOIN Cliente c ON m.Fk_Cliente = c.ID_Cliente;
/

-- Mostrar citas agendadas con informacion de veterinario y servicio
CREATE OR REPLACE VIEW CitasVeterinarios
AS
SELECT
    ci.ID_Cita,
    m.ID_Mascota,
    c.Nombre AS NombreCliente,
    c.Apellido AS ApellidoCliente,
    v.Nombre AS NombreVeterinario,
    v.Apellido AS ApellidoVeterinario,
    s.Nombre AS NombreServicio,
    ci.Fecha_Cita,
    ci.Hora
FROM Cita ci
INNER JOIN Mascota m ON ci.Fk_Mascota = m.ID_Mascota
INNER JOIN Veterinario v ON ci.Fk_Veterinario = v.ID_Veterinario
INNER JOIN Servicio s ON ci.Fk_Servicio = s.ID_Servicio
INNER JOIN Cliente c ON m.Fk_Cliente = c.ID_Cliente;
/

-- Mostrar productos del inventario, cuanto queda de stock y su precio
CREATE OR REPLACE VIEW ProductosInventario
AS
SELECT
    p.ID_Producto,
    p.Nombre_Producto,
    p.Descripcion,
    i.Cantidad AS CantidadEnStock,
    i.Precio_U AS PrecioUnitario
FROM Producto p
INNER JOIN Inventario i ON p.Fk_Stock = i.ID_Stock;
/

-- Mostrar informacion detallada de facturas
CREATE OR REPLACE VIEW FacturasDetalles
AS
SELECT
    f.ID_Factura,
    c.Nombre AS NombreCliente,
    c.Apellido AS ApellidoCliente,
    f.Fecha_Factura,
    df.Cantidad AS CantidadProducto,
    p.Nombre_Producto,
    f.Total AS TotalFactura
FROM Factura f
INNER JOIN Cliente c ON f.Fk_Cliente = c.ID_Cliente
INNER JOIN Detalle_Factura df ON f.ID_Factura = df.Fk_Factura
INNER JOIN Producto p ON df.Fk_Producto = p.ID_Producto;
/

-- ***********************************************************************************
-- Triggers (PL/SQL)
-- Se usan :OLD y :NEW en lugar de las tablas inserted/deleted.
-- RAISE_APPLICATION_ERROR en lugar de RAISERROR.
-- ***********************************************************************************

-- Evita que se elimine un cliente que tenga mascotas asociadas
CREATE OR REPLACE TRIGGER EvitarEliminarCliente
BEFORE DELETE ON Cliente
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Comprobar si hay mascotas asociadas al cliente que se está intentando eliminar (:OLD)
    SELECT COUNT(*) INTO v_count
    FROM Mascota
    WHERE Fk_Cliente = :OLD.ID_Cliente;

    IF v_count > 0 THEN
        -- Genera un error si se encuentran mascotas, lo que cancela la operación DELETE
        RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el cliente porque tiene mascotas asociadas.');
    END IF;
END;
/

-- Evitar edades incorrectas
CREATE OR REPLACE TRIGGER ValidarEdadMascota
BEFORE INSERT ON Mascota
FOR EACH ROW
BEGIN
    -- Verificar la edad de la nueva mascota que se está insertando (:NEW)
    IF :NEW.Edad <= 0 THEN
        -- Genera un error si la edad es inválida, lo que cancela la operación INSERT
        RAISE_APPLICATION_ERROR(-20002, 'La edad debe ser mayor a 0');
    END IF;
END;
/

-- ***********************************************************************************
-- Llamadas y Consultas de Prueba
-- ***********************************************************************************

-- Revision de tablas
SELECT * FROM Cliente;
SELECT * FROM Veterinario;
-- ... y el resto de SELECT * FROM Table;

-- Llamado de procedimientos almacenados (dentro de un bloque anónimo PL/SQL)
-- Primero, insertamos datos necesarios para las FKs (Direccion) y los objetos.

INSERT INTO Direccion (Provincia, Canton, Distrito, Barrio, Direccion)
VALUES ('San Jose', 'Central', 'El Centro', 'Barrio X', 'Direccion 1');
INSERT INTO Direccion (Provincia, Canton, Distrito, Barrio, Direccion)
VALUES ('Heredia', 'Central', 'Merced', 'Barrio Y', 'Direccion 2');

INSERT INTO Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion)
VALUES ('Dr. Smith', 'ApellidoVet', 'vet@email.com', '555-1234', 1);

INSERT INTO Servicio (Nombre, Descripcion, Precio)
VALUES ('Consulta General', 'Revisión y chequeo', 35.00);

COMMIT;

-- Ejecución de InsertarCliente
BEGIN
    InsertarCliente('Juan', 'Pérez', 'juan.perez@email.com', '123-456-7890', 1);
    COMMIT;
END;
/
SELECT * FROM Cliente;

-- Ejecución de ActualizarCliente
BEGIN
    ActualizarCliente(1, 'Juan Carlos', 'Pérez Sánchez', 'juan.carlos@email.com', '123-456-7891', 2);
    COMMIT;
END;
/
SELECT * FROM Cliente;

-- Ejecución de funciones
-- Se usa FROM DUAL para ejecutar funciones sin una tabla
SELECT CalcularPrecioServicio(1) AS PrecioServicio FROM DUAL;
SELECT ObtenerNombreCliente(1) AS NombreCliente FROM DUAL;
