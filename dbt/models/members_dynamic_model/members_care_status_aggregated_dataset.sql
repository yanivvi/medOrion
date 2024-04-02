{{ config(materialized='table') }}

with
    members as 
        (select member_id, gender 
         from {{ source('raw_data', 'members') }} )
    ,members_conditions_count as 
        (select member_id, count(distinct measure_id) number_of_medical_conditions, max(date) most_recent_date_of_measurement 
         from {{ ref('members_care_status_latest') }}
group by 1)
-- dynamic creation of ctes for each measure_id
{% for measure_id in get_unique_measure_ids() %}
    ,{{ measure_id }}_data as (
        select member_id, status, trend, currently_meet_condition from {{ ref('members_care_status_latest') }}
        where measure_id = '{{ measure_id }}')  
{% endfor %}
select 
    members.member_id,
    members.gender
-- dynamic creation of fields for each measure_id
{% for measure_id in get_unique_measure_ids() %}
    -- {{ measure_id }} data
    ,if ({{ measure_id }}_data.member_id is not null,true,false) as {{ measure_id }}
    ,{{ measure_id }}_data.trend as {{ measure_id }}_trend
    ,{{ measure_id }}_data.currently_meet_condition as {{ measure_id }}_condition_met
{% endfor %}
    ,members_conditions_count.number_of_medical_conditions
from 
    members 
-- dynamic join for each measure_id
{% for measure_id in get_unique_measure_ids() %}
    left join {{ measure_id }}_data
    on members.member_id = {{ measure_id }}_data.member_id
{% endfor %}
    join members_conditions_count
    on members.member_id = members_conditions_count.member_id