with interview_panel_feedback as (
    select *
    from {{ ref('int_lever__interview_panel_feedback') }}
),

lever_user as (
    select *
    from {{ var('user') }}
),

interviewer_user as (

    select *
    from {{ var('interviewer_user') }}
),

-- to get the hiring manager
posting_applications as (

    select *
    from {{ ref('int_lever__posting_applications') }}

),

order_posting_interview as (

    select 
        *,
        row_number() over(partition by interview_id order by _fivetran_synced desc) as row_num 

    from {{ var('posting_interview') }}
),

last_posting_interview as (

    select *
    from order_posting_interview
    where row_num = 1
),

grab_hiring_managers as (

    select 
        interview_panel_feedback.*,
        posting_applications.posting_hiring_manager_user_id as hiring_manager_user_id

    from interview_panel_feedback
    left join last_posting_interview 
        on interview_panel_feedback.interview_id = last_posting_interview.interview_id
    left join posting_applications 
        on last_posting_interview.posting_id = posting_applications.posting_id
),

-- there can be multiple interviewers for one interview (on top of multiple people belonging to a panel)
grab_interviewers as (

    select
        grab_hiring_managers.*,
        interviewer_user.user_id as interviewer_user_id
    from grab_hiring_managers
    join interviewer_user 
        on grab_hiring_managers.interview_id = interviewer_user.interview_id

),

-- necessary users are 
-- interviewer, completer of feedback, recruiter coordinator , panel coordinator, hiring manager
grab_user_names as (

    select
        grab_interviewers.*,
        interviewer.full_name as inteviewer_name,
        interviewer.email as interviewer_email,
        feedback_completer.full_name as feedback_completer_name,
        interview_coordinator.full_name as interview_coordinator_name,
        panel_coordinator.full_name as panel_coordinator_name,
        hiring_manager.full_name as hiring_manager_name,

        coalesce(hiring_manager.user_id, '') = interviewer.user_id as interviewer_is_hiring_manager

    from 
    grab_interviewers
    left join lever_user as interviewer 
        on grab_interviewers.interviewer_user_id = interviewer.user_id

    left join lever_user as feedback_completer
        on grab_interviewers.feedback_completer_user_id = feedback_completer.user_id

    left join lever_user as interview_coordinator
        on grab_interviewers.creator_user_id = interview_coordinator.user_id

    left join lever_user as panel_coordinator 
        on grab_interviewers.panel_creator_user_id = panel_coordinator.user_id

    left join lever_user as hiring_manager 
        on grab_interviewers.hiring_manager_user_id = hiring_manager.user_id
)

select * from grab_user_names