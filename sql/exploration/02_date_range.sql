-- Check data range and stats
SELECT
    MIN(date) as start_date,
    MAX(date) as end_date,
    COUNT(*) as total_sessions,
    COUNT(DISTINCT fullVisitorId) as unique_visitors
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170831';