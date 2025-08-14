with opportunity as (

    select *
    from {{ ref('stg_lever__opportunity') }}
),

application as (

    select *
    from {{ ref('stg_lever__application') }}
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
        and opportunity.source_relation = application.source_relation
)

select *
from final