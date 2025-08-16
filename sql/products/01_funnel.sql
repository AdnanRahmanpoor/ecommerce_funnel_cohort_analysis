-- products funnel
SELECT
    product.v2ProductName AS product,
    SUM(CASE WHEN hits.eCommerceAction.action_type = '2' THEN 1 ELSE 0 END) AS views,
    SUM(CASE WHEN hits.eCommerceAction.action_type = '3' THEN 1 ELSE 0 END) AS cart_adds,
    SUM(CASE WHEN hits.eCommerceAction.action_type = '6' THEN 1 ELSE 0 END) AS purchases,
    SAFE_DIVIDE(
        SUM(CASE WHEN hits.eCommerceAction.action_type = '6' THEN 1 ELSE 0 END),
        SUM(CASE WHEN hits.eCommerceAction.action_type = '2' THEN 1 ELSE 0 END)
    ) AS conversion_rate
FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
WHERE
    _TABLE_SUFFIX BETWEEN '20170701' AND '20170831'
    AND product.v2ProductName IS NOT NULL
GROUP BY 1
HAVING views > 100
ORDER BY purchases DESC;
