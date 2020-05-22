/*
Your solution should have three sets of steps.
Sort the resultant dataset by category id
- filter such that your dataset has products whose price is lesser than 100 USD
- on the filtered data set find out the higest value in the product_price column under each category
- on the filtered data set also find out total products under each category
- on the filtered data set also find out the average price of the product under each category
- on the filtered data set also find out the minimum price of the product under each category
*/

SELECT product_category_id, ROUND(MAX(product_price),2) AS expensive,
       COUNT(1) AS total_products, ROUND(AVG(product_price),2) AS avg_price,
       ROUND(MIN(product_price),2) AS cheaper
FROM products
WHERE product_price < 100
GROUP BY product_category_id;
