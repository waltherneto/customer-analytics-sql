# Customer Analytics SQL Project

A SQL-focused portfolio project designed to analyze e-commerce customer behavior using a realistic synthetic transactional dataset.

## Project Goal

This project demonstrates strong analytical SQL skills through a practical business scenario:

> An e-commerce company wants to better understand customer behavior, identify high-value customers, and uncover purchasing patterns.

## Updated Project Scope

This version uses a **synthetic dataset with 200,000 rows** generated specifically for the project instead of relying on an external public dataset.

This approach strengthens the portfolio value by demonstrating:

- analytical SQL capability
- data modeling awareness
- reproducibility
- ownership of the full analytical scenario

## Business Questions

The project answers the following questions:

- Who are the highest-value customers?
- How can customers be segmented using RFM analysis?
- How is revenue evolving month by month?
- Which product groups generate the most revenue?
- Are customers returning over time?

## Tech Stack

- SQL
- SQLite
- Python (for synthetic data generation and CSV/database loading only)

## Repository Structure

```text
customer-analytics-sql/
│
├── data/
│   ├── raw/
│   │   └── customer_transactions.csv
│   └── processed/
│       └── customer_analytics.db
│
├── sql_queries/
│   ├── 01_data_quality_checks.sql
│   ├── 02_customer_lifetime_value.sql
│   ├── 03_rfm_segmentation.sql
│   ├── 04_monthly_revenue_analysis.sql
│   ├── 05_top_product_groups.sql
│   └── 06_customer_retention.sql
│
├── analysis/
│   └── analytical_report.md
│
├── scripts/
│   ├── generate_dataset.py
│   └── load_data.py
│
├── docs/
│   └── schema.md
│
├── .gitignore
├── requirements.txt
└── README.md
```

## Dataset

This project uses a synthetic e-commerce transaction dataset generated specifically for portfolio purposes.

### Dataset Characteristics

- 200,000 transaction rows
- 12,000 customers
- 250 products
- 8 product categories
- 6 countries
- 24 months of transactional history

### Included Fields

- `order_id`
- `order_date`
- `customer_id`
- `country`
- `product_id`
- `product_name`
- `category`
- `quantity`
- `unit_price`
- `discount_pct`
- `gross_revenue`
- `net_revenue`

### Why a Synthetic Dataset?

A synthetic dataset makes the project:

- fully reproducible
- easy to run locally
- independent from third-party data availability
- flexible enough to simulate realistic analytical scenarios

## Data Loading

The project includes a reproducible SQLite loading step that transforms the synthetic CSV dataset into a queryable analytical database.

### Database Artifact

- `data/processed/customer_analytics.db`

### Loading Script

- `scripts/load_to_sqlite.py`

### Initial Data Quality Checks

The first SQL file includes validation queries for:

- row count
- distinct customers and products
- date range
- null checks on key fields
- invalid numeric values
- revenue reconciliation
- duplicate checks
- category and country distributions

## Core Analyses

The SQL layer is organized by analytical topic and covers the following business questions:

### 1. Customer Lifetime Value
Identify the highest-value customers and evaluate customer revenue concentration.

### 2. RFM Segmentation
Classify customers based on recency, frequency, and monetary value. Segment customers based on:

- **Recency**: how recently the customer purchased
- **Frequency**: how often the customer purchased
- **Monetary**: how much revenue the customer generated

### 3. Monthly Revenue Analysis
Track revenue trends, active customers, and month-over-month growth.

### 4. Top Product Groups
Identify the categories and products driving the highest revenue.

### 5. Customer Retention Indicators
Measure returning customers, repeat purchase behavior, and prior-month retention.

## Engineering Principles Demonstrated

Although this is a SQL-focused project, it is structured with portfolio-quality engineering practices:

- clean repository organization
- reproducible synthetic data generation
- separation between raw data, processed assets, SQL logic, and analysis
- business-oriented analytical documentation
- versioned implementation with clear Git commits

## Recommended Workflow

1. Initialize repository structure
2. Generate synthetic dataset with 200k rows
3. Load CSV data into SQLite
4. Write SQL analyses by topic
5. Produce an analytical report in Markdown
6. Finalize a polished GitHub README
