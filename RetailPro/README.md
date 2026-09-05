# Pre-entrega 4 — Consultas SQL de Negocio

Autora: Estefanía Baleiron

Script SQL (m4_consultas_negocio.sql) enfocado en la extracción de métricas comerciales, rankings y comparativas sobre la base de datos **Ventas_Tech_DB** para la empresa **TechStore / RetailPro**.

---

# Estructura de las Consultas (m4_consultas_negocio.sql)

El script resolver 4 consultas sobre la tabla ventas:

1. Resumen Ejecutivo Mensual: Métricas agregadas de facturación total (SUM(cantidad * precio_unitario)), cantidad de transacciones (COUNT(*)) y ticket promedio (AVG()), agrupadas por mes mediante MONTH(fecha_venta).
2. Ranking de Productos (Top 5): Listado de los 5 productos que generan mayor volumen de ingresos, indicando sus unidades físicas vendidas (TOP 5 con ORDER BY total_facturado DESC).
3. Análisis de Clientes Recurrentes: Segmentación de clientes con frecuencia de compra superior a un pedido (GROUP BY id_cliente HAVING COUNT(*) > 1).
4. Comparativa Mensual vs. Promedio General: Implementación de una CTE (Common Table Expression) y un bloque condicional `CASE WHEN` para clasificar la facturación mensual en 'Por encima' o 'Por debajo' del promedio global.

---

# Hallazgos Clave de Negocio

Al ejecutar las consultas sobre los datos transaccionales, se destacan las siguientes observaciones comerciales:

1. Concentración de Ingresos: El id_producto = 1 representa más del 55% de la facturación total ($3.600,00 sobre $6.444,00), posicionándose como el producto estrella del período.
2. Comportamiento de clients recurrentes: La totalidad de los clientes registrados realizó 2 pedidos, mostrando un índice de recurrencia estable.
3.Volumen vs. Valor Monetario:- El id_producto = 2 lideró en volumen físico vendido (13 unidades), pero ocupó el 5° puesto en facturación debido a su menor precio unitario.

---