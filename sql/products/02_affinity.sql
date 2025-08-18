WITH product_purchases AS (
  SELECT
    fullVisitorId,
    product.productSKU AS sku,
    product.v2ProductName AS product_name,
    hit.time AS hit_time
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) AS hit,
  UNNEST(hit.product) AS product
  WHERE 
    _TABLE_SUFFIX BETWEEN '20170701' AND '20170831'
    AND hit.eCommerceAction.action_type = '6'
    AND product.v2ProductName IS NOT NULL
),

product_pairs AS (
  SELECT
    a.fullVisitorId,
    a.product_name AS product1,
    b.product_name AS product2
  FROM product_purchases a
  JOIN product_purchases b
    ON a.fullVisitorId = b.fullVisitorId
    AND a.sku < b.sku
    AND a.hit_time != b.hit_time  
    AND a.product_name != b.product_name  
)

SELECT
  product1,
  product2,
  COUNT(DISTINCT fullVisitorId) AS paired_purchases,
  ROUND(COUNT(DISTINCT fullVisitorId) / 
    (SELECT COUNT(DISTINCT fullVisitorId) FROM product_purchases), 4) AS penetration_rate
FROM product_pairs
GROUP BY 1, 2
HAVING paired_purchases >= 5
ORDER BY paired_purchases DESC
LIMIT 50