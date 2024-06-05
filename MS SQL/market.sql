

-- checking doblicate
SELECT Itemname, BillNo, COUNT(*)
FROM market
GROUP BY Itemname, BillNo
HAVING COUNT(*) > 1;  

-- info & details 
SELECT  
	SUM(Price * Quantity) AS TotalSales,
	SUM(Quantity) AS TotalQuantitySold,
	AVG(Price) AS avg_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM market

-- highest billno for each item in marcket
SELECT *
FROM market x 
WHERE Price >= ALL(SELECT Price FROM market y WHERE x.Itemname = y.Itemname) 
ORDER BY Quantity

-- case 
WITH ranked_names AS (
    SELECT 
        Itemname, 
        ROW_NUMBER() OVER (PARTITION BY LEFT(Itemname, 1) ORDER BY Itemname) as rn
    FROM market
        
)
SELECT 
    *
FROM 
    ranked_names
WHERE 
    rn = 1;

-- the most trend in our products
SELECT Itemname ,COUNT(BillNo) events_number, SUM(Quantity) orders_qty, SUM(Price) price FROM (SELECT * FROM market X 
WHERE Price >= ALL(SELECT Price FROM market Y WHERE X.BillNo = Y.BillNo)) h
GROUP BY Itemname
ORDER BY events_number DESC

-- the highest bill price
SELECT CustomerID, Price, STRING_AGG(Itemname, ', '),SUM(Quantity) 
FROM market 
WHERE Price >= (SELECT MAX(Price) FROM market)
GROUP BY CustomerID, Price, Itemname

-- the customers highest price with aggrigate the items
SELECT CustomerID, STRING_AGG(Itemname, ', ') AS total_items_per_customer, SUM(Price), SUM(Quantity) 
FROM market x
GROUP BY CustomerID
ORDER BY CustomerID

SELECT CustomerID, COUNT(*)
FROM market
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- each bill items
SELECT BillNo, STRING_AGG(Itemname, ', ') AS ItemNames
FROM market
GROUP BY BillNo;

--2
SELECT * FROM (SELECT Price, BillNo, Itemname FROM market) ONE
PIVOT(
	COUNT(BillNo) FOR Itemname IN (Apples,Butter,Cereal,Cheese,Chicken,Coffee,Eggs,Juice,Milk,Onions,Oranges,Pasta,Potatoes,Sugar,Tea,Tomatoes,Yogurt)
) AS PivotTable;


SELECT 
    Itemname,
    COUNT(*) AS frequency,
    SUM(Quantity) AS total_quantity,
    SUM(Price * Quantity) AS total_sales
FROM market
GROUP BY Itemname
ORDER BY total_sales DESC;

SELECT 
    CustomerID,
    COUNT(DISTINCT BillNo) AS num_transactions,
    SUM(Price * Quantity) AS total_spent
FROM market
GROUP BY CustomerID
ORDER BY total_spent DESC;

SELECT 
    item1.Itemname AS item1,
    item2.Itemname AS item2,
    COUNT(*) AS frequency
FROM market item1
JOIN market item2 ON item1.BillNo = item2.BillNo AND item1.Itemname < item2.Itemname
GROUP BY item1.Itemname, item2.Itemname
ORDER BY frequency DESC;

SELECT 
    SUM(Price * Quantity) AS total_sales,
    AVG(Price * Quantity) AS avg_order_value
FROM market;

SELECT 
    CustomerID,
	SUM(Quantity) QTY,
    SUM(Price * Quantity) AS total_spent,
    COUNT(DISTINCT BillNo) AS num_transactions,
    AVG(Price * Quantity) AS avg_order_value
FROM market
GROUP BY CustomerID;