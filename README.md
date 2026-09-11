# Pre-entrega 3 — Ventas_Tech_DB — Base de Datos de Ventas de Tecnología

Autora: Estefanía Baleiron

Script de desarrollo SQL (`ventas_tech_db.sql`) para la creación y carga inicial de datos de la base de datos **Ventas_Tech_DB**, construida como parte del proyecto para **TechStore / RetailPro**.

---

# Estructura y Arquitectura del Script

El archivo .sql está organizado en 4 bloques lógicos diseñados para ejecutarse en orden sin errores de dependencias:

1. Se creó La base de datos `Ventas_Tech_DB`.
2. Se realizó una limpieza previa (DDL) mediante DROP TABLE IF EXISTS, ordenado de manera inversa a las jerarquías para evitar violaciones de integridad referencial.
3. Se crearon las tablas y se definieron las PK y FK (DDL):
   * *categorias*: Tabla de dimensión independiente con la categorización de productos.
   * *cliente*s: Tabla de dimensión con información demográfica y de contacto.
   * *productos*: Tabla de dimensión con clave foránea referenciada a *categorias*.
   * *ventas*: Tabla de hechos central que vincula a *clientes* y *productos* mediante claves foráneas (FK) y que registra las transacciones comerciales.
4. Se insertaron de manera ordenada los registros iniciales (4 categorías, 5 clientes, 6 productos y 10 transacciones de venta) (DML).
5. Se verificó la carga mediante consultas SELECT finales.

---

# Pre-entrega 4 — Consultas SQL de Negocio

Autora: Estefanía Baleiron

Script SQL (m4_consultas_negocio.sql) enfocado en la extracción de métricas comerciales, rankings y comparativas sobre la base de datos **Ventas_Tech_DB** para la empresa **TechStore / RetailPro**.

---

# Estructura de las Consultas (m4_consultas_negocio.sql)

El script busca resolver 4 consultas sobre la tabla ventas:

1. **Resumen Ejecutivo Mensual:** Métricas agregadas de facturación total (SUM(cantidad * precio_unitario)), cantidad de transacciones (COUNT(*)) y ticket promedio (AVG()), agrupadas por mes mediante MONTH(fecha_venta).
2. **Ranking de Productos (Top 5):** Listado de los 5 productos que generan mayor volumen de ingresos, indicando sus unidades físicas vendidas (TOP 5 con ORDER BY total_facturado DESC).
3. **Análisis de Clientes Recurrentes:** Segmentación de clientes con frecuencia de compra superior a un pedido (GROUP BY id_cliente HAVING COUNT(*) > 1).
4. **Comparativa Mensual vs. Promedio General:** Implementación de una CTE (Common Table Expression) y un bloque condicional `CASE WHEN` para clasificar la facturación mensual en 'Por encima' o 'Por debajo' del promedio global.

---

# Hallazgos Clave de Negocio

Al ejecutar las consultas sobre los datos transaccionales, se destacan las siguientes observaciones comerciales:

1. **Concentración de Ingresos:** El id_producto = 1 representa más del 55% de la facturación total ($3.600,00 sobre $6.444,00), posicionándose como el producto estrella del período.
2. **Comportamiento de clients recurrentes:** La totalidad de los clientes registrados realizó 2 pedidos, mostrando un índice de recurrencia estable.
3. **Volumen vs. Valor Monetario:** El id_producto = 2 lideró en volumen físico vendido (13 unidades), pero ocupó el 5° puesto en facturación debido a su menor precio unitario.

---

# Pre-entrega 5 — Consultas con JOINs para el proyecto
Autora: Estefanía Baleiron

Script SQL (m5_consultas_joins.sql) enfocado en el cruce de tablas y uniones de conjuntos sobre la base de datos Ventas_Tech_DB para la empresa RetailPro, con el objetivo de crear una vista enriquecida para luego crear el tablero de PowerBI.

Estructura de las Consultas:

**Consulta 1**
    Vista base del proyecto (INNER JOIN): Combinación de la tabla de ventas con las tablas dimensionales (clientes, productos y categorias) para obtener en una sola fila la fecha, identificación y ciudad del cliente, descripción del producto, categoría, cantidades, precios unitarios y total de venta.

**Consulta 2**
  Clientes sin ventas (LEFT JOIN): Identificación de clientes registrados que aún no han realizado ninguna compra, mostrando nombre, email y fecha de registro mediante el uso de WHERE ... IS NULL. En este caso, todos los clientes ya realizaron al menos una compra, por lo cual no se muestra ningún resultado.

**Consulta 3**
  Productos sin ventas (LEFT JOIN): Identificación de artículos del catálogo que no tienen ninguna venta registrada, mostrando nombre del producto, categoría y precio mediante el uso de WHERE ... IS NULL. En este caso, todos los artículos ya tienen al menos una venta registrada, por lo cual no se muestra ningún resultado.

**Consulta 4**
  Consolidado por canal (UNION ALL): Implementación de una CTE (VentasPorCanal) con dos SELECT separados para generar de forma literal las columnas de canal ('Presencial' y 'Online'), cerrando con un GROUP BY para totalizar la facturación y el recuento de operaciones sin eliminar filas repetidas.

**Hallazgos Clave de Integración**

Vista para Power BI: El uso de INNER JOIN consolida todas las dimensiones clave del modelo en una sola tabla, la cual sirve para la construcción de métricas y filtros en el dashboard.

Control de Inactividad: Las consultas con LEFT JOIN y filtros de nulidad nos permiten detectar de forma temprana clientes inactivos y artículos del catálogo sin movimiento registrados.

Generación Artificial de Canales: Como la base de datos original no traía separadas las ventas por canal, usamos una CTE para unir los datos. Esto nos permite simular de dónde vino cada compra (presencial u online) sin perder el detalle de ninguna transacción individual.
