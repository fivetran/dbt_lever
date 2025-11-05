with base as (

    select * 
    from {{ ref('stg_lever__opportunity_source_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__opportunity_source_tmp')),
                staging_columns=get_opportunity_source_columns()
            )
        }}

        {{ lever.apply_source_relation() }}

    from base
),

final as (

    select
        source_relation, 
        opportunity_id, 
        cast(_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced,
        source
    from fields
)

select * 
from final
