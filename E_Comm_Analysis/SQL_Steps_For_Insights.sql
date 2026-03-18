
DESC Customers;
DESC Products;
DESC Orders;
DESC OrderDetails;


select location , count(name) number_of_customers from Customers
group by location
order by count(name) desc
limit 3;




SELECT 
NumberOfOrders,
COUNT(*) AS CustomerCount
FROM (
    SELECT 
    Customer_ID,
    COUNT(Order_ID) AS NumberOfOrders
    FROM Orders
    GROUP BY Customer_ID
) t
GROUP BY NumberOfOrders
ORDER BY NumberOfOrders;



select product_id Product_Id, 
avg(quantity) AvgQuantity, 
 Sum(quantity * price_per_unit) TotalRevenue
from OrderDetails
group by product_id
 having avg(quantity) =2
order by TotalRevenue desc;



select 
p.category, 
count(distinct o.customer_id) unique_customers
 from Products p join OrderDetails  d 
on p.product_id=d.product_id join Orders O on d.order_id=o.order_id
group by p.category
order by unique_customers desc;





select date_format(order_date,'%Y-%m') Month, 
Sum(total_amount) TotalSales,
round(
    (Sum(total_amount)-lag(sum(total_amount))over(order by date_format(order_date,'%Y-%m') )) / 
lag(sum(total_amount))over(order by date_format(order_date,'%Y-%m') ) *100

,2) PercentChange
from orders
group by date_format(order_date,'%Y-%m') ;



SELECT 
Month,
ROUND(AvgOrderValue,2) AS AvgOrderValue,
ROUND(
AvgOrderValue,2) - round(LAG(AvgOrderValue) OVER (ORDER BY Month)
,2) AS ChangeInValue
FROM (
    SELECT 
    DATE_FORMAT(order_date,'%Y-%m') AS Month,
    AVG(total_amount) AS AvgOrderValue
    FROM Orders
    GROUP BY DATE_FORMAT(order_date,'%Y-%m')
) t
ORDER BY ChangeInValue DESC;



select product_id, count(product_id) SalesFrequency from OrderDetails
group by product_id
order by SalesFrequency desc
limit 5;



SELECT 
p.product_id,
p.name,
COUNT(DISTINCT o.customer_id) AS UniqueCustomerCount
FROM Products p
JOIN OrderDetails od 
ON p.product_id = od.product_id
JOIN Orders o 
ON od.order_id = o.order_id
GROUP BY p.product_id, p.name
HAVING COUNT(DISTINCT o.customer_id) <
(
SELECT COUNT( customer_id) * 0.40
FROM Customers
);


SELECT 
DATE_FORMAT(first_order_date,'%Y-%m') AS FirstPurchaseMonth,
COUNT(*) AS TotalNewCustomers
FROM
(
SELECT 
customer_id,
MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id
) t
GROUP BY DATE_FORMAT(first_order_date,'%Y-%m')
ORDER BY FirstPurchaseMonth;




select 
date_format(order_date,'%Y-%m') Month,
sum(total_amount) TotalSales from orders
group by date_format(order_date,'%Y-%m') 
order by TotalSales desc
limit 3;


