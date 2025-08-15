-- Conversion funnel from Sessions > Product views > add to cart > purchase
with hit_data AS (
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
    date,
    COUNT(*) AS sessions,
    SUM(viewed_product) AS product_views,
    SUM(added_to_cart) AS cart_additions,
    SUM(purchased) AS purchases,

    -- conv. rate
    SAFE_DIVIDE(SUM(added_to_cart), SUM(viewed_product)) AS view_to_cart_rate,
    SAFE_DIVIDE(SUM(purchased), SUM(added_to_cart)) AS cart_to_purchase_rate
FROM
    funnel_stages
GROUP BY date
ORDER BY date
    