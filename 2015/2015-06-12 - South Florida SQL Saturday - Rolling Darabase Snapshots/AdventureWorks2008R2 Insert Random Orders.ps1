#For SQL2008R2 load the PSSnapin
#For SQL2012 and later, use Import-Module SQLPS instead
if (!(Get-PSSnapin -Name SQLServerCmdletSnapin100 -ErrorAction SilentlyContinue)) {

   Add-PSSnapin SQLServerCmdletSnapin100
}

#Get name of latest database snaphost
Write-Output "Inserting a new SalesOrderHeader record.."
$result = Invoke-Sqlcmd -ServerInstance 'SQL2008R2-ONE\INSTANCE2' -InputFile 'C:\scripts\AdventureWorks2008R2 INSERT RANDOM Sales.SalesOrderHeader.sql' -OutputSqlErrors $true -OutVariable $result
$result