/* 
			 tutorial examples     
										 */
--             **  PIVOT  **
SELECT menu_item_id, item_name, American, Asian
FROM menu_items m 
PIVOT
 ( 
   AVG(price) FOR category IN (American, Asian)
 ) AS test

 --       
SELECT * FROM(
 SELECT menu_item_id, item_name, MONTH(order_date)AS SaleMonth, price FROM menu_items m
 JOIN order_details o
 ON m.menu_item_id = o.item_id) AS one
PIVOT (
    SUM(price)
    FOR SaleMonth IN ([1], [2], [3])) AS PivotTable
	ORDER BY [1] DESC, [2] DESC, [3] DESC;

SELECT * FROM (SELECT order_id, menu_item_id, item_name, category,MONTH(order_date)AS SalesMonth FROM menu_items m
JOIN order_details o
ON m.menu_item_id = o.item_id) one
PIVOT(
	COUNT (order_id) FOR SalesMonth IN([1],[2],[3])
) AS PivotTable
ORDER BY [1] DESC, [2] DESC, [3] DESC;

SELECT * FROM (SELECT order_id, menu_item_id, item_name,category FROM menu_items m
JOIN order_details o
ON m.menu_item_id = o.item_id) one
PIVOT(
	count(order_id) FOR category IN(Mexican,American,Asian,Italian)
) AS PivotTable
ORDER BY Mexican DESC, American DESC, Asian DESC, Italian DESC


--             **  unpivot  **

SELECT * FROM (SELECT order_id, order_details_id, CAST(price AS int)price FROM menu_items m
JOIN order_details o
ON m.menu_item_id = o.item_id) jo
UNPIVOT(
	salesAmount FOR details IN(order_details_id, order_id, price)
) AS PivotTable


/*      
				" TREGGERS "
										*/
CREATE TRIGGER updatee 
	ON order_details AFTER INSERT
	AS
	BEGIN 
	DECLARE @OrderDetailsID INT; DECLARE @OrderID INT; DECLARE @OrderDate DATE; DECLARE @OrderTIME TIME; DECLARE @ItemID INT;
	 DECLARE @LogMessage NVARCHAR(MAX);

	SELECT @LogMessage = 'New order inserted: orderID = ' + order_details_id + ', order_id = ' + order_id + ', date = ' + CONVERT(date, order_date) 
	+ ', time = ' + CONVERT(time, order_time +', item id' + item_id FROM inserted;

	END

insert into order_details (order_details_id, order_id, order_date, order_time, item_id) VALUES(12235,5371,'3/31/2023','10:16:50 PM',104)

CREATE TRIGGER UpdateOrderLogd
ON order_details
AFTER INSERT
AS
BEGIN
    -- Inserting into the log table
    INSERT INTO ordorder_details (orderdetailsid, OrderID, OrderDate, ordertime, itemid)
    SELECT order_details_id, order_id, order_date, order_time, item_id
    FROM inserted;
END;

CREATE TRIGGER InsertTriggerrs
ON order_details
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables to store inserted values
    DECLARE @OrderDetailsId INT,
		    @OrderID INT,
            @OrderDate DATE,
            @OrderTime TIME,
            @ItemID INT;

    -- Get the inserted values using SELECT INTO
    SELECT @OrderDetailsId = order_details_id,
		   @OrderID = order_id,
           @OrderDate = order_date,
           @OrderTime = order_time,
           @ItemID = item_id
    FROM inserted;

    -- Insert into the log table
    INSERT INTO order_log (OrderDetailsId, OrderID, OrderDate, OrderTime, ItemID)
    VALUES (@OrderDetailsId, @OrderID, @OrderDate, @OrderTime, @ItemID);
END;

CREATE TABLE order_log (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    OrderDate DATETIME,
    OrderTime TIME,
    ItemID INT
);

SELECT * FROM order_log;