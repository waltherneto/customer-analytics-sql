-- Monthly customer retention indicators

WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        strftime('%Y-%m', order_date) AS year_month
    FROM customer_transactions
),
first_purchase_month AS (
    SELECT
        customer_id,
        MIN(year_month) AS first_year_month
    FROM customer_months
    GROUP BY customer_id
),
monthly_customer_flags AS (
    SELECT
        cm.customer_id,
        cm.year_month,
        CASE
            WHEN cm.year_month = fpm.first_year_month THEN 1
            ELSE 0
        END AS is_new_customer
    FROM customer_months cm
    INNER JOIN first_purchase_month fpm
        ON cm.customer_id = fpm.customer_id
),
current_previous_month AS (
    SELECT
        curr.year_month,
        curr.customer_id,
        CASE
            WHEN prev.customer_id IS NOT NULL THEN 1
            ELSE 0
        END AS was_active_previous_month
    FROM customer_months curr
    LEFT JOIN customer_months prev
        ON curr.customer_id = prev.customer_id
       AND prev.year_month = strftime(
            '%Y-%m',
            date(curr.year_month || '-01', '-1 month')
       )
)

SELECT
    mcf.year_month,
    COUNT(DISTINCT mcf.customer_id) AS active_customers,
    SUM(mcf.is_new_customer) AS new_customers,
    COUNT(DISTINCT mcf.customer_id) - SUM(mcf.is_new_customer) AS returning_customers,
    SUM(cpm.was_active_previous_month) AS retained_from_previous_month,
    ROUND(
        (COUNT(DISTINCT mcf.customer_id) - SUM(mcf.is_new_customer)) * 100.0
        / COUNT(DISTINCT mcf.customer_id),
        2
    ) AS returning_customer_rate_pct,
    ROUND(
        SUM(cpm.was_active_previous_month) * 100.0
        / NULLIF(COUNT(DISTINCT mcf.customer_id), 0),
        2
    ) AS retained_from_previous_month_pct
FROM monthly_customer_flags mcf
INNER JOIN current_previous_month cpm
    ON mcf.customer_id = cpm.customer_id
   AND mcf.year_month = cpm.year_month
GROUP BY mcf.year_month
ORDER BY mcf.year_month;

-- Customers with repeat purchase behavior

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(net_revenue), 2) AS total_revenue
    FROM customer_transactions
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time Customers'
        ELSE 'Repeat Customers'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM customer_orders
GROUP BY customer_type
ORDER BY total_revenue DESC;