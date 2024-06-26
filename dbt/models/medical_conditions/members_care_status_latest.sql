{{ config(materialized='table') }}

with cte as (
select *,
lead(status) OVER (PARTITION BY member_id,measure_id ORDER BY row_rank) AS previous_status
 from {{ ref('members_care_status_ranked_v') }}
)
select 
date,
member_id,
measure_id,
status,
previous_status,
if(status=previous_status,'no_change',if(status>previous_status,'increasing','decreasing')) trend,
status>=0.8 as currently_meet_condition
from cte
where row_rank = 1