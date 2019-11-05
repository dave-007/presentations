#Simple SQL Query using Invoke-SqlCmd
#awkward to have queries in parameters
Invoke-Sqlcmd -ServerInstance DGEM -Database AdventureWorks2014 -Query "SELECT TOP 100 [ProductID]
      ,[Name]
      ,[StandardCost]
      ,[ListPrice]
      ,[ModifiedDate]
  FROM [AdventureWorks2014].[Production].[Product]" 

#Queries and long text values are better stored in 'here strings', wrapped in @ signs
$query = @"
SELECT TOP 100 [ProductID]
      ,[Name]
      ,[StandardCost]
      ,[ListPrice]
      ,[ModifiedDate]
  FROM [AdventureWorks2014].[Production].[Product]
"@
Invoke-Sqlcmd -ServerInstance DGEM -Database AdventureWorks2014 -Query $query
#Capture the query result
$result = Invoke-Sqlcmd -ServerInstance DGEM -Database AdventureWorks2014 -Query $query
$result
$result.Count
$result | Format-Table
$result | Out-GridView
$result | Get-Member

#You want it in Excel?
$result | Export-CSV -Path "$env:TEMP\result.csv"  -Force -NoTypeInformation
Invoke-Expression "$env:TEMP\result.csv"

