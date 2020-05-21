/*
Please accomplish following

1. Get number of orders by order_status for a given date '2013-12-14'
2. Get number of completed orders for each date before '2013-12-14 00:00:00.0'
3. Get number of pending, review and onhold order for each date for the month of 2013 December.
4. Get number of orders by order_status, which in  review, hold or in pending
status for all the orders placed between '2013-12-01 00:00:00.0' AND '2013-12-31 00:00:00.0'

Solution:
*/

-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/hadoopexamdb

-- 1. Get number of orders by order_status for a given date '2013-12-14'

SELECT order_status,TO_DATE(order_date) AS order_date, COUNT(order_id) AS num_orders
FROM orders
WHERE TO_DATE(order_date) LIKE('2013-12-14')
GROUP BY order_status,TO_DATE(order_date);

-- 2. Get number of completed orders for each date before '2013-12-14 00:00:00.0'

SELECT TO_DATE(order_date) AS order_date, order_status, COUNT(order_id) AS num_orders
FROM orders
WHERE order_status = 'COMPLETE' AND
      TO_DATE(order_date) < TO_DATE('2013-12-14 00:00:00.0')
GROUP BY TO_DATE(order_date),order_status
ORDER BY TO_DATE(order_date) DESC;

-- 3. Get number of pending, review and onhold order for each date for the month of 2013 December.

SELECT order_status,TO_DATE(order_date) AS order_date, COUNT(order_id) AS num_orders
FROM orders
WHERE order_status IN('ON_HOLD','PAYMENT_REVIEW','PENDING','PENDING_PAYMENT') AND
      TO_DATE(order_date) LIKE('2013-12-%')
GROUP BY order_status, TO_DATE(order_date);

-- 4. Get number of orders by order_status, which in  review, hold or in pending status for
-- all the orders placed between '2013-12-01 00:00:00.0' AND '2013-12-31 00:00:00.0'

SELECT order_status, TO_DATE(order_date) AS order_date, COUNT(order_id) AS num_orders
FROM orders
WHERE order_status IN('ON_HOLD','PAYMENT_REVIEW','PENDING','PENDING_PAYMENT') AND
      TO_DATE(order_date) BETWEEN TO_DATE('2013-12-01 00:00:00.0')
AND TO_DATE('2013-12-31 00:00:00.0')
GROUP BY order_status, TO_DATE(order_date);