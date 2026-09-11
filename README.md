Ventas_Tech_DB — Base de Datos de Ventas de Tecnología

Autora: Estefanía Baleiron

Script de desarrollo SQL (ventas_tech_db.sql) para la creación y carga inicial de datos de la base de datos Ventas_Tech_DB, construida como parte del proyecto para TechStore / RetailPro.

Estructura y Arquitectura del Script
El archivo .sql está organizado en 4 bloques lógicos diseñados para ejecutarse en orden sin errores de dependencias:

Se creó La base de datos Ventas_Tech_DB.
Se realizó una limpieza previa (DDL) mediante DROP TABLE IF EXISTS, ordenado de manera inversa a las jerarquías para evitar violaciones de integridad referencial.
Se crearon las tablas y se definieron las PK y FK (DDL):
categorias: Tabla de dimensión independiente con la categorización de productos.
clientes: Tabla de dimensión con información demográfica y de contacto.
productos: Tabla de dimensión con clave foránea referenciada a categorias.
ventas: Tabla de hechos central que vincula a clientes y productos mediante claves foráneas (FK) y que registra las transacciones comerciales.
Se insertaron de manera ordenada los registros iniciales (4 categorías, 5 clientes, 6 productos y 10 transacciones de venta) (DML).
Se verificó la carga mediante consultas SELECT finales.

