* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_TAX_PAYMENT_DPC_EXT->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ACTION_NAME                 TYPE        STRING(optional)
* | [--->] IT_PARAMETER                   TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_FUNC_IMPORT(optional)
* | [<---] ER_DATA                        TYPE REF TO DATA
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

  CASE iv_action_name.

    WHEN c_action-close.
      CALL METHOD me->action_close_document
        EXPORTING
          i_action_name           = iv_action_name
          it_parameter            = it_parameter
          ii_tech_request_context = io_tech_request_context
        IMPORTING
          er_data                 = er_data.

    WHEN c_action-revert.
      CALL METHOD me->action_revert_document
        EXPORTING
          i_action_name           = iv_action_name
          it_parameter            = it_parameter
          ii_tech_request_context = io_tech_request_context
        IMPORTING
          er_data                 = er_data.

    WHEN OTHERS.
      CALL METHOD super->/iwbep/if_mgw_appl_srv_runtime~execute_action
        EXPORTING
          iv_action_name          = iv_action_name
          it_parameter            = it_parameter
          io_tech_request_context = io_tech_request_context
        IMPORTING
          er_data                 = er_data.

  ENDCASE.

ENDMETHOD.