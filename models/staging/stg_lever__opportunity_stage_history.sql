with base as (

    select * 
    from {{ ref('stg_lever__opportunity_stage_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__opportunity_stage_history_tmp')),
                staging_columns=get_opportunity_stage_history_columns()
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
        opportunity_id,
        stage_id,
        to_stage_index,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        updater_id as updater_user_id,
        cast(_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced
    from fields
)

select * 
from final
