-- Top Product Categories

SELECT
    category,
    COUNT(*) AS transaction_rows,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    ROUND(SUM(quantity), 2) AS total_units_sold,
    ROUND(SUM(net_revenue), 2) AS total_net_revenue,
    ROUND(AVG(net_revenue), 2) AS avg_revenue_per_row
FROM customer_transactions
GROUP BY category
ORDER BY total_net_revenue DESC;

-- Top 20 products by revenue

SELECT
    product_id,
    product_name,
    category,
    ROUND(SUM(quantity), 2) AS total_units_sold,
    ROUND(SUM(net_revenue), 2) AS total_net_revenue,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM customer_transactions
GROUP BY
    product_id,
    product_name,
    category
ORDER BY total_net_revenue DESC
LIMIT 20;

-- Category share of total revenue

WITH category_revenue AS (
    SELECT
        category,
        ROUND(SUM(net_revenue), 2) AS total_net_revenue
    FROM customer_transactions
    GROUP BY category
),
total_revenue AS (
    SELECT SUM(total_net_revenue) AS overall_revenue
    FROM category_revenue
)

SELECT
    cr.category,
    cr.total_net_revenue,
    ROUND(cr.total_net_revenue * 100.0 / tr.overall_revenue, 2) AS revenue_share_pct
FROM category_revenue cr
CROSS JOIN total_revenue tr
ORDER BY cr.total_net_revenue DESC;