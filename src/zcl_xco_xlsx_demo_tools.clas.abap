CLASS zcl_xco_xlsx_demo_tools DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS gui_download_bin
      IMPORTING filepath TYPE csequence
                xstring  TYPE xstring.

    CLASS-METHODS gui_upload_bin
      IMPORTING filepath       TYPE csequence
      RETURNING VALUE(xstring) TYPE xstring.
ENDCLASS.


CLASS zcl_xco_xlsx_demo_tools IMPLEMENTATION.
  METHOD gui_download_bin.
    DATA(solix_tab) = cl_bcs_convert=>xstring_to_solix( xstring ).
    cl_gui_frontend_services=>gui_download( EXPORTING  bin_filesize            = xstrlen( xstring )
                                                       filename                = EXACT string( filepath )
                                                       filetype                = 'BIN'
                                            CHANGING   data_tab                = solix_tab
                                            EXCEPTIONS file_write_error        = 1
                                                       no_batch                = 2
                                                       gui_refuse_filetransfer = 3
                                                       invalid_type            = 4
                                                       no_authority            = 5
                                                       unknown_error           = 6
                                                       header_not_allowed      = 7
                                                       separator_not_allowed   = 8
                                                       filesize_not_allowed    = 9
                                                       header_too_long         = 10
                                                       dp_error_create         = 11
                                                       dp_error_send           = 12
                                                       dp_error_write          = 13
                                                       unknown_dp_error        = 14
                                                       access_denied           = 15
                                                       dp_out_of_memory        = 16
                                                       disk_full               = 17
                                                       dp_timeout              = 18
                                                       file_not_found          = 19
                                                       dataprovider_exception  = 20
                                                       control_flush_error     = 21
                                                       not_supported_by_gui    = 22
                                                       error_no_gui            = 23
                                                       OTHERS                  = 24 ).
    IF SY-SUBRC <> 0.
      RAISE EXCEPTION TYPE zcx_xco_xlsx_demo
        EXPORTING text  = |GUI_DOWNLOAD error &2 for file &1|
                  msgv1 = CONV #( filepath )
                  msgv2 = |{ sy-subrc }|.
    ENDIF.
  ENDMETHOD.

  METHOD gui_upload_bin.
    DATA(solix_tab) = VALUE solix_tab( ).
    cl_gui_frontend_services=>gui_upload( EXPORTING  filename                = EXACT string( filepath )
                                                     filetype                = 'BIN'
                                          CHANGING   data_tab                = solix_tab
                                          EXCEPTIONS file_open_error         = 1
                                                     file_read_error         = 2
                                                     no_batch                = 3
                                                     gui_refuse_filetransfer = 4
                                                     invalid_type            = 5
                                                     no_authority            = 6
                                                     unknown_error           = 7
                                                     bad_data_format         = 8
                                                     header_not_allowed      = 9
                                                     separator_not_allowed   = 10
                                                     header_too_long         = 11
                                                     unknown_dp_error        = 12
                                                     access_denied           = 13
                                                     dp_out_of_memory        = 14
                                                     disk_full               = 15
                                                     dp_timeout              = 16
                                                     not_supported_by_gui    = 17
                                                     error_no_gui            = 18
                                                     OTHERS                  = 19 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_xco_xlsx_demo
        EXPORTING text  = |GUI_UPLOAD error &2 for file &1|
                  msgv1 = CONV #( filepath )
                  msgv2 = |{ sy-subrc }|.
    ENDIF.
    xstring = cl_bcs_convert=>solix_to_xstring( solix_tab ).
  ENDMETHOD.
ENDCLASS.
