with opportunity as (

    -- this builds off the source opportunity table, incorporating application and internal user data. 
    select *
    from {{ ref('int_lever__opportunity_users') }}
),

opportunity_sources as (

    select
        source_relation,
        opportunity_id,
        {{ fivetran_utils.string_agg('source', "', '") }} as sources

    from {{ ref('stg_lever__opportunity_source') }}

    group by 1,2
),

contact_info as (

    select *
    from {{ ref('int_lever__contact_info') }}
),

order_resumes as (

    select 
        *,
        row_number() over(
            partition by opportunity_id {{', source_relation' if var('lever_union_schemas', false) or var('lever_union_databases', false) }} 
            order by created_at desc) as row_num
    
    from {{ ref('stg_lever__resume') }}
),

latest_resume as (

    select *
    from order_resumes 

    where row_num = 1
),

final as (

    select
        opportunity.*,
        opportunity_sources.sources,
        latest_resume.file_download_url as resume_download_url,
        contact_info.phones,
        contact_info.emails,
        contact_info.linkedin_link,
        contact_info.github_link

    from opportunity

    left join opportunity_sources
        on opportunity.opportunity_id = opportunity_sources.opportunity_id
        and opportunity.source_relation = opportunity_sources.source_relation

    left join latest_resume 
        on latest_resume.opportunity_id = opportunity.opportunity_id
        and latest_resume.source_relation = opportunity.source_relation

    left join contact_info
        on contact_info.contact_id = opportunity.contact_id
        and contact_info.source_relation = opportunity.source_relation
)

select *
from final