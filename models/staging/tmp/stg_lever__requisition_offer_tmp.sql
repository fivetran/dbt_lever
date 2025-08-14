
{{ config(enabled=var('lever_using_requisitions', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='requisition_offer', 
        database_variable='lever_database', 
        schema_variable='lever_schema', 
        default_database=target.database,
        default_schema='lever',
        default_variable='requisition_offer',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}