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

posting_inteview as (

    select *
    from {{ var('posting_interview') }}
),

-- do posting_requisition to get hirign manager

-- there can be multiple interviewers for one interview (on top of multiple people belonging to a panel)
grab_interviewers as (

    select
        interview_panel_feedback.*,
        interviewer_user.user_id as interviewer_user_id
    from interview_panel_feedback
    join interviewer_user 
        on interview_panel_feedback.interview_id = interviewer_user.interview_id

),

-- necessary users are 
-- interviewer, completer of feedback, recruiter coordinator , panel coordinator
grab_user_names as (

    select
        grab_interviewers.*,
        interviewer.full_name as inteviewer_name,
        interviewer.email as interviewer_email,
        feedback_completer.full_name as feedback_completer_name,
        interview_coordinator.full_name as interview_coordinator_name,
        panel_coordinator.full_name as panel_coordinator_name

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
)

select * from grab_user_names