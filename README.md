# Customer Analytics SQL Project

A SQL-focused analytics portfolio project designed to analyze e-commerce customer behavior using a realistic synthetic transaction dataset.

## Project Goal

This project demonstrates strong analytical SQL skills through a realistic business scenario:

> An e-commerce company wants to better understand customer behavior, identify high-value customers, uncover purchasing patterns, and monitor customer retention.

The project is intentionally designed to be lightweight in infrastructure and strong in analytical SQL quality.

## Updated Project Scope

This version uses a **synthetic dataset with 200,000 rows** generated specifically for the project instead of relying on an external public dataset.

This approach strengthens the portfolio value by demonstrating:

- analytical SQL capability
- data modeling awareness
- reproducibility
- ownership of the full analytical scenario

## Business Questions

This project answers the following questions:

- Who are the highest-value customers?
- How can customers be segmented using RFM analysis?
- How is revenue evolving month by month?
- Which product categories and products generate the most revenue?
- Are customers returning over time?

## Tech Stack

- SQL
- SQLite
- Python
- Pandas

## Repository Structure

```text
customer-analytics-sql/
├── analysis/
│   └── analytical_report.md
├── data/
│   ├── processed/
│   │   └── customer_analytics.db
│   └── raw/
│       └── customer_transactions.csv
├── docs/
│   └── schema.md
├── scripts/
│   ├── generate_dataset.py
│   └── load_to_sqlite.py
├── sql_queries/
│   ├── 01_data_quality_checks.sql
│   ├── 02_customer_lifetime_value.sql
│   ├── 03_rfm_segmentation.sql
│   ├── 04_monthly_revenue_analysis.sql
│   ├── 05_top_product_categories.sql
│   └── 06_customer_retention.sql
├── .gitignore
├── README.md
└── requirements.txt
```

## Dataset

This project uses a synthetic e-commerce transaction dataset generated specifically for portfolio purposes.

### Dataset Characteristics

- 200,000 transaction rows
- 11,993 customers
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

- **Customer Lifetime Value (CLV):** identify the highest-value customers and evaluate customer revenue concentration.
- **RFM Segmentation:** classify customers based on recency, frequency, and monetary value.
- **Monthly Revenue Analysis:** track revenue trends, active customers, and month-over-month growth.
- **Top Product Categories:** identify the categories and products driving the highest revenue.
- **Customer Retention Indicators:** measure returning customers, repeat purchase behavior, and prior-month retention.

Each analysis is stored in an individual SQL file inside the `sql_queries/` folder for readability and reuse.

## Analytical Report

A concise business-facing analytical report is available in:

- `analysis/analytical_report.md`

The report summarizes the main findings from the SQL analysis and translates query outputs into business insights.

## Engineering Principles Demonstrated

Although this is a small portfolio project, it demonstrates important analytics engineering and data project practices:

- reproducible dataset generation
- reproducible database loading
- structured repository organization
- data quality validation before analysis
- modular SQL by business topic
- business-facing analytical documentation

## How to Run

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Generate the synthetic dataset

```bash
python scripts/generate_dataset.py
```

### 3. Load data into SQLite

```bash
python scripts/load_to_sqlite.py
```

### 4. Run the SQL analyses

Using SQLite CLI:

```bash
sqlite3 -header -column data/processed/customer_analytics.db
```

Then run individual files:

```sql
.read sql_queries/01_data_quality_checks.sql
.read sql_queries/02_customer_lifetime_value.sql
.read sql_queries/03_rfm_segmentation.sql
.read sql_queries/04_monthly_revenue_analysis.sql
.read sql_queries/05_top_product_categories.sql
.read sql_queries/06_customer_retention.sql
```

You can also use DB Browser for SQLite or a VS Code SQLite extension.

## Recommended Workflow

1. Generate the synthetic dataset.
2. Load the CSV into SQLite.
3. Run the data quality checks.
4. Execute the analytical SQL files by topic.
5. Review the analytical report and update it with real results.
6. Finalize the project as a GitHub portfolio piece.

## Project Highlights

This project was built to showcase:

- strong SQL for analytics
- customer-centric business analysis
- clean project structure for GitHub
- reproducible local setup
- portfolio-ready written communication

## Possible Extensions

Potential future improvements include:

- cohort retention analysis
- customer churn scoring
- dashboarding in Power BI
- migration from SQLite to PostgreSQL
- dbt-based analytical modeling
- orchestration with a lightweight pipeline tool

## Why This Project Works for a Portfolio

This project is intentionally scoped to be:

- realistic
- fast to build
- easy to review
- strong in SQL fundamentals
- clear in business value

It is designed to demonstrate analytical thinking and engineering discipline without unnecessary infrastructure complexity.
