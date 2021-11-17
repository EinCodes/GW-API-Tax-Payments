* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method /EIN/CL_TAX_PAYMENT_DPC_EXT->DEBITSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TT_DEBIT
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD debitset_get_entityset.

  DATA(lw_key_values) = VALUE /ein/cl_tax_payment_mpc=>ts_payment( ).

  DATA(lt_navigation) = io_tech_request_context->get_navigation_path( ).

  DATA(lt_source_keys) = io_tech_request_context->get_source_keys( ).

  LOOP AT lt_source_keys INTO DATA(lw_source_keys).
    CASE lw_source_keys-name.
      WHEN c_name-bukrs.
        lw_key_values-bukrs = lw_source_keys-value.
      WHEN c_name-period.
        lw_key_values-period = lw_source_keys-value.
    ENDCASE.
  ENDLOOP.

  " ------------------------------------------------------------------ "
  "  Process Request
  " ------------------------------------------------------------------ "

  IF line_exists( lt_navigation[ nav_prop = c_nav_property-debits ] ).

    me->get_debits(
      EXPORTING
        iw_keys      = lw_key_values
        it_order     = it_order
      IMPORTING
        et_entityset = et_entityset
      EXCEPTIONS
        main_document_not_found = 1
        tax_estimates_not_found = 2
        OTHERS                  = 3 ).
    IF sy-subrc NE 0.
      me->rfc_save_log(
        EXPORTING
          i_entity_type = iv_entity_name
          it_key_tab    = it_key_tab ).
    ENDIF.

    RETURN.
  ENDIF.

ENDMETHOD.