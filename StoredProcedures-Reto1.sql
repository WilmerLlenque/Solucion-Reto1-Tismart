-- -----------------------------------------------------
-- PROCEDIMIENTO ALMACENADO "SP_HOSPITAL_REGISTRAR"
-- -----------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_HOSPITAL_REGISTRAR(
    p_id_distrito       IN HOSPITAL.ID_DISTRITO%TYPE,
    p_nombre            IN HOSPITAL.NOMBRE%TYPE,
    p_antiguedad        IN HOSPITAL.ANTIGUEDAD%TYPE,
    p_area              IN HOSPITAL.AREA%TYPE,
    p_id_sede           IN HOSPITAL.ID_SEDE%TYPE,
    p_id_gerente        IN HOSPITAL.ID_GERENTE%TYPE,
    p_id_condicion      IN HOSPITAL.ID_CONDICION%TYPE
)IS
    -- Declaracion de las variables 
    v_id_hospital HOSPITAL.ID_HOSPITAL%TYPE;
    v_id_distrito NUMBER;
    id_distrito_no_encontrado EXCEPTION;
    v_id_sede NUMBER;
    id_sede_no_encontrado EXCEPTION;
    v_id_gerente NUMBER;
    id_gerente_no_encontrado EXCEPTION;
    v_id_condicion NUMBER;
    id_condicion_no_encontrado EXCEPTION;
    v_count_hospital NUMBER;
    v_nombre_hospital_existe EXCEPTION;

BEGIN

    SELECT NVL(MAX(ID_HOSPITAL)+1,1) INTO v_id_hospital FROM HOSPITAL;
    SELECT COUNT(*) INTO v_count_hospital FROM HOSPITAL WHERE NOMBRE=p_nombre;
    SELECT COUNT(*) INTO v_id_distrito FROM DISTRITO WHERE ID_DISTRITO=p_id_distrito;
    SELECT COUNT(*) INTO v_id_sede FROM SEDE WHERE ID_SEDE=p_id_sede;
    SELECT COUNT(*) INTO v_id_gerente FROM GERENTE WHERE ID_GERENTE=p_id_gerente;
    SELECT COUNT(*) INTO v_id_condicion FROM CONDICION WHERE ID_CONDICION=p_id_condicion;
    
    -- Lanzamos las excepciones cuando no existen los id_distrito, id_sede, id_gerente, id_condicion.
    IF v_count_hospital>0 THEN RAISE v_nombre_hospital_existe; END IF;
    IF v_id_distrito=0 THEN RAISE id_distrito_no_encontrado; END IF;
    IF v_id_sede=0 THEN RAISE id_sede_no_encontrado; END IF;
    IF v_id_gerente=0 THEN RAISE id_gerente_no_encontrado; END IF;
    IF v_id_condicion=0 THEN RAISE id_condicion_no_encontrado; END IF;
    
    -- Registro del hospital
    INSERT INTO HOSPITAL (ID_HOSPITAL, ID_DISTRITO, NOMBRE, ANTIGUEDAD, AREA, ID_SEDE,ID_GERENTE,
                          ID_CONDICION, FECHA_REGISTRO)
    VALUES(v_id_hospital, p_id_distrito, p_nombre, p_antiguedad, P_area, p_id_sede, p_id_gerente,
                          p_id_condicion, SYSDATE);
    -- Mensaje para confirmar el registro del hospital
    DBMS_OUTPUT.PUT_LINE('Hospital registrado exitosamente.');
    -- Confirmar la transacción
    COMMIT;
    
EXCEPTION 
    -- Manejo de excepciones personalizadas
    WHEN v_nombre_hospital_existe THEN
    DBMS_OUTPUT.PUT_LINE('El nombre "'||p_nombre||'" ya existe en la base de datos');
    WHEN id_distrito_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_distrito '||p_id_distrito||' no existe en la base de datos');
    WHEN id_sede_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_sede '||p_id_sede||' no existe en la base de datos');
    WHEN id_gerente_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_gerente '||p_id_gerente||' no existe en la base de datos');
    WHEN id_condicion_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_condicion '||p_id_condicion||' no existe en la base de datos');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ');
   
END;


-- -----------------------------------------------------
-- PROCEDIMIENTO ALMACENADO "SP_HOSPITAL_ACTUALIZAR"
-- -----------------------------------------------------
/
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_ACTUALIZAR(
    p_id_hospital       IN HOSPITAL.ID_HOSPITAL%TYPE,
    p_id_distrito       IN HOSPITAL.ID_DISTRITO%TYPE,
    p_nombre            IN HOSPITAL.NOMBRE%TYPE,
    p_antiguedad        IN HOSPITAL.ANTIGUEDAD%TYPE,
    p_area              IN HOSPITAL.AREA%TYPE,
    p_id_sede           IN HOSPITAL.ID_SEDE%TYPE,
    p_id_gerente        IN HOSPITAL.ID_GERENTE%TYPE,
    p_id_condicion      IN HOSPITAL.ID_CONDICION%TYPE,
    p_fecha_registro    IN HOSPITAL.FECHA_REGISTRO%TYPE
    
)IS
    -- Declaramos el cursor nombre_hospital
    cursor nombre_hospital is select nombre,id_hospital from hospital;
    
    -- Declaracion de las variables    
    v_count NUMBER;
    id_hospital_no_encontrado EXCEPTION;    
    v_id_distrito NUMBER;
    id_distrito_no_encontrado EXCEPTION;    
    v_id_sede NUMBER;
    id_sede_no_encontrado EXCEPTION;    
    v_id_gerente NUMBER;
    id_gerente_no_encontrado EXCEPTION;    
    v_id_condicion NUMBER;
    id_condicion_no_encontrado EXCEPTION;    
    v_id NUMBER;
    v_nombre_hospital_existe EXCEPTION;
    v_boolean BOOLEAN:=false;
    

BEGIN
    
    --Verificamos que el hospital existe antes de realizar la actualizacion
    SELECT COUNT(*) INTO v_count FROM HOSPITAL WHERE ID_HOSPITAL = p_id_hospital;
    
    IF v_count = 0 THEN
          RAISE id_hospital_no_encontrado;
    
    ELSE
        SELECT COUNT(*) INTO v_id_distrito FROM DISTRITO WHERE ID_DISTRITO=p_id_distrito;
        SELECT COUNT(*) INTO v_id_sede FROM SEDE WHERE ID_SEDE=p_id_sede;
        SELECT COUNT(*) INTO v_id_gerente FROM GERENTE WHERE ID_GERENTE=p_id_gerente;
        SELECT COUNT(*) INTO v_id_condicion FROM CONDICION WHERE ID_CONDICION=p_id_condicion;
        
        -- Utilizamos el FOR para cursores para verificar si el nombre del hospital existe 
        for n in nombre_hospital loop
            IF n.id_hospital != p_id_hospital AND n.nombre = p_nombre THEN
            v_boolean := TRUE;
            EXIT; -- Salimos del bucle ya que hemos encontrado la coincidencia
            END IF;
        end loop;
        
        -- Lanzamos las excepciones cuando no existen los id_distrito, id_sede, id_gerente, id_condicion.
        IF v_id_distrito=0 THEN RAISE id_distrito_no_encontrado; END IF;
        IF v_id_sede=0 THEN RAISE id_sede_no_encontrado; END IF;
        IF v_id_gerente=0 THEN RAISE id_gerente_no_encontrado; END IF;
        IF v_id_condicion=0 THEN RAISE id_condicion_no_encontrado; END IF;    
        IF v_boolean THEN RAISE v_nombre_hospital_existe; END IF;
        
        -- Actualizacion del hospital
        UPDATE HOSPITAL 
        SET ID_DISTRITO=p_id_distrito, NOMBRE=p_nombre, ANTIGUEDAD=p_antiguedad, AREA=p_area,
            ID_SEDE=p_id_sede, ID_GERENTE=p_id_gerente, ID_CONDICION=p_id_condicion,
            FECHA_REGISTRO=p_fecha_registro
        WHERE ID_HOSPITAL = p_id_hospital;
        
        -- Mensaje para confirmar la actualizacion del hospital
        DBMS_OUTPUT.PUT_LINE('Hospital con ID ' || p_id_hospital || ' actualizado exitosamente.');
        -- Confirmar la transacción
        COMMIT;
    
    END IF;  
    
EXCEPTION 
    -- Manejo de excepciones personalizadas
    WHEN id_hospital_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El hospital con ID ' || p_id_hospital || ' no existe.');
    WHEN v_nombre_hospital_existe THEN
    DBMS_OUTPUT.PUT_LINE('El nombre "'||p_nombre||'" ya existe en la base de datos');
    WHEN id_distrito_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_distrito '||p_id_distrito||' no existe en la base de datos');
    WHEN id_sede_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_sede '||p_id_sede||' no existe en la base de datos');
    WHEN id_gerente_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_gerente '||p_id_gerente||' no existe en la base de datos');
    WHEN id_condicion_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_condicion '||p_id_condicion||' no existe en la base de datos');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ');

END;

-- -----------------------------------------------------
-- PROCEDIMIENTO ALMACENADO "SP_HOSPITAL_ELIMINAR"
-- -----------------------------------------------------
/
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_ELIMINAR(
    p_id_hospital IN HOSPITAL.ID_HOSPITAL%TYPE
) IS
    v_count NUMBER;
    id_hospital_no_encontrado EXCEPTION;
BEGIN
    --Verificamos que el hospital existe antes de realizar la actualizacion
    SELECT COUNT(*) INTO v_count FROM HOSPITAL WHERE ID_HOSPITAL = p_id_hospital;
    
    --Si no se encuentra el id lanzamos la excepcion, caso contrario procedemeos a eliminar el registro
    IF v_count = 0 THEN
        RAISE id_hospital_no_encontrado;
    ELSE
        -- Eliminar el hospital
        DELETE FROM HOSPITAL WHERE ID_HOSPITAL = p_id_hospital;
    
        -- Mensaje para confirmar la eliminación
        DBMS_OUTPUT.PUT_LINE('Hospital con ID ' || p_id_hospital || ' eliminado exitosamente.');
        -- Confirmar la transacción
        COMMIT;
    END IF;
    
EXCEPTION 
    WHEN id_hospital_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El hospital con ID ' || p_id_hospital || ' no existe.');
    
END;

-- -----------------------------------------------------
-- PROCEDIMIENTO ALMACENADO "SP_HOSPITAL_LISTAR"
-- -----------------------------------------------------
/
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_LISTAR(
    p_fecha_registro IN HOSPITAL.FECHA_REGISTRO%TYPE := NULL,
    p_antiguedad IN HOSPITAL.ANTIGUEDAD%TYPE := NULL,
    p_area IN HOSPITAL.AREA%TYPE := NULL,
    p_id_distrito IN HOSPITAL.ID_DISTRITO%TYPE := NULL,
    p_id_sede IN HOSPITAL.ID_SEDE%TYPE := NULL,
    p_id_gerente IN HOSPITAL.ID_GERENTE%TYPE := NULL,
    p_id_condicion IN HOSPITAL.ID_CONDICION%TYPE := NULL,
    p_nombre IN HOSPITAL.NOMBRE%TYPE := NULL
) IS
    -- Declaramos el cursor c_hospital
    CURSOR c_hospital IS
        SELECT * FROM HOSPITAL
        WHERE (p_nombre IS NULL OR nombre LIKE '%' || p_nombre || '%')
          AND (p_antiguedad IS NULL OR antiguedad >=p_antiguedad)
          AND (p_area IS NULL OR area >=p_area)
          AND (p_id_distrito IS NULL OR ID_DISTRITO =p_id_distrito)
          AND (p_id_sede IS NULL OR ID_SEDE =p_id_sede)
          AND (p_id_gerente IS NULL OR ID_GERENTE =p_id_gerente)
          AND (p_id_condicion IS NULL OR ID_CONDICION =p_id_condicion)
          AND (p_fecha_registro IS NULL OR fecha_registro LIKE '%' || p_fecha_registro || '%');
    
    -- Declaracion de las variables
    v_id_distrito NUMBER;
    id_distrito_no_encontrado EXCEPTION;
    v_id_sede NUMBER;
    id_sede_no_encontrado EXCEPTION;
    v_id_gerente NUMBER;
    id_gerente_no_encontrado EXCEPTION;
    v_id_condicion NUMBER;
    id_condicion_no_encontrado EXCEPTION;
    v_count NUMBER:=0;
    coincidencia_no_encontrada EXCEPTION;
BEGIN
    
    SELECT COUNT(*) INTO v_id_distrito FROM DISTRITO WHERE ID_DISTRITO=p_id_distrito;
    SELECT COUNT(*) INTO v_id_sede FROM SEDE WHERE ID_SEDE=p_id_sede;
    SELECT COUNT(*) INTO v_id_gerente FROM GERENTE WHERE ID_GERENTE=p_id_gerente;
    SELECT COUNT(*) INTO v_id_condicion FROM CONDICION WHERE ID_CONDICION=p_id_condicion;
    
    -- Lanzamos las excepciones cuando no existen los id_distrito, id_sede, id_gerente, id_condicion.
    IF v_id_distrito=0 and p_id_distrito IS NOT NULL THEN RAISE id_distrito_no_encontrado; END IF;
    IF v_id_sede=0 and p_id_sede IS NOT NULL THEN RAISE id_sede_no_encontrado; END IF;
    IF v_id_gerente=0 and p_id_gerente IS NOT NULL  THEN RAISE id_gerente_no_encontrado; END IF;
    IF v_id_condicion=0 and p_id_condicion IS NOT NULL THEN RAISE id_condicion_no_encontrado; END IF;
    
    -- Utilizamos el FOR para cursores para imprimir los datos del hospital 
    FOR r_hospital IN c_hospital LOOP        
        DBMS_OUTPUT.PUT_LINE('ID: ' || r_hospital. ID_HOSPITAL|| 
                             ' | ID_distrito: ' || r_hospital.ID_DISTRITO || 
                             ' | Nombre: ' || r_hospital.NOMBRE || 
                             ' | Antiguedad: ' || r_hospital.ANTIGUEDAD ||
                             ' | Area: ' || r_hospital.AREA || 
                             ' | ID_sede: ' || r_hospital.ID_SEDE || 
                             ' | ID_gerente: ' || r_hospital.ID_GERENTE || 
                             ' | ID_condicion: ' || r_hospital.ID_CONDICION || 
                             ' | Fecha_registro: ' || r_hospital.FECHA_REGISTRO
                             );
        v_count:=v_count+1;
    END LOOP;
    
    -- Lanzamos la excepcion cuando no se encontraron coincidencias
    IF v_count=0 THEN RAISE coincidencia_no_encontrada; END IF;
    
EXCEPTION 
    -- Manejo de excepciones personalizadas
    WHEN coincidencia_no_encontrada THEN
    DBMS_OUTPUT.PUT_LINE('No se encontraron coincidencias');
    WHEN id_distrito_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_distrito '||p_id_distrito||' no existe en la base de datos');
    WHEN id_sede_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_sede '||p_id_sede||' no existe en la base de datos');
    WHEN id_gerente_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_gerente '||p_id_gerente||' no existe en la base de datos');
    WHEN id_condicion_no_encontrado THEN
    DBMS_OUTPUT.PUT_LINE('El id_condicion '||p_id_condicion||' no existe en la base de datos');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ');
END;



