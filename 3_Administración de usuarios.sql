-- Rmover permisos de los roles genericos para usar el nuevo rol
REVOKE CREATE SESSION FROM ROL_LECTURA;
REVOKE CREATE SESSION FROM ROL_VETERINARIO;
REVOKE CREATE SESSION FROM ROL_ADMIN;

-- Creacion de un rol específico para Recepcionista
CREATE ROLE Rol_Recepcionista;
GRANT CREATE SESSION TO Rol_Recepcionista;

-- Asignar permisos al nuevo Rol_Recepcionista
GRANT SELECT ON Direccion TO Rol_Recepcionista;
GRANT SELECT ON Cliente TO Rol_Recepcionista;
GRANT SELECT ON Veterinario TO Rol_Recepcionista;
GRANT SELECT ON Mascota TO Rol_Recepcionista;
GRANT SELECT ON Servicio TO Rol_Recepcionista;
GRANT SELECT ON Producto TO Rol_Recepcionista;
GRANT SELECT ON Inventario TO Rol_Recepcionista;
GRANT SELECT ON Cita TO Rol_Recepcionista;
GRANT SELECT ON Historial_Medico TO Rol_Recepcionista;
GRANT SELECT ON Procedimiento TO Rol_Recepcionista;
GRANT SELECT ON Factura TO Rol_Recepcionista;
GRANT SELECT ON Detalle_Factura TO Rol_Recepcionista;

-- Modifica el rol de Veterinario para mantener los permisos originales pero con el nuevo rol
GRANT CREATE SESSION TO Rol_Veterinario;

-- Actualiza la asignación de roles a los usuarios existentes
REVOKE Rol_Lectura FROM Recepcionista_Vet;
GRANT Rol_Recepcionista TO Recepcionista_Vet;

-- El usuario User_Vet ahora usará el rol Rol_Veterinario.
REVOKE Rol_Veterinario FROM User_Vet;
GRANT Rol_Veterinario TO User_Vet;

-- Auditoría de inicio y cierre de sesión (exitosos y fallidos)
AUDIT SESSION;

-- Auditoría de Operaciones DML (INSERT, UPDATE, DELETE) en tablas críticas por acceso exitoso
AUDIT INSERT, UPDATE, DELETE ON Cliente BY ACCESS;

-- Controlar las modificaciones al registro de mascotas
AUDIT INSERT, UPDATE, DELETE ON Mascota BY ACCESS;

-- Para trazabilidad de transacciones financieras
AUDIT INSERT, UPDATE, DELETE ON Factura BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON Detalle_Factura BY ACCESS;

-- Para trazabilidad de los registros médicos
AUDIT INSERT, UPDATE ON Historial_Medico BY ACCESS;

-- Auditoría de privilegios de sistema
AUDIT GRANT ROLE;
AUDIT REVOKE ROLE;
AUDIT CREATE USER;
AUDIT ALTER USER;

-- Ver ultimas 50 acciones
SELECT
    TIMESTAMP,
    DBUSERNAME,
    ACTION_NAME,
    SQL_TEXT,
    OBJ_NAME
FROM
    DBA_AUDIT_TRAIL
ORDER BY
    TIMESTAMP DESC
FETCH FIRST 50 ROWS ONLY;

-- Ver inicios y cierres de sesion
SELECT
    TIMESTAMP,
    DBUSERNAME,
    ACTION_NAME,
    RETURNCODE,
    COMMENT_TEXT
FROM
    DBA_AUDIT_TRAIL
WHERE
    ACTION_NAME IN ('LOGON', 'LOGOFF')
ORDER BY
    TIMESTAMP DESC;


-- Ver operaciones DML en tablas críticas
    SELECT
    TIMESTAMP,
    DBUSERNAME,
    ACTION_NAME,
    SQL_TEXT
FROM
    DBA_AUDIT_TRAIL
WHERE
    OBJ_NAME = 'CLIENTE'
    AND ACTION_NAME IN ('INSERT', 'UPDATE', 'DELETE')
ORDER BY
    TIMESTAMP DESC;