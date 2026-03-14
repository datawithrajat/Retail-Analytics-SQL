--  ==================================== Retail_Analytics =============================================== 
Use retail_analytics;
show tables;
-- =======================================Cleaning Dataset=================================================
-- 1) Renaming Tables
Alter table customer_profiles
Rename to Customers;

Alter table product_inventory
rename to Products;

Alter table sales_transaction
rename sales; 

-- ==========================================Reading All Datasets===============================================
select * from customers;  -- ï»¿CustomerID
select * from products; -- ï»¿ProductID
Select * from sales;    -- ï»¿TransactionID

-- ï»¿CustomerID > CustomerID 
-- ï»¿ProductID > ProductID
-- ï»¿CustomerID > CustomerID

Alter table Customers
Change ï»¿CustomerID Customerid INT;

Alter table products
Change ï»¿ProductID ProductID INT;

Alter table sales
Change ï»¿TransactionID TransactionID INT;

-- ===================================== Challenge 1 Looking for duplicate and removing them ===============================================================
Select
Count(*)
From sales
Group by TransactionID
having Count(*) > 1; -- 5002

Create Table UniqueSales AS
Select distinct * from Sales; -- 5000

Drop table sales;

Alter Table uniquesales
Rename to Sales;

Select * from sales;

-- ================================================== Challenge 2 update those discrepancies to match the price in both the tables.==============
Select * from sales;
Select * from products;

Select
      s.transactionid,
      s.price AS TransactionPrice,
      p.price AS InventroyPrice
      from sales s 
      join products p 
      On p.productId = s.productid
      Where s.price <> p.price;
      
      Update sales s 
      Set Price = (
      Select
           p.price from products p 
           Where s.productid = p.productid
           )
		Where ProductID IN (
        Select 
             productID FROM Products p 
             Where p.price <> s.price
      );
      Set sql_safe_updates = 0;
Select * from sales;

-- =======================================Challenge 3 Updating Null Values ==============================
Select
      Count(*)
from  Customers
Where Location like "";

Update customers
Set Location = "Unknown"
Where Location like "";

Select * from customers;

-- ======================================== Chalenge 4 Updating Text to Date =============================================
Desc sales;
Create Table Sales_update AS 
Select 
      *,
      Str_to_date(TransactionDate, '%d/%m/%y') AS transactionDate_updated
      from sales;

Drop table Sales;

Alter table Sales_update
Rename sales;

Select * from sales;

-- ===========================    Challenge 5 Summarize the table==============================================
Select 
      ProductID,
      Sum(QuantityPurchased) AS TotalUnitSold,
      Round(Sum(QuantityPurchased * Price),2) AS TotalSales
      From Sales
      Group By ProductID
      Order By TotalSales desc;
      
-- ========================== Challenge 6 number of transactions =============================================

Select 
      CustomerID,
      Count(TransactionID) AS NumberOfTransactions
      From sales
      Group by CustomerID
      Order By Numberoftransactions desc;
      
-- ==============================Challenge 7 performance of the product categories based on the total sales ==============
desc products;
Desc sales;

Select 
      p.category,
      Sum(s.QuantityPurchased) TotalUnitSold,
      Sum(s.QuantityPurchased * s.Price) TotalSales
      From Products p 
      Left Join sales s
      On p.productid = s.productid
      Group by p.category
      Order by totalSales desc;
      
-- ========================================Challenge 8 top 10 products with the highest total sales =========================

Select
      ProductID,
      Sum(QuantityPurchased * Price) AS TotalRevenue
      from sales
      Group by ProductID
      Order by TotalRevenue desc
      Limit 10;

-- =============================Challenge 9 Least amount of unit sold===============================================
Select 
ProductID,
Sum(QuantityPurchased) AS TotalUnitsSold
from sales
Group by ProductID
Order by TotalUnitsSold Asc
Limit 10;     

-- ============================ Challenge 10 sales trend to understand the revenue pattern of the company===========

Select
TransactionDate_updated AS DATETRANS,
Count(TransactionID) Transaction_count,
Sum(QuantityPurchased) TotalUnits_Sold,
Sum(QuantityPurchased * Price) as TotalSales
from sales
group by DATETRANS
Order by DATETRANS DESC;

-- =================================== Challenge 11 month on month growth rate =======================================

With Newtable AS (
Select 
Extract(Month From TransactionDate_Updated) AS Month,
Round(Sum(QuantityPurchased * Price),2) AS Total_sales
From sales
Group by Month),
Newtable2 AS (
Select 
     Month,
     Total_sales,
     Lag(Total_sales) OVer(Order by Month) AS previous_month_sales
     From Newtable)
Select
     Month,
     Total_sales,
     previous_month_sales,
     Round(((Total_sales - previous_month_sales)/previous_month_sales * 100),2) AS mom_growth_percentage
     from Newtable2;
     
-- ================================== Chalenge 12 number of transaction along with the total amount spent by each customer transactions more than 10 and TotalSpent more than 1000 
Desc customers;

Select 
     c.customerID,
     Count(s.TransactionID) AS NumberOfTransactions,
     Round(Sum(s.QuantityPurchased * s.price),2) AS TotalSpent
     from Customers c 
     Join sales s 
     On s.customerid = c.customerid
     Group by c.customerid
     Having NumberofTransactions > 10 and TotalSpent > 1000
     Order by TotalSpent desc;
     
-- ==================================Chalenge 13 help us understand the customers who are occasional customers or have low purchase frequency===

Select 
      CustomerID,
      Count(TransactionID) AS NumberOfTransactions,
     Round(Sum(QuantityPurchased * price),2) AS TotalSpent
     from sales
     Group by CustomerID
     Having Numberoftransactions <=2
     Order by NumberofTransactions Asc, TotalSpent desc;
     
-- ==========================================Chalenge 14 describes the total number of purchases made by each customer against each productID

Select 
      CustomerID,
      ProductID,
      Count(TransactionID) As TimesPurchased
      from sales
      Group by CustomerID, ProductID
      Having Timespurchased <> 1
      Order by TimesPurchased desc;
      
-- Challenge 15 duration between the first and the last purchase of the customer in that particular company -------

With newtable AS(
Select
      CustomerID,
      Min(transactiondate_updated) AS FirstPurchase,
      Max(transactiondate_updated) AS LastPurchase
      from Sales
      Group by CustomerID)
Select
      CustomerID,
      FirstPurchase,
      LastPurchase,
      Datediff(LastPurchase, Firstpurchase) AS DaysBetweenPurchases
      from Newtable
      Having DaysBetweenPurchases >0
      Order By DaysBetweenPurchases desc;
      
-- =================================== Challenge 16  segments customers based on the total quantity of products they have purchased. 
-- > 1-10 -Low
-- > 11- 30 Mid
-- > 30 High

With Newtable AS (
Select
      c.CustomerID,
      COALESCE(Sum(s.quantityPurchased),0) AS NumberofQuantity
      From      customer_profiles c                  
      Join  sales_transaction s 
      on s.customerid = c.customerid
      Group by CustomerID),
Newtable2 AS (
Select 
      CustomerID,
      Case
      When NumberofQuantity Between 1 and 10 Then "Low"
      When NumberofQuantity Between 11 AND 30 Then "Med"
	  When NumberofQuantity > 30 Then "High"
      END AS CustomerSegment
      from Newtable)
Select
     CustomerSegment,
      Count(*)
     From NewTable2
     Group by CustomerSegment;
      
