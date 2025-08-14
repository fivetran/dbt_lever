with base as (

    select * 
    from {{ ref('stg_lever__feedback_form_field_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__feedback_form_field_tmp')),
                staging_columns=get_feedback_form_field_columns()
            )
        }}

        {{ fivetran_utils.source_relation(
            union_schema_variable='lever_union_schemas', 
            union_database_variable='lever_union_databases') 
        }}

    from base
),

final as (

    select
        source_relation, 
        cast(_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced,
        code_language,
        currency,
        feedback_form_id,
        field_index,
        value_index,
        value_date,
        value_decimal,
        value_file_id,
        value_number,
        value_text
    from fields
)

select * 
from final
