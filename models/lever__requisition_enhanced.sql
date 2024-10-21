{{ config(enabled=var('lever_using_requisitions', True)) }}

with requisition_users as (

    select *
    from {{ ref('int_lever__requisition_users') }}
),

requisition_posting as (

    select 
        source_relation,
        requisition_id,
        count(posting_id) as count_postings
    from {{ var('requisition_posting') }}

    group by 1,2
),

requisition_offer as (

    select
        source_relation,
        requisition_id,
        count(offer_id) as count_offers
    from {{ var('requisition_offer') }}

    group by 1,2
),

final as (

    select 
        requisition_users.*,
        coalesce(requisition_posting.count_postings, 0) as count_postings,
        requisition_posting.requisition_id is not null as has_posting,

        coalesce(requisition_offer.count_offers, 0) as count_offers,
        requisition_offer.requisition_id is not null as has_offer

    from requisition_users
    left join requisition_posting 
        on requisition_users.requisition_id = requisition_posting.requisition_id
        and requisition_users.source_relation = requisition_posting.source_relation
    left join requisition_offer
        on requisition_users.requisition_id = requisition_offer.requisition_id
        and requisition_users.source_relation = requisition_offer.source_relation
)

select * from final