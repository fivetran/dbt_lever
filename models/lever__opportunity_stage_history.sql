with opportunity as (

    select *
    from {{ ref('lever__opportunity_enhanced') }}
),

stage as (

    select *
    from {{ var('stage') }}
),

lever_user as (

    select *
    from {{ var('user') }}
),

opp_stage_history as (

    select 
        opportunity_id,
        updated_at as valid_from,
        stage_id,
        updater_user_id,
        to_stage_index as stage_index_in_pipeline,
        lead(updated_at) over (partition by opportunity_id order by updated_at asc) as valid_ending_at
    from {{ var('opportunity_stage_history') }}
),

time_in_stages as (

    select
        *,
        {{ dbt_utils.datediff('valid_from', 'valid_ending_at', 'day') }} as days_in_stage
        
    from opp_stage_history

),

final as (

    select 
        time_in_stages.*,
        stage.stage_name as stage,
        lever_user.full_name as updater_user_name,
        opportunity.contact_name,
        opportunity.job_title,
        opportunity.job_department,
        opportunity.job_location,
        opportunity.job_team,
        opportunity.application_type,
        opportunity.sources as application_sources,
        opportunity.hiring_manager_name,
        opportunity.opportunity_owner_name

    from time_in_stages

    join stage on time_in_stages.stage_id = stage.stage_id
    left join lever_user on lever_user.user_id = time_in_stages.updater_user_id 
    join opportunity on opportunity.opportunity_id = time_in_stages.opportunity_id
)

select * from final