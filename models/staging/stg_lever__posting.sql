with base as (

    select * 
    from {{ ref('stg_lever__posting_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__posting_tmp')),
                staging_columns=get_posting_columns()
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
        categories_commitment as job_commitment,
        categories_department as job_department,
        categories_level as job_level,
        categories_location as job_location,
        categories_team as job_team,
        content_description,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        creator_id as creator_user_id,
        id as posting_id, 
        owner_id as owner_user_id,
        requisition_code,
        state as current_state,
        text as job_title, 
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at
    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * 
from final
