-- =====================================================================
-- SCRIPT DE PRUEBAS Y EJEMPLOS DE SEGURIDAD
--          Este script sirve para probar
--          las funcionalidades de seguridad implementadas
-- Ejecutar después de 4_Seguridad_Veterinaria.sql
-- Ejecutar en Admin_Vet
-- =====================================================================

-- =====================================================================
-- SECCIÓN 1: EJEMPLOS DE USO DE ENCRIPTACIÓN
-- =====================================================================

-- Insertar un nuevo cliente de prueba con los datos encriptados
INSERT INTO Cliente (Nombre, Apellido, Email, Telefono, Fk_Direccion, Email_Encriptado, Telefono_Encriptado)
VALUES (
    'María', 
    'González', 
    'maria.gonzalez@prueba.com',  -- Dato original (se mantendrá temporalmente)
    '8888-8888',                   -- Dato original (se mantendrá temporalmente)
    1,
    encriptar_dato_sensible('maria.gonzalez@prueba.com'),  -- Dato encriptado
    encriptar_dato_sensible('8888-8888')                    -- Dato encriptado
);

-- Consultar datos usando la vista segura
SELECT * FROM VW_Cliente_Segura WHERE Nombre = 'María';

-- Ejemplo de consulta usando el procedimiento seguro
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_nombre VARCHAR2(100);
    v_apellido VARCHAR2(100);
    v_email VARCHAR2(100);
    v_telefono VARCHAR2(100);
    v_fk_direccion NUMBER;
    v_nivel_acceso VARCHAR2(100);
BEGIN
    
    SP_Consultar_Cliente_Seguro(v_id, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_id, v_nombre, v_apellido, v_email, v_telefono, v_fk_direccion, v_nivel_acceso;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            'Cliente: ' || v_nombre || ' ' || v_apellido ||  
            ', Email: ' || v_email ||  
            ', Teléfono: ' || v_telefono ||  
            ', Dirección ID: ' || v_fk_direccion ||
            ', Acceso: ' || v_nivel_acceso
        );
    END LOOP;
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error de procesamiento o Acceso Restringido: ' || SQLERRM);
END;
/

-- =====================================================================
-- SECCIÓN 2: PRUEBAS DE ROW LEVEL SECURITY
-- =====================================================================

-- Crear datos de prueba para verificar RLS
INSERT INTO Veterinario (Nombre, Apellido, Licencia, Email, Telefono, Fk_Direccion,
                        Licencia_Encriptada, Email_Encriptado, Telefono_Encriptado)
VALUES (
    'Dr. Carlos', 
    'Ramírez', 
    'VET-2025-001',
    'carlos.ramirez@vet.com',
    '2222-5555',
    1,
    encriptar_dato_sensible('VET-2025-001'),
    encriptar_dato_sensible('carlos.ramirez@vet.com'),
    encriptar_dato_sensible('2222-5555')
);

-- Insertar mascota para pruebas
INSERT INTO Mascota (Nombre, Especie, Raza, Fk_Cliente, Edad, Peso, Notas)
VALUES ('Firulais', 'Perro', 'Labrador', 1, 3, 25.5, 'Mascota muy activa');

-- Insertar historial médico para pruebas
INSERT INTO Historial_Medico (Fk_Mascota, Fk_Veterinario, Fecha, Observaciones)
VALUES (1, 1, SYSDATE, 'Chequeo general - mascota en buen estado de salud');

-- =====================================================================
-- SECCIÓN 3: SCRIPT DE VERIFICACIÓN DE SEGURIDAD
-- =====================================================================

-- Verificar encriptación de datos existentes
SELECT 
    'VERIFICACIÓN DE ENCRIPTACIÓN' AS Titulo,
    COUNT(*) AS Total_Clientes_Encriptados
FROM Cliente 
WHERE Email_Encriptado IS NOT NULL AND Telefono_Encriptado IS NOT NULL;

-- Verificar funcionamiento de desencriptación
SELECT 
    ID_Cliente,
    Nombre,
    Email AS Email_Original,
    desencriptar_dato_sensible(Email_Encriptado) AS Email_Desencriptado,
    CASE 
        WHEN Email = desencriptar_dato_sensible(Email_Encriptado) THEN 'CORRECTO'
        ELSE 'ERROR'
    END AS Estado_Encriptacion
FROM Cliente
WHERE ROWNUM <= 3;

-- =====================================================================
-- SECCIÓN 4: CONSULTAS DE MONITOREO DE SEGURIDAD
-- =====================================================================

-- Vista para monitorear accesos a datos sensibles
CREATE OR REPLACE VIEW VW_Monitor_Accesos AS
SELECT 
    Usuario,
    Tabla_Accedida,
    Operacion,
    COUNT(*) AS Total_Accesos,
    MAX(Fecha_Acceso) AS Ultimo_Acceso,
    MIN(Fecha_Acceso) AS Primer_Acceso
FROM Log_Acceso_Datos_Sensibles
GROUP BY Usuario, Tabla_Accedida, Operacion
ORDER BY Total_Accesos DESC;

-- Consulta para detectar actividad sospechosa
CREATE OR REPLACE VIEW VW_Actividad_Sospechosa AS
SELECT 
    Usuario,
    Tabla_Accedida,
    COUNT(*) AS Accesos_Frecuentes,
    MAX(Fecha_Acceso) AS Ultimo_Acceso
FROM Log_Acceso_Datos_Sensibles
WHERE Fecha_Acceso >= SYSDATE - 1  -- Últimas 24 horas
GROUP BY Usuario, Tabla_Accedida
HAVING COUNT(*) > 10  -- Más de 10 accesos en 24 horas
ORDER BY Accesos_Frecuentes DESC;

-- =====================================================================
-- SECCIÓN 5: PROCEDIMIENTOS DE MANTENIMIENTO DE SEGURIDAD
-- =====================================================================

-- Procedimiento para limpiar logs antiguos
CREATE OR REPLACE PROCEDURE SP_Limpiar_Logs_Antiguos (
    p_dias_antiguedad IN NUMBER DEFAULT 90
) IS
    v_registros_eliminados NUMBER;
BEGIN
    DELETE FROM Log_Acceso_Datos_Sensibles 
    WHERE Fecha_Acceso < SYSDATE - p_dias_antiguedad;
    
    v_registros_eliminados := SQL%ROWCOUNT;
    
    INSERT INTO Log_Acceso_Datos_Sensibles (
        Usuario, Tabla_Accedida, Operacion, Datos_Accedidos
    ) VALUES (
        USER, 'Log_Acceso_Datos_Sensibles', 'LIMPIEZA_AUTOMATICA',
        'Eliminados ' || v_registros_eliminados || ' registros de más de ' || p_dias_antiguedad || ' días'
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Limpieza completada: ' || v_registros_eliminados || ' registros eliminados');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en limpieza de logs: ' || SQLERRM);
        RAISE;
END;
/

-- Procedimiento para generar reporte de seguridad
CREATE OR REPLACE PROCEDURE SP_Reporte_Seguridad IS
    CURSOR c_resumen IS
        SELECT 
            'Total de clientes con datos encriptados' AS Metrica,
            COUNT(*) AS Valor
        FROM Cliente 
        WHERE Email_Encriptado IS NOT NULL
        UNION ALL
        SELECT 
            'Total de veterinarios con datos encriptados',
            COUNT(*)
        FROM Veterinario 
        WHERE Email_Encriptado IS NOT NULL
        UNION ALL
        SELECT 
            'Total de políticas RLS activas',
            COUNT(*)
        FROM USER_POLICIES
        UNION ALL
        SELECT 
            'Total de logs de acceso (última semana)',
            COUNT(*)
        FROM Log_Acceso_Datos_Sensibles 
        WHERE Fecha_Acceso >= SYSDATE - 7;
        
    v_metrica VARCHAR2(200);
    v_valor NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== REPORTE DE SEGURIDAD VETERINARIA ===');
    DBMS_OUTPUT.PUT_LINE('Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    FOR rec IN c_resumen LOOP
        DBMS_OUTPUT.PUT_LINE(rec.Metrica || ': ' || rec.Valor);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('=== FIN DEL REPORTE ===');
END;
/

-- =====================================================================
-- SECCIÓN 6: TRIGGERS DE AUDITORÍA
-- =====================================================================

-- Trigger para auditar cambios en inventario
CREATE OR REPLACE TRIGGER TR_AUDIT_INVENTARIO
    BEFORE UPDATE ON Inventario
    FOR EACH ROW
BEGIN
    -- Solo auditar cambios significativos en cantidad
    IF ABS(:NEW.Cantidad - :OLD.Cantidad) >= 5 OR :NEW.Precio_U != :OLD.Precio_U THEN
        INSERT INTO Log_Acceso_Datos_Sensibles (
            Usuario, Tabla_Accedida, Operacion, ID_Registro, Datos_Accedidos
        ) VALUES (
            USER, 'Inventario', 'UPDATE_SIGNIFICATIVO', :NEW.ID_Stock,
            'Cantidad: ' || :OLD.Cantidad || ' -> ' || :NEW.Cantidad || 
            ', Precio: ' || :OLD.Precio_U || ' -> ' || :NEW.Precio_U
        );
    END IF;
END;
/

-- Trigger para auditar modificaciones en datos financieros
CREATE OR REPLACE TRIGGER TR_AUDIT_FACTURA
    AFTER INSERT OR UPDATE OR DELETE ON Factura
    FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_detalles VARCHAR2(500);
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_detalles := 'Nueva factura - Cliente: ' || :NEW.Fk_Cliente || ', Total: ' || :NEW.Total;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_detalles := 'Factura modificada - ID: ' || :NEW.ID_Factura || 
                     ', Total anterior: ' || :OLD.Total || ', Nuevo total: ' || :NEW.Total;
    ELSE
        v_operacion := 'DELETE';
        v_detalles := 'Factura eliminada - ID: ' || :OLD.ID_Factura || ', Total: ' || :OLD.Total;
    END IF;
    
    INSERT INTO Log_Acceso_Datos_Sensibles (
        Usuario, Tabla_Accedida, Operacion, 
        ID_Registro, Datos_Accedidos
    ) VALUES (
        USER, 'Factura', v_operacion,
        COALESCE(:NEW.ID_Factura, :OLD.ID_Factura),
        v_detalles
    );
END;
/

-- =====================================================================
-- SECCIÓN 7: EJEMPLOS DE CONSULTAS PARA DIFERENTES USUARIOS
-- =====================================================================

-- Consulta para recepcionista (datos limitados)
SELECT 'Consulta para RECEPCIONISTA_VET' AS Usuario_Tipo,
       COUNT(*) AS Total_Clientes_Visibles
FROM VW_Cliente_Segura;

-- Consulta para veterinario (acceso completo a sus casos)
SELECT 'Datos disponibles para USER_VET' AS Usuario_Tipo,
       COUNT(*) AS Total_Historiales_Visibles
FROM Historial_Medico;

-- =====================================================================
-- SECCIÓN 8: PRUEBAS DE RENDIMIENTO
-- =====================================================================

-- Verificar impacto de encriptación en rendimiento
SELECT 
    'RENDIMIENTO - Consulta normal' AS Tipo,
    COUNT(*) AS Registros,
    SYSDATE AS Tiempo_Inicio
FROM Cliente;

SELECT 
    'RENDIMIENTO - Consulta con desencriptación' AS Tipo,
    COUNT(*) AS Registros,
    SYSDATE AS Tiempo_Inicio
FROM VW_Cliente_Segura;

-- =====================================================================
-- SECCIÓN 9: COMANDOS DE ADMINISTRACIÓN
-- =====================================================================

-- Ejecutar reporte de seguridad
EXEC SP_Reporte_Seguridad;

-- Verificar logs recientes
SELECT * FROM Log_Acceso_Datos_Sensibles 
WHERE Fecha_Acceso >= SYSDATE - 1
ORDER BY Fecha_Acceso DESC;

-- Verificar estado de políticas RLS
SELECT policy_name, object_name, enable, sel, ins, upd, del
FROM USER_POLICIES;

-- =====================================================================
-- SECCIÓN 10: LIMPIEZA Y MANTENIMIENTO
-- =====================================================================

-- Limpiar logs antiguos (más de 30 días)
-- EXEC SP_Limpiar_Logs_Antiguos(30);

-- Verificar integridad de datos encriptados
SELECT 
    'INTEGRIDAD DE DATOS' AS Verificacion,
    COUNT(*) AS Total_Registros,
    SUM(CASE WHEN Email_Encriptado IS NOT NULL THEN 1 ELSE 0 END) AS Con_Email_Encriptado,
    SUM(CASE WHEN Telefono_Encriptado IS NOT NULL THEN 1 ELSE 0 END) AS Con_Telefono_Encriptado
FROM Cliente;

COMMIT;