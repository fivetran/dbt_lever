with application as (

    select *
    from {{ var('application') }}
),

agg_applications as (

    select 
        posting_id,
        min(created_at) as first_app_sent_at,

        -- these should be the only types of applications
        sum(case when type = 'referral' then 1 else 0 end) as count_referred_applications,
        sum(case when type = 'posting' or type = 'agency' then 1 else 0 end) as count_posting_applications,
        sum(case when type = 'user' then 1 else 0 end) as count_manual_user_applications,

        count(distinct opportunity_id) as count_opportunities,
        count(distinct case when archived_at is null then opportunity_id end) as count_open_opportunities

    from application

    group by 1
)

select * from agg_applications