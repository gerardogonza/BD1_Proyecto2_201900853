
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
            SET NEWCUI= CONCAT('1111111',contador,codMunicipio);
        ELSE IF(contador<100) THEN
            SET NEWCUI= CONCAT('111111',contador,codMunicipio);
        ELSE IF(contador<1000)THEN
            SET NEWCUI= CONCAT('1111',contador,codMunicipio);
        END IF;
        END IF;
        END IF;
    ELSE
        IF(contador<10)THEN
            SET NEWCUI= CONCAT('111111111',contador,'0',codMunicipio);
        ELSE IF(contador<100) THEN
            SET NEWCUI= CONCAT('1111111',contador,'0',codMunicipio);
        ELSE IF(contador<1000)THEN
            SET NEWCUI= CONCAT('111111',contador,'0',codMunicipio);
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

    call AddNacimiento(1209090600101,1232080975101,'David','Alejando','Saul','2020-01-10',409,'M');

# ------------------------------------------------------------- Consulta 2-------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE AddDefuncion(IN cuifallecido bigint,fechaFallecio date, motivo varchar(300))
BEGIN
    DECLARE DETALLEDEFUNCION INT;
    DECLARE IDDEFUNCION INT;
    DECLARE IDDETALLE INT;
    SET IDDEFUNCION= (SELECT COUNT(*)+1 FROM defuncion);
    SET IDDETALLE= (SELECT COUNT(*)+1 FROM detalle_persona);
    IF verificarCUI(cuifallecido) then
       IF ValidarFechaDefuncion(cuifallecido,fechaFallecio)>=0 THEN
          IF validacionPrimeraVezFallicido(cuifallecido) THEN
              SELECT id_detalle_persona FROM persona WHERE cui=cuifallecido INTO @DETALLEDEFUNCION;
            IF BuscandoSiExisteActaDefuncion(@DETALLEDEFUNCION)THEN
                SELECT 'ERROR: Esta persona ya Murio una vez';
            ELSE
                INSERT INTO defuncion(fecha_fallecimiento, motivo) VALUES (fechaFallecio,motivo);
                UPDATE detalle_persona SET id_defuncion=IDDEFUNCION WHERE id_detalle_persona= @DETALLEDEFUNCION;
            end if;
            ELSE
              INSERT INTO defuncion(fecha_fallecimiento, motivo) VALUES (fechaFallecio,motivo);
              INSERT INTO detalle_persona(id_licencia, id_defuncion) VALUES (null,IDDEFUNCION);
              UPDATE persona SET id_detalle_persona=IDDETALLE WHERE cui=cuifallecido;
          end if;
           ELSE
           SELECT 'ERROR: FALLECIO ANTES DE SU NACIMIENTO';
       end if;
    ELSE
        select 'No Exite CUI';
    end if;
END$$
DELIMITER;

CREATE FUNCTION verificarCUI(
    dpi bigint
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
    IF (dpi in (select cui from persona)) THEN
        SET resultado=true;
    ELSE
        SET resultado = false;
    END IF;
    -- return the customer level
    RETURN (resultado);
END;
CREATE FUNCTION ValidarFechaDefuncion(
    dpi bigint,
    defuncion date
)
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE resultado int;
    SELECT TIMESTAMPDIFF(DAY ,fecha_nacimineto,defuncion)  INTO @EDAD
    FROM persona
    WHERE dpi=cui ;
    SET resultado=@EDAD;
    -- return the customer level
    RETURN (resultado);
END;
CREATE FUNCTION validacionPrimeraVezFallicido(
    dpi bigint
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
    IF ( select id_detalle_persona from persona WHERE cui=dpi ) THEN
        SET resultado=true;
    ELSE
        SET resultado = false;
    END IF;
    -- return the customer level
    RETURN (resultado);
END;

CREATE FUNCTION BuscandoSiExisteActaDefuncion(
        id bigint
    )
        RETURNS boolean
        DETERMINISTIC
    BEGIN
        DECLARE resultado boolean;
        IF ( select id_defuncion from detalle_persona WHERE id_detalle_persona=id ) THEN
            SET resultado=true;
        ELSE
            SET resultado = false;
        END IF;
        -- return the customer level
        RETURN (resultado);
    END;

        CALL AddDefuncion(1119706264101,'2022-10-11','mucho cigarro');
# ---------------------------------------------------- CONSULTA 3 ------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE AddMatrimonio(IN dpiHombre bigint,dpiMujer bigint, fechaMatrimonio date)
BEGIN
    IF verificarDPI(dpiHombre) THEN
        IF verificarDPI(dpiMujer) THEN
            IF verificarSolteria(dpiHombre) THEN
                IF verificarSolteria(dpiMujer) THEN
                    IF ValidarFechaEmision(dpiHombre,fechaMatrimonio)>=18 THEN
                        IF ValidarFechaEmision(dpiMujer,fechaMatrimonio)>=18 THEN
                            IF validacionPrimeraVezFallicido(dpiHombre) THEN
                                SELECT id_detalle_persona FROM persona WHERE cui=dpiHombre INTO @DETALLEDEFUNCION2;
                                IF BuscandoSiExisteActaDefuncion(@DETALLEDEFUNCION2)THEN
                                    SELECT 'ERROR: No tep puedes casar con alguien fallecido';
                                ELSE
                                    IF validacionPrimeraVezFallicido(dpiMujer) THEN
                                        SELECT id_detalle_persona FROM persona WHERE cui=dpiMujer INTO @DETALLEDEFUNCION2;
                                        IF BuscandoSiExisteActaDefuncion(@DETALLEDEFUNCION2)THEN
                                            SELECT 'ERROR: No tep puedes casar con alguien fallecido';
                                        ELSE

                                            INSERT INTO matrimonio( dpi_hombre, dpi_mujer, fecha_matrimonio)
                                            VALUES (dpiHombre,dpiMujer,fechaMatrimonio) ;
                                            UPDATE persona SET estado='C' WHERE cui= dpiHombre;
                                            UPDATE persona SET estado='C' WHERE cui= dpiMujer;
                                            SELECT 'INGRESO Correcto';

                                        end if;
                                    ELSE
                                        INSERT INTO matrimonio( dpi_hombre, dpi_mujer, fecha_matrimonio)
                                        VALUES (dpiHombre,dpiMujer,fechaMatrimonio) ;
                                        UPDATE persona SET estado='C' WHERE cui= dpiHombre;
                                        UPDATE persona SET estado='C' WHERE cui= dpiMujer;
                                        SELECT 'INGRESO Correcto';
                                    end if;

                                end if;
                            ELSE
                                IF validacionPrimeraVezFallicido(dpiMujer) THEN
                                    SELECT id_detalle_persona FROM persona WHERE cui=dpiMujer INTO @DETALLEDEFUNCION2;
                                    IF BuscandoSiExisteActaDefuncion(@DETALLEDEFUNCION2)THEN
                                        SELECT 'ERROR: No tep puedes casar con alguien fallecido';
                                    ELSE

                                        INSERT INTO matrimonio( dpi_hombre, dpi_mujer, fecha_matrimonio)
                                        VALUES (dpiHombre,dpiMujer,fechaMatrimonio) ;
                                        UPDATE persona SET estado='C' WHERE cui= dpiHombre;
                                        UPDATE persona SET estado='C' WHERE cui= dpiMujer;
                                        SELECT 'INGRESO Correcto';

                                    end if;
                                ELSE
                                    INSERT INTO matrimonio( dpi_hombre, dpi_mujer, fecha_matrimonio)
                                    VALUES (dpiHombre,dpiMujer,fechaMatrimonio) ;
                                    UPDATE persona SET estado='C' WHERE cui= dpiHombre;
                                    UPDATE persona SET estado='C' WHERE cui= dpiMujer;
                                    SELECT 'INGRESO Correcto';
                                end if;
                            end if;
                        ELSE
                            SELECT 'ERROR: Fecha de matrimonio no valida';
                        end if;
                        ELSE
                            SELECT 'ERROR: Fecha de matrimonio no valida';
                    end if;
                ELSE
                    SELECT 'ERROR: La mujer sigue casado';
                end if;
                ELSE
            SELECT 'ERROR: El hombre sigue casado';
            end if;
        ELSE
            SELECT 'ERROR: EL DPI Mujer esta mal escrito';
        end if;
    ELSE
        SELECT 'ERROR: EL DPI Hombre esta mal escrito';
    end if;
END$$
DELIMITER;

CREATE FUNCTION verificarDPI(
    dpi1 bigint
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
    IF (dpi1 in (select dpi from datos_dpi)) THEN
        SET resultado=true;
    ELSE
        SET resultado = false;
    END IF;
    -- return the customer level
    RETURN (resultado);
END;
CREATE FUNCTION verificarSolteria(
    dpi1 bigint
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
IF (SELECT estado FROM persona WHERE cui=dpi1 )='S' THEN
        SET resultado=true;
    ELSE
        SET resultado = false;
    END IF;
    -- return the customer level
    RETURN (resultado);
END;

CALL AddMatrimonio(1123462592101,1129958074101,'2025-10-12');
# -------------------------------------------------- Registrar Divorcio -----------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE AddDivorcio(IN actaMatrimonio int,fechaDivorcio date)
BEGIN
    IF VerificarExistActaMatrimonio(actaMatrimonio) THEN
      IF  VerificarMatrimonioNoAnulado(actaMatrimonio) THEN
          SELECT 'ESTE MATRIMONIO YA FUE ANULADO';
      ELSE

          IF ValidarFechaDeDivorcio(actaMatrimonio,fechaDivorcio)>=0 THEN
              INSERT INTO divorcio(fecha_divorcio, id_matrimonio)
              VALUES (fechaDivorcio,actaMatrimonio);
              SELECT dpi_hombre FROM matrimonio WHERE id_matrimonio=actaMatrimonio INTO @dpihom;
              SELECT dpi_mujer FROM matrimonio WHERE id_matrimonio=actaMatrimonio INTO @dpimu;
              UPDATE persona SET estado='S' WHERE cui= @dpihom;
              UPDATE persona SET estado='S' WHERE cui=  @dpimu;
              SELECT 'DIVORCIO CORRECTO';
          ELSE
              SELECT 'FECHA DIVORCIO NO VALIDA';
          end if;
      end if;
        ELSE
    SELECT 'ACTA DE MATRIMONIO NO EXISTE';
    end if;
END$$
DELIMITER;

CREATE FUNCTION VerificarExistActaMatrimonio(
    acta int
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
    IF (acta in(select id_matrimonio from matrimonio)) THEN
        SET resultado=true;
        ELSE
            SET resultado=false;
    end if;
    -- return the customer level
    RETURN (resultado);
END;

CREATE FUNCTION VerificarMatrimonioNoAnulado(
    acta bigint
)
    RETURNS boolean
    DETERMINISTIC
BEGIN
    DECLARE resultado boolean;
    IF (SELECT id_matrimonio FROM divorcio WHERE id_matrimonio=acta )=acta THEN
        SET resultado=true;
    ELSE
        SET resultado = false;
    END IF;
    -- return the customer level
    RETURN (resultado);
END;

CREATE FUNCTION ValidarFechaDeDivorcio(
    acta int,
    fechadivor date
)
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE resultado int;
    SELECT TIMESTAMPDIFF(DAY ,fecha_matrimonio,fechadivor)  INTO @EDAD
    FROM matrimonio
    WHERE id_matrimonio=acta ;
    SET resultado=@EDAD;
    -- return the customer level
    RETURN (resultado);
END;


CALL AddDivorcio(5,'2040-10-10');
# ---------------------------------------------------- CONSULTA 8 ------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE generarDPI(IN cui bigint,fechaEmision date, municipio int)
BEGIN
  IF verificarCUI(cui) THEN
      IF ValidarFechaEmision(cui,fechaEmision)>=18 THEN
         INSERT INTO datos_dpi(dpi, cui, fecha_emision,residenciaActual)
            VALUES (cui,cui,fechaEmision,municipio);
         SELECT 'INGRESO CORRECTO';
          ELSE
          SELECT 'ERROR: AUN NO ES MAYOR DE EDAD';
      end if ;
      ELSE
      SELECT 'ERROR: EL cui esta mal escrito';
  end if;
END$$
DELIMITER;

CREATE FUNCTION ValidarFechaEmision(
    dpi bigint,
    Emision date
)
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE resultado int;
    SELECT TIMESTAMPDIFF(YEAR ,fecha_nacimineto,Emision)  INTO @EDAD
    FROM persona
    WHERE dpi=cui ;
    SET resultado=@EDAD;
    -- return the customer level
    RETURN (resultado);
END;
CALL generarDPI(1129958074101,'2020-08-23',101);

# ---------------------------------------------- Consulta 9-----------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE getNacimiento(IN cui1 bigint)
BEGIN
    SELECT acta_nacimiento.id_acta,persona.cui,persona.primer_apellido,persona.segundo_apellido,persona.primer_nombre,persona.segundo_nombre,
          acta_nacimiento.nombre_padre,acta_nacimiento.apellido_padre,acta_nacimiento.dpi_padre,acta_nacimiento.nombre_madre,acta_nacimiento.apellido_madre,
           persona.fecha_nacimineto, municipio.nombre_municipio,departamento.nombre_departamento,persona.genero
    from persona,acta_nacimiento,departamento,municipio
    WHERE cui=cui1
    AND persona.id_acta_nacimiento=acta_nacimiento.id_acta
    AND persona.id_municipio=municipio.codigo_municipio
    AND departamento.codigo_departamento=municipio.codigo_departamento;
END$$
DELIMITER;

CALL getNacimiento(1111111630409);



select * from datos_dpi;
select * from persona ;
select * from detalle_persona;
select * from acta_nacimiento;
SELECT * FROM defuncion;
