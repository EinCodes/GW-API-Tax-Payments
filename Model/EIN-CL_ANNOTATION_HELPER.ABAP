CLASS /ein/cl_annotation_helper DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF c_display_format,
        date         TYPE /iwbep/med_annotation_value VALUE 'Date',
        non_negative TYPE /iwbep/med_annotation_value VALUE 'NonNegative',
        upper_case   TYPE /iwbep/med_annotation_value VALUE 'UpperCase',
      END OF c_display_format .
    CONSTANTS:
      BEGIN OF c_filter_restriction,
        interval     TYPE /iwbep/med_annotation_value VALUE 'interval',
        single_value TYPE /iwbep/med_annotation_value VALUE 'single-value',
        multi_value  TYPE /iwbep/med_annotation_value VALUE 'multi-value',
      END OF c_filter_restriction .

    METHODS constructor
      IMPORTING
        !ii_model            TYPE REF TO /iwbep/if_mgw_odata_model
        !ii_vocab_anno_model TYPE REF TO /iwbep/if_mgw_vocan_model .
    METHODS disable_conversion
      IMPORTING
        !i_entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_properties  TYPE string .
    METHODS set_as_date
      IMPORTING
        !i_entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_properties  TYPE string .
    METHODS set_as_uppercase
      IMPORTING
        !i_entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_properties  TYPE string .
    METHODS set_filter_as_dropdown
      IMPORTING
        !i_entityset_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_entity_name    TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_property_key   TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_property_desc  TYPE /iwbep/med_annotation_value .
    METHODS set_filter_as_interval
      IMPORTING
        !i_entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_properties  TYPE string .
    METHODS set_filter_as_required
      IMPORTING
        !i_entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_properties  TYPE string .
    METHODS set_filter_as_single_value
      IMPORTING
        !i_entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_properties  TYPE string .
    METHODS set_text_for
      IMPORTING
        !i_entity_name   TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_key_property  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_text_property TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name .
    METHODS value_help_bukrs
      IMPORTING
        !i_entity_name   TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        !i_property_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name .
  PROTECTED SECTION.

    DATA model TYPE REF TO /iwbep/cl_mgw_odata_model .
    DATA namespace TYPE string .
    DATA vocab_anno_model TYPE REF TO /iwbep/if_mgw_vocan_model .
    DATA vocan_reference TYPE REF TO /iwbep/if_mgw_vocan_reference .
  PRIVATE SECTION.
ENDCLASS.



CLASS /ein/cl_annotation_helper IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] II_MODEL                       TYPE REF TO /IWBEP/IF_MGW_ODATA_MODEL
* | [--->] II_VOCAB_ANNO_MODEL            TYPE REF TO /IWBEP/IF_MGW_VOCAN_MODEL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    model            ?= ii_model.
    vocab_anno_model = ii_vocab_anno_model.

    vocan_reference = vocab_anno_model->create_vocabulary_reference(
      EXPORTING
        iv_vocab_id      = '/IWBEP/VOC_COMMON'
        iv_vocab_version = '0001' ).

    vocan_reference->create_include(
      EXPORTING
        iv_namespace = 'com.sap.vocabularies.Common.v1'
        iv_alias     = 'Common' ).

    namespace = model->ms_header-schema_namespace.
    REPLACE '/EIN/' IN namespace WITH ''.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->DISABLE_CONVERSION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTIES                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD disable_conversion.
    DATA:
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property.

    DATA:
      lt_property TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
      l_property  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

    SPLIT i_properties AT ',' INTO TABLE lt_property.
    LOOP AT lt_property INTO l_property.
      TRY .
          li_odata_property = li_odata_entity_type->get_property( l_property ).
          li_odata_property->disable_conversion( ).
        CATCH /iwbep/cx_mgw_med_exception.
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->SET_AS_DATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTIES                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_as_date.
    DATA:
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property,
      li_odata_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    DATA:
      lt_property TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
      l_property  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

    SPLIT i_properties AT ',' INTO TABLE lt_property.
    LOOP AT lt_property INTO l_property.
      TRY .
          li_odata_property = li_odata_entity_type->get_property( l_property ).
          li_odata_annotation = li_odata_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
          li_odata_annotation->add(
            iv_key   = 'display-format'
            iv_value = c_display_format-date ).
        CATCH /iwbep/cx_mgw_med_exception.
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->SET_AS_UPPERCASE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTIES                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_as_uppercase.
    DATA:
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property,
      li_odata_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    DATA:
      lt_property TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
      l_property  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

    SPLIT i_properties AT ',' INTO TABLE lt_property.
    LOOP AT lt_property INTO l_property.
      TRY .
          li_odata_property = li_odata_entity_type->get_property( l_property ).
          li_odata_annotation = li_odata_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
          li_odata_annotation->add(
            iv_key   = 'display-format'
            iv_value = c_display_format-upper_case ).
        CATCH /iwbep/cx_mgw_med_exception.
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->SET_FILTER_AS_DROPDOWN
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITYSET_NAME               TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTY_KEY                 TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTY_DESC                TYPE        /IWBEP/MED_ANNOTATION_VALUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_filter_as_dropdown.
    DATA:
      li_odata_entity_set  TYPE REF TO /iwbep/if_mgw_odata_entity_set,
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property,
      li_odata_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    TRY .
        li_odata_entity_set = model->get_entity_set( i_entityset_name ).
        li_odata_annotation = li_odata_entity_set->create_annotation( 'sap' ).
        li_odata_annotation->add(
          iv_key   = 'semantics'
          iv_value = 'fixed-values' ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
        li_odata_property = li_odata_entity_type->get_property( i_property_key ).
        li_odata_annotation = li_odata_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
        li_odata_annotation->add(
          iv_key   = 'text'
          iv_value = i_property_desc ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->SET_FILTER_AS_INTERVAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTIES                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_filter_as_interval.
    DATA:
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property,
      li_odata_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    DATA:
      lt_property TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
      l_property  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

    SPLIT i_properties AT ',' INTO TABLE lt_property.
    LOOP AT lt_property INTO l_property.
      TRY .
          li_odata_property = li_odata_entity_type->get_property( l_property ).
          li_odata_annotation = li_odata_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
          li_odata_annotation->add(
            iv_key   = 'filter-restriction'
            iv_value = c_filter_restriction-interval ).
        CATCH /iwbep/cx_mgw_med_exception.
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->SET_FILTER_AS_REQUIRED
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTIES                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_filter_as_required.
    DATA:
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property,
      li_odata_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    DATA:
      lt_property TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
      l_property  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

    SPLIT i_properties AT ',' INTO TABLE lt_property.
    LOOP AT lt_property INTO l_property.
      TRY .
          li_odata_property = li_odata_entity_type->get_property( l_property ).
          li_odata_annotation = li_odata_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
          li_odata_annotation->add(
            iv_key   = 'required-in-filter'
            iv_value = 'true' ).
        CATCH /iwbep/cx_mgw_med_exception.
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->SET_FILTER_AS_SINGLE_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTIES                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_filter_as_single_value.
    DATA:
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property,
      li_odata_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    DATA:
      lt_property TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
      l_property  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

    SPLIT i_properties AT ',' INTO TABLE lt_property.
    LOOP AT lt_property INTO l_property.
      TRY .
          li_odata_property = li_odata_entity_type->get_property( l_property ).
          li_odata_annotation = li_odata_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
          li_odata_annotation->add(
            iv_key   = 'filter-restriction'
            iv_value = c_filter_restriction-single_value ).
        CATCH /iwbep/cx_mgw_med_exception.
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->SET_TEXT_FOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_KEY_PROPERTY                 TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_TEXT_PROPERTY                TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_text_for.
    DATA:
      li_odata_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      li_odata_property    TYPE REF TO /iwbep/if_mgw_odata_property,
      li_odata_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    TRY .
        li_odata_entity_type = model->get_entity_type( i_entity_name ).
        li_odata_property = li_odata_entity_type->get_property( i_key_property ).
        li_odata_annotation = li_odata_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
        li_odata_annotation->add(
          iv_key   = 'text'
          iv_value = CONV #( i_text_property ) ).
      CATCH /iwbep/cx_mgw_med_exception.
        RETURN.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /EIN/CL_ANNOTATION_HELPER->VALUE_HELP_BUKRS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ENTITY_NAME                  TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* | [--->] I_PROPERTY_NAME                TYPE        /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD value_help_bukrs.
    DATA:
      li_vocan_ann_target TYPE REF TO /iwbep/if_mgw_vocan_ann_target,
      li_vocan_annotation TYPE REF TO /iwbep/if_mgw_vocan_annotation,
      li_vocan_record     TYPE REF TO /iwbep/if_mgw_vocan_record,
      li_vocan_property   TYPE REF TO /iwbep/if_mgw_vocan_property,
      li_vocan_collection TYPE REF TO /iwbep/if_mgw_vocan_collection.

    li_vocan_ann_target = vocab_anno_model->create_annotations_target( |{ namespace }.{ i_entity_name }/{ i_property_name }| ).
    li_vocan_annotation = li_vocan_ann_target->create_annotation( 'com.sap.vocabularies.Common.v1.ValueList' ).

    li_vocan_record = li_vocan_annotation->create_record( ).

    li_vocan_property = li_vocan_record->create_property( 'CollectionPath' ).
    li_vocan_property->create_simple_value( )->set_string( 'VHCompanySet' ).

    li_vocan_collection = li_vocan_record->create_property( 'Parameters' )->create_collection( ).
    li_vocan_record = li_vocan_collection->create_record( 'com.sap.vocabularies.Common.v1.ValueListParameterInOut' ).

    li_vocan_property = li_vocan_record->create_property( 'LocalDataProperty' ).
    li_vocan_property->create_simple_value( )->set_property_path( 'Bukrs' ).

    li_vocan_property = li_vocan_record->create_property( 'ValueListProperty' ).
    li_vocan_property->create_simple_value( )->set_string( 'Bukrs' ).

    li_vocan_record = li_vocan_collection->create_record( 'com.sap.vocabularies.Common.v1.ValueListParameterDisplayOnly' ).
    li_vocan_property = li_vocan_record->create_property( 'ValueListProperty' ).
    li_vocan_property->create_simple_value( )->set_string( 'CompanyName' ).

    li_vocan_record = li_vocan_collection->create_record( 'com.sap.vocabularies.Common.v1.ValueListParameterDisplayOnly' ).
    li_vocan_property = li_vocan_record->create_property( 'ValueListProperty' ).
    li_vocan_property->create_simple_value( )->set_string( 'CNPJ' ).

  ENDMETHOD.

ENDCLASS.