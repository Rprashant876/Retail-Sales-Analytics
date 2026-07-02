# 🛒 Retail Sales Analytics Pipeline
### End-to-End Data Analysis Project | Python → SQL → Power BI

![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.x-orange?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-F2C811?logo=powerbi&logoColor=black)

---

## 📌 Project Overview

This project simulates a **real-world retail analytics workflow** — starting from raw messy data and ending with a live executive Power BI dashboard. The full pipeline covers data cleaning, exploratory data analysis, advanced SQL querying, and an interactive visualisation layer.

> **Business Problem:** A retail company wants to understand why profit margins are shrinking despite growing revenue. Which products, regions, customers, and discount strategies are hurting the business — and what should be done about it?

---

## 🗂️ Table of Contents

- [Tools & Technologies](#-tools--technologies)
- [Dataset](#-dataset)
- [Project Structure](#-project-structure)
- [Phase 1 — Python EDA](#-phase-1--python-data-cleaning--eda)
- [Phase 2 — SQL Analysis](#-phase-2--sql-analysis)
- [Phase 3 — Power BI Dashboard](#-phase-3--power-bi-dashboard)
- [Key Business Insights](#-key-business-insights)
- [What I Learned](#-what-i-learned)
- [Connect With Me](#-connect-with-me)

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Python 3.x** (Pandas, Matplotlib, Seaborn) | Data cleaning, feature engineering, EDA |
| **MySQL 8.x + MySQL Workbench** | Database storage, advanced SQL analysis |
| **Power BI Desktop + DAX** | Interactive 3-page live dashboard |
| **Jupyter Notebook** | Python analysis and documentation |
| **GitHub** | Version control and portfolio showcase |

---

## 📦 Dataset

| Field | Detail |
|-------|--------|
| **Name** | Sample Superstore Sales Dataset |
| **Source** | [Kaggle — vivek468/superstore-dataset-final](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) |
| **Rows** | 9,994 orders |
| **Columns** | 21 original + 9 engineered features |
| **Period** | January 2014 — December 2017 |
| **Geography** | United States (49 states, 531 cities) |

**Key columns:** Order Date, Ship Date, Customer Segment, Region, Category, Sub-Category, Product Name, Sales, Quantity, Discount, Profit

---

## 📁 Project Structure

```
retail-sales-pipeline/
│
├── data/
│   ├── superstore.csv              ← Raw original dataset (download from Kaggle)
│   └── superstore_clean.csv        ← Cleaned output from Phase 1
│
├── notebooks/
│   └── phase1_eda.ipynb            ← Full Python EDA notebook
│
├── charts/
│   ├── 01_sales_by_category.png
│   ├── 02_monthly_trend.png
│   ├── 03_profit_margin_dist.png
│   ├── 04_region_comparison.png
│   ├── 05_top_subcategories.png
│   ├── 06_sales_by_segment.png
│   ├── 07_discount_vs_profit.png
│   └── 08_correlation_heatmap.png
│
├── sql/
│   └── script.sql                  ← All SQL queries (10 analysis sections)
│
├── powerbi/
│   └── retail_dashboard.pbix       ← Power BI dashboard file
│
└── README.md
```

---

## 🐍 Phase 1 — Python: Data Cleaning & EDA

**Goal:** Transform raw messy data into a clean, analysis-ready dataset and uncover initial business patterns.

### Data Cleaning

- Fixed `Order Date` and `Ship Date` columns from `object` → `datetime` format
- Removed duplicate rows
- Stripped whitespace from all text columns
- Standardised column names — removed spaces for easier programmatic access

### Feature Engineering — 9 new business columns created

| New Column | Formula | Business Use |
|------------|---------|-------------|
| `Profit_Margin` | `(Profit / Sales) × 100` | Core profitability KPI |
| `Ship_Days` | `Ship Date − Order Date` | Logistics performance metric |
| `Is_Loss` | `Profit < 0` → Yes/No | Flag loss-making orders |
| `Order_Year` | Extracted from Order Date | Year-over-year comparison |
| `Order_Month` | Extracted from Order Date | Seasonality analysis |
| `Order_Month_Name` | Extracted from Order Date | Human-readable month labels |
| `Order_Quarter` | Extracted from Order Date | Quarterly reporting |
| `Order_Q_Label` | e.g. "2017Q4" | Power BI time axis label |
| `Sales_Bucket` | Small / Medium / Large / Enterprise | Order size segmentation |

### EDA Performed

- Revenue and profit by Category, Sub-Category, Region, Segment
- Monthly and quarterly sales trends (2014–2017)
- Top 10 revenue products vs top 10 loss-making products
- Correlation analysis — what factors most drive profit?
- Discount impact analysis — at what level do orders become unprofitable?

### Charts Generated (8 total)


| Chart | Insight |
|-------|---------|
| Sales & Profit by Category | Technology leads revenue; Furniture has worst margin |
| Monthly Sales Trend | Q4 peaks every year — seasonal pattern confirmed |
| Profit Margin Distribution | Large number of orders cluster around 0% margin |
| Region Comparison | West is most profitable; Central lags significantly |
| Top 10 Sub-Categories | Phones and Chairs dominate revenue |
| Sales by Segment (Pie) | Consumer = 50%, Corporate = 31%, Home Office = 19% |
| Discount vs Profit (Scatter) | Clear negative correlation — more discount = more losses |
| Correlation Heatmap | Discount has the strongest negative correlation with Profit |

---

## 🗄️ Phase 2 — SQL Analysis

**Goal:** Load clean data into MySQL and answer real business questions across 10 analysis categories using advanced SQL techniques.

**Database:** `retail` | **Table:** `superstore`

---

### 📂 SQL File: `sql/script.sql`

The SQL analysis is organised into **10 business question categories**:

---

#### 1. Overall Business Summary

```sql
-- Overall key metrics
SELECT SUM(Sales) total_revenue, SUM(Profit) total_profit,
       AVG(Sales) avg_order_value, AVG(Ship_Days) avg_ship_days
FROM superstore;

-- Overall profitability check
SELECT SUM(Sales) total_sales, SUM(Profit) total_profit,
       ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) profit_margin
FROM superstore;
```

---

#### 2. Revenue & Profit by Category

```sql
-- Which category contributes the most revenue?
SELECT category, SUM(Sales) total_revenue
FROM superstore
GROUP BY category
ORDER BY total_revenue DESC;

-- High sales but low profit categories?
SELECT category, SUM(Sales) AS total_sales, SUM(Profit) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;
```

> **Finding:** Technology leads in both revenue and profit. Furniture has high revenue but extremely low profit — driven by excessive discounting.

---

#### 3. Loss Investigation

```sql
-- What is causing losses? (by category)
SELECT category, COUNT(*) FROM superstore
WHERE Is_Loss = 'Yes'
GROUP BY category
ORDER BY COUNT(*) DESC;

-- Which products generate the largest losses?
SELECT category, product_name, SUM(Profit) total_loss
FROM superstore WHERE Profit < 0
GROUP BY category, product_name
ORDER BY total_loss;

-- Which states contribute most to losses?
SELECT state, SUM(Profit) total_loss
FROM superstore WHERE Profit < 0
GROUP BY state
ORDER BY total_loss;

-- What % of products are loss-making?
SELECT ROUND(
    (COUNT(DISTINCT CASE WHEN Profit < 0 THEN Product_Name END)
    / COUNT(DISTINCT Product_Name) * 100), 2
) loss_percent
FROM superstore;
```

> **Finding:** 41% of all products are loss-making. Texas contributes the most to total losses. Central region has the highest concentration of loss-making orders. Excessive discounting is the primary cause.

---

#### 4. Discount Impact Analysis

```sql
-- Does discount increase or decrease profitability?
SELECT
    CASE WHEN Discount = 0 THEN 'No Discount' ELSE 'Discount Applied' END AS discount_type,
    ROUND(AVG(Profit), 2) AS avg_profit
FROM superstore
GROUP BY discount_type;

-- At what discount level do orders become unprofitable?
SELECT
    CASE
        WHEN Discount = 0    THEN '0%'
        WHEN Discount <= 0.1 THEN '1-10%'
        WHEN Discount <= 0.2 THEN '11-20%'
        WHEN Discount <= 0.3 THEN '21-30%'
        WHEN Discount <= 0.5 THEN '31-50%'
        ELSE '>50%'
    END AS Discount_Window,
    SUM(Profit) total_profit
FROM superstore
GROUP BY Discount_Window
ORDER BY total_profit;

-- Which categories are most affected by discounts?
SELECT category,
    ROUND(AVG(CASE WHEN Discount = 0 THEN Profit ELSE 0 END), 2)  Profit_No_Discount,
    ROUND(AVG(CASE WHEN Discount > 0 THEN Profit ELSE 0 END), 2)  Profit_With_Discount
FROM superstore
GROUP BY category
ORDER BY Profit_With_Discount;
```

> **Finding:** Profitability declines sharply as discount increases. Furniture is the most affected category. Orders with 31–50% discount generate significant net losses. Discount policy should be revised — cap recommended at 20%.

---

#### 5. Customer Analysis

```sql
-- Most valuable customers by revenue
SELECT customer_name, SUM(Sales) total_sales
FROM superstore
GROUP BY customer_name
ORDER BY total_sales DESC;

-- Customers generating highest profits
SELECT customer_name, SUM(Profit) total_profit
FROM superstore
GROUP BY customer_name
ORDER BY total_profit DESC;

-- Customers consistently associated with losses
SELECT customer_name, COUNT(*) total_order,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) loss_orders,
    ROUND(SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) Loss_rate,
    ROUND(SUM(Profit), 2) total_losses
FROM superstore
GROUP BY customer_name
ORDER BY loss_rate DESC;
```

> **Finding:** Sean Miller is the highest revenue customer but generates a net loss. Tamara Chand generates the highest profit. Some customers have very high loss rates on their orders — driven by heavy discounts.

---

#### 6. Product Analysis

```sql
-- Top selling products
SELECT Product_Name, COUNT(DISTINCT Order_ID) orders,
    SUM(Quantity) Quantity,
    ROUND(SUM(Sales), 2) Sales,
    ROUND(SUM(Profit), 2) Profit
FROM superstore
GROUP BY Product_Name
ORDER BY Sales DESC;

-- Products to discontinue (net loss-makers)
SELECT product_name, SUM(Quantity) total_quantity,
    ROUND(SUM(Sales), 2) total_sales,
    ROUND(SUM(Profit), 2) net_profit
FROM superstore
GROUP BY product_name
HAVING SUM(Profit) < 0
ORDER BY net_profit;

-- Products deserving more promotion
SELECT product_name, SUM(Quantity) total_quantity,
    ROUND(SUM(Sales), 2) total_sales,
    ROUND(SUM(Profit), 2) profit
FROM superstore
GROUP BY product_name
HAVING SUM(Profit) > 0
ORDER BY total_quantity DESC, total_sales DESC, profit DESC;
```

> **Finding:** Cubify Cube 3D Printer Double Head generates the maximum loss of any single product and should be discontinued. Staples is the top-selling product by volume and deserves more promotion.

---

#### 7. Geographic Analysis

```sql
-- States with highest sales & profit
SELECT state, ROUND(SUM(Sales), 2) sales
FROM superstore
GROUP BY state ORDER BY sales DESC;

-- States with HIGH sales but LOW profit (using CTE)
WITH cte AS (
    SELECT state,
        ROUND(SUM(Sales), 2) total_sales,
        ROUND(SUM(Profit), 2) total_profit
    FROM superstore GROUP BY state
)
SELECT state, total_sales, total_profit FROM cte
WHERE total_sales > (SELECT AVG(total_sales) FROM cte)
AND   total_profit < (SELECT AVG(total_profit) FROM cte)
ORDER BY total_sales DESC;

-- Best markets to expand into
SELECT state,
    ROUND(SUM(Sales), 2) total_sales,
    ROUND(SUM(Profit), 2) total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100.0, 2) Profit_Margin
FROM superstore
GROUP BY state
HAVING SUM(Profit) > 0
ORDER BY total_profit DESC, total_sales DESC;
```

> **Finding:** California generates the highest sales and profit. Texas has high sales but is the biggest loss-contributing state. In Texas, Electric Binding Systems in Office Supplies cause the most losses — a targeted discount review is critical.

---

#### 8. Shipping Analysis

```sql
-- Which shipping mode is most profitable?
SELECT ship_mode, ROUND(SUM(Profit), 2) total_profit
FROM superstore GROUP BY ship_mode ORDER BY total_profit DESC;

-- Shipping mode loss rates
SELECT ship_mode,
    COUNT(*) total_orders,
    ROUND(SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END), 2) total_loss_orders,
    CONCAT(ROUND(SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') loss_percentage
FROM superstore
GROUP BY ship_mode
ORDER BY loss_percentage DESC;
```

> **Finding:** Standard Class shipping generates the highest number of loss-making orders despite being the most commonly used mode. First Class has the best average order value.

---

#### 9. Time Trend Analysis (Window Functions)

```sql
-- Year-over-year sales growth using LAG()
SELECT order_year, total_sales, pre_year_sales,
    ROUND((total_sales - pre_year_sales), 2) sales_growth,
    CONCAT(ROUND((total_sales - pre_year_sales) * 100 / pre_year_sales, 2), '%') growth_percentage
FROM (
    SELECT order_year, ROUND(SUM(Sales), 2) total_sales,
        LAG(ROUND(SUM(Sales), 2)) OVER (ORDER BY order_year) pre_year_sales
    FROM superstore GROUP BY order_year
) t;

-- Which months are strongest for sales?
SELECT order_month_name, ROUND(SUM(Sales), 2) total_sales
FROM superstore
GROUP BY order_month_name
ORDER BY total_sales DESC;

-- Best quarter per year using RANK() OVER PARTITION BY
WITH highest_profit AS (
    SELECT order_year, order_quarter,
        ROUND(SUM(Profit), 2) total_profit,
        RANK() OVER (PARTITION BY order_year ORDER BY ROUND(SUM(Profit), 2) DESC) rnk
    FROM superstore
    GROUP BY order_year, order_quarter
)
SELECT order_year, order_quarter, total_profit
FROM highest_profit WHERE rnk = 1;
```

> **Finding:** Revenue grew consistently year-over-year from 2014 to 2017. Q4 is the strongest quarter every year. November and December are the top 2 sales months — seasonal inventory planning is critical.

---

#### 10. SQL Techniques Summary

| Technique | Used For |
|-----------|---------|
| `GROUP BY` + `ORDER BY` | Category, region, customer aggregations |
| `HAVING` | Filtering aggregated results (e.g. profitable states only) |
| `CASE WHEN` | Discount banding, loss flagging, conditional aggregations |
| `CTE (WITH)` | Multi-step logic — high sales / low profit state analysis |
| `LAG() OVER` | Year-over-year sales growth calculation |
| `RANK() OVER PARTITION BY` | Best quarter per year ranking |
| `Subquery` | % of loss-making products, revenue share calculations |
| `CONCAT + ROUND` | Formatted percentage output |

---

## 📊 Phase 3 — Power BI Dashboard

**Goal:** Build a 3-page interactive dashboard connected live to the MySQL database.

**Connection:** Power BI Desktop → MySQL (`retail`) → `superstore` table (live connection)

### Dashboard Pages

**Page 1 — Executive Overview**
- KPI Cards: Total Revenue · Total Profit · Total Orders · Profit Margin %
- Line chart: Monthly revenue trend (2014–2017) with trend line
- Customer segment donut chart
- Slicers: Year · Category · Region

**Page 2 — Product & Category Deep Dive**
- Bar chart: Top 10 sub-categories by revenue
- Matrix table with red/green conditional formatting on Profit Margin %
- Clustered bar: Revenue vs Profit by Category (shows Furniture's problem instantly)
- Tile slicer: Customer segment

**Page 3 — Regional & Customer Analysis**
- Filled map: Sales by US state (shade intensity = revenue)
- Bar chart: Revenue vs Profit by Region
- Customer table: Top customers ranked by revenue with profit contribution
- KPI card: Loss-making order count (in red)

> *(Add Power BI dashboard screenshots here)*

### DAX Measures Created

```
Total Revenue       = SUM(superstore[Sales])
Total Profit        = SUM(superstore[Profit])
Total Orders        = DISTINCTCOUNT(superstore[Order_ID])
Profit Margin %     = DIVIDE([Total Profit], [Total Revenue]) * 100
Prev Month Revenue  = CALCULATE([Total Revenue], PREVIOUSMONTH(DateTable[Date]))
MoM Growth %        = DIVIDE([Total Revenue] - [Prev Month Revenue], [Prev Month Revenue]) * 100
Loss Orders         = CALCULATE(COUNT(superstore[Order_ID]), superstore[Is_Loss] = "Yes")
```

---

## 💡 Key Business Insights

After analysing 9,994 orders across 4 years, here are the most critical findings:

**1. Discounting is the root cause of most losses**
Profitability drops sharply once discounts exceed 20%. Orders with 31–50% discount generate a net loss across all categories. Recommendation: cap all discounts at 20% company-wide.

**2. 41% of products are loss-making**
Nearly half of all unique products generate a net loss. The Cubify Cube 3D Printer Double Head is the single biggest loss-generating product and should be discontinued.

**3. Furniture is a revenue trap**
Furniture generates $742K in revenue but only $18K in profit. Tables and Bookcases are the worst performers, driven by heavy discounting.

**4. Texas is the biggest problem state**
Texas has above-average sales but is the largest loss-contributing state. Electric Binding Systems in Office Supplies cause the most damage in Texas. A targeted discount review is recommended.

**5. Q4 drives the business — but also the most losses**
November and December are the strongest sales months every year. However, Q4 promotional discounting causes a spike in loss-making orders. Discount policies in Q4 should be tightened.

**6. Sean Miller is the most "expensive" customer**
The highest revenue customer generates a net financial loss. A customer profitability review across all top accounts is warranted.

**7. Standard Class shipping has the highest loss order rate**
Despite being the most-used shipping mode, Standard Class generates the most loss-making orders — shipping costs may be eroding already-thin margins.

---

--- 📚 What I Learned

- **Data cleaning** — fixing date formats, removing duplicates, handling whitespace in Pandas
- **Feature engineering** — creating Profit Margin %, Ship Days, Is_Loss flag, and date-based columns
- **EDA storytelling** — turning raw numbers into clear written business insights
- **Advanced SQL** — Window Functions (`RANK OVER PARTITION BY`, `LAG`), CTEs, subqueries, CASE WHEN discount banding
- **Business thinking in SQL** — framing every query as a business question with a documented conclusion
- **Power BI + DAX** — KPI cards, time intelligence measures, conditional formatting matrices, live MySQL connection
- **Dashboard design** — page navigation, cross-filtering slicers, map geocoding, professional theme
- **Portfolio presentation** — structured README that tells the full project story to recruiters

---

## 🔗 Connect With Me

**[Prashant Raghav]**

[![LinkedIn](https://www.linkedin.com/in/rprashant876/)
---


