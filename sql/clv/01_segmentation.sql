-- clv segmentation
WITH customer_values AS (
    SELECT
        fullVisitorId,
        SUM(totals.transactionRevenue)/1000000 AS total_revenue,
        AVG(totals.pageviews) AS avg_pageviews
    FROM
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
        AND totals.transactions IS NOT NULL
    GROUP BY fullVisitorId
)

SELECT
    CASE
        WHEN total_revenue > 200 THEN 'High Value'
        WHEN total_revenue > 50 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_segment,
    COUNT(fullVisitorId) AS customers,
    AVG(avg_pageviews) AS avg_pageviews,
    SUM(total_revenue) AS total_revenue
FROM
    customer_values
GROUP BY value_segment
ORDER BY total_revenue DESC;