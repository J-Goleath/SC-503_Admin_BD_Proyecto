-- Ejecutar en ADMIN_VET

-- Vista de Monitoreo#1  Monitorea el espacio usado por el usuario.

SELECT ROUND(SUM(bytes)/1024/1024,2) AS espacio_total_mb
FROM user_segments;


-- Vista de Monitoreo #2 Monitorea el uso del CPU.

SELECT name, value 
FROM v$sysstat
WHERE name LIKE '%CPU used by this session%';

-- Vista de Monitoreo #3 Muestra las consultas mas pesadas.

SELECT sql_id, elapsed_time/1000000 AS segundos, executions
FROM v$sql
WHERE elapsed_time > 10000000
ORDER BY elapsed_time DESC
FETCH FIRST 5 ROWS ONLY;


-- Consulta Ineficiente -- Volver a ejecutar cuando se crean los index para ver la diferencia.
SELECT
    c.Nombre || ' ' || c.Apellido AS Nombre_Cliente,
    m.Nombre AS Nombre_Mascota,
    h.Observaciones,
    v.Nombre || ' ' || v.Apellido AS Nombre_Veterinario
FROM Cliente c
JOIN Mascota m ON c.ID_Cliente = m.Fk_Cliente
JOIN Historial_Medico h ON m.ID_Mascota = h.Fk_Mascota
JOIN Veterinario v ON h.Fk_Veterinario = v.ID_Veterinario
WHERE c.Nombre = 'Juan' AND c.Apellido = 'Pérez';

-- Creación de un índice compuesto para acelerar búsquedas por nombre/apellido del cliente
CREATE INDEX IDX_CLIENTE_NOMBRE_APELLIDO
ON Cliente (Nombre, Apellido)
TABLESPACE VET_PROYECTO;