with base as (

    select * 
    from {{ ref('stg_lever__posting_interview_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__posting_interview_tmp')),
                staging_columns=get_posting_interview_columns()
            )
        }}

        {{ lever.apply_source_relation() }}

    from base
),

final as (

    select
        source_relation, 
        posting_id,
        interview_id,
        cast(_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced
    from fields
)

select * 
from final
