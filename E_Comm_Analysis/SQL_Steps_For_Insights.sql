-- Describe the Tables:

DESC Customers;
DESC Products;
DESC Orders;
DESC OrderDetails;

-- Identify the top 3 cities with the highest number of customers to determine key markets for targeted marketing and logistic optimization.

select location , count(name) number_of_customers from Customers
group by location
order by count(name) desc
limit 3;

-- As per the last query's result, Which of the cities must be focused as a part of marketing strategies? 
-- ANS : Delhi, Chennai, Jaipur

-- Determine how many customers fall into each order frequency category based on the number of orders they have placed.
-- Using the Orders table, calculate the number of customers who placed 1 order, 2 orders, 3 orders, etc.

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

-- As per the Engagement Depth Analysis question, What is the trend of the number of customers v/s number of orders?
-- Ans :  As the Number of orders increases, the Customer count decreases. 

-- As per the Engagement Depth Analysis question, Which customers category does the company experiences the most?
-- Ans : Occasional Shoppers

--Identify products where the average purchase quantity per order is 2 but with a high total revenue, suggesting premium product trends.

select product_id Product_Id, 
avg(quantity) AvgQuantity, 
 Sum(quantity * price_per_unit) TotalRevenue
from OrderDetails
group by product_id
 having avg(quantity) =2
order by TotalRevenue desc;

-- Among products with an average purchase quantity of two, which ones exhibit the highest total revenue?
-- Ans : Product1

-- For each product category, calculate the unique number of customers purchasing from it. This will help understand which categories have wider appeal across the customer base.

select 
p.category, 
count(distinct o.customer_id) unique_customers
 from Products p join OrderDetails  d 
on p.product_id=d.product_id join Orders O on d.order_id=o.order_id
group by p.category
order by unique_customers desc;

-- As per the last question, Which product category needs more focus as it is in high demand among the customers?
-- Ans : Electronics

-- Analyze the month-on-month percentage change in total sales to identify growth trends.

select date_format(order_date,'%Y-%m') Month, 
Sum(total_amount) TotalSales,
round(
    (Sum(total_amount)-lag(sum(total_amount))over(order by date_format(order_date,'%Y-%m') )) / 
lag(sum(total_amount))over(order by date_format(order_date,'%Y-%m') ) *100

,2) PercentChange
from orders
group by date_format(order_date,'%Y-%m') ;

--As per Sales Trend Analysis question, During which month did the sales experience the largest decline?
-- Ans : Feb 2024

--As per Sales Trend Analysis question, What could be inferred about the sales trend from March to August?
-- Ans : Sales Fluctuated with no trend.

-- Examine how the average order value changes month-on-month. Insights can guide pricing and promotional strategies to enhance order value.

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

-- As per last question, Which month has the highest change in the average order value?
-- Ans : December

--Based on sales data, identify products with the fastest turnover rates, suggesting high demand and the need for frequent restocking.

select product_id, count(product_id) SalesFrequency from OrderDetails
group by product_id
order by SalesFrequency desc
limit 5;

-- As per last question, Which product_id has the highest turnover rates and needs to be restocked frequently?
-- Ans : 7

-- List products purchased by less than 40% of the customer base, indicating potential mismatches between inventory and customer interest.

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

-- Why might certain products have purchase rates below 40% of the total customer base?
-- Ans : Poor visibility on the platform

-- What could be a strategic action to improve the sales of these underperforming products?
-- Ans : Implement targeted marketing campaigns to raise awareness and interest

-- Evaluate the month-on-month growth rate in the customer base to understand the effectiveness of marketing campaigns and market expansion efforts.

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

-- As per last question, What can be inferred about the growth trend in the customer base from the result table?
-- Ans : It is downward trend which implies the marketing campaign are not much effective.

-- Identify the months with the highest sales volume, aiding in planning for stock levels, marketing efforts, and staffing in anticipation of peak demand periods.

select 
date_format(order_date,'%Y-%m') Month,
sum(total_amount) TotalSales from orders
group by date_format(order_date,'%Y-%m') 
order by TotalSales desc
limit 3;

-- As per last question, Which months will require major restocking of product and increased staffs?
-- Ans : September, December


