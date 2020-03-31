/**
Find total orders and total amount per status per day
The result should be sorted by order date in descending, order status in ascending
and total amount in descending and total orders in ascending
order_date should be YYYY-MM-DD format
*/
SELECT FROM_UNIXTIME(order_date/1000, 'yyyy-MM-dd') AS order_date, order_status,
       COUNT(DISTINCT(order_id)) AS total_orders, ROUND(SUM(order_item_subtotal),2) AS total_amount
FROM orders JOIN order_items ON(order_id = order_item_order_id)
GROUP BY order_date, order_status
ORDER BY order_date DESC, order_status, total_amount DESC, total_orders

