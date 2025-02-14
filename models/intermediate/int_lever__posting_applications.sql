with application as (

    select *
    from {{ var('application') }}
),

agg_applications as (

    select 
        source_relation,
        posting_id,
        min(created_at) as first_app_sent_at,

        -- these should be the only types of applications
        sum(case when type = 'referral' then 1 else 0 end) as count_referred_applications,
        sum(case when type = 'posting' or type = 'agency' then 1 else 0 end) as count_posting_applications,
        sum(case when type = 'user' then 1 else 0 end) as count_manual_user_applications,

        count(distinct opportunity_id) as count_opportunities,
        count(distinct case when archived_at is null then opportunity_id end) as count_open_opportunities

    from application

    group by 1,2
),

order_hiring_managers as (

    select 
        source_relation,
        posting_id,
        posting_hiring_manager_user_id,
        row_number() over(
            partition by posting_id {{', source_relation' if var('lever_union_schemas', false) or var('lever_union_databases', false) }} 
            order by created_at desc) as row_num 
    from application
),

last_hiring_manager as (

    select *
    from order_hiring_managers 
    where row_num = 1
),

final as (

    select 
        agg_applications.*,
        last_hiring_manager.posting_hiring_manager_user_id

    from agg_applications
    join last_hiring_manager
        on agg_applications.posting_id = last_hiring_manager.posting_id
        and agg_applications.source_relation = last_hiring_manager.source_relation
)

select * from final