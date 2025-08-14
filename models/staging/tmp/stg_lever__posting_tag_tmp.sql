
{{ config(enabled=var('lever_using_posting_tag', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='posting_tag', 
        database_variable='lever_database', 
        schema_variable='lever_schema', 
        default_database=target.database,
        default_schema='lever',
        default_variable='posting_tag',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}