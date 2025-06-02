CLASS zcx_xco_xlsx_demo DEFINITION
  PUBLIC
  INHERITING FROM cx_no_check
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING !text TYPE csequence
                msgv1 TYPE sy-msgv1 OPTIONAL
                msgv2 TYPE sy-msgv2 OPTIONAL
                msgv3 TYPE sy-msgv3 OPTIONAL
                msgv4 TYPE sy-msgv4 OPTIONAL.

    METHODS get_longtext REDEFINITION.
    METHODS get_text     REDEFINITION.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_message,
        msgid TYPE sy-msgid,
        msgty TYPE sy-msgty,
        msgno TYPE sy-msgno,
        msgv1 TYPE sy-msgv1,
        msgv2 TYPE sy-msgv2,
        msgv3 TYPE sy-msgv3,
        msgv4 TYPE sy-msgv4,
      END OF ty_message.

    DATA symsg TYPE ty_message.
    DATA text  TYPE string.
ENDCLASS.


CLASS zcx_xco_xlsx_demo IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).

    me->text = text.
    REPLACE ALL OCCURRENCES OF '&1' IN me->text WITH msgv1.
    REPLACE ALL OCCURRENCES OF '&2' IN me->text WITH msgv2.
    REPLACE ALL OCCURRENCES OF '&3' IN me->text WITH msgv3.
    REPLACE ALL OCCURRENCES OF '&4' IN me->text WITH msgv4.

    IF sy-msgid IS NOT INITIAL.
      symsg = VALUE #( msgid = sy-msgid
                       msgty = sy-msgty
                       msgno = sy-msgno
                       msgv1 = sy-msgv1
                       msgv2 = sy-msgv2
                       msgv3 = sy-msgv3
                       msgv4 = sy-msgv4 ).
      MESSAGE ID symsg-msgid TYPE symsg-msgty NUMBER symsg-msgno
              WITH symsg-msgv1 symsg-msgv2 symsg-msgv3 symsg-msgv4
              INTO DATA(symsg_text).
      me->text = me->text && | / { 'System message'(001) }: { symsg_text }|.
    ENDIF.
  ENDMETHOD.

  METHOD get_longtext.
    result = get_text( ).
  ENDMETHOD.

  METHOD get_text.
    result = text.
  ENDMETHOD.
ENDCLASS.
