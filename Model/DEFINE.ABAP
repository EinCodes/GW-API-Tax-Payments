* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_TAX_PAYMENT_MPC_EXT->DEFINE
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] /IWBEP/CX_MGW_MED_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD define.

  super->define( ).

  DATA(lo_annotation_helper) = NEW /ein/cl_annotation_helper(
    ii_model            = model
    ii_vocab_anno_model = vocab_anno_model ).

  lo_annotation_helper->disable_conversion(
    EXPORTING
      i_entity_name = c_entity-payment
      i_properties  = c_property-period ).

  lo_annotation_helper->disable_conversion(
    EXPORTING
      i_entity_name = c_entity-credit
      i_properties  = c_property-period ).

  lo_annotation_helper->disable_conversion(
    EXPORTING
      i_entity_name = c_entity-debit
      i_properties  = c_property-period ).

ENDMETHOD.

  