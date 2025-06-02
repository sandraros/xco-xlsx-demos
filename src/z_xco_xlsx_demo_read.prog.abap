REPORT z_xco_xlsx_demo_read.

PARAMETERS filepath TYPE string LOWER CASE DEFAULT 'C:\temp\test.xlsx'.
PARAMETERS tabname TYPE tabname DEFAULT 'SCARR'.

START-OF-SELECTION.
  TRY.
      CALL METHOD ('LCL_APP')=>('MAIN').
    CATCH cx_root INTO DATA(exception).
      MESSAGE exception TYPE 'I' DISPLAY LIKE 'E'.
  ENDTRY.

CLASS lcl_app DEFINITION FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS main
      RAISING cx_dynamic_check.

    CLASS-METHODS read
      IMPORTING xstring TYPE xstring
      EXPORTING itab    TYPE ANY TABLE ##NEEDED.
ENDCLASS.


CLASS lcl_app IMPLEMENTATION.
  METHOD main.
    TYPES ty_ref_to_data TYPE REF TO data.
    FIELD-SYMBOLS <itab> TYPE STANDARD TABLE.

    DATA(xstring) = zcl_xco_xlsx_demo_tools=>gui_upload_bin( filepath ).

    DATA(ref_itab) = VALUE ty_ref_to_data( ).
    CREATE DATA ref_itab TYPE TABLE OF (tabname).
    ASSIGN ref_itab->* TO <itab>.

    read( EXPORTING xstring = xstring
          IMPORTING itab    = <itab> ).

    cl_demo_output=>display( <itab> ).
  ENDMETHOD.

  METHOD read.
    DATA(document) = xco_cp_xlsx=>document->for_file_content( xstring )->read_access( ).

    DATA(sheet) = document->get_workbook( )->worksheet->at_position( 1 ).

    DATA(pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    sheet->select( pattern
            )->row_stream(
            )->operation->write_to( REF #( itab )
            )->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
            )->execute( ).
  ENDMETHOD.
ENDCLASS.
