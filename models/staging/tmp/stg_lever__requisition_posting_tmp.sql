
{{ config(enabled=var('lever_using_requisitions', True)) }}

{{
    lever.lever_union_connections(
        connection_dictionary='lever_sources',
        single_source_name='lever',
        single_table_name='requisition_posting'
    )
}}