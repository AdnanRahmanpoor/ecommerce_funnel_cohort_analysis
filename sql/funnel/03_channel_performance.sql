-- traffic sources
SELECT
    trafficSource.source AS source,
    trafficSource.medium AS medium,
    COUNT(*) AS sessions,
    COUNT(DISTINCT fullVisitorId) AS unique_users,
    SUM(totals.transactions) AS transactions,
    SUM(totals.transactionRevenue) / 1000000 AS revenue_usd,
    SAFE_DIVIDE(SUM(totals.transactions), COUNT(*)) AS conversion_rate
FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20170701' AND '20170831'
    AND trafficSource.source IS NOT NULL
GROUP BY source, medium
HAVING sessions > 100
ORDER BY revenue_usd DESC;