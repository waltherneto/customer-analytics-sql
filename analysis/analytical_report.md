# Customer Analytics SQL Project — Analytical Report

## Executive Summary

This report summarizes the main findings from the customer analytics SQL analysis conducted on a synthetic e-commerce transaction dataset.

The objective of the analysis was to identify high-value customers, understand purchasing behavior, evaluate product performance, and measure customer retention patterns.

The analysis focused on five core business areas:

- Customer Lifetime Value (CLV)
- RFM Segmentation
- Monthly Revenue Trends
- Product and Category Performance
- Customer Retention Indicators

Overall, the analysis shows that revenue is concentrated among a subset of higher-value customers, while customer activity and revenue fluctuate over time across categories and countries. The retention analysis also highlights the balance between new customer acquisition and repeat purchasing behavior.

---

## Dataset and Methodology

The project uses a synthetic transactional e-commerce dataset built specifically for portfolio purposes.

### Dataset Overview

- **Rows:** 200,000
- **Customers:** 11,993
- **Products:** 250
- **Categories:** 8
- **Countries:** 6
- **Period Covered:** January 2023 to December 2024

### Analytical Approach

The analysis was performed using SQL on top of a SQLite database.

The workflow included:

1. synthetic dataset generation
2. reproducible loading into SQLite
3. data quality validation
4. analytical SQL queries organized by business topic
5. business interpretation of the results

The main revenue metric used throughout the analysis was **net revenue**, which reflects discounts already applied.

---

## 1. Customer Lifetime Value (CLV)

The CLV analysis was designed to identify the most valuable customers based on cumulative net revenue over the observed period.

### Key Findings

- The top customers generated significantly higher lifetime value than the average customer.
- Revenue appears to be concentrated among a relatively small share of customers.
- Customers with higher lifetime value also tend to show higher order frequency and longer active lifespan.

### Metrics to Highlight

After running `02_customer_lifetime_value.sql`, update this section with the actual results:

- **Average customer lifetime value:** `5412.84`
- **Maximum customer lifetime value:** `40626.35`
- **Average orders per customer:** `16.68`
- **Top 10 customers total lifetime value:** `C07433: 40626.35; C00967: 36513.58; C04102: 36107.43; C10838: 35443.52; C06875: 34840.15; C01837: 33766.14; C08614: 33260.31; C05021: 31613.44; C06067: 31448.24; C03370: 31397.97;`

### Business Interpretation

This pattern suggests that the business would benefit from targeted retention and loyalty strategies focused on its highest-value customer base. Identifying these customers early can help improve lifecycle marketing and customer success prioritization.

---

## 2. RFM Segmentation

The RFM analysis classified customers based on:

- **Recency:** how recently they made a purchase
- **Frequency:** how often they purchased
- **Monetary:** how much revenue they generated

### Key Findings

- A subset of customers falls into high-value strategic groups such as **Champions** and **Loyal Customers**.
- Another group shows lower recency and lower engagement, indicating possible churn risk.
- The segmentation provides a structured way to prioritize retention, reactivation, and upsell efforts.

### Metrics to Highlight

After running `03_rfm_segmentation.sql`, update this section with the actual results:

- **Largest customer segment:** `Potential Loyalists`
- **Highest revenue-generating segment:** `Champions`
- **Average monetary value for Champions:** `11309.94`
- **Share of customers classified as Hibernating / At Risk:** `30.85%`

### Business Interpretation

RFM segmentation helps move beyond average customer analysis and allows the company to define differentiated engagement strategies. High-recency and high-value segments are strong candidates for loyalty programs, while low-recency segments may require win-back campaigns.

---

## 3. Monthly Revenue Trends

The monthly revenue analysis evaluated:

- total monthly revenue
- active customers
- total orders
- average order value
- month-over-month revenue growth

### Key Findings

- Revenue changes over time rather than remaining flat, indicating natural seasonality and shifting customer activity.
- Certain months likely show stronger performance due to simulated commercial peaks.
- Active customer counts and order volume provide additional context for understanding whether revenue changes are demand-driven or ticket-driven.

### Metrics to Highlight

After running `04_monthly_revenue_analysis.sql`, update this section with the actual results:

- **Highest revenue month:** `Dec 2023: 3254996.26`
- **Lowest revenue month:** `Feb 2023: 2316994.51`
- **Average monthly revenue:** `2704838.98`
- **Strongest month-over-month growth:** `Nov 2023: 18.34%`

### Business Interpretation

Monthly trend analysis is essential for short-term planning, forecasting, and campaign evaluation. By combining revenue with order and customer activity, decision-makers can distinguish between changes caused by customer demand versus pricing or basket size effects.

---

## 4. Product and Category Performance

The product analysis focused on identifying the categories and products that contribute the most to revenue.

### Key Findings

- Revenue is not evenly distributed across categories.
- Some categories generate a disproportionately large share of total revenue.
- Top-performing products likely combine strong demand with higher effective selling prices.

### Metrics to Highlight

After running `05_top_product_categories.sql`, update this section with the actual results:

- **Top revenue category:** `Electronics: 28661226.66`
- **Category revenue share:** `	44.15%`
- **Top product by revenue:** `P0004 Electronic Product 4: 1784735.56`
- **Top 3 categories combined revenue share:** `72,98% (Electronics, Sports, Home)`

### Business Interpretation

This analysis helps identify which parts of the catalog are most important for revenue generation. It also supports prioritization in merchandising, promotions, pricing strategy, and inventory planning.

---

## 5. Customer Retention Indicators

The retention analysis examined:

- new customers by month
- returning customers by month
- prior-month retention
- repeat vs one-time customers

### Key Findings

- The business shows a mix of customer acquisition and returning customer activity over time.
- Returning customers are likely responsible for a meaningful share of recurring revenue.
- Repeat customers typically deliver higher revenue than one-time customers.

### Metrics to Highlight

After running `06_customer_retention.sql`, update this section with the actual results:

- **Average returning customer rate:** `90.58%`
- **Average retained-from-previous-month rate:** `53.29%`
- **Repeat customer share:** `99.69%`
- **Average revenue for repeat vs one-time customers:** `5428.18 (repeat) vs 168.57 (one-time)`

### Business Interpretation

Retention is one of the strongest signals of commercial health. A healthy returning customer base generally indicates better long-term revenue sustainability than a model overly dependent on new customer acquisition alone.

---

## Overall Business Implications

Taken together, the analyses suggest the following:

1. **Customer value is unevenly distributed**, making customer prioritization critical.
2. **Segmentation adds strategic clarity**, especially for lifecycle and CRM initiatives.
3. **Revenue trends should be monitored monthly** to identify seasonality and growth opportunities.
4. **Category concentration matters**, since a limited set of categories may drive a large share of revenue.
5. **Retention should be tracked alongside acquisition**, not in isolation.

These findings reinforce the importance of structured customer analytics as a foundation for commercial decision-making in e-commerce environments.

---

## Recommendations

Based on the analytical outputs, the business could consider the following actions:

- create targeted retention strategies for high-value customer segments
- design reactivation campaigns for low-recency customers
- monitor monthly revenue together with active customer volume
- prioritize top-performing categories in promotional planning
- track repeat purchase behavior as a core KPI

---

## Limitations

This project uses a **synthetic dataset**, which means the results are illustrative rather than tied to a real company operation.

However, the analytical structure, SQL logic, and business framing were designed to closely reflect a realistic customer analytics use case.

---

## Next Steps

Potential extensions for this project include:

- cohort retention analysis
- customer churn scoring
- geographic revenue segmentation
- dashboarding in Power BI or Tableau
- migration from SQLite to PostgreSQL
- dbt-based analytical modeling

---

## Files Used in This Analysis

- `sql_queries/01_data_quality_checks.sql`
- `sql_queries/02_customer_lifetime_value.sql`
- `sql_queries/03_rfm_segmentation.sql`
- `sql_queries/04_monthly_revenue_analysis.sql`
- `sql_queries/05_top_product_categories.sql`
- `sql_queries/06_customer_retention.sql`
