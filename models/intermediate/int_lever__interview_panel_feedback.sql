with interview as (

    select *
    from {{ var('interview') }}

),

interview_feedback as (

    select *
    from {{ var('interview_feedback') }}
),

feedback_form as (

    select *
    from {{ var('feedback_form') }}

    where deleted_at is null
),

panel as (

    select *
    from {{ var('panel') }}
),

join_interview_w_panel as (

    select
        interview.*,
        panel.canceled_at as panel_canceled_at,
        panel.creator_user_id as panel_creator_user_id,
        panel.last_interview_ends_at as panel_ends_at,
        panel.first_interview_starts_at as panel_starts_at,
        panel.note as panel_note
        
    from 
    interview
    left join panel on interview.panel_id = panel.panel_id
),

join_w_feedback as (

    select
        join_interview_w_panel.*,
        feedback_form.feedback_form_id,
        feedback_form.creator_user_id as feedback_completer_user_id,
        feedback_form.completed_at as feedback_completed_at,

        feedback_form.instructions as feedback_form_instructions,
        feedback_form.score_system_value,
        feedback_form.form_title as feedback_form_title


    from join_interview_w_panel
    -- todo: not sure if this should be a left join.....
    -- it fans out if it is
    join feedback_form 
        on join_interview_w_panel.interview_id = feedback_form.interview_id
)

select *
from join_w_feedback