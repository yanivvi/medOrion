## data model
Given the 2 data sets/tables - `members` , `members_care_status`.
Using that as the data sources of our solution - we need create the following:

Design and assumptions:
* Collect all measuremnts taken and rank them per member per medical condition - in one view - `members_care_status_ranked_v`. The source table is updated by appending new measurements - so in order to show the most recent we need to rank the records per member.
* Alternativly - we can just filter by latest date - that should also do the same filtering. (chose the prior due in case we need to also support a metric of "date of recency".)
* By ranking the measuremnts in descending order - the most recent will be shown first, following by the previous measurement.
* The most recent data will be saved into a table `members_care_status_latest` in order to calculate the metrics based on the recent data only.
* Using these 2 measurements will tell us - what is the current value - and by comapring to the previous - what is the change/trend?

DBT steps:
* Instead of creating 4 views and tables for 4 `measure_id`s - we will do a dynamic model that gets all of the avaliable `measure_id`s. 
* The model will use the `members` source and dynamiclly use the `members_care_status_latest` table created - per `meausre_id` found. That includes CTE creation, joins and field used.
* In addition - another join will be made to the model - for counting how many conditions a member has - by counting unique `measure_id`s in the `members_care_status_latest` table - per member.

## dbt command

`dbt build --select +members_care_status_aggregated_dataset`
