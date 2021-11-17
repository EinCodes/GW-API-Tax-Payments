* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method /EIN/CL_TAX_PAYMENT_DPC_EXT=>GET_PAYMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IW_KEYS                        TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TS_PAYMENT
* | [<---] EW_ENTITY                      TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TS_PAYMENT
* | [EXC!] DOCUMENT_NOT_FOUND
* | [EXC!] PAYMENT_NOT_FOUND
* | [EXC!] PAYMENT_NOT_FOUND
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_payment.
   
  SELECT SINGLE * FROM /ein/t_tax_documents
    INTO @DATA(lw_tax_document)
      WHERE document_id EQ @iw_keys-document_id.

  IF sy-subrc NE 0.
    MESSAGE e001(/ein/td)
      RAISING document_not_found.
  ENDIF.
     

  SELECT * FROM /ein/t_tax_document_items
    INTO TABLE @DATA(lt_td_items)
      WHERE document_id EQ @lw_tax_document-id.

  IF sy-subrc NE 0.
    MESSAGE e002(/ein/td)
      RAISING tax_estimates_not_found.
  ENDIF.


  SELECT * FROM /ein/t_td_debits
    INTO TABLE @DATA(lt_debits)
      WHERE document_id EQ @lw_tax_document-id.

  IF sy-subrc NE 0.
    MESSAGE e011(/ein/td)
      RAISING tax_estimates_not_found.
  ENDIF.
  

  SELECT * FROM /ein/t_td_credits
    INTO TABLE @DATA(lt_credits)
      WHERE document_id EQ @lw_tax_document-id.

  IF sy-subrc NE 0.
    MESSAGE e012(/ein/td)
      RAISING tax_estimates_not_found.
  ENDIF.


  DATA(lw_debit_total) = 
    /ein/util_table_process=>collect_values( lt_debits ).

  DATA(lw_credit_total) = 
    /ein/util_table_process=>collect_values( lt_credits ).

  DATA(lo_payment_document) = NEW /ein/cl_tax_payment_document( 
    IMPORTING
      iw_header  = lw_tax_document
      it_items   = lt_td_items
      iw_debits  = lw_debit_total 
      iw_credits = lw_credit_total ).

  TRY.
    ew_entity = lo_payment_document->get_summary(  ).
    
  CATCH
    /ein/cx_tdp_busi_exception.
  
    MESSAGE e002(/ein/td)
      RAISING payment_not_found.

  ENDTRY.

ENDMETHOD.