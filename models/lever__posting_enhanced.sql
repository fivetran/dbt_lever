with posting as (

    select *
    from {{ var('posting') }}
),

posting_applications as (

    select *
    from {{ ref('int_lever__posting_applications') }}
),

posting_interviews as (

    select *
    from {{ ref('int_lever__posting_interviews') }}
),

posting_requisitions as (

    select 
        posting_id,
        count(requisition_id) as count_requisitions
    from {{ var('requisition_posting') }}

    group by 1
),

final as (

    select 
        posting.*,
        posting_applications.first_app_sent_at,

        coalesce(posting_applications.count_referred_applications, 0) as count_referred_applications,
        coalesce(posting_applications.count_posting_applications, 0) as count_posting_applications,
        coalesce(posting_applications.count_manual_user_applications, 0) as count_manual_user_applications,
        coalesce(posting_applications.count_opportunities, 0) as count_opportunities,
        coalesce(posting_applications.count_open_opportunities, 0) as count_open_opportunities,

        coalesce(posting_interviews.count_interviews, 0) as count_interviews,
        coalesce(posting_interviews.count_interviewees, 0) as count_interviewees,

        coalesce(posting_requisitions.count_requisitions, 0) as count_requisitions,
        posting_requisitions.posting_id is not null as has_requisition


    from posting

    left join posting_applications
        on posting.posting_id = posting_applications.posting_id
    left join posting_interviews
        on posting.posting_id = posting_interviews.posting_id
    left join posting_requisitions
        on posting.posting_id = posting_requisitions.posting_id
)


select * from final