{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select {{ dbt_utils.star(from=ref('lever__opportunity_enhanced'), 
        except=['sources', 'phones', 'emails', 'tags', 'resume_download_url'] + var('consistency_test_exclude_metrics', [])) }} -- exclude string agg fields
    from {{ target.schema }}_lever_prod.lever__opportunity_enhanced
),

dev as (
    select {{ dbt_utils.star(from=ref('lever__opportunity_enhanced'), 
        except=['sources', 'phones', 'emails', 'tags', 'resume_download_url'] + var('consistency_test_exclude_metrics', [])) }}
    from {{ target.schema }}_lever_dev.lever__opportunity_enhanced
), 

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final