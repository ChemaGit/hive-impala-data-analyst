SET @row_number = 0;
select oit
from
(select (@row_number:=@row_number + 1) AS rownum, order_item_subtotal as oit
     from order_items order by order_item_subtotal) t,
(select round(count(*)/2) as total from order_items) t1
where rownum = total;