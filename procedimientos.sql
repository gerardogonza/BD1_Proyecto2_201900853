
# DELIMITER $$
# CREATE PROCEDURE AddNacimiento(IN dpipadre bigint,dpimadre bigint)
# BEGIN
#    INSERT INTO acta_nacimiento(dpi_padre,dpimadre)
#        SELECT dpipadre,dpimadre
#            FROM DUAL
#                WHERE EXISTS( SELECT *
#                              FROM persona
#                              WHERE cui =dpipadre
#                          )
#                  AND EXISTS( SELECT *
#                                         FROM persona
#                                         WHERE cui =dpimadre);
# END$$
# DELIMITER;

# ---------------------------- FUNCION 1 ----------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE AddNacimiento(IN dpipadre bigint,dpimadre bigint,primernom varchar(50),segundonom varchar(50),tercenom varchar(50),fechanac date,codMunicipio int, genero char)
BEGIN
    DECLARE contador INT;
    DECLARE NEWCUI bigint;
    DECLARE primer_nombre_padre varchar(50);
    DECLARE primer_apellido_padre varchar(50);
    DECLARE primer_nombre_madre varchar(50);
    DECLARE primer_apellido_madre varchar(50);
    DECLARE idacta INT;
    SELECT primer_nombre from persona WHERE cui=dpipadre into primer_nombre_padre;
    SELECT primer_apellido from persona WHERE cui=dpipadre into primer_apellido_padre;
    SELECT primer_nombre from persona WHERE cui=dpimadre into primer_nombre_madre;
    SELECT primer_apellido from persona WHERE cui=dpimadre into primer_apellido_madre;
    SET idacta= (SELECT COUNT(*)+1 FROM acta_nacimiento);
    SET contador= (SELECT COUNT(*)+1 FROM persona);
    IF codMunicipio >= 1000 then
        IF(contador<10)THEN
            SET NEWCUI= CONCAT('11111111',contador,codMunicipio);
        ELSE IF(contador<100) THEN
            SET NEWCUI= CONCAT('1111111',contador,codMunicipio);
        ELSE IF(contador<1000)THEN
            SET NEWCUI= CONCAT('11111',contador,codMunicipio);
        END IF;
        END IF;
        END IF;
    ELSE
        IF(contador<10)THEN
            SET NEWCUI= CONCAT('111111111',contador,codMunicipio);
        ELSE IF(contador<100) THEN
            SET NEWCUI= CONCAT('11111111',contador,codMunicipio);
        ELSE IF(contador<1000)THEN
            SET NEWCUI= CONCAT('1111111',contador,codMunicipio);
        END IF;
        END IF;
        END IF;
    end if;

   IF verificacionDatos(dpipadre,dpimadre) then
       IF ValidarMayoriaEdad(dpipadre)>=18 then
           IF ValidarMayoriaEdad(dpimadre)>=18 then
               IF verificarCadenaTexto(primernom,segundonom) then
                   INSERT INTO acta_nacimiento(dpi_padre, nombre_padre, apellido_padre, dpimadre, nombre_madre, apellido_madre)
                   VALUES (dpipadre,primer_nombre_padre,primer_apellido_padre,dpimadre,primer_nombre_madre,primer_apellido_madre);
                   INSERT INTO persona(cui, primer_nombre, segundo_nombre, tercer_nombre, primer_apellido, segundo_apellido,
                                       fecha_nacimineto, id_municipio, genero, estado,id_acta_nacimiento)
                   VALUES (NEWCUI,primernom,segundonom,tercenom,primer_apellido_padre,primer_apellido_madre,fechanac,codMunicipio,genero,'S',idacta);
               ELSE
                   SELECT 'ERROR CARECTERES NO ADMINITODS EN EL NOMBRE';
               end if;
              ELSE
                  SELECT 'ERROR LA MADRE ES MENOR DE EDAD';
           end if;
        ELSE
            SELECT 'ERROR El PADRE ES MENOR DE EDAD';
       end if;
    ELSE
       SELECT 'ERROR EN DPI madre y/o padre';
   end if;

END$$
DELIMITER;

CREATE FUNCTION verificacionDatos(
    dpipadre bigint,
    dpimadre bigint
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
    IF (dpipadre in (select cui from persona) and dpimadre in (select cui from persona)) THEN
      SET resultado=true;
    ELSE
        SET resultado = false;
    END IF;
    -- return the customer level
    RETURN (resultado);
END;
CREATE FUNCTION verificarCadenaTexto(
    primerNombre varchar(50),
    segundoNombre varchar(50)
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
    SELECT primerNombre REGEXP '^[a-zA-Z.]+$' into @validacion_primernombre;
    IF  @validacion_primernombre=1 THEN
        SELECT segundoNombre REGEXP '^[a-zA-Z.]+$' into @validacion_segundonombre;
        IF @validacion_segundonombre = 1 THEN
           SET resultado=true;
        ELSE
            SET resultado=false;
        end if;
    ELSE
        SET resultado=false;
    end if;
    -- return the customer level
RETURN (resultado);
END;
CREATE FUNCTION ValidarMayoriaEdad(
    dpi bigint
)
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE resultado int;
    SELECT TIMESTAMPDIFF(YEAR,fecha_nacimineto,CURDATE())  INTO @EDAD
    FROM persona
    WHERE dpi=cui ;
    SET resultado=@EDAD;
    -- return the customer level
RETURN (resultado);
END;



    call AddNacimiento(1111111110101,1111111120101,'Edson','Diego',null,'2022-01-10',101,'M');

DROP FUNCTION ValidarMayoriaEdad;
drop procedure AddNacimiento;
drop function verificacionDatos;
select * from persona;
select * from acta_nacimiento;
