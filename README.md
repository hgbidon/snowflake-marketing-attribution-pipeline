# Marketing Attribution Analytics Pipeline in Snowflake  
### Cloud-Based Multi-Touch Attribution & Channel Insights

This project implements a **cloud-hosted marketing attribution analytics pipeline** in Snowflake using a real-world multi-touch attribution dataset. It transforms raw customer journey logs into **attribution-ready datasets**, calculates **last-touch and linear attribution models**, and produces **channel performance insights** visualized through a Snowflake Dashboard.

---

## 🚀 Project Goals

- Build a scalable marketing analytics pipeline in Snowflake  
- Clean, standardize, and enrich multi-touch attribution data  
- Engineer journey features (touch order, funnel path, journey length)  
- Implement **last-touch** and **linear attribution** models  
- Create insight-ready summary tables for reporting  
- Develop a Snowflake dashboard for stakeholder consumption  
- Demonstrate analytics governance and reproducible SQL workflows  

---

## 🧰 Tech Stack

| Component | Tools Used |
|----------|------------|
| Cloud Data Warehouse | **Snowflake** |
| SQL Processing | Snowflake Worksheets |
| Dashboarding | **Snowflake Native Dashboards** |
| Dataset | Kaggle – Multi-Touch Attribution Dataset |
| Skills Demonstrated | Attribution modeling, ETL, data cleaning, feature engineering |

---

## 📊 Dataset Overview

**Source:**  
https://www.kaggle.com/datasets/vivekparasharr/multi-touch-attribution

**Key columns:**
- `User ID`
- `Timestamp`
- `Channel`
- `Campaign`
- `Conversion`

---

## 🏗️ Pipeline Architecture

```
Raw Data
↓
CLEANED_TOUCHPOINTS
↓
JOURNEY_ENRICHED
↓
LAST_TOUCH
↓
LINEAR_ATTRIBUTION
↓
CHANNEL_SUMMARY
↓
Snowflake Dashboard
```


---

## 🔧 SQL Components

### **1. Cleaned Touchpoints Table**
Normalizes channels, formats timestamps, removes nulls, and assigns touch order.

```sql
CREATE OR REPLACE TABLE PUBLIC.cleaned_touchpoints AS
SELECT
    "User ID"::string AS user_id,
    LOWER("CHANNEL") AS channel,
    "CAMPAIGN" AS campaign,
    TO_TIMESTAMP_NTZ("TIMESTAMP") AS event_time,
    IFF("CONVERSION" = TRUE, 1, 0) AS conversion,
    ROW_NUMBER() OVER (
        PARTITION BY "User ID"
        ORDER BY TO_TIMESTAMP_NTZ("TIMESTAMP")
    ) AS touch_order
FROM PUBLIC."Multi Touch Attribution Data"
WHERE "User ID" IS NOT NULL;
```

### **2. Journey Enriched Table**
Adds journey-level metrics such as total touch count.

```sql
CREATE OR REPLACE TABLE PUBLIC.journey_enriched AS
SELECT
    *,
    MAX(touch_order) OVER (PARTITION BY user_id) AS journey_length
FROM PUBLIC.cleaned_touchpoints;
```

### **3. Last-Touch Attribution Model**

```sql
CREATE OR REPLACE TABLE PUBLIC.last_touch AS
SELECT
    user_id,
    FIRST_VALUE(channel) OVER (
        PARTITION BY user_id
        ORDER BY event_time DESC
    ) AS last_touch_channel,
    MAX(conversion) AS converted
FROM PUBLIC.journey_enriched
GROUP BY user_id;
```

### **4. Linear Attribution Model**

```sql
CREATE OR REPLACE TABLE PUBLIC.linear_attribution AS
SELECT
    user_id,
    channel,
    campaign,
    conversion,
    journey_length,
    IFF(conversion = 1, 1.0 / journey_length, 0) AS credit
FROM PUBLIC.journey_enriched;
```

### **5. Channel Summary Table**

```sql
CREATE OR REPLACE TABLE PUBLIC.channel_summary AS
SELECT
    channel,
    COUNT_IF(conversion = 1) AS conversions,
    COUNT(*) AS total_touches,
    AVG(conversion) AS conversion_rate,
    SUM(credit) AS linear_attribution_credit
FROM PUBLIC.linear_attribution
GROUP BY channel
ORDER BY conversions DESC;
```

## 📈 Snowflake Dashboard

The Snowflake dashboard visualizes the core attribution insights created from the pipeline. It includes:

- **Conversion Volume by Last-Touch Channel**  
  Identifies which channels most frequently appear as the final converting touch.

- **Conversion Rate by Channel**  
  Measures effectiveness normalized for traffic volume.

- **Average Journey Length**  
  Shows how many touchpoints precede conversion events.

- **Linear Attribution Credit by Channel**  
  Distributes credit across all touchpoints in converting journeys.

**Recommended Dashboard Name:**  
**Marketing Attribution Insights Dashboard**

---

## 🎯 Key Insights

- Early-funnel channels like **Social Media** and **Search Ads** appear frequently in first touches.  
- **Retargeting** and **Email** close a significant portion of conversions under last-touch modeling.  
- Journeys with **3–4 touchpoints** show the strongest conversion likelihood.  
- Linear attribution reveals hidden value from **upper-funnel** channels that last-touch underrepresents.  
- Attribution models show that **multi-touch journeys** often outperform single-touch paths.

---

## 📎 Folder Structure
```sql
├── sql/
│ ├── cleaned_touchpoints.sql
│ ├── journey_enriched.sql
│ ├── last_touch.sql
│ ├── linear_attribution.sql
│ ├── channel_summary.sql
│ └── dashboard_queries.sql
├── screenshots/
│ ├── dashboard_overview.png
│ ├── channel_summary_chart.png
│ ├── journey_enriched_preview.png
├── README.md
```


---

## 🏁 Optional Enhancements

- Add **weighted multi-touch attribution** (e.g., time-decay, U-shaped).  
- Integrate with **dbt** for modular, production-grade pipeline modeling.  
- Build a **Streamlit**, **Tableau**, or **Power BI** dashboard using Snowflake data.  
- Add **Azure ML** or **Databricks** integration for predictive modeling.  
- Automate ingestion and transformation using **Snowflake Tasks** and **Streams**.  
- Expand into MMM (Marketing Mix Modeling) using synthetic spend data.

---

## 👤 Author

**Hana Gabrielle Bidon**  
Data Analyst • Marketing Analytics • Healthcare Analytics  
GitHub: https://github.com/hgbidon  
LinkedIn: https://linkedin.com/in/hgbidon
