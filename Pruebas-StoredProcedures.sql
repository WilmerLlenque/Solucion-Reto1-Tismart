-- -----------------------------------------------------
-- "PRUEBA FUNCIONAMIENTO DE SP_HOSPITAL_REGISTRAR"
-- -----------------------------------------------------

DECLARE
    v_id_distrito       HOSPITAL.ID_DISTRITO%TYPE;
    v_nombre            HOSPITAL.NOMBRE%TYPE;
    v_antiguedad        HOSPITAL.ANTIGUEDAD%TYPE;
    v_area              HOSPITAL.AREA%TYPE;
    v_id_sede           HOSPITAL.ID_SEDE%TYPE;
    v_id_gerente        HOSPITAL.ID_GERENTE%TYPE;
    v_id_condicion      HOSPITAL.ID_CONDICION%TYPE;

BEGIN
    v_id_distrito:=2;
    v_nombre:='Hospital san juan de dios';
    v_antiguedad:=2;
    v_area:=125.00;
    v_id_sede:=5;
    v_id_gerente:=4;
    v_id_condicion:=4;
    
    SP_HOSPITAL_REGISTRAR(v_id_distrito,v_nombre,v_antiguedad,v_area,v_id_sede,v_id_gerente,v_id_condicion);

END;



-- -----------------------------------------------------
-- "PRUEBA FUNCIONAMIENTO DE SP_HOSPITAL_ACTUALIZAR"
-- -----------------------------------------------------

DECLARE
    v_id_hospital       HOSPITAL.ID_HOSPITAL%TYPE;
    v_id_distrito       HOSPITAL.ID_DISTRITO%TYPE;
    v_nombre            HOSPITAL.NOMBRE%TYPE;
    v_antiguedad        HOSPITAL.ANTIGUEDAD%TYPE;
    v_area              HOSPITAL.AREA%TYPE;
    v_id_sede           HOSPITAL.ID_SEDE%TYPE;
    v_id_gerente        HOSPITAL.ID_GERENTE%TYPE;
    v_id_condicion      HOSPITAL.ID_CONDICION%TYPE;
    v_fecha_registro    HOSPITAL.FECHA_REGISTRO%TYPE;

BEGIN
    v_id_hospital:=7;
    v_id_distrito:=1;
    v_nombre:='Hospital San Martin1';
    v_antiguedad:=15;
    v_area:=128.00;
    v_id_sede:=1;
    v_id_gerente:=1;
    v_id_condicion:=5;
    v_fecha_registro:=to_date('10/04/2024','DD/MM/RRRR');
    
    SP_HOSPITAL_ACTUALIZAR(v_id_hospital,v_id_distrito,v_nombre,v_antiguedad,v_area,v_id_sede,v_id_gerente,v_id_condicion,v_fecha_registro);

END;





-- -----------------------------------------------------
-- "PRUEBA FUNCIONAMIENTO DE SP_HOSPITAL_LISTAR"
-- -----------------------------------------------------

BEGIN
    SP_HOSPITAL_LISTAR(
    --p_fecha_registro => to_date('04/08/2024','DD/MM/RRRR'),
    p_antiguedad =>1,
    p_area =>1,
    p_id_distrito=>2,
    p_id_sede=>9,
    p_id_gerente=>4,
    p_id_condicion=>4,
    p_nombre =>'belen'    
    );
END;





-- -----------------------------------------------------
-- "PRUEBA FUNCIONAMIENTO DE SP_HOSPITAL_ELIMINAR"
-- -----------------------------------------------------

BEGIN
    SP_HOSPITAL_ELIMINAR(8);
END;



























