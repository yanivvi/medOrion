{% macro get_unique_measure_ids() %}
    {% set query %}
        SELECT DISTINCT measure_id FROM {{ source('raw_data', 'members_care_status') }}
    {% endset %}
    
    {% set results = run_query(query) %}
    {% if execute %}
        {% set measure_ids = results.columns[0].values() %}
    {% else %}
        {% set measure_ids = [] %}
    {% endif %}
    
    {{ return(measure_ids) }}
{% endmacro %}
