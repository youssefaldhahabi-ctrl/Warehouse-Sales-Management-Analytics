# 📊 Product Category Sales Performance Dashboard

## 📌 Project Overview
This project delivers an end-to-end data analytics solution using the **AdventureWorksLT2022** database. The goal is to transform raw sales transactions into actionable business insights by optimizing data aggregation through **SQL Server** and developing an interactive, executive-ready dark-themed dashboard in **Power BI**.

## 🛠️ Tech Stack & Tools
* **Database:** SQL Server (AdventureWorksLT2022)
* **Data Engineering:** T-SQL (Views, Common Table Expressions - CTEs, Advanced JOINs, Conditional Logic)
* **Business Intelligence:** Power BI Desktop
* **Data Modeling:** Star Schema Design
* **Analytics:** Advanced DAX (Data Analysis Expressions) for Dynamic Market Share Calculations

---

## 🏗️ Phase 1: Data Engineering (SQL Server)
To ensure high query performance and clean data structures before importing into Power BI, complex multi-table joins and performance-tier categorizations were handled directly in SQL Server by creating an optimized **View**.

### Key View Created: `[SalesLT].[v_SalesPerformance]`
This view implements a Common Table Expression (CTE) to aggregate product quantities and unit prices by category for June 2008. It applies conditional branching (`CASE WHEN`) to evaluate and label performance classes (`Excellent`, `Average`, or `Weak`) directly at the database layer.

```sql
USE [AdventureWorksLT2022]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [SalesLT].[v_SalesPerformance] AS
WITH MainReport AS (
    SELECT 
        SalesLT.ProductCategory.Name AS CategoryName,
        ROUND(SUM(SalesLT.SalesOrderDetail.OrderQty * SalesLT.SalesOrderDetail.UnitPrice), 2) AS TotalCategorySales,
        CASE 
            WHEN SUM(SalesLT.SalesOrderDetail.OrderQty * SalesLT.SalesOrderDetail.UnitPrice) > 50000 THEN 'Excellent Performance'
            WHEN SUM(SalesLT.SalesOrderDetail.OrderQty * SalesLT.SalesOrderDetail.UnitPrice) BETWEEN 10000 AND 50000 THEN 'Average Performance'
            ELSE 'Weak Performance'
        END AS PerformanceStatus
    FROM SalesLT.Product
    JOIN SalesLT.ProductCategory ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID
    JOIN SalesLT.ProductModel ON SalesLT.Product.ProductModelID = SalesLT.ProductModel.ProductModelID
    JOIN SalesLT.SalesOrderDetail ON SalesLT.Product.ProductID = SalesLT.SalesOrderDetail.ProductID
    JOIN SalesLT.SalesOrderHeader ON SalesLT.SalesOrderDetail.SalesOrderID = SalesLT.SalesOrderHeader.SalesOrderID
    WHERE MONTH(SalesLT.SalesOrderHeader.OrderDate) = 6 
      AND YEAR(SalesLT.SalesOrderHeader.OrderDate) = 2008
    GROUP BY SalesLT.ProductCategory.Name
)
SELECT CategoryName, TotalCategorySales, PerformanceStatus 
FROM MainReport;
GO
```
📐 Phase 2: Data Modeling & DAX Measures (Power BI)
🔹 Data Modeling Strategy
The transformed data from the SQL View was loaded into Power BI. To maintain a clean, scalable, and professional data model, all analytical calculations were isolated into a dedicated _Measures table.

🔹 Core DAX Measures Built
Advanced DAX functions were utilized to calculate dynamic market share and total revenues that respond smoothly to dashboard filters:

Total Revenue: Computes the total revenue generated across the selected categories, displaying a total of 714.00K ر.س on the executive cards.
```dax
Code snippet
Total Revenue = SUM('SalesLT v_SalesPerformance'[TotalCategorySales])
```
Total Sales (All Categories): Utilizes CALCULATE combined with ALL to bypass visual filters, securing the absolute grand total for percentage distribution calculations.
```dax
Code snippet
Total Sales (All Categories) = CALCULATE([total revenue], ALL('SalesLT v_SalesPerformance'))
```
Category Contribution (%): Measures the specific market share or contribution of a performance class or category relative to the total enterprise revenue, using a safe DIVIDE function to prevent division-by-zero errors.
```dax
Code snippet
Category Contribution % = DIVIDE([total revenue], [Total Sales (All Categories)])
```
🎨 Phase 3: Dashboard Design & UX Strategy
The executive dashboard was crafted with a tailored Dark Mode Theme to provide a high-contrast, modern aesthetic that ensures visual comfort during extended analytical reviews.

Category Sales Breakdown: A clean horizontal bar chart ranks categories (led by Touring Bikes at 221K ر.س), allowing executive users to instantly spot top revenue drivers without label truncation.

Sales by Performance Class: A dynamic Donut Chart visualizes the enterprise market share, highlighting that the Average Performance tier dominates the monthly sales mix at 76.92%.

Interactive Slicers: A PerformanceStatus filter is positioned at the top right, enabling stakeholders to instantly drill down into specific performance clusters.
