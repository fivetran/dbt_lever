{%- macro does_table_exist(table_name) -%}
    {{ return(adapter.dispatch('does_table_exist', 'lever')(table_name)) }}
{% endmacro %}

{% macro default__does_table_exist(table_name) %}
    {%- if execute -%}
    {%- set source_relation = adapter.get_relation(
        database=source('lever', table_name).database,
        schema=source('lever', table_name).schema,
        identifier=source('lever', table_name).name) -%}

    {% set table_exists=source_relation is not none %}
    {{ return(table_exists) }}
    {%- endif -%} 

{% endmacro %}