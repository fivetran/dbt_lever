with posting as (

    select *
    from {{ var('posting') }}
),

posting_interview as (

    select *
    from {{ var('posting_interview') }}
),

requisition as (
    
    select *
    from {{ var('requisition') }}
),

requisition_posting as (

    select *
    from {{ var('requisition_posting') }}
),

join_w_interview as (

    select 
        posting.*,
        posting_interview.interview_id
    
    from posting 
    left join posting_interview using(posting_id)
),

join_w_requisition as (

    select
        join_w_interview.*,
        
        -- if a posting has multiple 
        max(requisition.hiring_manager_user_id) as hiring_manager_user_id,
        max(requisition.requisition_id is not null) as has_requisition,
        max(requisition.is_backfill) as requisition_is_backfill,
        max(requisition.compensation_band_currency) as compensation_band_currency,
        max(requisition.compensation_band_interval) as compensation_band_interval,
        max(requisition.compensation_band_max) as compensation_band_max,
        max(requisition.compensation_band_min) as compensation_band_min,
        sum(cast (requisition.headcount_hired as {{ dbt_utils.type_int() }}) ) as headcount_hired,
        sum(case
            when requisition.headcount_total_allotted = 'unlimited' then null 
            else cast(requisition.headcount_total_allotted as {{ dbt_utils.type_int() }}) end ) as headcount_total_allotted_finite,
        
        max(requisition.headcount_total_allotted = 'unlimited') as is_headcount_allotted_infinite


    from 
    join_w_interview -- 16 columns
    left join requisition_posting using(posting_id)
    left join requisition using(requisition_id)

    {{ dbt_utils.group_by(n=16) }}
)

select * from join_w_interview