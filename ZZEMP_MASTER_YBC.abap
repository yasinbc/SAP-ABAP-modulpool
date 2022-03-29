*&---------------------------------------------------------------------*
*& Report ZZEMP_MASTER_YBC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzemp_master_ybc.

TABLES: zzemp_master_ybc.

DATA: gs_emp_master TYPE zzemp_master_ybc.
DATA: gv_flag TYPE flag.


DATA: R_M, "Male
      R_F, "Female
      R_U. "Unknown



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : p_empid TYPE zzemp_master_ybc-empid OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  SELECT SINGLE * FROM zzemp_master_ybc INTO CORRESPONDING FIELDS OF gs_emp_master
  WHERE empid = p_empid.

    gs_emp_master-empid = p_empid.

    CALL SCREEN 0100.



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
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
  WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
    SET SCREEN 0.
  WHEN 'SAVE'.
    PERFORM save.
  ENDCASE.

  CLEAR : sy-ucomm.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SAVE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save .
  IF gs_emp_master-createdby IS INITIAL.
     gs_emp_master-createdby = sy-uname.
     gs_emp_master-createdby = sy-datum.
     gs_emp_master-createdby = sy-uzeit.
  ENDIF.

  MODIFY zzemp_master_ybc FROM gs_emp_master.

    MESSAGE 'Data saved successfully' TYPE 'S'.
      SET SCREEN 0.

ENDFORM.