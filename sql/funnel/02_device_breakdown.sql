-- funnel performance by device type
WITH hit_data AS (
  SELECT
    fullVisitorId,
    visitId,
    date,
    h.page.pagePath,
    h.eventInfo.eventAction,
    h.eCommerceAction.action_type,
    h.transaction.transactionId
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS h
  WHERE
    _TABLE_SUFFIX BETWEEN '20170701' AND '20170831'
),

funnel_stages AS (
    SELECT
        fullVisitorId,
        visitId,
        date,
        -- Stage 1: Product view
        MAX(CASE
            WHEN eventAction = 'Product Click' THEN 1
            ELSE 0
        END) AS viewed_product,

        -- Stage 2: Add to cart
        MAX(CASE
            WHEN eventAction = 'Add to Cart' OR action_type = '3' THEN 1
            ELSE 0
        END) AS added_to_cart,

        -- Stage 3: Purchase
        MAX(CASE
            WHEN transactionId IS NOT NULL OR action_type = '6' THEN 1
            ELSE 0
        END) AS purchased
    FROM hit_data
    GROUP BY fullVisitorId, visitId, date
)

SELECT
    device.deviceCategory AS device_type,
    COUNT(*) AS sessions,
    SUM(viewed_product) AS product_views,
    SUM(purchased) AS purchases,
    SAFE_DIVIDE(SUM(purchased), COUNT(*)) AS conversion_rate
FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS h
LEFT JOIN funnel_stages USING (fullVisitorId, visitId)
WHERE
    _TABLE_SUFFIX BETWEEN '20170701' AND '20170831'
GROUP BY device_type
ORDER BY sessions DESC;