SELECT * FROM `sqlproj29.sqlproj29.user_Events` LIMIT 1000

---define sales funnel and different stages

WITH funnel_stages AS (

  select
   count(distinct case when event_type = 'page_view' then user_id end) AS stage_1_views,
   count(distinct case when event_type = 'add_to_cart' then user_id end) AS stage_2_cart,
   count(distinct case when event_type = 'checkout_start' then user_id end) AS stage_3_checkout,
   count(distinct case when event_type = 'payment_info' then user_id end) AS stage_4_payment,
   count(distinct case when event_type = 'purchase' then user_id end) AS stage_5_purch

  FROM  `sqlproj29.sqlproj29.user_Events`

  WHERE event_date >= timestamp((date_sub(current_date(), INTERVAL 30 DAY)))
)
select * from funnel_stages


---- conversion rates through the funnel

WITH funnel_stages AS (

  select
   count(distinct case when event_type = 'page_view' then user_id end) AS stage_1_views,
   count(distinct case when event_type = 'add_to_cart' then user_id end) AS stage_2_cart,
   count(distinct case when event_type = 'checkout_start' then user_id end) AS stage_3_checkout,
   count(distinct case when event_type = 'payment_info' then user_id end) AS stage_4_payment,
   count(distinct case when event_type = 'purchase' then user_id end) AS stage_5_purch

  FROM  `sqlproj29.sqlproj29.user_Events`

  WHERE event_date >= timestamp((date_sub(current_date(), INTERVAL 30 DAY)))
)
SELECT
    stage_1_views, stage_2_cart,
    ROUND(stage_2_cart * 100 / stage_1_views) as view_to_cart_rate,
    
    stage_3_checkout,
    ROUND(stage_3_checkout * 100 / stage_2_cart) as checkout_to_cart_rate,

    stage_4_payment,
    ROUND(stage_4_payment * 100 / stage_3_checkout) as payment_to_checkout_rate,

    stage_5_purch,
    ROUND(stage_5_purch * 100 / stage_4_payment) as purch_to_payment_rate,
    
    ROUND(stage_5_purch * 100 / stage_1_views) as overall_conversion_rate

FROM funnel_stages

--- funnel by source

WITH funnel_source AS (
  SELECT
    traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
  FROM `sqlproj29.sqlproj29.user_Events`
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
  GROUP BY traffic_source
)
SELECT traffic_source, views, cart, purchases,
      ROUND(cart * 100 / views) AS cart_conversion_rate,
      ROUND(purchases *100/views) AS purchase_conversion_rate
FROM funnel_source;

--- time to conversion

WITH user_journey AS (
  SELECT 
    user_id,
    MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
  FROM `sqlproj29.sqlproj29.user_Events`  
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
  GROUP BY user_id
  HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)
SELECT 
  COUNT(*) AS converted_users,
  ROUND(AVG(TIMESTAMP_DIFF(cart_time, view_time, MINUTE)), 2) AS Avg_view_to_cart_mins,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, cart_time, MINUTE)), 2) AS Avg_purchase_to_cart_mins,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE)), 2) AS Avg_tot_journey_mins
FROM user_journey;


---revenue funnel analysis

WITH funnel_revenue AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_viewers,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
    SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,
    COUNT(CASE WHEN event_type='purchase' THEN 1 END) AS total_orders
  FROM `sqlproj29.sqlproj29.user_Events`  
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
)
SELECT total_viewers, total_buyers, total_revenue, total_orders,
       total_revenue/total_buyers AS rev_per_buyer,
       total_revenue/total_orders AS rev_per_order,
       total_revenue/total_viewers AS rev_per_visitor
FROM funnel_revenue
