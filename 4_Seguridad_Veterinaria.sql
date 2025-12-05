-- =====================================================================
-- SCRIPT DE SEGURIDAD
-- Implementa encriptación y auditorías
-- Ejecutar en Admin_Vet
-- > EJECUTAR BLOQUE A BLOQUE <
-- =====================================================================

-- =====================================================================
-- SECCIÓN 1: FUNCIONES DE ENCRIPTACIÓN PARA DATOS SENSIBLES
-- =====================================================================


-- >>> PRIMERO HAY QUE DARLE PERMISO SOBRE DBMS_CRYPTO A ADMIN_VET <<<
--     EJECUTAR EN ORDEN ESTOS COMANDOS EN EL CMD
sqlplus / as sysdba
alter session set container = xepdb1;

GRANT EXECUTE ON SYS.DBMS_CRYPTO TO ADMIN_VET;
GRANT CREATE VIEW TO ADMIN_VET;
GRANT EXECUTE ON SYS.DBMS_RLS TO ADMIN_VET;
GRANT SELECT ON SYS.DBA_AUDIT_TRAIL TO ADMIN_VET;
----------------------------------------------------------------------


-- A PARTIR DE ACÁ TODO VA EN EL SQL DEVELOPER CON EL USUARIO ADMIN_VET
    
-- Función para encriptar texto sensible usando AES
CREATE OR REPLACE FUNCTION encriptar_dato_sensible(p_text VARCHAR2) 
RETURN RAW 
DETERMINISTIC
IS
-- Clave de encriptación
    l_key RAW(128) := UTL_I18N.STRING_TO_RAW('VET_CLAVE_16_25!', 'AL32UTF8'); 
BEGIN 
    IF p_text IS NULL THEN
        RETURN NULL;
    END IF;
    
    RETURN DBMS_CRYPTO.ENCRYPT( 
        UTL_I18N.STRING_TO_RAW(p_text, 'AL32UTF8'), 
        DBMS_CRYPTO.AES_CBC_PKCS5, 
        l_key 
    ); 
EXCEPTION
    WHEN OTHERS THEN
        -- Log error y retornar NULL en caso de falla
        DBMS_OUTPUT.PUT_LINE('Error en encriptación: ' || SQLERRM);
        RETURN NULL;
END;
/

-- Función para desencriptar texto sensible
CREATE OR REPLACE FUNCTION desencriptar_dato_sensible(p_encrypted RAW) 
RETURN VARCHAR2 
DETERMINISTIC
IS 
    l_key RAW(128) := UTL_I18N.STRING_TO_RAW('VET_CLAVE_16_25!', 'AL32UTF8'); 
    l_raw RAW(32767);
BEGIN 
    IF p_encrypted IS NULL THEN
        RETURN NULL;
    END IF;
    
    l_raw := DBMS_CRYPTO.DECRYPT( 
        p_encrypted, 
        DBMS_CRYPTO.AES_CBC_PKCS5, 
        l_key 
    ); 
    RETURN UTL_I18N.RAW_TO_CHAR(l_raw, 'AL32UTF8'); 
EXCEPTION
    WHEN OTHERS THEN
        -- Log error y retornar mensaje de error en caso de falla
        DBMS_OUTPUT.PUT_LINE('Error en desencriptación: ' || SQLERRM);
        RETURN '[DATO ENCRIPTADO - ERROR AL DESENCRIPTAR]';
END;
/

-- =====================================================================
-- SECCIÓN 2: MODIFICACIONES A LAS TABLAS PARA GUARADAR LOS DATOS SENSIBLES
-- =====================================================================

-- Agregar columnas encriptadas para datos sensibles en tabla Cliente
ALTER TABLE Cliente ADD (
    Email_Encriptado RAW(2000),
    Telefono_Encriptado RAW(2000)
);

-- Agregar columnas encriptadas para datos sensibles en tabla Veterinario
ALTER TABLE Veterinario ADD (
    Email_Encriptado RAW(2000),
    Telefono_Encriptado RAW(2000),
    Licencia_Encriptada RAW(2000)
);

-- =====================================================================
-- SECCIÓN 3: MIGRAR DATOS EXISTENTES AL FORMATO ENCRIPTADO
-- =====================================================================

-- Encriptar emails y teléfonos existentes de clientes
UPDATE Cliente 
SET Email_Encriptado = encriptar_dato_sensible(Email),
    Telefono_Encriptado = encriptar_dato_sensible(Telefono);

-- Encriptar emails, teléfonos y licencias existentes de veterinarios
UPDATE Veterinario 
SET Email_Encriptado = encriptar_dato_sensible(Email),
    Telefono_Encriptado = encriptar_dato_sensible(Telefono),
    Licencia_Encriptada = encriptar_dato_sensible(Licencia);

-- Verificar que la encriptación funcionó correctamente
SELECT 
    ID_Cliente,
    Nombre,
    desencriptar_dato_sensible(Email_Encriptado) AS Email_Verificado,
    desencriptar_dato_sensible(Telefono_Encriptado) AS Telefono_Verificado
FROM Cliente 
WHERE ROWNUM <= 5;


SET SERVEROUTPUT ON
DECLARE
  v_email_original VARCHAR2(100);
  v_email_encriptado RAW(2000);
BEGIN
  -- Selecciona un email que NO sea nulo para la prueba
  SELECT Email INTO v_email_original FROM Cliente WHERE ROWNUM = 1;

  -- Llama la función y observa si hay mensajes de error
  v_email_encriptado := encriptar_dato_sensible(v_email_original);

  -- Muestra el resultado
  DBMS_OUTPUT.PUT_LINE('Email Original: ' || v_email_original);
  DBMS_OUTPUT.PUT_LINE('Email Encriptado (RAW): ' || v_email_encriptado);

  IF v_email_encriptado IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('¡FALLO LA ENCRIPTACIÓN!');
  END IF;

END;
/


-- =====================================================================
-- SECCIÓN 4: VISTAS SEGURAS PARA ACCESO A DATOS ENCRIPTADOS
-- =====================================================================

-- Vista segura para clientes con datos desencriptados (solo para usuarios autorizados)
CREATE OR REPLACE VIEW VW_Cliente_Segura AS
SELECT 
    ID_Cliente,
    Nombre,
    Apellido,
    CASE 
        WHEN USER IN ('ADMIN_VET', 'USER_VET') THEN 
            desencriptar_dato_sensible(Email_Encriptado)
        ELSE 
            SUBSTR(desencriptar_dato_sensible(Email_Encriptado), 1, 3) || '***@***.***'
    END AS Email,
    CASE 
        WHEN USER IN ('ADMIN_VET', 'USER_VET') THEN 
            desencriptar_dato_sensible(Telefono_Encriptado)
        ELSE 
            '***-***-' || SUBSTR(desencriptar_dato_sensible(Telefono_Encriptado), -4)
    END AS Telefono,
    Fk_Direccion,
    'DATOS_PROTEGIDOS' AS Nivel_Acceso
FROM Cliente;

-- Vista segura para veterinarios con datos desencriptados
CREATE OR REPLACE VIEW VW_Veterinario_Segura AS
SELECT 
    ID_Veterinario,
    Nombre,
    Apellido,
    CASE 
        WHEN USER = 'ADMIN_VET' THEN 
            desencriptar_dato_sensible(Licencia_Encriptada)
        ELSE 
            'LIC-***-' || SUBSTR(desencriptar_dato_sensible(Licencia_Encriptada), -4)
    END AS Licencia,
    CASE 
        WHEN USER IN ('ADMIN_VET', 'USER_VET') THEN 
            desencriptar_dato_sensible(Email_Encriptado)
        ELSE 
            SUBSTR(desencriptar_dato_sensible(Email_Encriptado), 1, 3) || '***@***.***'
    END AS Email,
    CASE 
        WHEN USER IN ('ADMIN_VET', 'USER_VET') THEN 
            desencriptar_dato_sensible(Telefono_Encriptado)
        ELSE 
            '***-***-' || SUBSTR(desencriptar_dato_sensible(Telefono_Encriptado), -4)
    END AS Telefono,
    Fk_Direccion
FROM Veterinario;

-- =====================================================================
-- SECCIÓN 5: ROW LEVEL SECURITY (RLS) PARA CONTROL DE ACCESO
-- =====================================================================

-- Función RLS para tabla Cliente - los recepcionistas solo pueden ver clientes activos
CREATE OR REPLACE FUNCTION politica_acceso_cliente (
    schema_var IN VARCHAR2,
    table_var IN VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    -- Recepcionistas solo pueden ver clientes con citas activas en los últimos 6 meses
    IF USER = 'RECEPCIONISTA_VET' THEN
        RETURN 'EXISTS (SELECT 1 FROM Cita c, Mascota m WHERE m.Fk_Cliente = ID_Cliente AND c.Fk_Mascota = m.ID_Mascota AND c.Fecha_Cita >= ADD_MONTHS(SYSDATE, -6))';
    -- Veterinarios pueden ver todos los clientes
    ELSIF USER IN ('USER_VET', 'ADMIN_VET') THEN
        RETURN NULL; -- Sin restricciones
    ELSE
        RETURN '1 = 0'; -- Denegar acceso por defecto
    END IF;
END;
/

-- Función RLS para tabla Historial_Medico - control por veterinario
CREATE OR REPLACE FUNCTION politica_historial_medico (
    schema_var IN VARCHAR2,
    table_var IN VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    -- Cada veterinario solo puede ver los historiales que ha creado
    IF USER = 'USER_VET' THEN
        RETURN 'Fk_Veterinario = (SELECT ID_Veterinario FROM Veterinario WHERE UPPER(Nombre || '' '' || Apellido) = USER)';
    -- Admin puede ver todo
    ELSIF USER = 'ADMIN_VET' THEN
        RETURN NULL;
    -- Recepcionistas pueden ver solo información básica de los últimos 30 días
    ELSIF USER = 'RECEPCIONISTA_VET' THEN
        RETURN 'Fecha >= SYSDATE - 30';
    ELSE
        RETURN '1 = 0'; -- Denegar acceso
    END IF;
END;
/

-- Aplicar políticas RLS
BEGIN
    -- Política para tabla Cliente
    DBMS_RLS.ADD_POLICY(
        object_schema => USER,
        object_name => 'Cliente',
        policy_name => 'POL_ACCESO_CLIENTE',
        function_schema => USER,
        policy_function => 'politica_acceso_cliente',
        statement_types => 'SELECT'
    );
    
    -- Política para tabla Historial_Medico
    DBMS_RLS.ADD_POLICY(
        object_schema => USER,
        object_name => 'Historial_Medico',
        policy_name => 'POL_HISTORIAL_MEDICO',
        function_schema => USER,
        policy_function => 'politica_historial_medico',
        statement_types => 'SELECT, UPDATE'
    );
END;
/

-- =====================================================================
-- SECCIÓN 6: TABLA DE AUDITORÍA PERSONALIZADA
-- =====================================================================

-- Tabla para logs de acceso a datos sensibles
CREATE TABLE Log_Acceso_Datos_Sensibles (
    ID_Log NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    Usuario VARCHAR2(100) NOT NULL,
    Tabla_Accedida VARCHAR2(100) NOT NULL,
    Operacion VARCHAR2(50) NOT NULL,
    ID_Registro NUMBER,
    Fecha_Acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IP_Cliente VARCHAR2(45),
    Datos_Accedidos VARCHAR2(500),
    CONSTRAINT PK_Log_Acceso PRIMARY KEY (ID_Log)
) TABLESPACE VET_PROYECTO;

-- Auditar accesos a datos de clientes
AUDIT SELECT ON Cliente BY ACCESS;

SELECT * FROM DBA_AUDIT_TRAIL 
WHERE OBJ_NAME = 'CLIENTE' AND ACTION_NAME = 'SELECT';


-- =====================================================================
-- SECCIÓN 7: AUDITORÍAS AVANZADAS ESPECÍFICAS PARA VETERINARIA
-- =====================================================================

-- Auditoría de operaciones críticas en tablas financieras
AUDIT INSERT, UPDATE, DELETE ON Factura BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON Detalle_Factura BY ACCESS;

-- Auditoría de modificaciones en registros médicos
AUDIT INSERT, UPDATE, DELETE ON Historial_Medico BY ACCESS;

-- Auditoría de cambios en inventario de productos
AUDIT UPDATE ON Inventario BY ACCESS;
AUDIT UPDATE ON Producto BY ACCESS;

-- Auditoría de creación y modificación de citas
AUDIT INSERT, UPDATE, DELETE ON Cita BY ACCESS;

-- Auditoría específica para datos de mascotas
AUDIT INSERT, UPDATE, DELETE ON Mascota BY ACCESS;

-- =====================================================================
-- SECCIÓN 8: PERMISOS SEGUROS PARA ROLES
-- =====================================================================

-- Permisos para Rol_Recepcionista sobre vistas seguras
GRANT SELECT ON VW_Cliente_Segura TO Rol_Recepcionista;
GRANT SELECT ON VW_Veterinario_Segura TO Rol_Recepcionista;

-- Denegar acceso directo a tablas originales con datos sensibles
REVOKE SELECT ON Cliente FROM Rol_Recepcionista;
REVOKE SELECT ON Veterinario FROM Rol_Recepcionista;

-- Permisos completos para veterinarios en vistas seguras
GRANT SELECT ON VW_Cliente_Segura TO Rol_Veterinario;
GRANT SELECT ON VW_Veterinario_Segura TO Rol_Veterinario;

-- =====================================================================
-- SECCIÓN 9: PROCEDIMIENTO DE CONSULTA SEGURA DE DATOS
-- =====================================================================

-- Procedimiento para consultar datos de cliente de forma segura
CREATE OR REPLACE PROCEDURE SP_Consultar_Cliente_Seguro (
    p_id_cliente IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    -- Log del acceso
    INSERT INTO Log_Acceso_Datos_Sensibles (
        Usuario, Tabla_Accedida, Operacion, ID_Registro, Datos_Accedidos
    ) VALUES (
        USER, 'Cliente', 'CONSULTA_SEGURA', p_id_cliente, 
        'Consulta segura de cliente ID: ' || p_id_cliente
    );
    
    -- Retornar datos según el nivel de acceso del usuario
    IF USER = 'ADMIN_VET' THEN
        OPEN p_cursor FOR
            SELECT * FROM VW_Cliente_Segura WHERE ID_Cliente = p_id_cliente;
    ELSIF USER IN ('USER_VET', 'RECEPCIONISTA_VET') THEN
        OPEN p_cursor FOR
            SELECT ID_Cliente, Nombre, Apellido, Email, Telefono, Nivel_Acceso
            FROM VW_Cliente_Segura WHERE ID_Cliente = p_id_cliente;
    ELSE
        OPEN p_cursor FOR
            SELECT 'ACCESO DENEGADO' AS Mensaje FROM DUAL;
    END IF;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- =====================================================================
-- SECCIÓN 10: VERIFICACIÓN DE IMPLEMENTACIÓN DE SEGURIDAD
-- =====================================================================

-- Verificar que las funciones de encriptación funcionan
SELECT 
    'TEST ENCRIPTACIÓN' AS Prueba,
    encriptar_dato_sensible('test@email.com') AS Dato_Encriptado,
    desencriptar_dato_sensible(encriptar_dato_sensible('test@email.com')) AS Dato_Desencriptado
FROM DUAL;

-- Verificar políticas RLS activas
SELECT policy_name, object_name, function, enable FROM USER_POLICIES;

-- Verificar auditorías activas
SELECT
    SEL,
    UPD,
    DEL,
    INS,
    OBJECT_NAME
FROM
    USER_OBJ_AUDIT_OPTS
WHERE
    OBJECT_NAME IN ('FACTURA', 'HISTORIAL_MEDICO', 'CLIENTE', 'MASCOTA');

-- Contar registros en log de accesos
SELECT COUNT(*) AS Total_Logs_Acceso FROM Log_Acceso_Datos_Sensibles;


COMMIT;