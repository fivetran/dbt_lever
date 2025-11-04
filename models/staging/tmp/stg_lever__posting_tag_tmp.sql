
{{ config(enabled=var('lever_using_posting_tag', True)) }}

{{
    lever.lever_union_connections(
        connection_dictionary='lever_sources',
        single_source_name='lever',
        single_table_name='posting_tag'
    )
}}