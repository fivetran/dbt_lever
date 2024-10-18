with opportunity as (

    select *
    from {{ var('opportunity') }}
),

application as (

    select *
    from {{ var('application') }}
),

final as (

    select 
        opportunity.*,
        application.application_id,
        application.comments,
        application.company, 
        application.posting_hiring_manager_user_id,
        application.posting_id,
        application.posting_owner_user_id,
        application.referrer_user_id,
        application.requisition_id,
        application.type as application_type

    from opportunity
    left join application
        on opportunity.opportunity_id = application.opportunity_id
        {{ 'and opportunity.source_relation = application.source_relation' if var('lever_union_schemas', false) or var('lever_union_databases', false) }}
)

select *
from final