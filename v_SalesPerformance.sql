USE [AdventureWorksLT2022]
GO

/****** Object:  View [SalesLT].[v_SalesPerformance]    Script Date: 6/6/2026 01:06:40 م ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 🌟 أمر الحفظ السحري
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

