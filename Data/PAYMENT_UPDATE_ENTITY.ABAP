* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method /EIN/CL_TAX_PAYMENT_DPC_EXT->PAYMENTSET_UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_U(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TS_PAYMENT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD paymentset_update_entity.

  DATA:
    lw_data TYPE /ein/cl_tax_payment_mpc=>ts_payment.

  io_data_provider->read_entry_data(
    IMPORTING
      es_data = lw_data ).

  " ------------------------------------------------------------------ "
  "  Process Request
  " ------------------------------------------------------------------ "

  me->get_payment(
    EXPORTING
      iw_data   = lw_data
    IMPORTING
      ew_entity = er_entity
    EXCEPTIONS
      document_not_found = 1
      OTHERS             = 2 ).

  IF sy-subrc NE 0.
    me->rfc_save_log(
      EXPORTING
        i_entity_type = iv_entity_name
        it_key_tab    = it_key_tab ).
  ENDIF.

ENDMETHOD.