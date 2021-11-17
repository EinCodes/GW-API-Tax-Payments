* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method /EIN/CL_TAX_PAYMENT_DPC_EXT=>GET_DEBITS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER(optional)
* | [--->] IW_KEYS                        TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TS_PAYMENT
* | [<---] ET_ENTITYSET                   TYPE        /EIN/CL_TAX_PAYMENT_MPC=>TT_DEBIT
* | [EXC!] MAIN_DOCUMENT_NOT_FOUND
* | [EXC!] TAX_ESTIMATES_NOT_FOUND
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_debits.

  SELECT SINGLE * FROM /ein/t_main_tax_documents
    INTO @DATA(lw_mtd)
      WHERE bukrs  EQ @iw_keys-bukrs
        AND period EQ @iw_keys-period.

  IF sy-subrc NE 0.
    MESSAGE e001(/ein/mtd)
      RAISING main_document_not_found.
  ENDIF.

  SELECT * FROM /ein/t_mtd_debits
    INTO TABLE @DATA(lt_debits)
      WHERE document_id EQ lw_mtd-document_id.

  IF sy-subrc NE 0.
    MESSAGE e012(/ein/mtd)
      RAISING tax_estimates_not_found.
  ENDIF.

  DATA(lt_total) = /ein/util_table_process=>collect_values( lt_debits ).

  MOVE-CORRESPONDING
    lt_total TO et_entityset.

  /iwbep/cl_mgw_data_util=>orderby(
    EXPORTING
      it_order = lt_order
    CHANGING
      ct_data = et_entityset ).

ENDMETHOD.