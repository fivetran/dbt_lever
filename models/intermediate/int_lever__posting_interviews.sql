with posting_interview as (

    select *
    from {{ var('posting_interview') }}

),

interview as (

    select 
        source_relation,
        interview_id,
        opportunity_id 

    from {{ var('interview') }}

),

posting_interview_metrics as (
    
    select
        posting_interview.source_relation,
        posting_interview.posting_id,
        count(distinct posting_interview.interview_id) as count_interviews,
        count(distinct interview.opportunity_id) as count_interviewees

    from posting_interview 
    join interview using(interview_id)
    group by 1,2

)

select * from posting_interview_metrics