-- Customer Lifetime Value Analysis

WITH customer_clv AS (
    SELECT
        customer_id,
        country,
        COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(net_revenue), 2) AS lifetime_value,
        ROUND(AVG(net_revenue), 2) AS avg_revenue_per_row,
        ROUND(SUM(net_revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
        MIN(order_date) AS first_purchase_date,
        MAX(order_date) AS last_purchase_date,
        CAST(julianday(MAX(order_date)) - julianday(MIN(order_date)) AS INTEGER) AS customer_lifespan_days
    FROM customer_transactions
    GROUP BY customer_id, country
)

SELECT
    customer_id,
    country,
    total_orders,
    lifetime_value,
    avg_revenue_per_row,
    avg_order_value,
    first_purchase_date,
    last_purchase_date,
    customer_lifespan_days
FROM customer_clv
ORDER BY lifetime_value DESC
LIMIT 50;

-- CLV summary statistics

WITH customer_clv AS (
    SELECT
        customer_id,
        ROUND(SUM(net_revenue), 2) AS lifetime_value,
        COUNT(DISTINCT order_id) AS total_orders
    FROM customer_transactions
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(lifetime_value), 2) AS avg_customer_ltv,
    ROUND(MIN(lifetime_value), 2) AS min_customer_ltv,
    ROUND(MAX(lifetime_value), 2) AS max_customer_ltv,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM customer_clv;

-- Top 10 customers by lifetime value

WITH customer_clv AS (
    SELECT
        customer_id,
        ROUND(SUM(net_revenue), 2) AS lifetime_value
    FROM customer_transactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    lifetime_value
FROM customer_clv
ORDER BY lifetime_value DESC
LIMIT 10;