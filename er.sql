use proyecto201900853;

CREATE TABLE departamento(
                          codigo_departamento INT,
                          nombre_departamento VARCHAR(70),
                          PRIMARY KEY (codigo_departamento)
);

CREATE TABLE municipio(
                          codigo_municipio INT,
                          nombre_municipio VARCHAR(70),
                          codigo_departamento INT,
                             PRIMARY KEY (codigo_municipio),
                            foreign key (codigo_departamento) references departamento(codigo_departamento)
);

CREATE TABLE defuncion(
    id_defuncion int auto_increment,
    fecha_fallecimiento date,
    motivo varchar(100),
    PRIMARY KEY (id_defuncion)
);

CREATE TABLE acta_nacimiento(
    id_acta int not null auto_increment,
    dpi_padre bigint,
    nombre_padre varchar(50),
    apellido_padre varchar(50),
    dpimadre bigint,
    nombre_madre varchar(50),
    apellido_madre varchar(50),
    PRIMARY KEY (id_acta)
);

CREATE TABLE detalle_persona(
    id_detalle_persona int auto_increment,
    id_defuncion int,
    PRIMARY KEY (id_detalle_persona),
    foreign key (id_defuncion) references defuncion(id_defuncion)
);

CREATE TABLE persona(
    cui bigint ,
    primer_nombre varchar(50),
    segundo_nombre varchar(50),
    tercer_nombre varchar(50),
    primer_apellido varchar(50),
    segundo_apellido varchar(50),
    fecha_nacimineto date,
    id_municipio int,
    genero char,
    estado char,
    id_detalle_persona int,
    id_acta_nacimiento int,
                    PRIMARY KEY (cui),
    foreign key (id_detalle_persona) references detalle_persona(id_detalle_persona),
    foreign key (id_acta_nacimiento) references acta_nacimiento(id_acta),
    foreign key (id_municipio) references municipio(codigo_municipio)
);
CREATE TABLE datos_dpi(
                          dpi bigint,
                          cui bigint,
                          fecha_emision date,
                          residenciaActual int,
                          PRIMARY KEY (dpi),
                          foreign key (cui) references persona(cui)
);

CREATE TABLE matrimonio(
                           id_matrimonio int auto_increment,
                           dpi_hombre bigint,
                           dpi_mujer bigint,
                           fecha_matrimonio date,
                           PRIMARY KEY (id_matrimonio),
                           foreign key (dpi_hombre) references datos_dpi(dpi),
                           foreign key (dpi_mujer) references datos_dpi(dpi)
);

CREATE TABLE divorcio(
                         id_divorcio int auto_increment,
                         fecha_divorcio date,
                         id_matrimonio int,
                         PRIMARY KEY (id_divorcio),
                         foreign key (id_matrimonio) references matrimonio(id_matrimonio)
);
CREATE TABLE licencia_anulada(
                                 id_anulacion int auto_increment,
                                 fecha_anulacion date,
                                 motivo varchar(200),
                                 primary key (id_anulacion)
);
CREATE TABLE licencia(
                         id_licencia int auto_increment,
                         CUI bigint,
                         tipo_licencia char,
                         fecha_emision date,
                         fecha_renovacion date,
                         id_anulacion int,
                         primary key (id_licencia),
                         foreign key (CUI) references persona(cui),
                         foreign key (id_anulacion) references licencia_anulada(id_anulacion)
);

# INSERT INTO departamento ( codigo_departamento,nombre_departamento)  (SELECT codigo_departamento,nombre_departamento FROM temporaldepartamentos);
# INSERT INTO municipio ( codigo_municipio,nombre_municipio,codigo_departamento)  (SELECT codigo_municipio,nombre_municipio,codigo_departamento FROM temporalmunicipios);



# INSERT INTO defuncion(fecha_fallecimiento, motivo) VALUES  ('2022-10-10','no pudo mas con la vida de rockstar');
#
# INSERT INTO acta_nacimiento(dpi_padre, nombre_padre, apellido_padre, dpimadre, nombre_madre, apellido_madre) VALUES
# (1111111110101,'Pablo','Mendez',1111111120101,'Sofia','Gimenez');

INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
                    VALUES (1111111110101,'Gerard','Steve','munoz','contreras',null,'2000-08-23','101','M','S',null,null);
INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
VALUES (1111111120101,'Vania','Astrid',null,'lopez','estrada','2001-08-23','101','F','S',null,null);

INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
VALUES
    (1338325313101,'Bernard','Alexandra','Hutchinson','Burch','Carlson','2001-05-26',101,'F','S',null,null),
    (1123462592101,'Xandra','Malik','Graves','Levy','Francis','2000-12-22',101,'F','S',null,null),
    (1677241443101,'Hall','Gabriel','Barnett','Vega','Klein','2000-06-01',101,'M','S',null,null),
    (2103562486101,'Rooney','Karyn','Rosales','Winters','Conway','2002-04-20',101,'M','S',null,null),
    (1242751095101,'Jena','Holly','Whitley','Frost','Travis','2001-02-28',101,'F','S',null,null),
    (1869266167101,'Dominique','Carissa','Cox','Cardenas','Hartman','2001-04-26',101,'F','S',null,null),
    (1232080975101,'Olympia','Brooke','Sanders','Yang','Jacobs','2002-12-06',101,'M','S',null,null),
    (1953147752101,'Kelsey','Vivian','Cervantes','Singleton','Castillo','2001-12-17',101,'M','S',null,null),
    (1431629731101,'Portia','Ezra','Dean','Downs','Blanchard','2002-06-22',101,'F','S',null,null),
    (1598386948101,'Zoe','Patience','Stokes','Nguyen','Holder','2000-11-14',101,'F','S',null,null);

INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
VALUES
    (1775710398101,'Regan','Scott','Patterson','Hunt','Rojas','2000-08-20',101,'M','S',null,null),
    (1988012504101,'Judith','Kasimir','Foley','Noble','Jackson','2002-12-23',101,'F','S',null,null),
    (1823486015101,'Sybil','Leroy','Horne','Gibson','Hodge','2002-03-27',101,'F','S',null,null),
    (1334181271101,'Xandra','Lamar','Galloway','Espinoza','Sparks','2002-07-01',101,'M','S',null,null),
    (1387033337101,'Arsenio','Orson','York','Hernandez','Strickland','2001-07-02',101,'M','S',null,null),
    (1678905766101,'Fallon','Ezekiel','Houston','Talley','Jacobson','2000-09-19',101,'F','S',null,null),
    (1459989545101,'Shelby','Montana','Caldwell','Harrell','Fowler','2000-06-29',101,'F','S',null,null),
    (1267121342101,'Kane','Veda','Klein','Baker','Dixon','2001-12-29',101,'M','S',null,null),
    (1917930143101,'Dale','Aurelia','Parsons','Gregory','Weiss','2000-07-24',101,'M','S',null,null);

INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
VALUES
    (1236838998101,'Leroy','Indira','Beach','Dominguez','Tillman','2002-02-01',101,'F','S',null,null),
    (2139497794101,'Keelie','Lydia','Burch','Mcmahon','Mullins','2001-10-06',101,'F','S',null,null),
    (1731585585101,'Brady','Colt','Roth','Bass','Lancaster','2000-07-12',101,'M','S',null,null),
    (1799989207101,'Quinlan','Debra','Lawrence','Chapman','Anderson','2002-01-14',101,'M','S',null,null),
    (1946168697101,'Jael','Jackson','Sellers','Savage','Hamilton','2002-11-17',101,'F','S',null,null),
    (1374613916101,'Carolyn','Ciaran','Hicks','Blake','Fry','2000-09-20',101,'F','S',null,null),
    (1307922485101,'Branden','Camden','Gamble','Guthrie','Franklin','2002-09-29',101,'M','S',null,null),
    (1306992000101,'Darrel','Piper','Randolph','Mercer','Booth','2002-06-30',101,'M','S',null,null),
    (1331194658101,'Orlando','Patience','Davis','Mueller','Reeves','2000-10-26',101,'F','S',null,null),
    (1347771026101,'Marshall','Reed','Santos','Hooper','Randolph','2002-08-31',101,'F','S',null,null);
INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
VALUES
    (1585259194101,'Philip','Tamekah','Bates','Benjamin','Bullock','2002-08-03',101,'F','S',null,null),
    (1549700463101,'Nathaniel','Hannah','Roach','Fitzpatrick','Gill','2002-06-13',101,'F','S',null,null),
    (1483379541101,'Silas','Anthony','Hanson','Huffman','Washington','2002-06-14',101,'M','S',null,null),
    (2086510701101,'Helen','Keith','Bowen','Bishop','Ruiz','2002-07-01',101,'M','S',null,null),
    (2075280005101,'Allen','Amethyst','Decker','York','Lewis','2002-01-18',101,'F','S',null,null),
    (1498901157101,'Aphrodite','Madonna','Beach','Thompson','Mckay','2002-11-29',101,'F','S',null,null),
    (2128888229101,'Igor','Raymond','Hartman','Gill','Singleton','2001-01-08',101,'M','S',null,null),
    (1677752847101,'Abraham','Hedley','Shaffer','Sutton','Miles','2002-02-05',101,'M','S',null,null),
    (2128941998101,'Noelani','Alana','Whitley','Dudley','Hancock','2002-03-10',101,'F','S',null,null),
    (2049465294101,'Ivan','Malik','Herman','Velazquez','Marquez','2002-01-29',101,'F','S',null,null);
INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
VALUES
    (1364486819101,'Lucian','Demetrius','Le','Dillard','Castro','2000-12-21',101,'M','S',null,null),
    (1588223872101,'Tarik','Brynne','Guy','Hughes','Britt','2002-11-18',101,'M','S',null,null),
    (1152105153101,'Alan','Fulton','Mcmillan','Larson','Juarez','2002-07-27',101,'F','S',null,null),
    (1595177371101,'Amal','Christopher','Nolan','Franks','Burris','2000-09-28',101,'F','S',null,null),
    (1913805482101,'Hyacinth','Honorato','Lynn','Hendricks','Yates','2000-12-17',101,'M','S',null,null),
    (1129958074101,'Ethan','Caleb','Woods','Hawkins','Vang','2000-12-31',101,'M','S',null,null),
    (1180805758101,'Portia','Morgan','Armstrong','Bass','Vasquez','2003-04-27',101,'F','S',null,null),
    (2205512954101,'Acton','Magee','Welch','Parker','Evans','2002-01-19',101,'F','S',null,null),
    (1119706264101,'Zane','Shad','Marsh','Middleton','Battle','2002-04-23',101,'M','S',null,null),
    (1382720752101,'Mollie','Mannix','Moon','Mcfadden','Hogan','2002-11-16',101,'M','S',null,null);
INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA,
                    ID_ACTA_NACIMIENTO)
VALUES
    (1293760330101,'Ruby','Holly','Washington','Weiss','Bush','2000-09-11',101,'F','S',null,null),
    (2162485255101,'Piper','Hanae','Harper','Vang','Leonard','2002-04-03',101,'F','S',null,null),
    (1691360703101,'Patrick','Gisela','Gamble','Dillon','Burt','2001-11-18',101,'M','S',null,null),
    (1411017078101,'Hadley','Emmanuel','Whitney','Randolph','Wise','2000-05-11',101,'M','S',null,null),
    (1234599696101,'Kirk','Marcia','Gentry','Burton','Nolan','2000-09-15',101,'F','S',null,null),
    (1209090600101,'Driscoll','Xenos','Woodard','Horton','Talley','2002-04-17',101,'F','S',null,null),
    (1614205457101,'Flynn','Leila','Kelley','Riggs','Cameron','2000-11-25',101,'M','S',null,null),
    (1502091399101,'Gretchen','Violet','Mccarthy','Everett','Rush','2001-05-27',101,'M','S',null,null),
    (1778835901101,'Branden','Mona','Byers','Bradshaw','Adkins','2001-12-04',101,'F','S',null,null),
    (1882883947101,'Chastity','Shelly','Lindsey','Heath','Avery','2001-10-13',101,'F','S',null,null);
select * from licencia;
select * from defuncion;
select * from acta_nacimiento;
select * from persona;




drop table divorcio;
drop table matrimonio;
drop table datos_dpi;
drop table licencia;
drop table licencia_anulada;
drop table persona;
drop table detalle_persona;
drop table acta_nacimiento;
drop table defuncion;

