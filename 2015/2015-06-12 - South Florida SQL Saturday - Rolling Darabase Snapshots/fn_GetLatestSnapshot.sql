/*
PURPOSE:
This function returns the latest snapshot for the given database.
Returns null of no snapshots exist for the given database.
AUTHOR:	David Cobb (sql@davidcobb.net)
SOURCE: https://github.com/dave-007/MSSQL-Rolling-DB-Snapshots
USAGE:
SELECT dbo.fn_GetLatestSnapshot('AdventureWorks2008R2')
*/
USE master
GO
IF EXISTS(SELECT * FROM sys.objects WHERE type_desc LIKE '%FUNCTION%' and name = 'fn_GetLatestSnapshot')
	DROP FUNCTION fn_GetLatestSnapshot 
GO
CREATE FUNCTION fn_GetLatestSnapshot 
(
	-- Add the parameters for the function here
	@sourceDatabase sysname
)
RETURNS sysname
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result sysname

	SELECT TOP 1 @Result = name FROM sys.databases
	WHERE source_database_id = DB_ID(@sourceDatabase)
	ORDER BY create_date DESC

	RETURN @Result

END
GO


