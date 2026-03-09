-- 1. Row count
SELECT COUNT(*) AS total_rows
FROM customer_transactions;

-- 2. Distinct customers
SELECT COUNT(DISTINCT customer_id) AS distinct_customers
FROM customer_transactions;

-- 3. Distinct products
SELECT COUNT(DISTINCT product_id) AS distinct_products
FROM customer_transactions;

-- 4. Date range
SELECT
    MIN(order_date) AS min_order_date,
    MAX(order_date) AS max_order_date
FROM customer_transactions;

-- 5. Null / blank checks for key dimensions
SELECT
    SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN product_id IS NULL OR TRIM(product_id) = '' THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN category IS NULL OR TRIM(category) = '' THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN order_date IS NULL OR TRIM(order_date) = '' THEN 1 ELSE 0 END) AS null_order_date
FROM customer_transactions;

-- 6. Invalid numeric values
SELECT
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity_rows,
    SUM(CASE WHEN unit_price <= 0 THEN 1 ELSE 0 END) AS invalid_unit_price_rows,
    SUM(CASE WHEN gross_revenue < 0 THEN 1 ELSE 0 END) AS negative_gross_revenue_rows,
    SUM(CASE WHEN net_revenue < 0 THEN 1 ELSE 0 END) AS negative_net_revenue_rows
FROM customer_transactions;

-- 7. Revenue reconciliation check
SELECT
    COUNT(*) AS mismatched_rows
FROM customer_transactions
WHERE ROUND(quantity * unit_price, 2) <> ROUND(gross_revenue, 2);

-- 8. Discount consistency check
SELECT
    COUNT(*) AS discount_mismatch_rows
FROM customer_transactions
WHERE ROUND(gross_revenue * (1 - discount_pct), 2) <> ROUND(net_revenue, 2);

-- 9. Duplicate order line check at current grain
SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    COUNT(*) AS duplicate_count
FROM customer_transactions
GROUP BY
    order_id,
    customer_id,
    product_id,
    order_date
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 20;

-- 10. Distribution by category
SELECT
    category,
    COUNT(*) AS row_count,
    ROUND(SUM(net_revenue), 2) AS total_net_revenue
FROM customer_transactions
GROUP BY category
ORDER BY total_net_revenue DESC;

-- 11. Distribution by country
SELECT
    country,
    COUNT(*) AS row_count,
    ROUND(SUM(net_revenue), 2) AS total_net_revenue
FROM customer_transactions
GROUP BY country
ORDER BY total_net_revenue DESC;