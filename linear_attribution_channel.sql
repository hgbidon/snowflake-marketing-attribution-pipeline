USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

SELECT
    channel,
    SUM(credit) AS total_credit
FROM PUBLIC.linear_attribution
GROUP BY channel
ORDER BY total_credit DESC;
