*&---------------------------------------------------------------------*
*& Report ZZEMP_MASTER_YBC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzemp_master_ybc. "nombre modulpool

TABLES: zzemp_master_ybc. "nombre tabla donde se almacenan datos en BBDD


DATA: gs_emp_master TYPE zzemp_master_ybc. "tabla donde se copian los datos
DATA: gv_flag TYPE flag.


DATA: R_M, "Male
      R_F, "Female
      R_U. "Unknown

"Variables para almacenar campos del desplegable 'title' (Mr./Mrs.)
DATA: gv_id     TYPE vrm_id,
      gt_values TYPE vrm_values,
      gs_values LIKE LINE OF gt_values.
DATA: gv_init.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : p_empid TYPE zzemp_master_ybc-empid OBLIGATORY. "pantalla de inicio del programa
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  SELECT SINGLE * FROM zzemp_master_ybc INTO CORRESPONDING FIELDS OF gs_emp_master "seleccion de tabla maestra en copia
  WHERE empid = p_empid. "asigna el campo p_empid a empid

    gs_emp_master-empid = p_empid. "accede a la tabla y almacena el dato

    "establece valores iniciales por defecto del campo 'Gender'
    IF gs_emp_master-gender = 'M'.
        R_M = 'X'.
      ELSEIF GS_EMP_MASTER-gender = 'F'.
        R_F = 'X'.
      ELSE.
        
      ENDIF.

    CALL SCREEN 0100. "asigna SCREEN PAINTER 0100



END-OF-SELECTION.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'PF1'.
 SET TITLEBAR 'T1'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ext INPUT.
       SET SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT. "modulo PBO

  CASE sy-ucomm. "si se pulsan los botones del menu general...
  WHEN 'BACK' OR 'EXIT' OR 'CANCEL'. "ejecuta evento BACK, EXIT o CANCEL
    SET SCREEN 0. "te saca a la pantalla inicial del programa
  WHEN 'SAVE'. "Si a la opcion guardar 
    PERFORM save. "El programa guarda tus cambios
  ENDCASE.

  CLEAR : sy-ucomm. "limpia la variable SY-UCOMM


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SAVE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save . "indica lo que hace la funcion SAVE
  IF gs_emp_master-createdby IS INITIAL.
     gs_emp_master-createdby = sy-uname.
     gs_emp_master-createdby = sy-datum.
     gs_emp_master-createdby = sy-uzeit.
  ENDIF.

  "Si 'Gender' no está iniciado:
  IF R_M IS NOT INITIAL.
    GS_EMP_MASTER-GENDER = 'M'.
  ELSEIF R_F IS NOT INITIAL.
    GS_EMP_MASTER-GENDER = 'F'.
  ELSE.
    CLEAR: GS_EMP_MASTER-GENDER.
  ENDIF.
  
  MODIFY zzemp_master_ybc FROM gs_emp_master. 

    MESSAGE 'Data saved successfully' TYPE 'S'. "Mensaje despues de haber guardado
      SET SCREEN 0. "Te lleva fuera de la pantala

ENDFORM.

"Forma manual de elegir Mr/Mrs en el campo 'Title' 
FORM set_list_box.

    CLEAR: GT_VALUES[], GS_VALUES.
  
    gs_values-key = 'MR.'.
    APPEND gs_values TO gt_values.
  
    gs_values-key = 'Mrs.'.
    APPEND gs_values TO gt_values.
  
    SORT gt_values BY key.
    DELETE ADJACENT DUPLICATES FROM gt_values COMPARING key.
  
    GV_ID = 'GS_EMP_MASTER-TITLE'.
  
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        ID     = GV_ID
        VALUES = GT_VALUES.
  
    CLEAR: GS_VALUES, GT_VALUES[].
  
  ENDFORM.