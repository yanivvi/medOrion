{{ config(materialized='view') }}

select 
date,
member_id,
measure_id,
status,
rank() over (partition by member_id order by date desc) row_rank -- ranks the status of the member by date 1 being the most recent
from {{ source('raw_data', 'members_care_status') }}
where measure_id = 'adherent_to_high_colorectal_medications'
