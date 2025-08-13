with opportunity_tag as (

    select *
    from {{ ref('stg_lever__opportunity_tag') }}
),

agg_tags as (

    select
        source_relation,
        opportunity_id,
        {{ fivetran_utils.string_agg('tag_name', "', '") }} as tags 

    from opportunity_tag
    group by 1,2
)

select * from agg_tags