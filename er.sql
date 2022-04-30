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

CREATE TABLE matrimonio(
    id_matrimonio int auto_increment,
    dpi_hombre bigint,
    dpi_mujer bigint,
    fecha_matrimonio date,
    PRIMARY KEY (id_matrimonio)
);

CREATE TABLE divorcio(
    id_divorcio int auto_increment,
    fecha_divorcio date,
    PRIMARY KEY (id_divorcio)
);
CREATE TABLE datos_dpi(
    dpi bigint,
    fecha_emision date,
    PRIMARY KEY (dpi)
);

CREATE TABLE detalle_matrimonio_divorcio(
    id_datalle_matrimonio_divorcio int auto_increment,
    id_matrimonio int,
    id_divorcio int,
    dpi bigint,
    PRIMARY KEY (id_datalle_matrimonio_divorcio),
    foreign key (id_matrimonio) references matrimonio(id_matrimonio),
    foreign key (id_divorcio) references divorcio(id_divorcio),
    foreign key (dpi) references datos_dpi(dpi)
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
CREATE TABLE licencia_anulada(
    id_anulacion int auto_increment,
    fecha_anulacion date,
    motivo varchar(200),
    primary key (id_anulacion)
);
CREATE TABLE licencia(
    id_licencia int auto_increment,
    tipo_licencia char,
    fecha_emision date,
    fecha_renovacion date,
    id_anulacion int,
    primary key (id_licencia),
    foreign key (id_anulacion) references licencia_anulada(id_anulacion)
);

CREATE TABLE detalle_persona(
    id_detalle_persona int auto_increment,
    id_licencia int,
    id_defuncion int,
    PRIMARY KEY (id_detalle_persona),
     foreign key (id_licencia) references licencia(id_licencia) ,
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
    id_detalle_matrimonio_divorcio int ,
    id_acta_nacimiento int,
                    PRIMARY KEY (cui),
    foreign key (id_detalle_persona) references detalle_persona(id_detalle_persona),
    foreign key (id_detalle_matrimonio_divorcio) references detalle_matrimonio_divorcio(id_datalle_matrimonio_divorcio),
    foreign key (id_acta_nacimiento) references acta_nacimiento(id_acta),
    foreign key (id_municipio) references municipio(codigo_municipio)
);
# INSERT INTO departamento ( codigo_departamento,nombre_departamento)  (SELECT codigo_departamento,nombre_departamento FROM temporaldepartamentos);
# INSERT INTO municipio ( codigo_municipio,nombre_municipio,codigo_departamento)  (SELECT codigo_municipio,nombre_municipio,codigo_departamento FROM temporalmunicipios);


INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2000-06-11','2005-06-11',null);
INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2001-06-11','2005-06-11',null);
INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2002-06-11','2004-06-11',null);
INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2003-06-11','2006-06-11',null);
INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2004-06-11','2007-06-11',null);
INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2005-06-11','2009-06-11',null);
INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2006-06-11','2009-06-11',null);
INSERT INTO licencia (tipo_licencia, fecha_emision, fecha_renovacion, id_anulacion) VALUES ('C','2006-06-11','2008-06-11',null);

INSERT INTO defuncion(fecha_fallecimiento, motivo) VALUES  ('2022-10-10','no pudo mas con la vida de rockstar');

INSERT INTO acta_nacimiento(dpi_padre, nombre_padre, apellido_padre, dpimadre, nombre_madre, apellido_madre) VALUES
(1111111110101,'Pablo','Mendez',1111111120101,'Sofia','Gimenez');

INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA, ID_DETALLE_MATRIMONIO_DIVORCIO,
                    ID_ACTA_NACIMIENTO)
                    VALUES (1111111110101,'Gerard','Steve','munoz','contreras',null,'2000-08-23','101','M','S',null,null,null);
INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA, ID_DETALLE_MATRIMONIO_DIVORCIO,
                    ID_ACTA_NACIMIENTO)
VALUES (1111111120101,'Vania','Astrid',null,'lopez','estrada','2001-08-23','101','F','S',null,null,null);

INSERT INTO persona(CUI, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE,primer_apellido,segundo_apellido, FECHA_NACIMINETO,
                    ID_MUNICIPIO, GENERO, ESTADO, ID_DETALLE_PERSONA, ID_DETALLE_MATRIMONIO_DIVORCIO,
                    ID_ACTA_NACIMIENTO)
VALUES (1111111130101,'Andre','Valverder','berrios','avila',null,'2002-08-23','101','F','S',null,null,null);

select * from licencia;
select * from defuncion;
select * from acta_nacimiento;
drop table persona;
drop table detalle_persona;
drop table acta_nacimiento;
drop table detalle_matrimonio_divorcio;
drop table matrimonio;
drop table defuncion;
drop table datos_dpi;