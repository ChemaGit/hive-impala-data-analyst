/** Question 98
  *   	- Task 1: Get revenue for each order_item_order_id
  */

SELECT order_item_order_id, ROUND(SUM(order_item_subtotal),2) AS revenue
FROM order_items
GROUP BY order_item_order_id
ORDER BY revenue DESC;