--CREAR BD
CREATE DATABASE telovendo_sprint;
--conexion a la bd
\c telovendo_sprint;

--CREAR USUARIO 
CREATE USER admintlv WITH PASSWORD 'admin';

GRANT ALL PRIVILEGES ON DATABASE telovendo_sprint TO admintlv;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admintlv;

GRANT ALL PRIVILEGES ON SCHEMA public TO admintlv;
GRANT CREATE ON SCHEMA public TO admintlv;
GRANT USAGE, SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admintlv;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO admintlv;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO admintlv;

--tabla categorias disponibles
create table categoria(
    id_cat serial primary key,
    nombre_cat varchar(25) not null
);
--INSERTS DE CATEGORIAS
INSERT INTO categoria (nombre_cat) VALUES
  ('Electrónica'),
  ('Computadoras'),
  ('Telecomunicaciones'),
  ('Accesorios'),
  ('Audio y Video');


--TABLA PROVEEDOR
CREATE TABLE proveedor(
    id_prov serial primary key,
    rut varchar(10) unique,
    nombre_rep_legal varchar(50) not null,
    nombre_corporativo varchar(50) not null,
    id_cat int,
    correo_electronico varchar(50),
    FOREIGN KEY (id_cat) REFERENCES categoria (id_cat)
);

--INSERTS de proveedores
INSERT INTO proveedor (rut, nombre_rep_legal, nombre_corporativo, id_cat, correo_electronico) VALUES
  ('12345678-9', 'Juan Pérez', 'ElectroTech', 1, 'juan@electrotech.com'),
  ('98765432-1', 'María López', 'TechZone', 2, 'maria@techzone.com'),
  ('45678912-3', 'Pedro González', 'ElecPlus', 1, 'pedro@elecplus.com'),
  ('54321678-9', 'Ana Rodríguez', 'GadgetWorld', 3, 'ana@gadgetworld.com'),
  ('98765433-1', 'Carlos Sánchez', 'DigitalTech', 2, 'carlos@digitaltech.com');

--tabla contactos de proveedores 
create table contactos_proveedor(
    id_con_pro serial primary key,
    id_prov int,
    telefono varchar(15) not null,
    nombre_contacto varchar(50) not null,
    FOREIGN KEY (id_prov) REFERENCES proveedor (id_prov)
);


-- INSERTS de la tabla "contactos_proveedor" (2 contactos por proveedor)
INSERT INTO contactos_proveedor (id_prov, telefono, nombre_contacto) VALUES
  --proveedor 1
  (1, '+56912345678', 'Juan'),
  (1, '+56998765432', 'Pedro'),

  --proveedor 2
  (2, '+56911111111', 'Maria'),
  (2, '+56922222222', 'Ana'),

  --proveedor 3
  (3, '+56933333333', 'Carlos'),
  (3, '+56944444444', 'Luis'),

  --proveedor 4
  (4, '+56955555555', 'Sofia'),
  (4, '+56966666666', 'Laura'),

  --proveedor 5
  (5, '+56977777777', 'Roberto'),
  (5, '+56988888888', 'Patricia');


--TABLA CLIENTES
create table clientes(
    id_cli serial primary key,
    nombre varchar(30) not null,
    apellidos varchar(60) not null,
    direccion varchar(100) not null
);

--INSERTS DE 5 CLIENTES
INSERT INTO clientes (nombre, apellidos, direccion) VALUES
  ('Juan', 'Gómez Pérez', 'Calle 123, Ciudad'),
  ('María', 'López Rodríguez', 'Avenida Principal, Pueblo'),
  ('Pedro', 'Sánchez García', 'Carrera 45, Villa'),
  ('Ana', 'Fernández Martínez', 'Calle Secundaria, Barrio'),
  ('Carlos', 'Torres Jiménez', 'Avenida Central, Urbanización');

--TABLA PRODUTOS
create table productos(
    id_producto serial primary key,
    nombre_producto varchar(30) not null,
    precio int not null,
    id_cat int not null,
    color varchar(15) not null,
    stock smallint not null,
    FOREIGN KEY (id_cat) REFERENCES categoria (id_cat)
);

--TABLA RELACION PRODUCTOS PROVEEDORES
create table producto_proveedor(
    id_producto integer not null,
    id_prov int not null,
    PRIMARY KEY (id_producto, id_prov),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_prov) REFERENCES proveedor(id_prov)
);


-- INSERTS de tabla productos
INSERT INTO productos (nombre_producto, precio, id_cat, color, stock) VALUES
  ('Laptop', 1000000, 2, 'Negro', 12),
  ('Smartphone', 800000, 1, 'Gris', 23),
  ('Televisor', 350000, 3, 'Negro', 9),
  ('Tablet', 200000, 2, 'Blanco', 10),
  ('Camara', 600000, 4, 'Plateado', 15),
  ('Auriculares', 70000, 5, 'Negro', 35),
  ('Impresora', 230000, 4, 'Blanco', 10),
  ('Altavoz', 110000, 5, 'Rojo', 10),
  ('Monitor', 230000, 2, 'Gris', 12),
  ('Teclado', 50000, 4, 'Negro', 58),
  ('PC GAMER', 1200000,2,'Negro', 11);

-- INSERTS de tabla producto_proveedor
INSERT INTO producto_proveedor (id_producto, id_prov) VALUES
  (1, 1),
  (1, 2),
  (2, 2),
  (3, 3),
  (4, 1),
  (4, 3),
  (5, 2),
  (6, 4),
  (7, 1),
  (8, 3);



  --Cuál es la categoría de productos que más se repite.
  select count(*) as cantidad, p.id_cat, nombre_cat 
  from productos p 
  inner join categoria c on (c.id_cat = p.id_cat) 
  group by p.id_cat, nombre_cat 
  order by cantidad desc 
  limit 1;
-- cantidad | id_cat |  nombre_cat
-- ----------+--------+--------------
--         4 |      2 | Computadoras


--Cuáles son los productos con mayor stock
select * from productos order by stock desc limit 3;
--  id_producto | nombre_producto | precio | id_cat | color | stock
-- -------------+-----------------+--------+--------+-------+-------
--           10 | Teclado         |  50000 |      4 | Negro |    58
--            6 | Auriculares     |  70000 |      5 | Negro |    35
--            2 | Smartphone      | 800000 |      1 | Gris  |    23


--Qué color de producto es más común en nuestra tienda.
select color, count(*) as cantidad from productos group by color order by cantidad desc limit 1;
--  color | cantidad
-- -------+----------
--  Negro |        5

--Cual o cuales son los proveedores con menor stock de productos.
select distinct(pv.id_prov),rut, nombre_rep_legal, nombre_corporativo  
from proveedor pv 
where pv.id_prov in (select distinct(pp.id_prov) from productos p 
inner join producto_proveedor pp on (p.id_producto = pp.id_producto)
where stock < (select avg(stock) from productos));
--CONSULTA TRAE LOS PROVEEDORES QUE TENGAN STOCK MENOR AL PROMEDIO



--Cambien la categoría de productos más popular por ‘Electrónica y computación’.
update categoria set nombre_cat = 'Electrónica y computacion' 
where id_cat = (
    select sub.id_cat from (select count(*) as cantidad, p.id_cat 
    from productos p 
    inner join categoria c on (c.id_cat = p.id_cat) 
    group by p.id_cat, nombre_cat 
    order by cantidad desc 
    limit 1) as sub
);
