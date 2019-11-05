#For SQL2008R2 load the PSSnapin
#For SQL2012 and later, use Import-Module SQLPS instead
if (!(Get-PSSnapin -Name SQLServerCmdletSnapin100 -ErrorAction SilentlyContinue)) {

   Add-PSSnapin SQLServerCmdletSnapin100
}

#Get name of latest database snaphost
$result = Invoke-Sqlcmd -Database master -ServerInstance 'SQL2008R2-ONE' -Query "SELECT dbo.fn_GetLatestSnapshot('AdventureWorks2008R2')"
$latestSnapshotName = $result.Column1
Write-Output "Latest snapshot is $latestSnapshotName"



$orderQuery = @"
SELECT TOP 5 * 
FROM Sales.SalesOrderHeader 
ORDER BY SalesOrderID DESC
"@


#Get latest orders from production
Write-Output "Retrieving latest orders from production as of $(Get-Date)..."
$latestProductionOrderResult = Invoke-Sqlcmd -Database 'AdventureWorks2008R2' -ServerInstance 'SQL2008R2-ONE\INSTANCE2' -Query $orderQuery
$latestProductionOrderResult | Select-Object SalesOrderID, OrderDate |  Format-Table
#$latestOrderResult | Out-GridView

#Get latest orders from snapshot
Write-Output "Retrieving latest orders from latest reporting snapshot $latestSnapshotName as of $(Get-Date)..."
$latestReportingSnapshotOrderResult = Invoke-Sqlcmd -Database $latestSnapshotName -ServerInstance 'SQL2008R2-ONE' -Query $orderQuery
$latestReportingSnapshotOrderResult | Select-Object SalesOrderID, OrderDate |  Format-Table
#$latestOrderResult | Out-GridView
