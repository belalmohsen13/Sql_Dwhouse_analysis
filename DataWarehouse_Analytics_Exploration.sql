use DataWarehouseAnalytics

/* DataBase Exploration*/

-- EXPLORE ALL THE OBJECTS

SELECT *FROM INFORMATION_SCHEMA.TABLES

-- EXPLORE ALL THE COLUMNS 

SELECT *FROM INFORMATION_SCHEMA.COLUMNS
WHERE  TABLE_NAME ='dim_customers'



/*Dimensions Exploration*/

-- EXPLORE ALL THE COUNTERIES THAT CUSTOEMER CAME FROM
SELECT DISTINCT COUNTRY	FROM GOLD.dim_customers
 
 -- EXPLORE ALL THE PRODUCT CATEGORIES FROM 
SELECT DISTINCT CATEGORY ,subcategory , product_name	FROM GOLD.dim_products
ORDER BY 1 ,2 ,3



/*Data Exploration*/

 -- EXPLORE THE FIRST DATE AND LAST DATE OF ORDERS
 SELECT MIN(ORDER_DATE) AS FIRST_ORDER,
		MAX(ORDER_DATE) AS LAST_ORDER ,
		datediff(year,MIN(ORDER_DATE),MAX(ORDER_DATE) ) AS DATE_DIFF
FROM gold.fact_sales

 -- EXPLORE THE YOUNGEST AND OLDEST CUSTOMER
   SELECT MAX(BIRTHDATE) AS YOUNGEST_CUSTOMER ,
		datediff(year,MAX(BIRTHDATE),GETDATE()) AS DATE_OF_YOUNGEST_CUSTOMER,
		MIN(BIRTHDATE) AS OLDEST , 
		datediff(year,MIN(BIRTHDATE),GETDATE() ) AS DATE_OF_OLDEST_CUSTOMER,
		datediff(year,MIN(BIRTHDATE),MAX(BIRTHDATE) ) AS DATE_DIFF
FROM gold.dim_customers

/* Measure Exploration*/

--Find the Total sum
select sum(sales_amount) as Total_sales from gold.fact_sales
--Find how many items are sold
select sum(quantity) as Total_sales from gold.fact_sales

--Find the Average selling price
select avg(price) as avg_price from gold.fact_sales

--Find the Total number of Orders 
select count(order_number) as Total_Orders from gold.fact_sales
select count(distinct order_number) as Distinct_Total_Orders from gold.fact_sales

--Find the Total number of products 
select count(distinct product_name) as Total_numberProducts from gold.dim_products

--Find the Total number of customers
select count(customer_id) as Total_numberCustomers from gold.dim_customers

--Find the Total number of customers that has placed an order
select count(Distinct customer_key) as Total_Customers_with_Orders from gold.fact_sales



/* Report shows all key metrics of business*/

select 'Total Sales' as measure_name , sum(sales_amount) as Total_sales from gold.fact_sales
union all
select 'total quantity' , sum(quantity) as Total_sales from gold.fact_sales
union all
select 'Average_price',avg(price) as avg_price from gold.fact_sales
union all
select 'Total NR. Orders ' ,count(distinct order_number) as Distinct_Total_Orders from gold.fact_sales
union all
select 'Total NR. products ', count(distinct product_name) as Total_numberProducts from gold.dim_products
union all
select 'Total NR. customer', count(customer_id) as Total_numberCustomers from gold.dim_customers

/**************** magnitude analysis *******************/

-- total customer by countries
select  
country,
count(customer_key) as total_customers
from gold.dim_customers
group by country
order by total_customers desc

-- total customer by gender

select  
gender,
count(customer_key) as total_customers
from gold.dim_customers
group by gender
order by total_customers desc
-- total products by category

select  
category,
count(product_key) as total_customers
from gold.dim_products
group by category
order by total_customers desc

-- the average costs in every category

select  
category,
avg(cost) as avg_cost
from gold.dim_products
group by category
order by avg_cost desc

-- the total revenue in every category

select 
p.category,
sum(sales_amount) as total_revenue
from gold.fact_sales s left join gold.dim_products p
on s.product_key=p.product_key
group by p.category
order by total_revenue desc

-- the total revenue by each customers

select 
c.first_name +' '+c.last_name as full_name,
sum(sales_amount) as total_revenue
from gold.fact_sales s left join gold.dim_customers c
on s.customer_key=c.customer_key
group by c.first_name +' '+c.last_name 
order by total_revenue desc

-- the distribution of sold items across countries

select 
c.country,
sum(quantity) as Total_sold_items
from gold.fact_sales s left join gold.dim_customers c
on s.customer_key=c.customer_key
group by c.country 
order by Total_sold_items desc


/************* Ranking Analysis ********************/

-- top 5 prouducts with high revenue
select top 5
p.product_name,
sum(sales_amount) as Total_sold_items
from gold.fact_sales s left join gold.dim_products p
on s.product_key=p.product_key
group by p.product_name
order by Total_sold_items desc


-- worst 5 prouducts in sales

select top 5
p.product_name,
sum(sales_amount) as Total_sold_items
from gold.fact_sales s left join gold.dim_products p
on s.product_key=p.product_key
group by p.product_name
order by Total_sold_items asc