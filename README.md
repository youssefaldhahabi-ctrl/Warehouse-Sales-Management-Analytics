📊 Warehouse & Sales Management Performance Dashboard

## 📌 Project Overview
This project delivers an end-to-end data analytics solution using the **AdventureWorksLT2022** database. The goal is to bridge the gap between raw transactional data and executive decision-making by optimizing data extraction through **SQL Server** and developing an interactive, dark-themed executive dashboard in **Power BI**.

## 🛠️ Tech Stack & Tools
* **Database:** SQL Server (AdventureWorksLT2022)
* **Data Engineering:** T-SQL (Views, Complex JOINs, Conditional Logic)
* **Business Intelligence:** Power BI Desktop
* **Data Modeling:** Star Schema (Fact & Dimension Tables)
* **Analytics:** DAX (Data Analysis Expressions) for Advanced Measures

---

## 🏗️ Phase 1: Data Engineering (SQL Server)
To ensure high performance and clean data before importing into Power BI, complex transformations and joins were handled directly in SQL Server by creating optimized **Views**.

### Key View Created: `v_SalesPerformance`
This view flattens the relational database schema, joining sales order headers, details, customer data, and products, while applying conditional logic for data readiness.
 
```sql
 
CREATE VIEW v_SalesPerformance AS
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.DueDate,
    soh.ShipDate,
    soh.Status,
    -- Customer Information
    c.CustomerID,
    ISNULL(c.CompanyName, 'Individual Customer') AS CompanyName,
    -- Product Information
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    pc.Name AS ProductCategory,
    -- Financial Metrics
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal,
    -- Shipping Performance Logic
    DATEDIFF(day, soh.OrderDate, soh.ShipDate) AS DaysToShip,
    CASE 
        WHEN soh.ShipDate > soh.DueDate THEN 1 
        ELSE 0 
    END AS IsShippedLate
FROM SalesLT.SalesOrderHeader soh
INNER JOIN SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN SalesLT.Customer c ON soh.CustomerID = c.CustomerID
INNER JOIN SalesLT.Product p ON sod.ProductID = p.ProductID
INNER JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID;

```
📐 Phase 2: Data Modeling & DAX Measures (Power BI)
🔹 Data Modeling Strategy
Data was loaded into Power BI using a structured workspace. To keep the model clean and scalable, all analytical calculations were isolated into a dedicated _Measures table.

🔹 Core DAX Measures Built
Here are the primary business metrics calculated for the dashboard:

Total Sales: Calculates the total revenue generated from sales.

```sql
Code snippet
Total Sales = SUM(v_SalesPerformance[LineTotal])
```
Total Orders: Tracks the unique count of sales orders.
```sql
Code snippet
Total Orders = DISTINCTCOUNT(v_SalesPerformance[SalesOrderID])
```
Late Shipping Rate (%): Calculates the percentage of orders that missed their due date to monitor warehouse efficiency.
```sql
Code snippet
Late Shipping Rate (%) = 
DIVIDE(
    CALCULATE(COUNT(v_SalesPerformance[SalesOrderID]), v_SalesPerformance[IsShippedLate] = 1),
    COUNT(v_SalesPerformance[SalesOrderID]),
    0
)
```
🎨 Phase 3: Dashboard Design & UX Strategy
The dashboard was designed with an executive-ready Dark Mode Theme to provide a sleek, modern, and high-contrast user experience that reduces visual fatigue.

Container-Based Layout: Visuals are grouped into clean, structured containers to separate Sales KPIs from Warehouse Logistics.

Actionable Visuals: Utilized Horizontal Bar Charts for top-performing products and categories, ensuring text labels are fully readable without truncation.

KPI Cards: Placed at the top for immediate visibility of critical metrics (Sales, Orders, and Shipping Delays).
