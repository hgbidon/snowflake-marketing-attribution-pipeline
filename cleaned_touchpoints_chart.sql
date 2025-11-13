USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

SELECT
    channel,
    COUNT(*) AS touchpoints
FROM PUBLIC.cleaned_touchpoints
GROUP BY channel
ORDER BY touchpoints DESC;
