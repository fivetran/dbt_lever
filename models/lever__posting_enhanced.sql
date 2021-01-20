with posting_applications as (

    select *
    from {{ ref('int_lever__posting_applications') }}
),

posting as (

    select *
    from {{ ref('int_lever__posting_requisition_interview') }}
),

final as (

    select 
        posting.*,
        coalesce(posting_applications.count_opportunities, 0) as count_opportunities,
        coalesce(posting_applications.count_open_opportunities, 0) as count_open_opportunities,
        coalesce(posting_applications.count_referred_applications, 0) as count_referred_applications,
        coalesce(posting_applications.count_posting_applications, 0) as count_posting_applications,
        coalesce(posting_applications.count_manual_user_applications, 0) as count_manual_user_applications,
        posting_applications.first_app_sent_at

    from posting 
    left join posting_applications using(posting_id)
)

select * from final