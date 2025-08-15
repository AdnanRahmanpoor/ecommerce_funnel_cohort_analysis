-- Sample data structure
SELECT
    date,
    fullVisitorId,
    visitId,
    visitStartTime,
    trafficSource.source,
    trafficSource.medium,
    device.deviceCategory,
    totals.visits,
    totals.hits,
    totals.pageviews,
    totals.transactions,
    totals.transactionRevenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
LIMIT 10;