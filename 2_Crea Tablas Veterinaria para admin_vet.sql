-- Correr en Admin_Vet

CREATE TABLE Direccion(
    ID_Direccion NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Provincia VARCHAR2(100) NOT NULL, Canton VARCHAR2(100) NOT NULL, Distrito VARCHAR2(100) NOT NULL,
    Direccion_Detalle VARCHAR2(255) NOT NULL,
    CONSTRAINT PK_Direccion PRIMARY KEY (ID_Direccion)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Servicio(
    ID_Servicio NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL, Descripcion VARCHAR2(255), Precio NUMBER(10, 2) NOT NULL,
    CONSTRAINT PK_Servicio PRIMARY KEY (ID_Servicio),
    CONSTRAINT CHK_Servicio_Precio CHECK (Precio > 0)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Procedimiento(
    ID_Procedimiento NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL, Descripcion VARCHAR2(255), Costo NUMBER(10, 2) NOT NULL,
    CONSTRAINT PK_Procedimiento PRIMARY KEY (ID_Procedimiento)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Inventario(
    ID_Stock NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    InStock NUMBER(1) NOT NULL, Precio_U NUMBER(10, 2) NOT NULL, Cantidad NUMBER NOT NULL,
    CONSTRAINT PK_Inventario PRIMARY KEY (ID_Stock),
    CONSTRAINT CHK_Inventario_Cantidad CHECK (Cantidad >= 0)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Cliente(
    ID_Cliente NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL, Apellido VARCHAR2(100) NOT NULL, Email VARCHAR2(100) NOT NULL,
    Telefono VARCHAR2(15) NOT NULL, Fk_Direccion NUMBER NOT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (ID_Cliente),
    CONSTRAINT UK_Cliente_Email UNIQUE (Email),
    CONSTRAINT FK_Cliente_Direccion FOREIGN KEY (Fk_Direccion) REFERENCES Direccion(ID_Direccion)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Veterinario(
    ID_Veterinario NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL, Apellido VARCHAR2(100) NOT NULL, Licencia VARCHAR2(20) NOT NULL,
    Email VARCHAR2(100) NOT NULL, Telefono VARCHAR2(15) NOT NULL, Fk_Direccion NUMBER NOT NULL,
    CONSTRAINT PK_Veterinario PRIMARY KEY (ID_Veterinario),
    CONSTRAINT UK_Veterinario_Licencia UNIQUE (Licencia),
    CONSTRAINT FK_Vet_Direccion FOREIGN KEY (Fk_Direccion) REFERENCES Direccion(ID_Direccion)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Producto(
    ID_Producto NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre_Producto VARCHAR2(100) NOT NULL, Descripcion VARCHAR2(255), Fk_Stock NUMBER NOT NULL,
    CONSTRAINT PK_Producto PRIMARY KEY (ID_Producto),
    CONSTRAINT FK_Producto_Stock FOREIGN KEY (Fk_Stock) REFERENCES Inventario(ID_Stock)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Mascota(
    ID_Mascota NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL, Especie VARCHAR2(50) NOT NULL, Raza VARCHAR2(100),
    Fk_Cliente NUMBER NOT NULL, Edad NUMBER NOT NULL, Peso NUMBER(5, 2) NOT NULL, Notas VARCHAR2(255),
    CONSTRAINT PK_Mascota PRIMARY KEY (ID_Mascota),
    CONSTRAINT CHK_Mascota_Edad CHECK (Edad >= 0),
    CONSTRAINT FK_Mascota_Cliente FOREIGN KEY (Fk_Cliente) REFERENCES Cliente(ID_Cliente)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Factura(
    ID_Factura NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Cliente NUMBER NOT NULL, Total NUMBER(10, 2) NOT NULL, Fecha_Factura DATE NOT NULL,
    CONSTRAINT PK_Factura PRIMARY KEY (ID_Factura),
    CONSTRAINT FK_Factura_Cliente FOREIGN KEY (Fk_Cliente) REFERENCES Cliente(ID_Cliente)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Detalle_Factura(
    ID_DetalleFactura NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Factura NUMBER NOT NULL,
    Fk_Producto NUMBER,
    Fk_Servicio NUMBER,
    Precio_U NUMBER(10, 2) NOT NULL,
    Cantidad NUMBER NOT NULL,
    PrecioT NUMBER(10, 2) NOT NULL,
    CONSTRAINT PK_DetalleFactura PRIMARY KEY (ID_DetalleFactura),
    CONSTRAINT CHK_Detalle_XOR CHECK ((Fk_Producto IS NOT NULL AND Fk_Servicio IS NULL) OR (Fk_Producto IS NULL AND Fk_Servicio IS NOT NULL)),
    CONSTRAINT FK_Detalle_Factura FOREIGN KEY (Fk_Factura) REFERENCES Factura(ID_Factura),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (Fk_Producto) REFERENCES Producto(ID_Producto),
    CONSTRAINT FK_Detalle_Servicio FOREIGN KEY (Fk_Servicio) REFERENCES Servicio(ID_Servicio)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Cita(
    ID_Cita NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Mascota NUMBER NOT NULL, Fk_Veterinario NUMBER NOT NULL, Fk_Servicio NUMBER NOT NULL,
    Fecha_Cita DATE NOT NULL, Hora VARCHAR2(5) NOT NULL,
    CONSTRAINT PK_Cita PRIMARY KEY (ID_Cita),
    CONSTRAINT CHK_Cita_Hora CHECK (REGEXP_LIKE(Hora, '^[0-2][0-9]:[0-5][0-9]$')),
    CONSTRAINT FK_Cita_Mascota FOREIGN KEY (Fk_Mascota) REFERENCES Mascota(ID_Mascota),
    CONSTRAINT FK_Cita_Veterinario FOREIGN KEY (Fk_Veterinario) REFERENCES Veterinario(ID_Veterinario),
    CONSTRAINT FK_Cita_Servicio FOREIGN KEY (Fk_Servicio) REFERENCES Servicio(ID_Servicio)
) TABLESPACE VET_PROYECTO;

CREATE TABLE Historial_Medico(
    ID_Historial NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Fk_Mascota NUMBER NOT NULL, Fk_Veterinario NUMBER NOT NULL, Fk_Procedimiento NUMBER,
    Fecha DATE NOT NULL, Observaciones VARCHAR2(500) NOT NULL,
    CONSTRAINT PK_Historial PRIMARY KEY (ID_Historial),
    CONSTRAINT FK_Historial_Mascota FOREIGN KEY (Fk_Mascota) REFERENCES Mascota(ID_Mascota),
    CONSTRAINT FK_Historial_Vet FOREIGN KEY (Fk_Veterinario) REFERENCES Veterinario(ID_Veterinario),
    CONSTRAINT FK_Historial_Proc FOREIGN KEY (Fk_Procedimiento) REFERENCES Procedimiento(ID_Procedimiento)
) TABLESPACE VET_PROYECTO;

------------------------------------------------

INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('San José', 'San José', 'Catedral', 'Calle Central, Ave 2');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Alajuela', 'Alajuela', 'Carmen', 'Frente al parque');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Cartago', 'Cartago', 'Oriental', '100m Sur Basílica');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Heredia', 'Heredia', 'Mercedes', 'Costado Norte UNA');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Guanacaste', 'Liberia', 'Liberia', 'Plaza Santa Rosa');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Puntarenas', 'Puntarenas', 'Puntarenas', 'Paseo de los Turistas');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Limón', 'Limón', 'Limón', 'Barrio Cieneguita');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('San José', 'Escazú', 'San Rafael', 'Plaza Itskatzú');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Heredia', 'Santo Domingo', 'Santo Domingo', 'Cerca del INBio');
INSERT INTO Direccion (Provincia, Canton, Distrito, Direccion_Detalle) VALUES ('Alajuela', 'San Ramón', 'San Ramón', 'Parque Central');

INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Consulta General', 'Revisión de salud', 30000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Vacunación Rabia', 'Vacuna antirrábica', 20000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Desparasitación', 'Tratamiento parásitos', 15000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Cirugía Menor', 'Procedimiento quirúrgico simple', 150000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Limpieza Dental', 'Profilaxis dental', 75000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Radiografía', 'Imagen diagnóstica', 50000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Baño y Corte', 'Estética canina', 40000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Consulta Emergencia', 'Atención 24h', 80000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Eutanasia', 'Procedimiento humanitario', 100000.00);
INSERT INTO Servicio (Nombre, Descripcion, Precio) VALUES ('Análisis Sangre', 'Hemograma completo', 60000.00);

INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Esterilización Felina', 'Cirugía de castración gata', 120000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Castración Canina', 'Cirugía de castración perro', 100000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Sutura Herida', 'Cierre de herida', 40000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Extracción Dental', 'Remoción de pieza dental', 30000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Toma de Muestra', 'Biopsia o muestra de sangre', 10000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Fisioterapia', 'Sesión de rehabilitación', 25000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Colocación Microchip', 'Implante de ID', 35000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Limpieza Oídos', 'Lavado y revisión', 15000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Corte de Uñas', 'Corte y limado', 8000.00);
INSERT INTO Procedimiento (Nombre, Descripcion, Costo) VALUES ('Fluidoterapia', 'Administración de suero', 50000.00);

INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 15000.00, 100);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 25500.00, 50);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 12000.00, 200);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 8750.00, 150);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 30000.00, 80);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 18000.00, 120);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (0, 22000.00, 0);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 45000.00, 60);
INSERT INTO Inventario (InStock, Precio_U, Cantidad) VALUES (1, 19990.00, 100);
INSERT INTO InventARIO (InStock, Precio_U, Cantidad) VALUES (1, 5000.00, 300);

INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Stanislas-1', 'Yakovlev', 'syakovlev1@quantcast.com', '656456456', 1);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Corrianne-1', 'Monery', 'cmonery1@paginegialle.it', '456456456', 2);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Aharon-1', 'Yoxall', 'ayoxall1@51.la', '456456456', 3);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Jacinda-1', 'Ferrara', 'jferrara1@booking.com', '456456456', 4);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Christin-1', 'Ughi', 'cughi1@google.ca', '456456456', 5);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Tabbatha-1', 'Claypool', 'tclaypool1@w3.org', '456456456', 6);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Lira-1', 'Duran', 'lduran1@dailymotion.com', '456456456', 7);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Theressa-1', 'Gurg', 'tgurg1@mediafire.com', '456456456', 8);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Constantine-1', 'Birts', 'cbirts1@list-manage.com', '456456456', 9);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Dolley-1', 'St Angel', 'dstangel1@globo.com', '456456456', 10);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Stanislas-2', 'Yakovlev', 'syakovlev2@quantcast.com', '656456456', 1);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Corrianne-2', 'Monery', 'cmonery2@paginegialle.it', '456456456', 2);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Aharon-2', 'Yoxall', 'ayoxall2@51.la', '456456456', 3);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Jacinda-2', 'Ferrara', 'jferrara2@booking.com', '456456456', 4);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Christin-2', 'Ughi', 'cughi2@google.ca', '456456456', 5);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Tabbatha-2', 'Claypool', 'tclaypool2@w3.org', '456456456', 6);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Lira-2', 'Duran', 'lduran2@dailymotion.com', '456456456', 7);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Theressa-2', 'Gurg', 'tgurg2@mediafire.com', '456456456', 8);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Constantine-2', 'Birts', 'cbirts2@list-manage.com', '456456456', 9);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Dolley-2', 'St Angel', 'dstangel2@globo.com', '456456456', 10);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Stanislas-3', 'Yakovlev', 'syakovlev3@quantcast.com', '656456456', 1);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Corrianne-3', 'Monery', 'cmonery3@paginegialle.it', '456456456', 2);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Aharon-3', 'Yoxall', 'ayoxall3@51.la', '456456456', 3);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Jacinda-3', 'Ferrara', 'jferrara3@booking.com', '456456456', 4);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Christin-3', 'Ughi', 'cughi3@google.ca', '456456456', 5);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Tabbatha-3', 'Claypool', 'tclaypool3@w3.org', '456456456', 6);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Lira-3', 'Duran', 'lduran3@dailymotion.com', '456456456', 7);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Theressa-3', 'Gurg', 'tgurg3@mediafire.com', '456456456', 8);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Constantine-3', 'Birts', 'cbirts3@list-manage.com', '456456456', 9);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Dolley-3', 'St Angel', 'dstangel3@globo.com', '456456456', 10);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Stanislas-4', 'Yakovlev', 'syakovlev4@quantcast.com', '656456456', 1);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Corrianne-4', 'Monery', 'cmonery4@paginegialle.it', '456456456', 2);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Aharon-4', 'Yoxall', 'ayoxall4@51.la', '456456456', 3);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Jacinda-4', 'Ferrara', 'jferrara4@booking.com', '456456456', 4);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Christin-4', 'Ughi', 'cughi4@google.ca', '456456456', 5);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Tabbatha-4', 'Claypool', 'tclaypool4@w3.org', '456456456', 6);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Lira-4', 'Duran', 'lduran4@dailymotion.com', '456456456', 7);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Theressa-4', 'Gurg', 'tgurg4@mediafire.com', '456456456', 8);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Constantine-4', 'Birts', 'cbirts4@list-manage.com', '456456456', 9);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Dolley-4', 'St Angel', 'dstangel4@globo.com', '456456456', 10);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Stanislas-5', 'Yakovlev', 'syakovlev5@quantcast.com', '656456456', 1);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Corrianne-5', 'Monery', 'cmonery5@paginegialle.it', '456456456', 2);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Aharon-5', 'Yoxall', 'ayoxall5@51.la', '456456456', 3);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Jacinda-5', 'Ferrara', 'jferrara5@booking.com', '456456456', 4);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Christin-5', 'Ughi', 'cughi5@google.ca', '456456456', 5);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Tabbatha-5', 'Claypool', 'tclaypool5@w3.org', '456456456', 6);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Lira-5', 'Duran', 'lduran5@dailymotion.com', '456456456', 7);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Theressa-5', 'Gurg', 'tgurg5@mediafire.com', '456456456', 8);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Constantine-5', 'Birts', 'cbirts5@list-manage.com', '456456456', 9);
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) VALUES ('Dolley-5', 'St Angel', 'dstangel5@globo.com', '456456456', 10);

INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Horatio-1', 'Von Brook', 'LIC01', 'hvonbrook1@clinic.com', '76789879', 1);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Geoff-1', 'Adamec', 'LIC02', 'gadamec1@clinic.com', '76789879', 2);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Raynard-1', 'Danahar', 'LIC03', 'rdanahar1@clinic.com', '76789879', 3);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Robbin-1', 'Kendle', 'LIC04', 'rkendle1@clinic.com', '76789879', 4);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Irma-1', 'Strevens', 'LIC05', 'istrevens1@clinic.com', '76789879', 5);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Niel-1', 'Finneran', 'LIC06', 'nfinneran1@clinic.com', '76789879', 6);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Davis-1', 'Quipp', 'LIC07', 'dquipp1@clinic.com', '76789879', 7);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Mattheus-1', 'Cantwell', 'LIC08', 'mcantwell1@clinic.com', '76789879', 8);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Sibby-1', 'Bending', 'LIC09', 'sbending1@clinic.com', '76789879', 9);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Ilaire-1', 'Paule', 'LIC10', 'ipaule1@clinic.com', '76789879', 10);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Horatio-2', 'Von Brook', 'LIC11', 'hvonbrook2@clinic.com', '76789879', 1);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Geoff-2', 'Adamec', 'LIC12', 'gadamec2@clinic.com', '76789879', 2);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Raynard-2', 'Danahar', 'LIC13', 'rdanahar2@clinic.com', '76789879', 3);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Robbin-2', 'Kendle', 'LIC14', 'rkendle2@clinic.com', '76789879', 4);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Irma-2', 'Strevens', 'LIC15', 'istrevens2@clinic.com', '76789879', 5);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Niel-2', 'Finneran', 'LIC16', 'nfinneran2@clinic.com', '76789879', 6);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Davis-2', 'Quipp', 'LIC17', 'dquipp2@clinic.com', '76789879', 7);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Mattheus-2', 'Cantwell', 'LIC18', 'mcantwell2@clinic.com', '76789879', 8);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Sibby-2', 'Bending', 'LIC19', 'sbending2@clinic.com', '76789879', 9);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Ilaire-2', 'Paule', 'LIC20', 'ipaule2@clinic.com', '76789879', 10);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Horatio-3', 'Von Brook', 'LIC21', 'hvonbrook3@clinic.com', '76789879', 1);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Geoff-3', 'Adamec', 'LIC22', 'gadamec3@clinic.com', '76789879', 2);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Raynard-3', 'Danahar', 'LIC23', 'rdanahar3@clinic.com', '76789879', 3);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Robbin-3', 'Kendle', 'LIC24', 'rkendle3@clinic.com', '76789879', 4);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Irma-3', 'Strevens', 'LIC25', 'istrevens3@clinic.com', '76789879', 5);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Niel-3', 'Finneran', 'LIC26', 'nfinneran3@clinic.com', '76789879', 6);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Davis-3', 'Quipp', 'LIC27', 'dquipp3@clinic.com', '76789879', 7);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Mattheus-3', 'Cantwell', 'LIC28', 'mcantwell3@clinic.com', '76789879', 8);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Sibby-3', 'Bending', 'LIC29', 'sbending3@clinic.com', '76789879', 9);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Ilaire-3', 'Paule', 'LIC30', 'ipaule3@clinic.com', '76789879', 10);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Horatio-4', 'Von Brook', 'LIC31', 'hvonbrook4@clinic.com', '76789879', 1);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Geoff-4', 'Adamec', 'LIC32', 'gadamec4@clinic.com', '76789879', 2);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Raynard-4', 'Danahar', 'LIC33', 'rdanahar4@clinic.com', '76789879', 3);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Robbin-4', 'Kendle', 'LIC34', 'rkendle4@clinic.com', '76789879', 4);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Irma-4', 'Strevens', 'LIC35', 'istrevens4@clinic.com', '76789879', 5);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Niel-4', 'Finneran', 'LIC36', 'nfinneran4@clinic.com', '76789879', 6);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Davis-4', 'Quipp', 'LIC37', 'dquipp4@clinic.com', '76789879', 7);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Mattheus-4', 'Cantwell', 'LIC38', 'mcantwell4@clinic.com', '76789879', 8);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Sibby-4', 'Bending', 'LIC39', 'sbending4@clinic.com', '76789879', 9);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Ilaire-4', 'Paule', 'LIC40', 'ipaule4@clinic.com', '76789879', 10);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Horatio-5', 'Von Brook', 'LIC41', 'hvonbrook5@clinic.com', '76789879', 1);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Geoff-5', 'Adamec', 'LIC42', 'gadamec5@clinic.com', '76789879', 2);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Raynard-5', 'Danahar', 'LIC43', 'rdanahar5@clinic.com', '76789879', 3);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Robbin-5', 'Kendle', 'LIC44', 'rkendle5@clinic.com', '76789879', 4);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Irma-5', 'Strevens', 'LIC45', 'istrevens5@clinic.com', '76789879', 5);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Niel-5', 'Finneran', 'LIC46', 'nfinneran5@clinic.com', '76789879', 6);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Davis-5', 'Quipp', 'LIC47', 'dquipp5@clinic.com', '76789879', 7);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Mattheus-5', 'Cantwell', 'LIC48', 'mcantwell5@clinic.com', '76789879', 8);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Sibby-5', 'Bending', 'LIC49', 'sbending5@clinic.com', '76789879', 9);
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion) VALUES ('Ilaire-5', 'Paule', 'LIC50', 'ipaule5@clinic.com', '76789879', 10);

INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P1', 'Limpieza dental', 1);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Heartworm medication P2', 'Prevención parásitos', 2);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P3', 'Solución limpieza oídos', 3);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P4', 'Masticables veterinarios', 4);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Joint supplements P5', 'Suplementos articulaciones', 5);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P6', 'Champú para mascotas', 6);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P7', 'Champú para mascotas', 7);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P8', 'Suplementos articulaciones perros', 8);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Flea treatment P9', 'Tratamiento pulgas', 9);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P10', 'Solución limpieza oídos', 10);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P11', 'Limpieza dental', 1);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Heartworm medication P12', 'Prevención parásitos', 2);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P13', 'Solución limpieza oídos', 3);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P14', 'Masticables veterinarios', 4);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Joint supplements P15', 'Suplementos articulaciones', 5);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P16', 'Champú para mascotas', 6);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P17', 'Champú para mascotas', 7);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P18', 'Suplementos articulaciones perros', 8);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Flea treatment P19', 'Tratamiento pulgas', 9);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P20', 'Solución limpieza oídos', 10);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P21', 'Limpieza dental', 1);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Heartworm medication P22', 'Prevención parásitos', 2);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P23', 'Solución limpieza oídos', 3);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P24', 'Masticables veterinarios', 4);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Joint supplements P25', 'Suplementos articulaciones', 5);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P26', 'Champú para mascotas', 6);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P27', 'Champú para mascotas', 7);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P28', 'Suplementos articulaciones perros', 8);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Flea treatment P29', 'Tratamiento pulgas', 9);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P30', 'Solución limpieza oídos', 10);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P31', 'Limpieza dental', 1);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Heartworm medication P32', 'Prevención parásitos', 2);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P33', 'Solución limpieza oídos', 3);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P34', 'Masticables veterinarios', 4);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Joint supplements P35', 'Suplementos articulaciones', 5);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P36', 'Champú para mascotas', 6);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P37', 'Champú para mascotas', 7);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P38', 'Suplementos articulaciones perros', 8);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Flea treatment P39', 'Tratamiento pulgas', 9);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P40', 'Solución limpieza oídos', 10);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P41', 'Limpieza dental', 1);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Heartworm medication P42', 'Prevención parásitos', 2);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P43', 'Solución limpieza oídos', 3);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P44', 'Masticables veterinarios', 4);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Joint supplements P45', 'Suplementos articulaciones', 5);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P46', 'Champú para mascotas', 6);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Pet shampoo P47', 'Champú para mascotas', 7);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P48', 'Suplementos articulaciones perros', 8);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Flea treatment P49', 'Tratamiento pulgas', 9);
INSERT INTO Producto (Nombre_Producto, Descripcion, Fk_Stock) VALUES ('Dental chews P50', 'Solución limpieza oídos', 10);

INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Firulais-1', 'Perro', 'Labrador', 1, 6, 11.5, 'Necesita dieta especial');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Milo-1', 'Gato', 'Siamés', 2, 3, 6.6, 'Comportamiento ansioso');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Pepe-1', 'Perro', 'Chihuahua', 3, 1, 3.0, 'Vacunación pendiente');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Luna-1', 'Perro', 'Pastor Alemán', 4, 10, 25.0, 'Historial de displasia');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Nala-1', 'Gato', 'Persa', 5, 2, 9.4, 'Ojos llorosos');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Copito-1', 'Conejo', 'Jersey Wooly', 6, 4, 4.2, 'Revisión dental');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Sol-1', 'Pez', 'Guppy', 7, 1, 0.1, 'Temperatura estable');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Shadow-1', 'Serpiente', 'Pitón', 8, 10, 7.7, 'Revisión de piel');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Lucky-1', 'Perro', 'Dóberman', 9, 9, 6.9, 'Control de peso');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Toby-1', 'Gato', 'Ragdoll', 10, 3, 10.0, 'Solo alimento húmedo');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Firulais-2', 'Perro', 'Poodle', 11, 2, 8.5, 'Requiere corte de pelo');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Milo-2', 'Gato', 'Común', 12, 5, 4.1, 'Muy activa');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Pepe-2', 'Perro', 'Beagle', 13, 7, 12.2, 'Chequeo articular');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Luna-2', 'Perro', 'Boxer', 14, 4, 28.0, 'Control de vacunas');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Nala-2', 'Gato', 'Maine Coon', 15, 8, 7.5, 'Cuidado renal');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Copito-2', 'Conejo', 'Holland Lop', 16, 2, 3.1, 'Control de heces');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Sol-2', 'Pez', 'Betta', 17, 1, 0.2, 'Cambio de agua');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Shadow-2', 'Tortuga', 'Galápagos', 18, 15, 50.5, 'Suplemento de calcio');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Lucky-2', 'Perro', 'Pitbull', 19, 3, 20.9, 'Dieta de alta proteína');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Toby-2', 'Gato', 'Esfinge', 20, 1, 5.5, 'Cuidado de piel');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Rex-3', 'Perro', 'Poodle', 21, 2, 8.5, 'Requiere corte de pelo');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Cleo-3', 'Gato', 'Común', 22, 5, 4.1, 'Muy activa');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Rocky-3', 'Perro', 'Beagle', 23, 7, 12.2, 'Chequeo articular');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Venus-3', 'Perro', 'Boxer', 24, 4, 28.0, 'Control de vacunas');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Juno-3', 'Gato', 'Maine Coon', 25, 8, 7.5, 'Cuidado renal');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Marvin-3', 'Conejo', 'Holland Lop', 26, 2, 3.1, 'Control de heces');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Pluto-3', 'Pez', 'Betta', 27, 1, 0.2, 'Cambio de agua');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Vulcano-3', 'Tortuga', 'Galápagos', 28, 15, 50.5, 'Suplemento de calcio');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Mars-3', 'Perro', 'Pitbull', 29, 3, 20.9, 'Dieta de alta proteína');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Neptuno-3', 'Gato', 'Esfinge', 30, 1, 5.5, 'Cuidado de piel');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Rex-4', 'Perro', 'Poodle', 31, 2, 8.5, 'Requiere corte de pelo');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Cleo-4', 'Gato', 'Común', 32, 5, 4.1, 'Muy activa');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Rocky-4', 'Perro', 'Beagle', 33, 7, 12.2, 'Chequeo articular');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Venus-4', 'Perro', 'Boxer', 34, 4, 28.0, 'Control de vacunas');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Juno-4', 'Gato', 'Maine Coon', 35, 8, 7.5, 'Cuidado renal');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Marvin-4', 'Conejo', 'Holland Lop', 36, 2, 3.1, 'Control de heces');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Pluto-4', 'Pez', 'Betta', 37, 1, 0.2, 'Cambio de agua');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Vulcano-4', 'Tortuga', 'Galápagos', 38, 15, 50.5, 'Suplemento de calcio');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Mars-4', 'Perro', 'Pitbull', 39, 3, 20.9, 'Dieta de alta proteína');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Neptuno-4', 'Gato', 'Esfinge', 40, 1, 5.5, 'Cuidado de piel');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Rex-5', 'Perro', 'Poodle', 41, 2, 8.5, 'Requiere corte de pelo');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Cleo-5', 'Gato', 'Común', 42, 5, 4.1, 'Muy activa');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Rocky-5', 'Perro', 'Beagle', 43, 7, 12.2, 'Chequeo articular');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Venus-5', 'Perro', 'Boxer', 44, 4, 28.0, 'Control de vacunas');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Juno-5', 'Gato', 'Maine Coon', 45, 8, 7.5, 'Cuidado renal');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Marvin-5', 'Conejo', 'Holland Lop', 46, 2, 3.1, 'Control de heces');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Pluto-5', 'Pez', 'Betta', 47, 1, 0.2, 'Cambio de agua');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Vulcano-5', 'Tortuga', 'Galápagos', 48, 15, 50.5, 'Suplemento de calcio');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Mars-5', 'Perro', 'Pitbull', 49, 3, 20.9, 'Dieta de alta proteína');
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas) VALUES ('Neptuno-5', 'Gato', 'Esfinge', 50, 1, 5.5, 'Cuidado de piel');

INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (1, 394941.00, TO_DATE('2024-06-10', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (2, 802468.00, TO_DATE('2024-09-01', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (3, 258636.00, TO_DATE('2024-03-21', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (4, 428944.00, TO_DATE('2024-05-13', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (5, 753143.00, TO_DATE('2024-01-23', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (6, 543490.00, TO_DATE('2024-03-21', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (7, 55262.00, TO_DATE('2024-04-30', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (8, 127274.00, TO_DATE('2024-11-10', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (9, 402337.00, TO_DATE('2024-09-23', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (10, 67398.00, TO_DATE('2024-11-27', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (11, 400000.00, TO_DATE('2024-06-11', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (12, 810000.00, TO_DATE('2024-09-02', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (13, 260000.00, TO_DATE('2024-03-22', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (14, 430000.00, TO_DATE('2024-05-14', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (15, 760000.00, TO_DATE('2024-01-24', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (16, 550000.00, TO_DATE('2024-03-22', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (17, 56000.00, TO_DATE('2024-05-01', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (18, 130000.00, TO_DATE('2024-11-11', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (19, 410000.00, TO_DATE('2024-09-24', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (20, 68000.00, TO_DATE('2024-11-28', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (21, 400000.00, TO_DATE('2024-06-12', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (22, 810000.00, TO_DATE('2024-09-03', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (23, 260000.00, TO_DATE('2024-03-23', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (24, 430000.00, TO_DATE('2024-05-15', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (25, 760000.00, TO_DATE('2024-01-25', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (26, 550000.00, TO_DATE('2024-03-24', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (27, 56000.00, TO_DATE('2024-05-02', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (28, 130000.00, TO_DATE('2024-11-12', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (29, 410000.00, TO_DATE('2024-09-25', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (30, 68000.00, TO_DATE('2024-11-29', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (31, 400000.00, TO_DATE('2024-06-13', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (32, 810000.00, TO_DATE('2024-09-04', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (33, 260000.00, TO_DATE('2024-03-24', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (34, 430000.00, TO_DATE('2024-05-16', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (35, 760000.00, TO_DATE('2024-01-26', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (36, 550000.00, TO_DATE('2024-03-25', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (37, 56000.00, TO_DATE('2024-05-03', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (38, 130000.00, TO_DATE('2024-11-13', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (39, 410000.00, TO_DATE('2024-09-26', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (40, 68000.00, TO_DATE('2024-11-30', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (41, 400000.00, TO_DATE('2024-06-14', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (42, 810000.00, TO_DATE('2024-09-05', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (43, 260000.00, TO_DATE('2024-03-25', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (44, 430000.00, TO_DATE('2024-05-17', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (45, 760000.00, TO_DATE('2024-01-27', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (46, 550000.00, TO_DATE('2024-03-26', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (47, 56000.00, TO_DATE('2024-05-04', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (48, 130000.00, TO_DATE('2024-11-14', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (49, 410000.00, TO_DATE('2024-09-27', 'YYYY-MM-DD'));
INSERT INTO Factura (Fk_Cliente, Total, Fecha_Factura) VALUES (50, 68000.00, TO_DATE('2024-12-01', 'YYYY-MM-DD'));

INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (1, 1, 1, TO_DATE('2025-08-23', 'YYYY-MM-DD'), '08:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (2, 2, 2, TO_DATE('2025-11-17', 'YYYY-MM-DD'), '10:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (3, 3, 3, TO_DATE('2025-11-02', 'YYYY-MM-DD'), '12:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (4, 4, 4, TO_DATE('2025-01-22', 'YYYY-MM-DD'), '14:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (5, 5, 5, TO_DATE('2025-07-29', 'YYYY-MM-DD'), '16:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (6, 6, 6, TO_DATE('2025-02-11', 'YYYY-MM-DD'), '09:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (7, 7, 7, TO_DATE('2025-07-28', 'YYYY-MM-DD'), '11:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (8, 8, 8, TO_DATE('2025-10-03', 'YYYY-MM-DD'), '13:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (9, 9, 9, TO_DATE('2025-10-06', 'YYYY-MM-DD'), '15:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (10, 10, 10, TO_DATE('2025-03-29', 'YYYY-MM-DD'), '17:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (11, 11, 1, TO_DATE('2025-08-24', 'YYYY-MM-DD'), '08:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (12, 12, 2, TO_DATE('2025-11-18', 'YYYY-MM-DD'), '10:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (13, 13, 3, TO_DATE('2025-11-03', 'YYYY-MM-DD'), '12:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (14, 14, 4, TO_DATE('2025-01-23', 'YYYY-MM-DD'), '14:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (15, 15, 5, TO_DATE('2025-07-30', 'YYYY-MM-DD'), '16:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (16, 16, 6, TO_DATE('2025-02-12', 'YYYY-MM-DD'), '09:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (17, 17, 7, TO_DATE('2025-07-29', 'YYYY-MM-DD'), '11:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (18, 18, 8, TO_DATE('2025-10-04', 'YYYY-MM-DD'), '13:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (19, 19, 9, TO_DATE('2025-10-07', 'YYYY-MM-DD'), '15:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (20, 20, 10, TO_DATE('2025-03-30', 'YYYY-MM-DD'), '17:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (21, 21, 1, TO_DATE('2025-08-25', 'YYYY-MM-DD'), '08:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (22, 22, 2, TO_DATE('2025-11-19', 'YYYY-MM-DD'), '10:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (23, 23, 3, TO_DATE('2025-11-04', 'YYYY-MM-DD'), '12:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (24, 24, 4, TO_DATE('2025-01-24', 'YYYY-MM-DD'), '14:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (25, 25, 5, TO_DATE('2025-07-31', 'YYYY-MM-DD'), '16:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (26, 26, 6, TO_DATE('2025-02-13', 'YYYY-MM-DD'), '09:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (27, 27, 7, TO_DATE('2025-07-30', 'YYYY-MM-DD'), '11:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (28, 28, 8, TO_DATE('2025-10-05', 'YYYY-MM-DD'), '13:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (29, 29, 9, TO_DATE('2025-10-08', 'YYYY-MM-DD'), '15:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (30, 30, 10, TO_DATE('2025-03-31', 'YYYY-MM-DD'), '17:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (31, 31, 1, TO_DATE('2025-08-26', 'YYYY-MM-DD'), '08:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (32, 32, 2, TO_DATE('2025-11-20', 'YYYY-MM-DD'), '10:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (33, 33, 3, TO_DATE('2025-11-05', 'YYYY-MM-DD'), '12:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (34, 34, 4, TO_DATE('2025-01-25', 'YYYY-MM-DD'), '14:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (35, 35, 5, TO_DATE('2025-08-01', 'YYYY-MM-DD'), '16:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (36, 36, 6, TO_DATE('2025-02-14', 'YYYY-MM-DD'), '09:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (37, 37, 7, TO_DATE('2025-07-31', 'YYYY-MM-DD'), '11:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (38, 38, 8, TO_DATE('2025-10-06', 'YYYY-MM-DD'), '13:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (39, 39, 9, TO_DATE('2025-10-09', 'YYYY-MM-DD'), '15:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (40, 40, 10, TO_DATE('2025-04-01', 'YYYY-MM-DD'), '17:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (41, 41, 1, TO_DATE('2025-08-27', 'YYYY-MM-DD'), '08:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (42, 42, 2, TO_DATE('2025-11-21', 'YYYY-MM-DD'), '10:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (43, 43, 3, TO_DATE('2025-11-06', 'YYYY-MM-DD'), '12:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (44, 44, 4, TO_DATE('2025-01-26', 'YYYY-MM-DD'), '14:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (45, 45, 5, TO_DATE('2025-08-02', 'YYYY-MM-DD'), '16:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (46, 46, 6, TO_DATE('2025-02-15', 'YYYY-MM-DD'), '09:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (47, 47, 7, TO_DATE('2025-08-01', 'YYYY-MM-DD'), '11:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (48, 48, 8, TO_DATE('2025-10-07', 'YYYY-MM-DD'), '13:00');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (49, 49, 9, TO_DATE('2025-10-10', 'YYYY-MM-DD'), '15:30');
INSERT INTO Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) VALUES (50, 50, 10, TO_DATE('2025-04-02', 'YYYY-MM-DD'), '17:00');

INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (1, 1, 1, TO_DATE('2024-01-06', 'YYYY-MM-DD'), 'Spaying/neutering');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (2, 2, 2, TO_DATE('2024-07-03', 'YYYY-MM-DD'), 'Annual check-up');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (3, 3, 3, TO_DATE('2024-03-19', 'YYYY-MM-DD'), 'Vacunación y desparasitación');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (4, 4, 4, TO_DATE('2024-10-09', 'YYYY-MM-DD'), 'Control de pulgas');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (5, 5, 5, TO_DATE('2024-08-09', 'YYYY-MM-DD'), 'Revisión general de salud');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (6, 6, 6, TO_DATE('2024-05-18', 'YYYY-MM-DD'), 'Aplicación de vacunas');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (7, 7, 7, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Prevención de parásitos');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (8, 8, 8, TO_DATE('2024-07-02', 'YYYY-MM-DD'), 'Chequeo anual de reptiles');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (9, 9, 9, TO_DATE('2023-12-24', 'YYYY-MM-DD'), 'Control de rutina');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (10, 10, 10, TO_DATE('2024-11-05', 'YYYY-MM-DD'), 'Medicación preventiva');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (11, 11, 1, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 'Revisión post-operatoria');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (12, 12, 2, TO_DATE('2024-07-13', 'YYYY-MM-DD'), 'Evaluación de condición corporal');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (13, 13, 3, TO_DATE('2024-03-29', 'YYYY-MM-DD'), 'Desparasitación');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (14, 14, 4, TO_DATE('2024-10-19', 'YYYY-MM-DD'), 'Consulta por alergias');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (15, 15, 5, TO_DATE('2024-08-19', 'YYYY-MM-DD'), 'Terapia física iniciada');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (16, 16, 6, TO_DATE('2024-05-28', 'YYYY-MM-DD'), 'Control de heridas');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (17, 17, 7, TO_DATE('2024-02-11', 'YYYY-MM-DD'), 'Análisis de agua');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (18, 18, 8, TO_DATE('2024-07-12', 'YYYY-MM-DD'), 'Revisión de caparazón');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (19, 19, 9, TO_DATE('2024-01-03', 'YYYY-MM-DD'), 'Implantación de microchip');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (20, 20, 10, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 'Sueroterapia');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (21, 21, 1, TO_DATE('2024-01-26', 'YYYY-MM-DD'), 'Control de peso');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (22, 22, 2, TO_DATE('2024-07-23', 'YYYY-MM-DD'), 'Examen físico completo');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (23, 23, 3, TO_DATE('2024-03-30', 'YYYY-MM-DD'), 'Vacunación');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (24, 24, 4, TO_DATE('2024-10-29', 'YYYY-MM-DD'), 'Limpieza dental');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (25, 25, 5, TO_DATE('2024-08-29', 'YYYY-MM-DD'), 'Control de cicatriz');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (26, 26, 6, TO_DATE('2024-05-08', 'YYYY-MM-DD'), 'Revisión ocular');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (27, 27, 7, TO_DATE('2024-02-21', 'YYYY-MM-DD'), 'Análisis de parásitos');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (28, 28, 8, TO_DATE('2024-07-22', 'YYYY-MM-DD'), 'Biopsia de piel');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (29, 29, 9, TO_DATE('2024-01-13', 'YYYY-MM-DD'), 'Revisión general');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (30, 30, 10, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 'Consulta por vómitos');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (31, 31, 1, TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'Seguimiento de cirugía');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (32, 32, 2, TO_DATE('2024-08-02', 'YYYY-MM-DD'), 'Revisión de heridas');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (33, 33, 3, TO_DATE('2024-04-09', 'YYYY-MM-DD'), 'Desparasitación');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (34, 34, 4, TO_DATE('2024-11-08', 'YYYY-MM-DD'), 'Control de pulgas');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (35, 35, 5, TO_DATE('2024-09-08', 'YYYY-MM-DD'), 'Terapia física');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (36, 36, 6, TO_DATE('2024-06-07', 'YYYY-MM-DD'), 'Vacunación');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (37, 37, 7, TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Análisis de agua');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (38, 38, 8, TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'Chequeo anual');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (39, 39, 9, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Microchip');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (40, 40, 10, TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'Medicación');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (41, 41, 1, TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Control de peso');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (42, 42, 2, TO_DATE('2024-08-12', 'YYYY-MM-DD'), 'Examen físico');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (43, 43, 3, TO_DATE('2024-04-19', 'YYYY-MM-DD'), 'Vacunación');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (44, 44, 4, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 'Limpieza dental');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (45, 45, 5, TO_DATE('2024-09-18', 'YYYY-MM-DD'), 'Control de cicatriz');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (46, 46, 6, TO_DATE('2024-06-17', 'YYYY-MM-DD'), 'Revisión ocular');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (47, 47, 7, TO_DATE('2024-03-11', 'YYYY-MM-DD'), 'Análisis de parásitos');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (48, 48, 8, TO_DATE('2024-08-11', 'YYYY-MM-DD'), 'Biopsia de piel');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (49, 49, 9, TO_DATE('2024-03-03', 'YYYY-MM-DD'), 'Revisión general');
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Fecha, Observaciones) VALUES (50, 50, 10, TO_DATE('2024-12-14', 'YYYY-MM-DD'), 'Consulta por vómitos');

INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (1, 1, NULL, 3160.34, 6, 801.47);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (2, 2, NULL, 2005.46, 1, 1147.69);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (3, 3, NULL, 5180.96, 7, 890.70);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (4, 4, NULL, 2677.00, 5, 291.33);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (5, 5, NULL, 3106.88, 8, 988.61);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (6, 6, NULL, 8379.51, 5, 642.96);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (7, 7, NULL, 7005.33, 2, 688.86);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (8, 8, NULL, 1131.10, 1, 265.01);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (9, 9, NULL, 3095.04, 9, 415.03);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (10, 10, NULL, 6698.24, 2, 683.95);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (11, 11, NULL, 3200.00, 5, 700.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (12, 12, NULL, 2100.00, 2, 1000.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (13, 13, NULL, 5200.00, 7, 800.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (14, 14, NULL, 2700.00, 5, 300.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (15, 15, NULL, 3200.00, 8, 1000.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (16, 16, NULL, 8400.00, 5, 600.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (17, 17, NULL, 7100.00, 2, 700.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (18, 18, NULL, 1200.00, 1, 300.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (19, 19, NULL, 3100.00, 9, 450.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (20, 20, NULL, 6700.00, 2, 750.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (21, 21, NULL, 3300.00, 6, 800.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (22, 22, NULL, 2200.00, 1, 1200.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (23, 23, NULL, 5300.00, 7, 900.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (24, 24, NULL, 2800.00, 5, 350.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (25, 25, NULL, 3300.00, 8, 1100.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (26, 26, NULL, 8500.00, 5, 650.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (27, 27, NULL, 7200.00, 2, 800.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (28, 28, NULL, 1300.00, 1, 350.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (29, 29, NULL, 3200.00, 9, 500.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (30, 30, NULL, 6800.00, 2, 850.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (31, 31, NULL, 3400.00, 6, 850.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (32, 32, NULL, 2300.00, 1, 1300.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (33, 33, NULL, 5400.00, 7, 950.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (34, 34, NULL, 2900.00, 5, 400.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (35, 35, NULL, 3400.00, 8, 1200.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (36, 36, NULL, 8600.00, 5, 700.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (37, 37, NULL, 7300.00, 2, 900.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (38, 38, NULL, 1400.00, 1, 400.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (39, 39, NULL, 3300.00, 9, 550.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (40, 40, NULL, 6900.00, 2, 950.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (41, 41, NULL, 3500.00, 6, 900.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (42, 42, NULL, 2400.00, 1, 1400.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (43, 43, NULL, 5500.00, 7, 1000.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (44, 44, NULL, 3000.00, 5, 450.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (45, 45, NULL, 3500.00, 8, 1300.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (46, 46, NULL, 8700.00, 5, 750.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (47, 47, NULL, 7400.00, 2, 1000.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (48, 48, NULL, 1500.00, 1, 450.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (49, 49, NULL, 3400.00, 9, 600.00);
INSERT INTO Detalle_Factura (Fk_Factura, Fk_Producto, Fk_Servicio, PrecioT, Cantidad, Precio_U) VALUES (50, 50, NULL, 7000.00, 2, 1050.00);

COMMIT;

-- Indices

CREATE INDEX IDX_CLIENTE_FK_DIRECCION ON Cliente (Fk_Direccion) TABLESPACE VET_PROYECTO;
CREATE INDEX IDX_VETERINARIO_FK_DIRECCION ON Veterinario (Fk_Direccion) TABLESPACE VET_PROYECTO;
CREATE INDEX IDX_MASCOTA_FK_CLIENTE ON Mascota (Fk_Cliente) TABLESPACE VET_PROYECTO;
CREATE INDEX IDX_CITA_FK_VET ON Cita (Fk_Veterinario) TABLESPACE VET_PROYECTO;
CREATE INDEX IDX_HISTORIAL_FK_MASC ON Historial_Medico (Fk_Mascota) TABLESPACE VET_PROYECTO;

-- Privilegios

-- Rol lectura
GRANT SELECT ON Direccion TO Rol_Lectura;
GRANT SELECT ON Cliente TO Rol_Lectura;
GRANT SELECT ON Veterinario TO Rol_Lectura;
GRANT SELECT ON Mascota TO Rol_Lectura;
GRANT SELECT ON Servicio TO Rol_Lectura;
GRANT SELECT ON Producto TO Rol_Lectura;
GRANT SELECT ON Inventario TO Rol_Lectura;
GRANT SELECT ON Cita TO Rol_Lectura;

-- Rol veterinario
GRANT SELECT ON Cliente TO Rol_Veterinario;
GRANT SELECT ON Veterinario TO Rol_Veterinario;
GRANT SELECT ON Mascota TO Rol_Veterinario;
GRANT SELECT ON Servicio TO Rol_Veterinario;
GRANT SELECT ON Procedimiento TO Rol_Veterinario;
GRANT SELECT, INSERT, UPDATE, DELETE ON Cita TO Rol_Veterinario;
GRANT SELECT, INSERT, UPDATE ON Historial_Medico TO Rol_Veterinario;
GRANT SELECT ON Producto TO Rol_Veterinario;
GRANT SELECT ON Inventario TO Rol_Veterinario;

SELECT '1. Cliente' AS Tabla, COUNT(*) AS Filas FROM Cliente
UNION ALL
SELECT '2. Veterinario' AS Tabla, COUNT(*) AS Filas FROM Veterinario
UNION ALL
SELECT '3. Mascota' AS Tabla, COUNT(*) AS Filas FROM Mascota
UNION ALL
SELECT '4. Producto' AS Tabla, COUNT(*) AS Filas FROM Producto
UNION ALL
SELECT '5. Factura' AS Tabla, COUNT(*) AS Filas FROM Factura
UNION ALL
SELECT '6. Detalle_Factura' AS Tabla, COUNT(*) AS Filas FROM Detalle_Factura
UNION ALL
SELECT '7. Cita' AS Tabla, COUNT(*) AS Filas FROM Cita
UNION ALL
SELECT '8. Historial_Medico' AS Tabla, COUNT(*) AS Filas FROM Historial_Medico
ORDER BY Tabla;