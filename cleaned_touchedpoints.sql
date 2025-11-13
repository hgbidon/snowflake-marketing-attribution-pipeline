USE DATABASE "Marketing Analytics Enablement Pipeline in Snowflake on Azure";
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE TABLE PUBLIC.cleaned_touchpoints AS
SELECT
    "User ID"::STRING AS user_id,
    LOWER("CHANNEL") AS channel,
    "CAMPAIGN" AS campaign,
    TO_TIMESTAMP_NTZ("TIMESTAMP") AS event_time,
    IFF("CONVERSION" = TRUE, 1, 0) AS conversion
FROM PUBLIC."Multi Touch Attribution Data"
WHERE "User ID" IS NOT NULL
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY "User ID", "CHANNEL", "TIMESTAMP"
    ORDER BY "TIMESTAMP"
) = 1;
