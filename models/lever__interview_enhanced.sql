-- note: each record is a unique interview-interviewer feedback form combo
-- an interview can have multiple interviewers, and interviewers can have multiple feedback forms
with interview as (

    select *
    from {{ ref('int_lever__interview_users') }}
),

--  just to grab stufff
opportunity as (

    select *
    from {{ var('opportunity') }}
),

join_w_opportunity as (

    select
        interview.*,
        opportunity.contact_name as interviewee_name,
        opportunity.contact_location as interviewee_location,
        opportunity.origin as interviewee_origin,
        opportunity.contact_id as interviewee_contact_id,
        {{ dbt_utils.datediff('opportunity.created_at', 'interview.occurred_at', 'day') }} as days_since_opp_created,
        opportunity.last_advanced_at > interview.occurred_at as has_advanced_since_interview

    from interview
    join opportunity using(opportunity_id)
)
{# ,

final as (

    select 
        join_w_opportunity.*
    
    from join_w_opportunity
    left join posting_requisition
) #}

-- is hiring manager
select * from join_w_opportunity