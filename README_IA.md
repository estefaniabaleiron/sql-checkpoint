# RetailPro — Proyecto de Análisis de Datos, SQL, ETL y Business Intelligence

**Autora:** Estefanía Baleiron

Proyecto integral de Business Intelligence y Data Analytics desarrollado para **RetailPro / TechStore**. El proyecto abarca desde la formulación del problema de negocio, el diseño relacional y la implementación en SQL, hasta la construcción de un pipeline ETL, modelado dimensional en Power BI, definición de medidas DAX y desarrollo de un dashboard ejecutivo interactivo para la toma de decisiones estratégicas.

---

## Herramientas Utilizadas

* **Base de Datos y Lenguaje SQL:** SQL Server (DDL, DML, CTE, JOINs, Funciones de agregación) — Pre-entregas 3, 4 y 5.
* **Modelado de Datos:** dbdiagram.io (Diagramación ER) y Modelo en Estrella (Star Schema) — Pre-entregas 2 y 8.
* **ETL y Limpieza de Datos:** Power Query y Lenguaje M (Power BI Desktop) — Pre-entrega 6.
* **Business Intelligence y Analytics:** Power BI Desktop, Lenguaje DAX y Diseño UX/UI de Dashboards — Pre-entregas 7 y 8.
* **Control de Versiones:** GitHub y Markdown — Documentación general del proyecto.

---

## Pre-entrega 1 — Brief y Definición del Proyecto

### Qué se hizo
Se desarrolló el brief conceptual inicial del proyecto RetailPro, diferenciando las fuentes transaccionales de los datasets analíticos, definiendo el problema central de negocio, delimitando el alcance del proyecto, formulando las preguntas analíticas clave y estableciendo los KPIs estratégicos.

### Problema / Necesidad de Negocio
RetailPro identificó que un porcentaje reducido de su cartera de clientes genera la mayor parte de las ventas totales. Existía la necesidad crítica de comprender qué hábitos de compra (categorías de productos elegidas, distribución regional y frecuencia de pedido) caracterizan a estos clientes de alta rentabilidad.

### Objetivo
Establecer las bases de información para diseñar un modelo analítico que permita diagnosticar la concentración de facturación en clientes VIP y definir acciones estratégicas de fidelización e incremento del ticket promedio.

### Principales Preguntas de Análisis y KPIs
* **Preguntas de Análisis:**
  * ¿Qué características comparten los clientes que generan el mayor volumen de ventas para RetailPro?
  * ¿Qué segmentos de clientes presentan el ticket promedio más alto?
  * ¿Qué categorías de productos compran con mayor frecuencia los clientes de mayor volumen?
  * ¿Existen diferencias en el comportamiento de compra según la región o territorio?
  * ¿Qué porcentaje de las ventas proviene de clientes recurrentes?
  * ¿Qué segmentos de clientes realizan compras con mayor frecuencia?
* **KPIs Definidos:**
  * **Ticket Promedio por Transacción:** `SUM(Total_Venta) / COUNT(ID_Venta)`
  * **Tasa de Clientes Recurrentes (%):** `(Clientes Recurrentes / Total Clientes) * 100`
  * **Frecuencia Promedio de Compra:** `COUNT(ID_Venta) / COUNT(DISTINCT ID_Cliente)`
  * **Facturación Promedio por Cliente ($):** `SUM(Total_Venta) / COUNT(DISTINCT ID_Cliente)`

### Fuentes de Datos Identificadas
* **Clientes:** Atributos demográficos y comerciales (`id_cliente`, `nombre`, `edad`, `genero`, `ciudad`, `fecha_registro`, `segmento`).
* **Productos:** Catálogo comercial (`id_producto`, `nombre_producto`, `categoria`, `subcategoria`, `marca`, `precio`, `costo`).
* **Ventas:** Registro transaccional (`id_venta`, `fecha_venta`, `id_cliente`, `id_producto`, `id_territorio`, `cantidad`, `total_venta`, `canal`).
* **Territorio:** Segmentación geográfica (`id_territorio`, `region`, `pais`, `zona`).
* **Calendario:** Dimensión temporal (`fecha`, `día`, `mes`, `trimestre`, `año`, `día_semana`).

### Origen del Proyecto
Esta etapa sirvió como el documento de requerimientos funcionales que dio origen al proyecto, definiendo la estructura que debía tener la base de datos relacional para poder responder cada pregunta comercial.

---

## Pre-entrega 2 — Introducción a las Bases de Datos Relacionales y PostgreSQL

### Qué se hizo
Se diseñó la arquitectura del modelo de datos relacional mediante dbdiagram.io, traduciendo las fuentes de datos identificadas en la Pre-entrega 1 en un modelo de entidad-relación estructurado y normalizado.

### Modelo Relacional y Tablas Definidas
* **`clientes` (Dimensión):** Almacena perfiles demográficos y comerciales (`id_cliente` [PK], `nombre`, `email`, `edad`, `genero`, `ciudad`, `segmento`, `fecha_registro`).
* **`productos` (Dimensión):** Contiene el catálogo de artículos (`id_producto` [PK], `nombre_producto`, `categoria`, `subcategoria`, `marca`, `precio`, `costo`).
* **`territorios` (Dimensión):** Registra la ubicación geográfica (`id_territorio` [PK], `region`, `pais`, `zona`).
* **`ventas` (Tabla de Hechos):** Registra las operaciones comerciales (`id_venta` [PK], `fecha_venta`, `id_cliente` [FK], `id_producto` [FK], `id_territorio` [FK], `cantidad`, `total_venta`, `canal`).

### Aplicación de las Formas Normales
* **Primera Forma Normal (1NF):** Se garantizó la atomicidad de los datos (cada campo contiene un valor indivisible), sin grupos repetidos ni columnas duplicadas para el mismo concepto. Se definieron claves primarias explícitas y tipos de datos estrictos (INT, VARCHAR, DECIMAL, DATE).
* **Segunda Forma Normal (2NF):** Se eliminaron dependencias parciales estableciendo claves primarias simples de un solo atributo en todas las tablas, garantizando que los atributos no clave dependan funcionalmente del 100% de la PK.
* **Tercera Forma Normal (3NF):** Se eliminaron dependencias transitivas aislando atributos en sus tablas maestras. Por ejemplo, los atributos `categoria` y `costo` dependen únicamente de `id_producto`, mientras que la información demográfica depende de `id_cliente`.

### Principales Decisiones de Modelado
* **Aislamiento de Redundancia:** La tabla `ventas` almacena exclusivamente claves foráneas y métricas numéricas transaccionales (`cantidad`, `total_venta`), evitando duplicaciones y anomalías de actualización.
* **Inclusión de Campos Estratégicos:** Se incluyó la columna `segmento` en `clientes` para evaluar categorías de clientes (Corp VIP, Corp Std, Mayoristas, Retail) y `subcategoria` en `productos` para análisis de margen detallado.

### Herramienta Utilizada
dbdiagram.io y entorno de modelado PostgreSQL.

### Conexión con la Base SQL
Este diseño constituyó el plano de arquitectura exacto para la posterior creación física del esquema DDL en SQL.

---

## Pre-entrega 3 — Base de Datos SQL

### Creación de Ventas_Tech_DB
Desarrollo del script SQL (`ventas_tech_db.sql`) para la creación y carga inicial de la base de datos **Ventas_Tech_DB**, construida para **TechStore / RetailPro**.

### DDL, DML y Arquitectura del Script
El script se estructuró en 4 bloques lógicos para garantizar una ejecución secuencial sin violaciones de integridad referencial:
1. **Creación de la Base de Datos:** Definición e inicialización de `Ventas_Tech_DB`.
2. **Limpieza Previa (DDL):** Sentencias `DROP TABLE IF EXISTS` ordenadas en secuencia inversa a la jerarquía de dependencias para eliminar tablas previas de manera limpia.
3. **Creación de Tablas (DDL):**
   * `categorias`: Tabla de dimensión independiente.
   * `clientes`: Tabla de dimensión demográfica.
   * `productos`: Tabla de dimensión con clave foránea (`FK`) hacia `categorias`.
   * `ventas`: Tabla de hechos central vinculada a `clientes` y `productos` mediante claves foráneas (`FK`).
4. **Carga Inicial de Datos (DML):** Inserción ordenada de registros iniciales (4 categorías, 5 clientes, 6 productos y 10 transacciones de venta).
5. **Verificación de Carga:** Sentencias `SELECT` de comprobación para validar la integridad de los datos cargados.

**Conexión con el proyecto:** La base de datos SQL construida en esta etapa permite realizar las consultas de negocio planteadas en la Pre-entrega 4.

---

## Pre-entrega 4 — Consultas SQL de Negocio

### Objetivo de las Consultas
Extraer métricas comerciales, rankings y comparativas sobre la base de datos `Ventas_Tech_DB` mediante el script `m4_consultas_negocio.sql`.

### Estructura de las Consultas
1. **Resumen Ejecutivo Mensual:** Cálculo de métricas agregadas de facturación total (`SUM(cantidad * precio_unitario)`), total de transacciones (`COUNT(*)`) y ticket promedio (`AVG()`), agrupadas por mes mediante `MONTH(fecha_venta)`.
2. **Ranking de Productos (Top 5):** Identificación de los 5 productos con mayor volumen de ingresos monetarios e indicación de sus unidades vendidas (`TOP 5` con `ORDER BY total_facturado DESC`).
3. **Análisis de Clientes Recurrentes:** Segmentación de clientes con frecuencia de compra superior a una orden (`GROUP BY id_cliente HAVING COUNT(*) > 1`).
4. **Comparativa Mensual vs. Promedio General:** Implementación de una CTE (*Common Table Expression*) y un bloque condicional `CASE WHEN` para clasificar la facturación mensual en "Por encima" o "Por debajo" del promedio global de ventas.

### Hallazgos Clave de Negocio
* **Concentración de Ingresos:** El `id_producto = 1` concentró más del 55% de la facturación total ($3.600,00 sobre $6.444,00), posicionándose como el producto líder del catálogo.
* **Comportamiento Recurrente:** El 100% de los clientes registrados realizó exactamente 2 pedidos en el período analizado, mostrando un índice de recurrencia parejo.
* **Volumen vs. Valor Monetario:** El `id_producto = 2` lideró en volumen físico de unidades vendidas (13 unidades), pero ocupó la 5ª posición en facturación debido a su menor precio unitario.

**Conexión con el proyecto:** Las consultas y resultados obtenidos en esta etapa sirven como base para los cruces y análisis desarrollados en la Pre-entrega 5.

---

## Pre-entrega 5 — Consultas SQL con JOINs

### Objetivo
Realizar cruces de tablas y uniones de conjuntos sobre `Ventas_Tech_DB` (`m5_consultas_joins.sql`) para generar una vista analítica unificada destinada a alimentar el modelo de Power BI.

### Estructura de las Consultas
* **Consulta 1 — Vista Base (INNER JOIN):** Combinación de la tabla de hechos `ventas` con las tablas de dimensión (`clientes`, `productos` y `categorias`) para consolidar en una sola fila la fecha, cliente, ciudad, descripción del producto, categoría, cantidades, precios y total vendido.
* **Consulta 2 — Clientes sin Ventas (LEFT JOIN):** Identificación de clientes registrados sin operaciones comerciales mediante el filtro `WHERE ... IS NULL`. Se verificó que todos los clientes registrados poseen al menos una compra activa.
* **Consulta 3 — Productos sin Ventas (LEFT JOIN):** Detección de artículos del catálogo sin transacciones registradas mediante `WHERE ... IS NULL`. Se confirmó movimiento comercial en todos los productos del catálogo.
* **Consulta 4 — Consolidado por Canal (UNION ALL):** Definición de una CTE (`VentasPorCanal`) con dos `SELECT` unificados para clasificar explícitamente las operaciones por canal ("Presencial" y "Online"), aplicando un `GROUP BY` final para totalizar facturación y transacciones sin omitir registros duplicados.

### Hallazgos Clave de Integración
* **Vista Analítica para Power BI:** El uso de `INNER JOIN` permitió construir la tabla plana base para el desarrollo del modelo relacional en la herramienta de BI.
* **Control de Inactividad:** La técnica de `LEFT JOIN` con exclusión de nulos dejó preparada la estructura de auditoría para detectar futuros clientes o productos inactivos.
* **Estructuración por Canal:** La integración mediante CTE y `UNION ALL` facilitó la simulación y segmentación de ventas según el medio comercial.

**Conexión con el proyecto:** Los cruces y la vista analítica generados en esta etapa preparan la información de manera estructurada para las fases de Business Intelligence.

---

## Pre-entrega 6 — Pipeline ETL con Power Query y Lenguaje M

### Descripción
Construcción del pipeline ETL (*Extracción, Transformación y Carga*) en Power BI Desktop (`Pipeline_ETL_Baleiron_Estefania.pbix`) utilizando Power Query y lenguaje M. El objetivo fue diagnosticar, limpiar, transformar y documentar la base de datos para garantizar la consistencia del modelo.

### Tabla de Control de Calidad

| Consulta | Tipo de Tabla | Filas Iniciales | Filas Finales | Estado / Transformaciones Principales |
| :--- | :--- | :---: | :---: | :--- |
| **`Dim_Clientes`** | Dimensión | 12 | **11** | Eliminación de duplicado por PK y tratamiento de nulos. |
| **`Dim_Productos`** | Dimensión | 13 | **12** | Eliminación de duplicado por PK e imputación técnica de nulos. |
| **`Dim_Categorias`** | Dimensión | 4 | **4** | Tabla maestra validada sin errores. |
| **`Fact_Ventas`** | Tabla de Hechos | 50 | **50** | Enriquecida mediante Merge con `Dim_Productos`. |

### Detalle de Transformaciones y Justificación Técnica
* **`Dim_Clientes`:**
  * *Eliminación de duplicados:* Se removió el registro duplicado evaluando strictly la clave primaria `id_cliente = 1`.
  * *Email nulo (`id_cliente = 9` - Valentina Paz):* Reemplazado por `"Sin Email"` para conservar el registro del cliente y evitar la pérdida de transacciones históricas en `Fact_Ventas`.
  * *Ciudad nula (`id_cliente = 11` - Roberto Díaz):* Reemplazado por `"Sin Dato"` para mantener la integridad de la fila.
  * *Tipado:* Conversión de `fecha_registro` a tipo `Fecha`.
* **`Dim_Productos`:**
  * *Eliminación de duplicados:* Eliminación del registro duplicado sobre la clave `id_producto = 103`.
  * *Precio nulo (`id_producto = 109` - SSD Externo 1TB):* Imputación del valor `130.00` identificando el precio unitario histórico registrado en las ventas de `Fact_Ventas`.
  * *Categoría nula (`id_producto = 111` - Laptop Gaming Pro):* Reemplazado por `"Computación"`, infiriendo el valor desde su subcategoría `"Laptops"`.
  * *Tipado:* Configuración de `precio` y `costo` a tipo `Número Decimal`.
* **`Fact_Ventas`:**
  * *Combinación de consultas (Merge):* Cruzada con `Dim_Productos` mediante clave `id_producto`.
  * *Expansión acotada:* Expansión de las columnas `nombre_producto` y `categoria`.
  * *Tipado:* Conversión de `fecha_venta` a tipo `Fecha`.

### Documentación en Lenguaje M
Todas las transformaciones aplicadas fueron documentadas en el Editor Avanzado mediante comentarios explícitos (`//`), explicando la lógica analítica de cada paso.

**Conexión con el proyecto:** El proceso ETL limpia y prepara los datos para garantizar un modelado dimensional y un análisis preciso en Power BI.

---

## Pre-entrega 7 — Diseño y Layout del Dashboard

### Objetivo del Dashboard
Identificar las causas de la concentración de ventas en los clientes más rentables mediante el análisis de sus hábitos de compra (frecuencia, ticket promedio, distribución regional y productos elegidos) para planificar acciones estratégicas de fidelización.

### Público Objetivo
Gerencia ejecutiva y equipo directivo comercial de RetailPro.

### Wireframe y Layout
Diseño estructurado siguiendo los principios de la Zona de Oro visual (KPIs en el borde superior, gráficos de tendencia y distribución en la zona media, y tabla operativa detallada en el sector inferior).

### KPIs Principales (Zona de Oro)
* **Ticket Promedio:** **$45.200** (+5,2% vs. mes anterior).
* **Tasa Clientes Recurrentes:** **38,5%** (+2,1% vs. objetivo).
* **Frecuencia Compra:** **3,2 órdenes** (Promedio por cliente).
* **Fact. Prom / Cliente:** **$145.000** (+12,8% vs. trimestre anterior).

### Distribución de Visualizaciones
* **Gráfico de Líneas (Zona Media Izquierda):** Muestra la *Evolución Mensual de Ventas* (Enero - Junio), permitiendo identificar estacionalidad y picos de facturación.
* **Gráfico de Barras Horizontales (Zona Media Derecha):** Representa las *Ventas por Región (Geográfico)*, jerarquizando las zonas de mayor aporte (Norte: $650K, Sur: $420K, Centro: $310K, Este: $150K, Oeste: $70K).
* **Tabla Detallada (Zona Inferior):** *Ranking Top Clientes*, con desglose por Cliente, Tipo Segmento, Categoría Top, Facturación Total, % Participación, Frecuencia y Estado.

### Criterios de UX/UI y Decisiones de Diseño
* **Control de Carga Cognitiva:** Limitado a menos de 6 elementos visuales principales por pantalla.
* **Resumen vs. Detalle:** Separación clara entre visión ejecutiva estratégica y consulta operativa granular.
* **Tooltip Interactivo:** Configurado sobre la línea de evolución temporal y regiones para desplegar la *Categoría Top* y el *Producto Estrella* al pasar el cursor, sin saturar la vista principal.

**Conexión con el proyecto:** El diseño del dashboard define la estructura visual y los componentes funcionales que luego se implementan en Power BI.

---

## Pre-entrega 8 — Modelo de Datos y Medidas DAX

### Modelo de Datos y Esquema Estrella
Implementación de un modelo dimensional en esquema estrella (*Star Schema*) dentro de Power BI Desktop, compuesto por una tabla de hechos central (`Fact_Ventas`) conectada a las tablas dimensionales (`Dim_Clientes`, `Dim_Productos`, `Dim_Categorias` y `Dim_Territorios`) y una tabla analítica de calendario (`Dim_Calendario`).

### Relaciones del Modelo
* Relaciones de **1 a Muchos (1:N)** desde las tablas maestras dimensionales hacia la tabla transaccional `Fact_Ventas`.
* Dirección de filtro cruzado unidireccional para garantizar la consistencia en la propagación de filtros.

### Tabla de Fechas
Creación de la tabla dimensional `Dim_Calendario` integrada al modelo para soportar agrupaciones temporales (año, trimestre, mes, día) y habilitar cálculos con funciones de inteligencia de tiempo.

### Medidas DAX Desarrolladas
Todas las medidas se organizaron dentro de una tabla dedicada (`_Medidas`) para optimizar el mantenimiento del modelo:

* **Ticket Promedio:**
  ```dax
  Ticket Promedio = DIVIDE(SUM(Fact_Ventas[total_venta]), COUNT(Fact_Ventas[id_venta]))
