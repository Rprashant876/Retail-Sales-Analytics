create database retail;
use retail;
select * from superstore;

select count(*) from superstore;
select max(Order_Date),min(Order_date) from superstore;

-- Overall Business Number
select sum(Sales) total_revenue ,sum(Profit) total_profit,
avg(sales) avg_order_value,avg(ship_days) avg_ship_days from superstore ;

--                                     Revenue & Profit
-- -------------------------------------------------------------------------------------------------------
-- 1. Is the company profitable overall?
select sum(sales) total_sales , sum(profit) total_profit,
round((sum(profit)/sum(sales))*100,2) profit_margin from superstore;

-- 2. Which categories contribute the most revenue?
-- ------------------------------------------------------
select * from superstore;
select category,sum(sales) total_revenue from superstore 
group by category 
order by total_revenue desc;

-- 3. Which categories contribute the most profit?
-- -----------------------------------------------------
select category,sum(profit) total_profit from superstore 
group by category 
order by total_profit desc;

-- 4. Are there categories with high sales but low profit?
-- ----------------------------------------------------------
SELECT category,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;


--                                           Loss Investigation
-- --------------------------------------------------------------------------------------------------------------------------------------

-- 5. What is causing losses in the business?
-- ------------------------------------------------------------
select category , count(*) from superstore 
where Is_Loss = 'Yes'
group by category
order by count(*) desc;
select * from superstore 
where Is_Loss = 'Yes';  -- unwanted Discount cause losses

-- 6. Which products generate the largest losses? 
-- ------------------------------------------------------------
select category,product_name,sum(profit) total_loss 
from superstore where profit < 0
group by category,product_name
order by total_loss ;      -- Technology category (Cubify Cube#D Printer Double HEad Print) product make maximun losses

select category,sum(profit) total_loss 
from superstore where profit < 0
group by category
order by total_loss ;  -- Furniture Category Product Cause maxinum losses

select product_name,round(avg(discount),2) avg_dist,sum(profit) total_loss 
from superstore where profit < 0
group by product_name
order by total_loss 
limit 10;          -- small discount Cause Big Loss

-- 7. Which states or regions contribute most to losses?
-- ------------------------------------------------------------
select state,sum(profit) total_loss 
from superstore where profit < 0
group by state
order by total_loss ;   -- Texas contribute most to losses

select region,sum(profit) total_loss 
from superstore where profit < 0
group by region
order by total_loss ;   -- central region 

select category,product_name,sum(profit) total_loss from superstore
where state ='Texas' and profit < 0 
group by category,product_name
order by total_loss ;    -- in Office Supplies category Electric Binding System cause more losses in Texas State

-- 8. Are losses concentrated in a few products or spread across many?
-- -----------------------------------------------------------------------

select round(
(count(distinct case when profit < 0 then product_name end )
/count(distinct product_name)*100)
,2) loss_percent
from superstore;            -- 41% product are Loss Making Product



--                                              Discount Impact
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Does offering discounts increase profitability?
-- ----------------------------------------------------
select
sum(case when discount = 0 then profit else 0 end ) no_discount,
sum(case when discount >0 then profit else 0 end) discount_profit
from superstore;

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        ELSE 'Discount Applied'
    END AS discount_type,
    ROUND(AVG(profit),2) AS avg_profit
FROM superstore
GROUP BY discount_type; -- Profitability declines as discounts increase


-- At what discount level do orders become unprofitable?
-- ---------------------------------------------------------
select 
CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.1 THEN '1-10%'
        WHEN discount <= 0.2 THEN '11-20%'
        WHEN discount <= 0.3 THEN '21-30%'
        WHEN discount <= 0.5 THEN '31-50%'
        ELSE '>50%'
end as Discount_Window,
sum(profit) total_profit
from superstore
group by Discount_Window
order by total_profit;


-- Which categories are most affected by discounts?
-- ------------------------------------------------------
select category,
round(avg(case when discount=0 then profit else 0 end ),2) Profit_No_Discount,
round(avg(case when discount > 0 then profit else 0 end ),2) Profit_With_Discount
 from superstore
 group by category
 order by profit_With_Discount ;    -- Furniture Category are most effected by discount

-- Should discount policies be revised?
-- ----------------------------------------
select 
sum(case when discount=0 then profit else 0 end ) Profit_No_Discount,
sum(case when discount > 0 then profit else 0 end ) Profit_With_Discount
 from superstore;    -- Yes
 
 
--                                             Customer Analysis
-- -------------------------------------------------------------------------------------------------------------------------------------
-- Who are the most valuable customers?
-- --------------------------------------
select customer_name , sum(sales) total_sales  from superstore
group by customer_name
order by total_sales desc;     -- Sean Miller are the most valuable customer

-- Which customers generate the highest profits?
-- ------------------------------------------------
select customer_name , sum(profit) total_profit from superstore
group by customer_name
order by total_profit desc;  -- Tamara Chand Generate the Highest Profits

-- Are some customers consistently associated with losses?
-- --------------------------------------------------------
select customer_name,count(*) total_order,
sum(case when profit <0 then 1 else 0 end ) loss_orders,
round(sum(case when profit < 0 then 1 else 0 end) *100.0 / count(*),2) Loss_rate,
round(sum(profit),2) total_losses
from superstore
group by customer_name
order by loss_rate desc;     -- Yes


-- Is revenue dependent on a small group of customers?
-- ------------------------------------------------------
select customer_name,
round(sum(sales),2) total_revenue,
round(sum(sales)*100.0/(select sum(sales) from superstore),2) revenure_percentage
from superstore
group by customer_name
order by total_revenue desc;


--                                             Product Analysis
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Which products are top sellers?
-- ----------------------------------
select Product_Name, count(distinct order_id) orders,
sum(quantity) Quantity,
round(sum(sales),2) Sales,
round(sum(profit),2)  Profit
 from superstore
group by product_name 
order by Sales desc;

-- Which products generate the most profit?
-- -------------------------------------------
select product_name , round(sum(profit),2) total_profit 
from superstore
group by product_name
order by total_profit desc ;

-- Which products should be discontinued due to poor performance?
-- -----------------------------------------------------------------
select product_name ,sum(quantity) total_quantity,
round(sum(sales),2) total_sales,
sum(case when profit > 0 then profit else 0 end ) total_profit,
sum(case when profit < 0 then profit else 0 end )  total_loss,
round(sum(profit),2) net_profit
from superstore
group by product_name
having sum(profit) < 0
order by net_profit ;    -- 3D Printer Double Head Print should be Discontinued

-- Which products deserve additional promotion?
-- -----------------------------------------------
select product_name,
sum(quantity) total_quantity,
round(sum(sales),2) total_sales,
round(sum(profit),2) profit
from superstore 
group by product_name
having sum(profit)>0
order by total_quantity desc , total_sales desc,profit desc;   -- Staples 


--                                                 Geographic Analysis
-- -------------------------------------------------------------------------------------------------------------------------------------
-- Which states generate the highest sales?
-- -------------------------------------------
select state,round(sum(sales),2) sales
from superstore
group by state order by sales desc;   -- California Generate Highest Sales

-- Which states generate the highest profit?
-- ---------------------------------------------
select state,round(sum(profit),2) profit
from superstore
group by state order by profit desc;    -- California Generate Highest Profit

-- Which states generate high sales but low profit?
-- ---------------------------------------------------
with cte as ( select state,
round(sum(sales),2) total_sales,
round(sum(profit),2) total_profit
from superstore
group by state
)
select state,total_sales,total_profit
from cte
where total_sales > (select avg(total_sales) from cte)
and total_profit < (select avg(total_profit) from cte)
order by total_sales desc;                                -- Texas 

-- Which markets should the company expand into?
-- -------------------------------------------------
select state , 
round(sum(sales),2) total_sales,
round(sum(profit),2) total_profit,
round((sum(profit)/sum(sales))*100.0,2) Profit_Margin
from superstore
group by state
having sum(profit) > 0
order by total_profit desc,
		total_sales desc;
        
--                                               Shipping Analysis
-- --------------------------------------------------------------------------------------------------------------------------------------

-- Which shipping mode is most profitable?
-- ---------------------------------------
select ship_mode,round(sum(profit),2) total_profit
from superstore group by ship_mode order by total_profit desc;

-- Does faster shipping improve customer value?
-- ----------------------------------------------
select ship_mode,count(*) total_orders,
round(sum(sales),2) total_sales ,
round(sum(profit),2) total_profit,
round(avg(sales),2) avg_order_value ,
round(avg(profit),2) avg_progit_per_order
from superstore group by ship_mode 
order by avg_order_value desc;

-- Are certain shipping methods associated with losses?
-- -----------------------------------------------------
select ship_mode,
count(*) total_orders,
round(sum(case when profit <0 then 1 else 0 end ),2) total_loss_orders,
concat(round(round(sum(case when profit <0 then 1 else 0 end ),2)*100.0/count(*),2),"%") loss_percentage
from superstore
group by ship_mode
order by loss_percentage desc;  -- standard class ship mode make more loss order


--                                               Time Trend Analysis
-- --------------------------------------------------------------------------------------------------------------------------------------

-- Are sales growing over time?
-- ------------------------------
select order_year,total_sales,pre_year_sales
, round((total_sales - pre_year_sales),2) sales_growth,
 concat(round((total_sales - pre_year_sales)*100/pre_year_sales,2),"%") growth_percentage
from (
select order_year,round(sum(sales),2) total_sales ,
lag(round(sum(sales),2)) over (order by order_year) pre_year_sales
from superstore
group by order_year) t;


-- Which months are strongest for sales?
-- --------------------------------------
select order_month_name , round(sum(sales),2) total_sales 
from superstore 
group by order_month_name
order by total_sales desc;


-- Which quarters generate the highest profit?
-- ---------------------------------------------
with highest_profit as (
select order_year,order_quarter , round(sum(profit),2) total_profit ,
rank() over (partition by order_year order by round(sum(profit),2) desc) rnk
from superstore
group by order_year,order_quarter 
order by order_year,total_profit desc
)
select order_year,order_quarter,total_profit
from highest_profit 
where rnk=1;

select order_quarter , round(sum(profit),2) total_profit 
from superstore
group by order_quarter 
order by total_profit desc;



-- =================X======================X================================X================================X=============================

