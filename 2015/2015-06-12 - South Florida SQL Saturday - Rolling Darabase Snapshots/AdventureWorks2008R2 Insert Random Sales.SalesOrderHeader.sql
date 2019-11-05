/*
PURPOSE: I couldn't find any samples to insert orders into AdventureWorks, so made this one.
Note that it doesn't create the SalesOrderDetail records, 
and only adds foreign key values for existing customers, credit cards, etc.
It doesn't create any other related records.
AUTHOR: David Cobb (sql@davidcobb.net)
SOURCE: https://github.com/dave-007/MSSQL-Rolling-DB-Snapshots

*/
USE [AdventureWorks2008R2]
INSERT INTO [Sales].[SalesOrderHeader]
           ([RevisionNumber]
           ,[OrderDate]
           ,[DueDate]
           ,[ShipDate]
           ,[Status]
           ,[OnlineOrderFlag]
           ,[PurchaseOrderNumber]
           ,[AccountNumber]
           ,[CustomerID]
           ,[SalesPersonID]
           ,[TerritoryID]
           ,[BillToAddressID]
           ,[ShipToAddressID]
           ,[ShipMethodID]
           ,[CreditCardID]
           ,[CreditCardApprovalCode]
           ,[CurrencyRateID]
           ,[SubTotal]
           ,[TaxAmt]
           ,[Freight]
           ,[Comment]
           ,[rowguid]
           ,[ModifiedDate])
--SEE new record
OUTPUT inserted.*                 
     VALUES
           (1
           ,getdate()
           ,dateadd(d,CEILING(RAND() * 7),getdate())
           ,NULL
           ,0
           ,1
           ,CAST(CEILING(RAND() * 9999999) AS INT)
           ,CAST(CEILING(RAND() * 999999) AS INT)
           ,(SELECT TOP 1 CustomerID FROM Sales.Customer ORDER BY newid())
           ,(SELECT TOP 1 BusinessEntityID FROM Sales.SalesPerson ORDER BY newid())
           ,(SELECT TOP 1 TerritoryID FROM Sales.SalesTerritory ORDER BY newid())
           ,(SELECT TOP 1 AddressID FROM Person.Address ORDER BY newid())
           ,(SELECT TOP 1 AddressID FROM Person.Address ORDER BY newid())
           ,(SELECT TOP 1 ShipMethodID FROM Purchasing.ShipMethod ORDER BY newid())
           ,(SELECT TOP 1 CreditCardID FROM Sales.PersonCreditCard ORDER BY newid())
           ,left(cast(newid() as varchar(255)),15)
           ,(SELECT TOP 1 CurrencyRateID FROM Sales.CurrencyRate ORDER BY newid())
           ,CAST(CEILING(RAND() * 99999999) AS INT)
           ,CAST(CEILING(RAND() * 9999) AS INT)
           ,CAST(CEILING(RAND() * 99999) AS INT)
           ,'Automated Order'
           ,newid()
           ,GETDATE())

  
GO


/*
SELECT TOP 100 *
FROM [AdventureWorks2008R2].[Sales].[SalesOrderHeader]
ORDER BY OrderDate DESC
*/