{% if var('lever_union_schemas', []) | length > 0 or var('lever_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='archive_reason', 
        database_variable='lever_database', 
        schema_variable='lever_schema', 
        default_database=target.database,
        default_schema='lever',
        default_variable='archive_reason',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='lever_sources',
        single_source_name='lever',
        single_table_name='archive_reason'
    )
}}

{% endif %}