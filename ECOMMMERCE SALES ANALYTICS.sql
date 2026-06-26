-- SQL PROJECT TITLE --
-- ECOMMMERCE SALES ANALYTICS --

CREATE DATABASE EcommerceAnalytics;
USE EcommerceAnalytics;


-- Define Tables
-- Expense table
CREATE TABLE Expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE,
    received_amount DECIMAL(10,2),
    expense_item VARCHAR(100),
    expense_amount DECIMAL(10,2)
);

-- WarehouseCosts table
CREATE TABLE WarehouseCosts (
    cost_id INT PRIMARY KEY AUTO_INCREMENT,
    service_type VARCHAR(100),
    shiprocket_cost DECIMAL(10,2),
    increff_cost DECIMAL(10,2)
);

-- ProductCatalog Table(May2022 and P-LMarch2021)
CREATE TABLE ProductCatalog (
    sku VARCHAR(50) PRIMARY KEY,
    style_id VARCHAR(50),
    catalog VARCHAR(50),
    category VARCHAR(50),
    weight DECIMAL(5,2),
    tp DECIMAL(10,2),          -- Transfer Price
    mrp DECIMAL(10,2),         -- Market Retail Price
    ajio_mrp DECIMAL(10,2),
    amazon_mrp DECIMAL(10,2),
    flipkart_mrp DECIMAL(10,2),
    myntra_mrp DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    sku VARCHAR(50),
    platform VARCHAR(50),      -- e.g., Amazon, Flipkart
    sale_date DATE,
    quantity INT,
    sale_price DECIMAL(10,2),
    FOREIGN KEY (sku) REFERENCES ProductCatalog(sku)
);

-- Insert Data
-- Expenses
INSERT INTO Expenses (date, received_amount, expense_item, expense_amount) VALUES
('2022-06-19', 1000, 'Large Bag', 380),
('2022-06-20', 1500, 'Stationary', 170),
('2022-06-22',500,'OLA',839),
('2022-06-23',2000,'Auto Rent',520);

select * from expenses;

-- Warehouse Costs
INSERT INTO WarehouseCosts (service_type, shiprocket_cost, increff_cost) VALUES
('Inbound', 4.00, 4.00),
('Outbound', 7.00, 11.00),
('Storage Fee/Cft', 25.00, 0.15),
('Customer Return with QC',	6.00,15.50);

select * from warehousecosts;

-- Product Catalog
INSERT INTO ProductCatalog VALUES
('Os206_3141_S', 'Os206_3141', 'Moments', 'Kurta', 0.3, 538, 2295, 2295, 2295, 2295, 2295),
('Os181_5051_M','Os181_5051','Colors-8','Kurta',0.3	,438, 1895, 1895, 1895, 1895, 1895),
('Os228_1432_L','Os228_1432','Rozana',' KurtaSet',	0.4 , 590, 2495, 2495, 2495	, 2495, 2495);

select*from productcatalog;

-- Sales
INSERT INTO Sales (sku, platform, sale_date, quantity, sale_price) VALUES
('Os206_3141_S', 'Amazon', '2022-05-15', 2, 2295),
('Os206_3141_S', 'Flipkart', '2022-05-20', 1, 2295),
('Os181_5051_M','Myntra','2022-05-25',3,1895),
('Os228_1432_L','Ajio','2022-06-01',1,2495);

select * from sales;

-- SQL QUERIES --
-- 1.List all expense items recorded in June 2022.
Select expense_item,expense_amount
from expenses
where month(date)=6 and year(date)=2022;

-- 2.Show all warehouse services where Shiprocket cost is greater than Increff cost.
SELECT service_type, shiprocket_cost, increff_cost
FROM WarehouseCosts
WHERE shiprocket_cost > increff_cost;

-- 3.Retrieve all products in the catalog with MRP greater than 2000.
SELECT sku, style_id, catalog, category, mrp
FROM ProductCatalog
WHERE mrp > 2000;

-- 4.Calculate the total expenses grouped by expense item.
select expense_item,sum(expense_amount) as TotalExpenses
from expenses
group by expense_item;

-- 5.Find the average sale price of products sold on Flipkart.
select AVG(sale_price) as AvgFlipkartPrice
from sales
where platform = 'Flipkart';

-- 6.Show the top 3 SKUs with highest sales revenue.
select sku,sum(quantity*sale_price) as TotalRevenue
from sales
group by sku
order by TotalRevenue desc
limit 3;

-- 7.Compare Shiprocket vs Increff costs for outbound services.
SELECT service_type, shiprocket_cost, increff_cost,
       (shiprocket_cost - increff_cost) AS CostDifference
FROM WarehouseCosts
WHERE service_type = 'Outbound';

-- 8.Find customers (SKUs) that were sold on multiple platforms
SELECT sku, COUNT(DISTINCT platform) AS PlatformsSold
FROM Sales
GROUP BY sku
HAVING COUNT(DISTINCT platform) > 1;

-- 9.Calculate the profit margin for each product:
select sku,category,(mrp-tp) as ProfitMargin
from productcatalog;

-- 10.Find the platform contributing the highest revenue overall
select platform,SUM(quantity*sale_price) as TotalRevenue
from sales
group by platform
order by TotalRevenue desc
limit 1;

-- 11. Show the month-wise sales trend.
select date_format(sale_date,'%y-%m') as Month,SUM(quantity*sale_price) as MonthlyRevenue
from sales
group by month
order by month;

-- 12.Rank SKUs by total revenue contribution using RANK().
SELECT sku,
       SUM(quantity * sale_price) AS TotalRevenue,
       RANK() OVER (ORDER BY SUM(quantity * sale_price) DESC) AS RevenueRank
FROM Sales
GROUP BY sku;



