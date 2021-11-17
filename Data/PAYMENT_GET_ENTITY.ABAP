* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method /EIN/CL_TAX_PAYMENT_DPC_EXT->PAYMENTSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_REQUEST_OBJECT              TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [<---] ER_ENTITY                      TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TS_PAYMENT
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD paymentset_get_entity.

  DATA:
    lw_key_values TYPE /ein/cl_tax_payment_mpc=>ts_payment.

  io_tech_request_context->get_converted_keys(
    IMPORTING
      es_key_values = lw_key_values ).

  " ------------------------------------------------------------------ "
  "  Process Request
  " ------------------------------------------------------------------ "

  me->get_payment(
    EXPORTING
      iw_keys   = lw_key_values
    IMPORTING
      ew_entity = er_entity
    EXCEPTIONS
      document_not_found = 1
      payment_not_found  = 2
      OTHERS             = 3 ).

  IF sy-subrc NE 0.
    me->rfc_save_log(
      EXPORTING
        i_entity_type = iv_entity_name
        it_key_tab    = it_key_tab ).
  ENDIF.

ENDMETHOD.