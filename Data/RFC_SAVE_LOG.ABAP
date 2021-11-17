* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method /EIN/CL_TAX_PAYMENT_DPC_EXT->RFC_SAVE_LOG
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_TYPE                  TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR(optional)
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD RFC_SAVE_LOG.

  DATA(lw_return) = VALUE bapiret2(
    id         = sy-msgid
    type       = sy-msgty
    number     = sy-msgno
    message_v1 = sy-msgv1
    message_v2 = sy-msgv2
    message_v3 = sy-msgv3
    message_v4 = sy-msgv4 ).

  me->/iwbep/if_sb_dpc_comm_services~rfc_save_log(
    EXPORTING
      is_return      = lw_return
      it_key_tab     = it_key_tab 
      iv_entity_type = i_entity_type ).

ENDMETHOD.