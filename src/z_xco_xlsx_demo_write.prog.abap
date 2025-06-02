REPORT z_xco_xlsx_demo_write.

PARAMETERS filepath TYPE string LOWER CASE DEFAULT 'C:\temp\test.xlsx'.
PARAMETERS tabname TYPE tabname DEFAULT 'SCARR'.
PARAMETERS rows TYPE i DEFAULT 10.

START-OF-SELECTION.
  TRY.
      CALL METHOD ('LCL_APP')=>('MAIN').
    CATCH cx_root INTO DATA(exception).
      MESSAGE exception TYPE 'I' DISPLAY LIKE 'E'.
  ENDTRY.

CLASS lcl_app DEFINITION FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS main.

    CLASS-METHODS write
      IMPORTING itab           TYPE ANY TABLE
      RETURNING VALUE(xstring) TYPE xstring.
ENDCLASS.


CLASS lcl_app IMPLEMENTATION.
  METHOD main.
    TYPES ty_ref_to_data TYPE REF TO data.
    FIELD-SYMBOLS <itab> TYPE STANDARD TABLE.

    DATA(ref_itab) = VALUE ty_ref_to_data( ).
    CREATE DATA ref_itab TYPE TABLE OF (tabname).
    ASSIGN ref_itab->* TO <itab>.

    SELECT *
      FROM (tabname)
      INTO TABLE @<itab>
      UP TO @rows ROWS.

    DATA(xstring) = write( <itab> ).

    zcl_xco_xlsx_demo_tools=>gui_download_bin( filepath = filepath
                                               xstring  = xstring ).
  ENDMETHOD.

  METHOD write.
    DATA(write_access) = xco_cp_xlsx=>document->empty( )->write_access( ).

    DATA(worksheet) = write_access->get_workbook( )->worksheet->at_position( 1 ).

    DATA(selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    worksheet->select( selection_pattern
               )->row_stream(
               )->operation->write_from( REF #( itab )
               )->execute( ).

    xstring = write_access->get_file_content( ).
  ENDMETHOD.
ENDCLASS.
