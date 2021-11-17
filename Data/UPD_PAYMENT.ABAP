* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method /EIN/CL_TAX_PAYMENT_DPC_EXT=>UPD_PAYMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IW_DATA                        TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TS_PAYMENT
* | [<---] EW_ENTITY                      TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TS_PAYMENT
* | [EXC!] DOCUMENT_NOT_FOUND
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD upd_payment.

  DATA:
    lw_key_values TYPE /ein/cl_tax_payment_mpc=>ts_payment,
    lw_mtd        TYPE /ein/cl_tax_payment_mpc=>ts_payment.

  lw_key_values = VALUE #(
    bukrs  = iw_data-bukrs
    period = iw_data-period ).

  get_payment(
    EXPORTING
      iw_keys   = lw_key_values
    IMPORTING
      ew_entity = ew_entity
    EXCEPTIONS
      document_not_found = 1
      payment_not_found  = 2
      OTHERS             = 3 ).

  IF sy-subrc NE 0.
    MESSAGE e125(/ein/td)
      RAISING document_not_found.
  ENDIF.

  ew_entity = VALUE #(
    payment_date   = iw_data-payment_date
    payment_type   = iw_data-payment_type
    payment_desc   = iw_data-payment_desc 
    manual_payment = iw_data-manual_payment
    payment_amount = iw_data-payment_amount ).

  DATA(lo_payment_document) = NEW /ein/cl_tax_payment_document( 
    IMPORTING
      iw_summary = ew_entity ).

  lo_payment_document->update_document(  ).

ENDMETHOD.
