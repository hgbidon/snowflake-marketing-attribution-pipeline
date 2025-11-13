USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE TABLE PUBLIC.last_touch AS
SELECT
    user_id,
    channel AS last_touch_channel,
    conversion AS converted
FROM (
    SELECT
        user_id,
        channel,
        conversion,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_time DESC
        ) AS rn
    FROM PUBLIC.journey_enriched
)
WHERE rn = 1;
