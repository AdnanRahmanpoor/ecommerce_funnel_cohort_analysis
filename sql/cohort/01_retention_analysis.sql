WITH user_cohorts AS (
    SELECT
        fullVisitorId,
        DATE_TRUNC(MIN(PARSE_DATE('%Y%m%d', date)), MONTH) AS cohort_month,
    FROM
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
    GROUP BY fullVisitorId
),

user_activity AS (
    SELECT
        fullVisitorId,
        DATE_TRUNC(PARSE_DATE('%Y%m%d', date), MONTH) AS activity_month
    FROM
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
    GROUP BY fullVisitorId, activity_month
),

month_numbers AS (
  SELECT 0 AS month_number UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
  SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
  SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
  SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11
)


SELECT
    c.cohort_month,
    m.month_number,
    COUNT(DISTINCT c.fullVisitorId) AS cohort_size,
    COUNT(DISTINCT a.fullVisitorId) AS retained_users,
    SAFE_DIVIDE(COUNT(DISTINCT CASE WHEN a.activity_month IS NOT NULL THEN c.fullVisitorId END),
                COUNT(DISTINCT c.fullVisitorId)) AS retention_rate
FROM user_cohorts c
CROSS JOIN month_numbers m
LEFT JOIN user_activity a
    ON c.fullVisitorId = a.fullVisitorId
    AND a.activity_month = DATE_ADD(c.cohort_month, INTERVAL m.month_number MONTH)
GROUP BY 1, 2
ORDER BY cohort_month, month_number;