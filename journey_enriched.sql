USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE TABLE PUBLIC.journey_enriched AS
SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY user_id 
        ORDER BY event_time
    ) AS touch_order,
    COUNT(*) OVER (
        PARTITION BY user_id
    ) AS journey_length
FROM PUBLIC.cleaned_touchpoints
ORDER BY user_id, event_time;
