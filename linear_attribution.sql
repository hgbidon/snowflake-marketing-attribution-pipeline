USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE TABLE PUBLIC.linear_attribution AS
SELECT
    user_id,
    channel,
    event_time,
    conversion,
    1.0 / journey_length AS credit
FROM PUBLIC.journey_enriched
WHERE conversion = 1
ORDER BY user_id, event_time;
