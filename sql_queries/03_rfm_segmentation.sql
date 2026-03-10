-- RFM Segmentation

WITH snapshot_date AS (
    SELECT DATE(MAX(order_date), '+1 day') AS reference_date
    FROM customer_transactions
),
rfm_base AS (
    SELECT
        ct.customer_id,
        CAST(julianday(sd.reference_date) - julianday(MAX(ct.order_date)) AS INTEGER) AS recency_days,
        COUNT(DISTINCT ct.order_id) AS frequency,
        ROUND(SUM(ct.net_revenue), 2) AS monetary
    FROM customer_transactions ct
    CROSS JOIN snapshot_date sd
    GROUP BY ct.customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary,
        6 - NTILE(5) OVER (ORDER BY recency_days ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
    FROM rfm_base
),
rfm_segments AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary,
        recency_score,
        frequency_score,
        monetary_score,
        CAST(recency_score AS TEXT) ||
        CAST(frequency_score AS TEXT) ||
        CAST(monetary_score AS TEXT) AS rfm_score,
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN recency_score >= 3 AND frequency_score >= 4 AND monetary_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'Recent Customers'
            WHEN recency_score <= 2 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'At Risk High Value'
            WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score <= 2 THEN 'Hibernating'
            ELSE 'Potential Loyalists'
        END AS customer_segment
    FROM rfm_scores
)

SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score,
    customer_segment
FROM rfm_segments
ORDER BY monetary DESC;

-- Segment distribution summary

WITH snapshot_date AS (
    SELECT DATE(MAX(order_date), '+1 day') AS reference_date
    FROM customer_transactions
),
rfm_base AS (
    SELECT
        ct.customer_id,
        CAST(julianday(sd.reference_date) - julianday(MAX(ct.order_date)) AS INTEGER) AS recency_days,
        COUNT(DISTINCT ct.order_id) AS frequency,
        ROUND(SUM(ct.net_revenue), 2) AS monetary
    FROM customer_transactions ct
    CROSS JOIN snapshot_date sd
    GROUP BY ct.customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary,
        6 - NTILE(5) OVER (ORDER BY recency_days ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
    FROM rfm_base
),
rfm_segments AS (
    SELECT
        customer_id,
        monetary,
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN recency_score >= 3 AND frequency_score >= 4 AND monetary_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'Recent Customers'
            WHEN recency_score <= 2 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'At Risk High Value'
            WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score <= 2 THEN 'Hibernating'
            ELSE 'Potential Loyalists'
        END AS customer_segment
    FROM rfm_scores
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(monetary), 2) AS avg_monetary_value,
    ROUND(SUM(monetary), 2) AS total_segment_revenue
FROM rfm_segments
GROUP BY customer_segment
ORDER BY total_segment_revenue DESC;