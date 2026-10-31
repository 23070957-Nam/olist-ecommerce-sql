-- Q1. What are the headline business numbers?
SELECT
    (SELECT COUNT(*) FROM orders)                                   AS total_orders,
    (SELECT COUNT(DISTINCT customer_unique_id) FROM customers)      AS unique_customers,
    (SELECT COUNT(*) FROM sellers)                                  AS sellers,
    (SELECT ROUND(SUM(price), 0) FROM order_items)                  AS revenue_brl,
    (SELECT ROUND(SUM(price) / COUNT(DISTINCT order_id), 2)
       FROM order_items)                                            AS avg_order_value_brl,
    (SELECT ROUND(AVG(review_score), 2) FROM order_reviews)         AS avg_review_score;

-- Q2. How did monthly orders and revenue grow, month over month?
WITH monthly AS (
    SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS month,
           COUNT(DISTINCT o.order_id)                    AS orders,
           SUM(i.price)                                  AS revenue
    FROM orders o
    JOIN order_items i ON i.order_id = o.order_id
    WHERE o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp <  '2018-09-01'
    GROUP BY month
)
SELECT month,
       orders,
       ROUND(revenue, 0) AS revenue_brl,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Q3. How much did revenue grow year over year (January–August)?
WITH yearly AS (
    SELECT strftime('%Y', o.order_purchase_timestamp) AS year,
           SUM(i.price)                               AS revenue
    FROM orders o
    JOIN order_items i ON i.order_id = o.order_id
    WHERE CAST(strftime('%m', o.order_purchase_timestamp) AS INTEGER) BETWEEN 1 AND 8
      AND strftime('%Y', o.order_purchase_timestamp) IN ('2017', '2018')
    GROUP BY year
)
SELECT MAX(CASE WHEN year = '2017' THEN ROUND(revenue, 0) END) AS revenue_2017_jan_aug,
       MAX(CASE WHEN year = '2018' THEN ROUND(revenue, 0) END) AS revenue_2018_jan_aug,
       ROUND(100.0 * (MAX(CASE WHEN year = '2018' THEN revenue END)
                    - MAX(CASE WHEN year = '2017' THEN revenue END))
             / MAX(CASE WHEN year = '2017' THEN revenue END), 1) AS yoy_growth_pct
FROM yearly;

-- Q4. Which product categories drive revenue?
WITH category_revenue AS (
    SELECT COALESCE(t.product_category_name_english, 'unknown') AS category,
           SUM(i.price)                                         AS revenue,
           COUNT(DISTINCT i.order_id)                           AS orders
    FROM order_items i
    JOIN products p ON p.product_id = i.product_id
    LEFT JOIN category_translation t ON t.product_category_name = p.product_category_name
    GROUP BY category
)
SELECT category,
       orders,
       ROUND(revenue, 0)                                                   AS revenue_brl,
       ROUND(100.0 * revenue / SUM(revenue) OVER (), 1)                    AS share_pct,
       ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC)
             / SUM(revenue) OVER (), 1)                                    AS cumulative_share_pct
FROM category_revenue
ORDER BY revenue DESC
LIMIT 10;

-- Q5. How reliable is delivery overall?
SELECT COUNT(*)                                                              AS delivered_orders,
       ROUND(100.0 * AVG(order_delivered_customer_date
                         <= order_estimated_delivery_date), 1)               AS on_time_pct,
       ROUND(AVG(julianday(order_delivered_customer_date)
                 - julianday(order_purchase_timestamp)), 1)                  AS avg_delivery_days,
       ROUND(AVG(julianday(order_estimated_delivery_date)
                 - julianday(order_purchase_timestamp)), 1)                  AS avg_promised_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- Q6. Which states are served worst?
SELECT c.customer_state                                                      AS state,
       COUNT(*)                                                              AS delivered_orders,
       ROUND(100.0 * AVG(o.order_delivered_customer_date
                         <= o.order_estimated_delivery_date), 1)             AS on_time_pct,
       ROUND(AVG(julianday(o.order_delivered_customer_date)
                 - julianday(o.order_purchase_timestamp)), 1)                AS avg_delivery_days
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY state
HAVING COUNT(*) >= 500
ORDER BY on_time_pct
LIMIT 5;

-- Q7. How much does a late delivery hurt the review score?
WITH delivered AS (
    SELECT o.order_id,
           julianday(date(o.order_delivered_customer_date))
         - julianday(date(o.order_estimated_delivery_date)) AS days_late
    FROM orders o
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT CASE WHEN d.days_late <= 0 THEN '1. On time or early'
            WHEN d.days_late <= 3 THEN '2. 1-3 days late'
            WHEN d.days_late <= 7 THEN '3. 4-7 days late'
            ELSE '4. 8+ days late' END                       AS delivery_group,
       COUNT(*)                                              AS reviews,
       ROUND(AVG(r.review_score), 2)                         AS avg_review,
       ROUND(100.0 * AVG(r.review_score <= 2), 1)            AS pct_1_or_2_stars
FROM delivered d
JOIN order_reviews r ON r.order_id = d.order_id
GROUP BY delivery_group
ORDER BY delivery_group;

-- Q8. How many customers come back, and how much revenue do they bring?
WITH order_revenue AS (
    SELECT order_id, SUM(price) AS revenue
    FROM order_items
    GROUP BY order_id
),
customer_orders AS (
    SELECT c.customer_unique_id,
           COUNT(o.order_id)             AS orders,
           COALESCE(SUM(r.revenue), 0)   AS revenue
    FROM orders o
    JOIN customers c        ON c.customer_id = o.customer_id
    LEFT JOIN order_revenue r ON r.order_id = o.order_id
    GROUP BY c.customer_unique_id
)
SELECT CASE WHEN orders > 1 THEN 'Repeat' ELSE 'One-time' END       AS customer_type,
       COUNT(*)                                                     AS customers,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)           AS customer_share_pct,
       ROUND(100.0 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1)   AS revenue_share_pct,
       ROUND(SUM(revenue) / COUNT(*), 0)                            AS revenue_per_customer_brl
FROM customer_orders
GROUP BY customer_type;

-- Q9. How do customers pay?
SELECT payment_type,
       COUNT(DISTINCT order_id)                                             AS orders,
       ROUND(100.0 * COUNT(DISTINCT order_id)
             / (SELECT COUNT(DISTINCT order_id) FROM order_payments), 1)   AS order_share_pct,
       ROUND(AVG(payment_value), 2)                                         AS avg_payment_brl,
       ROUND(AVG(payment_installments), 1)                                  AS avg_installments
FROM order_payments
WHERE payment_type <> 'not_defined'
GROUP BY payment_type
ORDER BY orders DESC;

-- Q10. Do customers who pay in more installments spend more?
SELECT CASE WHEN payment_installments <= 1 THEN '1'
            WHEN payment_installments <= 3 THEN '2-3'
            WHEN payment_installments <= 6 THEN '4-6'
            ELSE '7+' END                         AS installments,
       COUNT(*)                                   AS payments,
       ROUND(AVG(payment_value), 0)               AS avg_payment_brl
FROM order_payments
WHERE payment_type = 'credit_card'
GROUP BY installments
ORDER BY MIN(payment_installments);

-- Q11. How concentrated is revenue among sellers?
WITH seller_revenue AS (
    SELECT seller_id, SUM(price) AS revenue
    FROM order_items
    GROUP BY seller_id
),
ranked AS (
    SELECT seller_id, revenue,
           NTILE(10) OVER (ORDER BY revenue DESC) AS decile
    FROM seller_revenue
)
SELECT decile,
       COUNT(*)                                                    AS sellers,
       ROUND(100.0 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1)  AS revenue_share_pct
FROM ranked
GROUP BY decile
ORDER BY decile
LIMIT 3;

-- Q12. Where is demand high but seller supply thin?
WITH demand AS (
    SELECT c.customer_state AS state, COUNT(*) AS orders
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY state
),
supply AS (
    SELECT seller_state AS state, COUNT(*) AS sellers
    FROM sellers
    GROUP BY state
)
SELECT d.state,
       d.orders,
       COALESCE(s.sellers, 0)                                AS sellers,
       ROUND(1.0 * d.orders / NULLIF(s.sellers, 0), 0)       AS orders_per_seller
FROM demand d
LEFT JOIN supply s ON s.state = d.state
WHERE d.orders >= 1000
ORDER BY orders_per_seller DESC
LIMIT 6;

-- Q13. When do customers shop?
SELECT CASE strftime('%w', order_purchase_timestamp)
            WHEN '0' THEN 'Sun' WHEN '1' THEN 'Mon' WHEN '2' THEN 'Tue'
            WHEN '3' THEN 'Wed' WHEN '4' THEN 'Thu' WHEN '5' THEN 'Fri'
            ELSE 'Sat' END                                         AS weekday,
       COUNT(*)                                                    AS orders,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)          AS share_pct
FROM orders
GROUP BY strftime('%w', order_purchase_timestamp)
ORDER BY orders DESC;
