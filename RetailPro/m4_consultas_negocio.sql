-- ============================================================
-- PROYECTO: Ventas_Tech_DB
-- ENTREGABLE: Pre-entrega 4 - Consultas SQL de negocio
-- AUTOR: Estefanía Baleiron
-- ============================================================

USE Ventas_Tech_DB;
GO

-- ============================================================
-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.
-- ============================================================
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- ============================================================
-- CONSULTA 2: RANKING DE PRODUCTOS (TOP 5)
-- Top 5 de id_producto por total facturado, mostrando las unidades vendidas y el total generado.
-- ============================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- ============================================================
-- CONSULTA 3: CLIENTES RECURRENTES
-- Muestra id_cliente que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado.
-- ============================================================
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;


-- ============================================================
-- CONSULTA 4: MESES POR ENCIMA/POR DEBAJO DEL PROMEDIO
-- Compara la facturación mensual contra el promedio mensual general.
-- ============================================================
WITH FacturacionMensual AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM FacturacionMensual) 
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS evaluacion_promedio
FROM FacturacionMensual
ORDER BY mes;


-- ============================================================
-- BLOQUE DE CIERRE: HALLAZGOS CLAVE DE NEGOCIO
-- ============================================================
-- 1. Alta concentración de ingresos en id_producto = 1: El producto 1 generó $3.600,00 representando más del 55% de la facturación total registrada ($6.444,00).
--    
-- 2. Los 5 clientes registrados en la base de datos realizaron exactamente 2 pedidos cada uno durante el período analizado.
--    
-- 3. El id_producto = 2 (Mouse Inalámbrico) fue el producto con mayor volumen físico vendido (13 unidades), pero quedó en el 5° lugar de ingresos debido a su precio unitario.
--    