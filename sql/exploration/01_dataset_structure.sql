-- Dataset exploration query
SELECT
  table_name,
  ddl
FROM `bigquery-public-data.google_analytics_sample.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'ga_sessions_%'
LIMIT 5;
