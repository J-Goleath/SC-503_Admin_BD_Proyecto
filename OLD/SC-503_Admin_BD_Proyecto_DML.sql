-- INSERT Cliente
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Stanislas', 'Yakovlev', 'syakovlev0@quantcast.com', '656456456', 1);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Corrianne', 'Monery', 'cmonery1@paginegialle.it', '456456456', 2);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Aharon', 'Yoxall', 'ayoxall2@51.la', '456456456', 3);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Jacinda', 'Ferrara', 'jferrara3@booking.com', '456456456', 4);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Christin', 'Ughi', 'cughi4@google.ca', '456456456', 5);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Tabbatha', 'Claypool', 'tclaypool5@w3.org', '456456456', 6);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Lira', 'Duran', 'lduran6@dailymotion.com', '456456456', 7);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Theressa', 'Gurg', 'tgurg7@mediafire.com', '456456456', 8);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Constantine', 'Birts', 'cbirts8@list-manage.com', '456456456', 9);
insert into Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Dolley', 'St Angel', 'dstangel9@globo.com', '456456456', 10);

-- INSERT Veterinario
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Horatio', 'Von Brook', 'hvonbrook0@canalblog.com', '76789879', 1);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Geoff', 'Adamec', 'gadamec1@nyu.edu', '76789879', 2);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Raynard', 'Danahar', 'rdanahar2@wordpress.org', '76789879', 3);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Robbin', 'Kendle', 'rkendle3@mapquest.com', '76789879', 4);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Irma', 'Strevens', 'istrevens4@sogou.com', '76789879', 5);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Niel', 'Finneran', 'nfinneran5@hao123.com', '76789879', 6);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Davis', 'Quipp', 'dquipp6@google.fr', '76789879', 7);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Mattheus', 'Cantwell', 'mcantwell7@earthlink.net', '76789879', 8);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Sibby', 'Bending', 'sbending8@springer.com', '76789879', 9);
insert into Veterinario (Nombre, Apellido, Email, Telefono, Fk_Direccion) values ('Ilaire', 'Paule', 'ipaule9@blogtalkradio.com', '76789879', 10);

-- INSERT Mascota
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (1, 1, 6, 11, 'Indigo');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (2, 2, 3, 66, 'Teal');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (3, 3, 1, 3, 'Red');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (4, 4, 10, 25, 'Blue');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (5, 5, 2, 94, 'Turquoise');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (6, 6, 4, 42, 'Crimson');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (7, 7, 10, 89, 'Violet');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (8, 8, 10, 77, 'Blue');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (9, 9, 9, 69, 'Maroon');
insert into Mascota (Fk_Cliente, Fk_Animal, Edad, Peso, Notas) values (10, 10, 3, 100, 'Pink');

-- INSERT Cita (Usa TO_CHAR para convertir el TIMESTAMP a 'HH24:MI' string)
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (1, 1, 1, TO_DATE('2025-08-23', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('03:30:45', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (2, 2, 2, TO_DATE('2025-11-17', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('12:15:30', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (3, 3, 3, TO_DATE('2025-11-02', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('12:15:30', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (4, 4, 4, TO_DATE('2025-01-22', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('18:45:00', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (5, 5, 5, TO_DATE('2025-07-29', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('03:30:45', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (6, 6, 6, TO_DATE('2025-02-11', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('03:30:45', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (7, 7, 7, TO_DATE('2025-07-28', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('18:45:00', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (8, 8, 8, TO_DATE('2025-10-03', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('00:00:00', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (9, 9, 9, TO_DATE('2025-10-06', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('12:15:30', 'HH24:MI:SS'), 'HH24:MI'));
insert into Cita (Fk_Mascota, Fk_Veterinario, Fk_Servicio, Fecha_Cita, Hora) values (10, 10, 10, TO_DATE('2025-03-29', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('23:59:59', 'HH24:MI:SS'), 'HH24:MI'));

-- INSERT Consulta (Usa TO_CHAR para convertir el TIMESTAMP a 'HH24:MI' string)
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (1, 1, 1, 79, 618238, TO_DATE('2024-09-22', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('3:13:18', 'HH:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (2, 2, 2, 78, 956584, TO_DATE('2024-12-06', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('5:08:54', 'HH:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (3, 3, 3, 22, 208191, TO_DATE('2025-01-20', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('16:44:42', 'HH24:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (4, 4, 4, 69, 614351, TO_DATE('2024-04-16', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('23:13:54', 'HH24:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (5, 5, 5, 65, 677564, TO_DATE('2024-03-23', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('12:34:03', 'HH24:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (6, 6, 6, 28, 124756, TO_DATE('2024-11-15', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('12:26:10', 'HH24:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (7, 7, 7, 6, 512215, TO_DATE('2024-05-24', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('8:03:55', 'HH:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (8, 8, 8, 23, 875014, TO_DATE('2024-05-03', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('14:45:20', 'HH24:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (9, 9, 9, 70, 443133, TO_DATE('2024-01-16', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('11:34:11', 'HH24:MI:SS'), 'HH24:MI'));
insert into Consulta (Fk_Mascota, Fk_Veterinario, Fk_Procedimiento, Dias_Internado, Precio, Fecha_Cita, Hora) values (10, 10, 10, 27, 997436, TO_DATE('2024-03-24', 'YYYY-MM-DD'), TO_CHAR(TO_TIMESTAMP('7:35:02', 'HH:MI:SS'), 'HH24:MI'));

-- INSERT Producto
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Dental chews', 'Veterinary dental chews', 1);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Heartworm medication', 'Veterinary dental chews', 2);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Pet shampoo', 'Ear cleaner solution', 3);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Dental chews', 'Veterinary dental chews', 4);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Joint supplements', 'Veterinary dental chews', 5);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Pet shampoo', 'Veterinary dental chews', 6);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Pet shampoo', 'Shampoo for pets', 7);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Dental chews', 'Joint supplements for dogs', 8);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Flea treatment', 'Veterinary dental chews', 9);
insert into Producto (Nombre_Producto, Descripcion, Fk_Stock) values ('Dental chews', 'Ear cleaner solution', 10);

-- INSERT Historial
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (1, 1, 1, 'Spaying/neutering', TO_DATE('2024-01-06', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (2, 2, 2, 'Annual check-up', TO_DATE('2024-07-03', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (3, 3, 3, 'Spaying/neutering', TO_DATE('2024-03-19', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (4, 4, 4, 'Flea prevention', TO_DATE('2024-10-09', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (5, 5, 5, 'Spaying/neutering', TO_DATE('2024-08-09', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (6, 6, 6, 'Vaccinations', TO_DATE('2024-05-18', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (7, 7, 7, 'Flea prevention', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (8, 8, 8, 'Annual check-up', TO_DATE('2024-07-02', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (9, 9, 9, 'Annual check-up', TO_DATE('2023-12-24', 'YYYY-MM-DD'));
insert into Historial (Fk_Mascota, Fk_Veterinario, Fk_Proceso, Descripcion, Fecha) values (10, 10, 10, 'Flea prevention', TO_DATE('2024-11-05', 'YYYY-MM-DD'));

-- INSERT Factura
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (1, 394941, TO_DATE('2024-06-10', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (2, 802468, TO_DATE('2024-09-01', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (3, 258636, TO_DATE('2024-03-21', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (4, 428944, TO_DATE('2024-05-13', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (5, 753143, TO_DATE('2024-01-23', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (6, 543490, TO_DATE('2024-03-21', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (7, 55262, TO_DATE('2024-04-30', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (8, 127274, TO_DATE('2024-11-10', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (9, 402337, TO_DATE('2024-09-23', 'YYYY-MM-DD'));
insert into Factura (Fk_Cliente, Total, Fecha_Factura) values (10, 67398, TO_DATE('2024-11-27', 'YYYY-MM-DD'));

-- INSERT Detalle_Factura (Corregida la lista de columnas para que coincida con los valores)
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (1, 1, 316034, 60, 801473);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (2, 2, 200546, 11, 114769);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (3, 3, 518096, 74, 890705);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (4, 4, 267700, 52, 291332);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (5, 5, 310688, 81, 988611);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (6, 6, 837951, 52, 642965);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (7, 7, 700533, 26, 688861);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (8, 8, 11311, 16, 265014);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (9, 9, 309504, 99, 415037);
insert into Detalle_Factura (Fk_Factura, Fk_Producto, PrecioT, Cantidad, Precio_U) values (10, 10, 669824, 24, 683950);

-- Consultas de Verificación
select * from Direccion;
select * from Cliente;
select * from Veterinario;
select * from Animal;
select * from Mascota;
select * from Canino;
select * from Felino;
select * from Granja;
select * from Roedor;
select * from Ave;
select * from Pez;
select * from Reptil;
select * from Otros;
select * from Servicio;
select * from Procedimiento;
select * from Inventario;
select * from Producto;
select * from Historial;
select * from Cita;
select * from Consulta;
select * from Factura;
select * from Detalle_Factura;

-- Confirma los cambios en la base de datos
COMMIT;