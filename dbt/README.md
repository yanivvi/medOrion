## data model
Given the 2 data sets/tables - `members` , `members_care_status`.
Using that as the data sources of our solution - we need create the following:

1) a. Per medical condition - collect all measuremnts taken and rank them per member.
   b. By ranking the measuremnts in descending order - the most recent will be shown first, following by the previous measurement.
   c. Using these 2 measurements will tell us - what is the current value - and by comapring to the previous - what is the change/trend?

2) DBT steps:
   a. Create 4 views on top of the `members_care_status` source data - split by the `measure_id` value. rank the status values.
   b. Create for each view a table that holds the latest values using the ranking we did in the view
   c. Create a final dataset table using the `members` source data and join the 3 tables mentioned in the requirement (1 was left out - cancer screening). Join will be done as Left Outer Join. filter the data for only member with at least one measurement taken (Active members).

## dbt command

`dbt build --select +members_care_status_latest_dataset`