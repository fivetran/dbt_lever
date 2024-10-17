ADD source_relation WHERE NEEDED + CHECK JOINS AND WINDOW FUNCTIONS! (Delete this line when done.)

with opportunity_tag as (

    select *
    from {{ var('opportunity_tag') }}
),

agg_tags as (

    select
        opportunity_id,
        {{ fivetran_utils.string_agg('tag_name', "', '") }} as tags 

    from opportunity_tag
    group by 1
)

select * from agg_tags