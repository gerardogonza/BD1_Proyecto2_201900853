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
    dpi_hombre int,
    dpi_mujer int,
    fecha_matrimonio date,
    PRIMARY KEY (id_matrimonio)
);

CREATE TABLE divorcio(
    id_divorcio int auto_increment,
    fecha_divorcio date,
    PRIMARY KEY (id_divorcio)
);
CREATE TABLE datos_dpi(
    dpi int auto_increment,
    fecha_emision date,
    PRIMARY KEY (dpi)
);

CREATE TABLE detalle_matrimonio_divorcio(
    id_datalle_matrimonio_divorcio int auto_increment,
    id_matrimonio int,
    id_divorcio int,
    dpi int,
    PRIMARY KEY (id_datalle_matrimonio_divorcio),
    foreign key (id_matrimonio) references matrimonio(id_matrimonio),
    foreign key (id_divorcio) references divorcio(id_divorcio),
    foreign key (dpi) references datos_dpi(dpi)
);

CREATE TABLE acta_nacimiento(
    id_acta int not null auto_increment,
    dpi_padre int,
    nombre_padre varchar(50),
    apellido_padre varchar(50),
    dpimadre int,
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
    acta_naciemiento int,
    PRIMARY KEY (id_detalle_persona),
     foreign key (id_licencia) references licencia(id_licencia) ,
    foreign key (id_defuncion) references defuncion(id_defuncion),
    foreign key (acta_naciemiento) references acta_nacimiento(id_acta)
);

CREATE TABLE persona(
    cui int auto_increment,
    primer_nombre varchar(50),
    segundo_nombre varchar(50),
    tercer_nombre varchar(50),
    fecha_nacimineto date,
    id_municipio int,
    genero char,
    estado char,
    id_detalle_persona int,
    id_detalle_matrimonio_divorcio int ,
                    PRIMARY KEY (cui),
    foreign key (id_detalle_persona) references detalle_persona(id_detalle_persona),
    foreign key (id_detalle_matrimonio_divorcio) references detalle_matrimonio_divorcio(id_datalle_matrimonio_divorcio),
    foreign key (id_municipio) references municipio(codigo_municipio)
);
# INSERT INTO departamento ( codigo_departamento,nombre_departamento)  (SELECT codigo_departamento,nombre_departamento FROM temporaldepartamentos);
# INSERT INTO municipio ( codigo_municipio,nombre_municipio,codigo_departamento)  (SELECT codigo_municipio,nombre_municipio,codigo_departamento FROM temporalmunicipios);
