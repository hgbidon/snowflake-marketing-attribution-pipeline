USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

SELECT
    channel,
    ROUND(AVG(conversion), 3) AS conversion_rate
FROM PUBLIC.cleaned_touchpoints
GROUP BY channel
ORDER BY conversion_rate DESC;
