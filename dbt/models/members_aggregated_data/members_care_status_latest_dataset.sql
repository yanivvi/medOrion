{{ config(materialized='table') }}

select 
-- members data
members.member_id,
members.gender,
-- diabetes data
if (diabetes.member_id is not null,true,false) as has_diabetes,
diabetes.trend as diabetes_medication_trend,
diabetes.currently_meet_condition as adherent_to_diabetes_medications,
-- blood pressure data
if (blood_pressure.member_id is not null,true,false) as has_blood_pressure,
blood_pressure.trend as blood_pressure_medication_trend,
blood_pressure.currently_meet_condition as adherent_to_blood_pressure_medications,
-- high colorectal data
if (high_colorectal.member_id is not null,true,false) as has_high_colorectal,
high_colorectal.trend as high_colorectal_medication_trend,
high_colorectal.currently_meet_condition as adherent_to_high_colorectal_medications,
-- number of medical conditions
if (diabetes.member_id is not null, 1, 0) + 
if (blood_pressure.member_id is not null, 1, 0) + 
if (high_colorectal.member_id is not null, 1, 0) number_of_medical_conditions
from {{ source('raw_data', 'members') }} members
 left join {{ ref('members_care_status_diabetes_latest') }} diabetes 
    on members.member_id = diabetes.member_id
 left join {{ ref('members_care_status_high_blood_pressure_latest') }} blood_pressure 
    on members.member_id = blood_pressure.member_id
 left join {{ ref('members_care_status_high_colorectal_latest') }} high_colorectal 
    on members.member_id = high_colorectal.member_id
where
 -- only include members with at least one medical condition
 (diabetes.member_id is not null or blood_pressure.member_id is not null or high_colorectal.member_id is not null) 