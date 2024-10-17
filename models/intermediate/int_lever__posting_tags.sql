ADD source_relation WHERE NEEDED + CHECK JOINS AND WINDOW FUNCTIONS! (Delete this line when done.)

{{ config(enabled=var('lever_using_posting_tag', True)) }}

with posting_tag as (

    select *
    from {{ var('posting_tag') }}
),

agg_tags as (

    select
        posting_id,
        {{ fivetran_utils.string_agg('tag_name', "', '") }} as tags 

    from posting_tag
    group by 1
)

select * from agg_tags