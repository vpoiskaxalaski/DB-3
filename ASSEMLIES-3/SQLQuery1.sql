USE publishing;
GO
sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
sp_configure 'clr enabled', 1;  
GO
sp_configure 'clr strict security', 0;
GO  
RECONFIGURE;   
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'hello')  
   drop procedure hello 
GO
IF EXISTS (SELECT name FROM sys.assemblies WHERE name = 'helloworld')  
   drop assembly helloworld  
GO
GO  
CREATE ASSEMBLY helloworld from 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\helloworld.dll' WITH PERMISSION_SET = SAFE;
GO 
CREATE PROCEDURE hello  
@value1 datetime,
@value2 datetime 
AS  
EXTERNAL NAME helloworld.HelloWorldProc.PriceSum   
GO

DECLARE 
@J1 datetime = '2017-05-23T14:25:10',
@J2 datetime = '2018-05-23T14:25:10' 
EXEC dbo.hello @J1, @J2  


---------MyType-------
CREATE ASSEMBLY getMyType FROM 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\MyType.dll' WITH PERMISSION_SET = SAFE  
GO
DROP ASSEMBLY getMyType;
GO
CREATE TYPE myString
EXTERNAL NAME getMyType.[LPLab03.MyType];
GO
DECLARE @s myString
SET @s = 'г. Минск ул. Белорусская д. 22'
SELECT @s.ToString();


GO

SELECT SoldBooks.book_id AS 'BOOK', SUM(SoldBooks.nbook) AS  COUNT FROM SoldBooks GROUP BY SoldBooks.book_id; 
 
GO

-- Pivot table with one row and 7 columns  
SELECT 'COUNT' AS Count_Sorted_By_Order_Data,   
[1], [2], [3], [4], [5], [6], [7]
FROM  
(SELECT book_id, nbook   
    FROM SoldBooks where order_data between '2017-05-23T14:25:10' and '2018-05-23T14:25:10' ) AS SourceTable  
PIVOT  
(  
SUM(nbook)  
FOR book_id IN ([1], [2], [3], [4], [5], [6], [7])  
) AS PivotTable;