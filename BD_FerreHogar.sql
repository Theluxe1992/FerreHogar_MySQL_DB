-- BASE DE DATOS: ferrehogar_db
-- AUTOR: Juan Pablo Alarcón Naranjo

-- LIMPIAR Y CREAR LA BASE DE DATOS EN CASO DE QUERER EJECUTAR EL SCRIPT VARIAS VECES
DROP DATABASE IF EXISTS ferrehogar_db;

CREATE DATABASE ferrehogar_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_spanish_ci;

USE ferrehogar_db;

-- (Tablas independientes que no heredan de ninguna tabla para poder existir)

-- TABLA CLIENTES 
CREATE TABLE IF NOT EXISTS cliente (
	id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) DEFAULT NULL,
    email VARCHAR(100),
    direccion VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA EMPLEADO
CREATE TABLE IF NOT EXISTS empleado (
	id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cedula VARCHAR(20) UNIQUE,
    cargo VARCHAR(50),
    telefono VARCHAR(30),
    email VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA PROVEEDOR
CREATE TABLE IF NOT EXISTS proveedor (
	id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
	nit VARCHAR(20) UNIQUE,
    telefono VARCHAR(30),
    email VARCHAR(150),
    direccion VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    
-- TABLA CATEGORIA
CREATE TABLE IF NOT EXISTS categoria (
	id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- (Tablas dependientes con Claves Foráneas que dependen de otras tablas)

-- TABLA PRODUCTO
CREATE TABLE IF NOT EXISTS producto (
	id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    precio_costo DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    id_categoria INT,
    CONSTRAINT fk_producto_categoria
		FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA INVENTARIO (Depende de la tabla producto)
CREATE TABLE IF NOT EXISTS inventario (
	id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL UNIQUE,
    cantidad INT NOT NULL DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    ubicacion_bodega VARCHAR(100),
    CONSTRAINT fk_inventario_producto
		FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA COMPRA (Depende de las tablas proveedor y empleado)Q
CREATE TABLE IF NOT EXISTS compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL, 
    total DECIMAL(10,2) NOT NULL,
    id_proveedor INT NOT NULL, 
    id_empleado INT NOT NULL,
    CONSTRAINT fk_compra_proveedor
		FOREIGN KEY (id_proveedor) REFERENCES proveedor (id_proveedor) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_compra_empleado
		FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA DETALLE_COMPRA (Depende de las tablas compra y producto)
CREATE TABLE IF NOT EXISTS detalle_compra (
	id_detalle_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_compra_compra
		FOREIGN KEY (id_compra) REFERENCES compra (id_compra)
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_detalle_compra_producto
		FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA VENTA (Depende de tablas cliente y empleado)
CREATE TABLE IF NOT EXISTS venta (
	id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    id_cliente INT,
    id_empleado INT NOT NULL,
    CONSTRAINT fk_venta_cliente
		FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_venta_empleado
		FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado)
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA DETALLE_VENTA (Depende de tablas venta y producto)
CREATE TABLE IF NOT EXISTS detalle_venta (
	id_detalle_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
	CONSTRAINT fk_detalle_venta_venta
        FOREIGN KEY (id_venta) REFERENCES venta (id_venta)
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_detalle_venta_producto
		FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA FACTURA (Depende de tabla venta)
CREATE TABLE IF NOT EXISTS factura (
	id_factura INT AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(50) NOT NULL UNIQUE,
    fecha DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    id_venta INT NOT NULL UNIQUE,
    CONSTRAINT fk_factura_venta
		FOREIGN KEY (id_venta) REFERENCES venta (id_venta)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- VERIFICACION
SHOW TABLES;

-- *************************************************************************************************************************************************************************************************
-- INSERCION DE DATOS DE PRUEBA CON SENTENCIA (INSERT)

USE ferrehogar_db;

-- INSERTAR DATOS PARA LA TABLA CATEGORIA
INSERT INTO categoria (nombre, descripcion) VALUES
('Herramientas manuales', 'Martillos, destornilladores, alicates y llaves'),
('Herramientas electricas', 'Taladros, pulidoras y cortadoras'),
('Pinturas y Acabados', 'Pinturas de agua, aceite, borchas y rodillos');

-- INSERTAR DATOS PARA LA TABLA CLIENTE
INSERT INTO cliente (nombre, apellido, documento, telefono, email, direccion) VALUES
('Juan Diego', 'Durán', '1023562899', '3001234567', 'j.diego.duran@email.com', 'Calle 81 # 106-34'),
('Juana Camila', 'Velazques', '1012445747', '3108869212', 'j.camila.velazques@gmail.com', 'Diagonal 85 # 110-35'),
('Empresa Constructora', 'SAS', '899123456', '6017771234', 'contacto@constructorasas.com', 'Av. NQS # 68-96');
-- Al intentar ingresar el nombre de una empresa como cliente de ferrehogar, existen varias opciones: 1. ingresar como nombre 'Empresa Constructora' y como apellido 'SAS'(usada en este ejemplo)
-- 2. en el campo de apellido ingresar 'N/A' o 3. ingresar como apellido '-'

-- INSERTAR DATOS PARA LA TABLA EMPLEADOS
INSERT INTO empleado (nombre, cedula, cargo, telefono, email) VALUES
('Juan Pablo Alarcón', '1098765432', 'Administrador', '3150001122', 'juan.alarcon@ferrehogar.com'),
('Natalia Perez', '1087654321', 'Cajera', '3169998877', 'nata.perez@ferrehogar.com'),
('Sofia Duarte', '1080669432', 'Cajera', '3153348520', 'sofi.duarte@ferrehogar.com');

-- INSERTAR DATOS PARA LA TABLA PROVEEDOR
INSERT INTO proveedor (nombre, nit, telefono, email, direccion) VALUES
('Distribuidora Ferreteria TodoAquí', '800111222-1', '6024445566', 'ventas@todoaqui.com', 'Zona Industrial Lote 4'),
('Pinturas Colombia SA', '890333444-5', '6013332211', 'pedidos@pintucol.com', 'Calle 13 # 40-20'),
('Distribuidora Fontaner SAS', '900555666-8', '6017778899', 'servicio@fontaner', 'Carrera 68 # 20-10');

-- INSERTAR DATOS PARA LA TABLA PRODUCTO
INSERT INTO producto (nombre, descripcion, precio_costo, precio_venta, id_categoria) VALUES
('Martillo de Uña 16oz', 'Martillo con mango de fibra de vidrio', 15000.00, 25000.00, 1),
('Taladro Percutor 1/2 650W', 'Taladro eléctrico velocidad variable', 120000.00, 185000.00, 2),
('Pintura Vinilo Blanco 1 Galón', 'Pintura lavable tipo 1', 45000.00, 72000.00, 3);

-- INSERTAR DATOS PARA LA TABLA inventario
INSERT INTO inventario (id_producto, cantidad, stock_minimo, ubicacion_bodega) VALUES
(1, 25, 5, 'Estante A-1'),
(2, 8, 2, 'Estante B-3'),
(3, 15, 4, 'Bodega Principal');

-- INSERTAR DATOS PARA LA TABLA compra
INSERT INTO compra (fecha, total, id_proveedor, id_empleado) VALUES
('2026-10-01', 510000.00, 1, 1),
('2026-10-02', 360000.00, 2, 1),
('2026-10-03', 240000.00, 3, 3);


-- INSERTAR DATOS PARA LA TABLA detalle_compra
INSERT INTO detalle_compra (id_compra, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 10, 15000.00),
(2, 3, 8, 45000.00),
(1, 2, 3, 120000.00);

-- INSERTAR DATOS PARA LA TABLA venta
INSERT INTO venta (fecha, total, id_cliente, id_empleado) VALUES
('2026-10-05 10:30:00', 210000.00, 1, 2),
('2026-10-05 11:15:00', 72000.00, 2, 2),
('2026-10-06 14:20:00', 185000.00, 3, 3);

-- INSERTAR DATOS PARA LA TABLA detalle_venta
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 25000.00),
(2, 3, 1, 72000.00),
(1, 2, 1, 185000.00);

-- INSERTAR DATOS PARA LA TABLA
INSERT INTO factura (numero_factura, fecha, total, id_venta) VALUES
('FAC-0001', '2026-10-05 10:32:00', 210000.00, 1),
('FAC-0002', '2026-10-05 11:17:00', 72000.00, 2),
('FAC-0003', '2026-10-06 14:22:00', 185000.00, 3);

-- MENSAJE DE VERIFICACION EXITOSA PARA LA INSERSION DE DATOS
SELECT 'Datos insertados exitosamente' AS Mensaje; 

-- *************************************************************************************************************************************************************************************************

-- CONSULTAS CON LA SENTENCIA 'JOIN'

-- CONSULTA 1: Catálogo de Productos, Categoría e Inventario
-- OBJETIVO: Relacionar producto, categoría y stock disponible (stock_minimo).
SELECT
	p.id_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    p.precio_costo AS costo,
    p.precio_venta AS precio_venta,
    i.cantidad AS stock_actual,
    i.ubicacion_bodega AS ubicacion_bodega
FROM producto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria
INNER JOIN inventario i ON p.id_producto = i.id_producto;

-- CONSULTA 2: Reporte de ventas, factura, cliente y empleado
-- OBJETIVO: Relacionar compra, cliente, empleado y factura generada.
SELECT
	f.numero_factura AS no_factura,
	v.fecha AS fecha_hora,
    c.nombre AS cliente,
    c.documento AS documento_cliente,
    e.nombre AS vendedor,
    v.total AS total_facturado
FROM venta v
INNER JOIN cliente c ON v.id_cliente = c.id_cliente
INNER JOIN empleado e ON v.id_empleado = e.id_empleado
INNER JOIN factura f ON v.id_venta = f.id_venta;

-- CONSULTA 3: Detalle completo de productos en factura
-- OBJETIVO: Verificar los productos vendidos dentro de cada factura con el calculo subtotal
SELECT
	f.numero_factura AS no_factura,
    p.nombre AS producto,
    dv.cantidad AS cantidad,
    dv.precio_unitario AS precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal
FROM factura f
INNER JOIN detalle_venta dv ON f.id_venta = dv.id_venta
INNER JOIN producto p ON dv.id_producto = p.id_producto;
