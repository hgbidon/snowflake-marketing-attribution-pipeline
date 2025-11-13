# Marketing Attribution Analytics Pipeline  
### Snowflake + Databricks | Multi-Touch Attribution Dashboard

This project builds a full **marketing attribution pipeline** using Snowflake for data processing and Databricks for visualization. Starting from a raw multi-touch attribution dataset, the workflow cleans, transforms, and models customer journeys to produce **last-touch attribution**, **linear attribution**, and **channel performance insights**.

---

## 🚀 Project Objectives

- Import and clean a real-world multi-touch attribution dataset in Snowflake  
- Build a scalable SQL pipeline for:
  - touchpoint normalization  
  - journey enrichment  
  - attribution modeling  
  - channel-level summary tables  
- Create dashboards directly in Snowflake  
- Use Databricks for deeper visual exploration  
- Produce insights for marketing, performance, and funnel optimization  

---

## 🧰 Tech Stack

| Layer | Tools |
|-------|-------|
| Data Warehouse | **Snowflake** |
| Transformation | SQL (Snowflake Worksheets) |
| Visualization | **Snowflake Dashboard**, Databricks (Python + Matplotlib/Seaborn) |
| Dataset | Kaggle — Multi-Touch Attribution |

---

## 📊 Dataset

**Source:**  
https://www.kaggle.com/datasets/vivekparasharr/multi-touch-attribution

**Key fields:**  
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
↓
Databricks Visual Exploration
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

**Dashboard Name:**  
**Marketing Attribution Insights Dashboard**

**Includes:**
- Conversions by channel  
- Conversion rate by channel  
- Linear vs. last-touch attribution credit  
- Journey length KPIs  
- Touch order performance  

---

## 📊 Databricks Visualizations

The Databricks notebook produces several categories of insights:

### **Channel-Level Insights**
- Conversions & conversion rate  
- Users touched per channel  
- Attribution credit vs. traffic volume  

### **Journey & Funnel Insights**
- Conversion rate by touch order  
- Conversion rate by campaign  
- Journey length comparison (converters vs. non-converters)  

### **Time-Based Insights**
- Conversion heatmap by hour and day  
- Share of total conversions by channel  

---

## 🎯 Key Insights

### **Channel Performance**
- **Direct traffic, display ads, and referral** consistently delivered the highest number of conversions across attribution models.  
- **Email** underperformed in conversion rate compared to other channels, despite having a similar volume of users touched.  
- **Search ads** showed the lowest conversion volume and conversion share.

### **Attribution Findings**
- Linear attribution confirmed that **upper-funnel channels** (social media, display ads) still contribute meaningful value before conversion.  
- Last-touch attribution concentrates credit toward **direct traffic and email**, but linear attribution exposes broader influence across the journey.

### **User Journey Insights**
- Most customer journeys contain **3–5 touchpoints**, aligning with typical multi-touch marketing behavior.  
- Longer journeys show slightly higher conversion probability, with a noticeable increase around **touch order 6 and 9**.  
- Extremely long journeys (10–12 touches) showed instability, suggesting noise or edge-case behavior.

### **Campaign Performance**
- Campaigns such as **Discount Offer**, **Brand Awareness**, and **New Product Launch** performed similarly in conversion rate.  
- **Retargeting** campaigns delivered strong mid-funnel lift but were not the highest in conversion rate.  
- **Winter Sale** performed on the lower end compared to other campaigns.

### **Time-Based Behavior**
- The conversion heatmap shows clear hourly/day-of-week variation, with stronger performance in specific afternoon and evening windows.  
- Both Monday and Tuesday exhibit distinct high-conversion periods, suggesting opportunities for send-time optimization.

### **Traffic vs. Conversion Dynamics**
- Channels with higher traffic (e.g., display ads, direct traffic) generally had higher attributed conversions.  
- **Social media** had mid-range traffic but moderate conversion share, indicating it plays a supporting role rather than a closing role.

---

## 📎 Folder Structure
```sql
├── sql/
│   ├── cleaned_touchpoints.sql
│   ├── journey_enriched.sql
│   ├── last_touch.sql
│   ├── linear_attribution.sql
│   ├── channel_summary.sql
│
├── databricks/
│   ├── marketing_attribution_notebook.dbc
│   └── visualizations_export/
│
├── screenshots/
│   ├── dashboard.png
│   ├── visualizations/
│
└── README.md
```
---

## 👤 Author

**Hana Gabrielle Bidon**  
Data Analyst • Marketing Analytics • Healthcare Analytics  
GitHub: https://github.com/hgbidon  
LinkedIn: https://linkedin.com/in/hgbidon
