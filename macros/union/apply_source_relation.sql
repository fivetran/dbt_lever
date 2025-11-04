{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'lever') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('lever_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("lever_database", target.database) }}' || '.'|| '{{ var("lever_schema", "lever") }}' as source_relation
{% endif %}

{%- endmacro %}