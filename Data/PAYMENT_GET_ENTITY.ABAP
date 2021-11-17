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