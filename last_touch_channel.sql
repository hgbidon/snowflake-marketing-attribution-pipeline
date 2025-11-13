USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

SELECT
    last_touch_channel AS channel,
    COUNT(*) AS conversions
FROM PUBLIC.last_touch
WHERE converted = 1
GROUP BY channel
ORDER BY conversions DESC;
