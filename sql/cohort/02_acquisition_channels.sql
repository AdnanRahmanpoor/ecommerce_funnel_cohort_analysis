-- acquisiton channels perf
SELECT
    trafficSource.source AS source,
    trafficSource.medium AS medium,
    COUNT(DISTINCT fullVisitorId) AS unique_users,
    COUNT(*) AS sessions,
    SUM(totals.transactions) AS transactions,
    SUM(totals.transactionRevenue)/1000000 AS revenue_usd,
    SAFE_DIVIDE(SUM(totals.transactions), COUNT(*)) AS conversion_rate
FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
    AND trafficSource.source IS NOT NULL
GROUP BY source, medium
HAVING sessions > 100
ORDER BY revenue_usd DESC;