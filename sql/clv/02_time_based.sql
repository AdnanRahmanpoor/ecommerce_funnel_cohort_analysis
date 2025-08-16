-- time based clv
SELECT
  DATE_TRUNC(PARSE_DATE('%Y%m%d', date), MONTH) AS month,
  COUNT(DISTINCT fullVisitorId) AS paying_users,
  SUM(totals.transactionRevenue)/1000000 AS revenue,
  SUM(totals.transactionRevenue)/COUNT(DISTINCT fullVisitorId) AS avg_clv
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE 
  _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
  AND totals.transactions > 0
GROUP BY 1
ORDER BY 1;