-- Monthly Revenue Analysis

WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', order_date) AS year_month,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS active_customers,
        ROUND(SUM(net_revenue), 2) AS monthly_net_revenue,
        ROUND(AVG(net_revenue), 2) AS avg_revenue_per_row,
        ROUND(SUM(net_revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value
    FROM customer_transactions
    GROUP BY strftime('%Y-%m', order_date)
),
monthly_growth AS (
    SELECT
        year_month,
        total_orders,
        active_customers,
        monthly_net_revenue,
        avg_revenue_per_row,
        avg_order_value,
        LAG(monthly_net_revenue) OVER (ORDER BY year_month) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    year_month,
    total_orders,
    active_customers,
    monthly_net_revenue,
    avg_revenue_per_row,
    avg_order_value,
    ROUND(
        CASE
            WHEN previous_month_revenue IS NULL OR previous_month_revenue = 0 THEN NULL
            ELSE ((monthly_net_revenue - previous_month_revenue) * 100.0 / previous_month_revenue)
        END,
        2
    ) AS revenue_growth_pct
FROM monthly_growth
ORDER BY year_month;

-- Monthly revenue by country

SELECT
    strftime('%Y-%m', order_date) AS year_month,
    country,
    ROUND(SUM(net_revenue), 2) AS monthly_net_revenue
FROM customer_transactions
GROUP BY
    strftime('%Y-%m', order_date),
    country
ORDER BY year_month, monthly_net_revenue DESC;