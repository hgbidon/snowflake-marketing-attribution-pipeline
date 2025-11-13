USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE TABLE PUBLIC.channel_summary AS
SELECT
    channel,
    COUNT(DISTINCT user_id) AS users_touched,
    SUM(credit) AS attributed_conversions,
    SUM(credit) / COUNT(DISTINCT user_id) AS conversion_rate
FROM PUBLIC.linear_attribution
GROUP BY channel
ORDER BY attributed_conversions DESC;
