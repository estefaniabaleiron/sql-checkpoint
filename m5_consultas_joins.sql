-- ============================================================
-- PROYECTO: Ventas_Tech_DB
-- ENTREGABLE: Pre-entrega 5 - Consultas con JOINs para el proyecto
-- AUTORA: Estefanía Baleiron
-- ============================================================

USE Ventas_Tech_DB;
GO

-- ============================================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Cruza la tabla de hechos (ventas) con todas las dimensiones, con el objetivo de enriquecer los datos para el dashboard en Power BI.
-- ============================================================
SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS ciudad_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- ============================================================
-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- Identifica clientes registrados que no aún no realizaron compras.
-- ============================================================
SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- ============================================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Identifica productos del catálogo que no tienen movimiento.
-- ============================================================
SELECT 
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- ============================================================
-- CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL)
-- Simula un canal de ventas dividiendo las transacciones en ¨Presencial¨ (clientes 1 y 2) y ¨Online¨ (clientes 3, 4 y 5). Se agrupa el resultado final para obtener el total.
-- ============================================================
WITH VentasPorCanal AS (
    -- Canal Presencial
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE id_cliente IN (1, 2)
    
    UNION ALL
    
    -- Canal Online
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM ventas
    WHERE id_cliente IN (3, 4, 5)
)
SELECT 
    canal,
    SUM(total) AS total_facturado,
    COUNT(*) AS total_transacciones
FROM VentasPorCanal
GROUP BY canal;
