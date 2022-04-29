DROP TABLE  temporalmunicipios;
TRUNCATE TABLE temporalmunicipios;
SELECT * FROM temporalmunicipios;
SELECT COUNT(*) FROM temporalmunicipios;

CREATE DATABASE proyecto201900853;
use proyecto201900853;

create table temporalmunicipios(
                         codigo_municipio int(5),
                         nombre_municipio varchar(250),
                         codigo_departamento int(4)

);