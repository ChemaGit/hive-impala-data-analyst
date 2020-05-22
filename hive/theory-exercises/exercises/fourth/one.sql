/*
please find total orders and total amount per status per day. The result should be sorted by order date in descending,
order status in ascending and total amount in descending and total orders in ascending.
order_date should be YYYY-MM-DD format, and the result should be stored in a table called result
*/

SELECT o.order_date,o.order_status, COUNT(oi.order_item_order_id) AS total_orders, ROUND(SUM(oi.order_item_subtotal), 2) AS total_amount
FROM orders o
JOIN order_items oi ON(o.order_id = oi.order_item_order_id)
GROUP BY o.order_date,o.order_status
ORDER BY o.order_date DESC, o.order_status ASC, total_amount DESC, total_orders ASC