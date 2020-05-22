/**
  * Use retail_db data set
  *
  * Problem Statement
  * Get daily revenue by product considering completed and closed orders.
  * Data need to be sorted by ascending order by date and descending order
  * by revenue computed for each product for each day.
  */

USE retail_db;

SELECT o.order_date, p.product_id, ROUND(SUM(oi.order_item_subtotal),2) AS daily_product_revenue
FROM orders o
JOIN order_items oi ON(o.order_id = oi.order_item_order_id)
JOIN products p ON(oi.order_item_product_id = p.product_id)
WHERE o.order_status IN('COMPLETE','CLOSED')
GROUP BY o.order_date, p.product_id
ORDER BY o.order_date, daily_product_revenue DESC;