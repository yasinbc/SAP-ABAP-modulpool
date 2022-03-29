*FLOW LOGIC

PROCESS BEFORE OUTPUT.
 MODULE STATUS_0100.

PROCESS AFTER INPUT.
 MODULE USER_COMMAND_0100.


 MODULE EXT AT EXIT-COMMAND.



 

 *&---------------------------------------------------------------------*
*& Report ZZEMP_MASTER_YBC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZZEMP_MASTER_YBC.

tables: ZZEMP_MASTER_YBC.

data: gs_emp_master type ZZEMP_MASTER_YBC.
data: gv_flag type flag.

SELECTION-SCREEN begin of BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS : P_EMPID TYPE ZZEMP_MASTER_YBC-empid OBLIGATORY.
SELECTION-SCREEN end of BLOCK b1.

START-OF-SELECTION.
  SELECT SINGLE * FROM ZZEMP_MASTER_YBC INTO CORRESPONDING FIELDS OF gs_emp_master
  WHERE EMPID = p_empid.

    GS_EMP_MASTER-EMPID = p_empid.

    call SCREEN 0100.



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

  CASE SY-ucomm.
  WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
    SET SCREEN 0.
  WHEN 'SAVE'.
    PERFORM SAVE.
  ENDCASE.

  CLEAR : SY-ucomm.


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
  IF GS_EMP_MASTER-createdby IS INITIAL.
     GS_EMP_MASTER-createdby = SY-UNAME.
     GS_EMP_MASTER-createdby = SY-DATUM.
     GS_EMP_MASTER-createdby = SY-UZEIT.
  ENDIF.

  MODIFY zzemp_master_ybc FROM GS_EMP_MASTER.

    MESSAGE 'Data saved successfully' TYPE 'S'.
      SET SCREEN 0.

ENDFORM.