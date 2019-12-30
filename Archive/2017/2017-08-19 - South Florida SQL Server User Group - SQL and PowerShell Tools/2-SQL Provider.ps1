break  #prevent F5


Import-Module -Name SQLServer
Get-PSProvider

#Navigate our SQL Server using the SQL Provider
Set-Location -Path SQLSERVER:
#See what aspects of SQL Server are available
Get-ChildItem

#Use absolute path
Set-Location -Path SQLSERVER:\SQL\
Get-ChildItem

Set-Location -Path SQLSERVER:\SQL\$($Env:COMPUTERNAME)
Get-ChildItem


#Use relative path
Set-Location -Path .\DEFAULT
#See what aspects of this instance are available
Get-ChildItem

#Database object types
Get-ChildItem -Path .\Databases\AdventureWorks2014
#Tables
Get-ChildItem -Path .\Databases\AdventureWorks2014\Tables
#Let's inspect one table
Get-ChildItem -Path .\Databases\AdventureWorks2014\Tables\HumanResources.Employee 
Get-ChildItem -Path .\Databases\AdventureWorks2014\Tables\HumanResources.Employee\columns

#Let's get that item as an object
$tableObject = Get-Item -Path .\Databases\AdventureWorks2014\Tables\HumanResources.Employee 
$tableObject | Get-Member
$tableObject | Get-Member | Select-Object -ExpandProperty TypeName -First 1
$tableObject | Get-Member -MemberType Property
$tableObject | Get-Member -MemberType Method

$tableObject | Get-Member
#It is a Microsoft.SqlServer.Management.Smo.Table object
#https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.table.aspx
#try the methods
$tableObject.Rebuild()
#try properties
$tableObject.Columns
$tableObject.Script()




#SQL Agent
Get-ChildItem -Path .\JobServer
Get-ChildItem -Path .\JobServer\Jobs

#Get a job object
$job = Get-ChildItem -Path .\JobServer\Jobs | Where-Object -Property Name -EQ 'Test Job'
$job | Get-Member

#work with job object
$job.Script()

#Cleanup
Set-Location C:\
Remove-Module -Name SQLServer