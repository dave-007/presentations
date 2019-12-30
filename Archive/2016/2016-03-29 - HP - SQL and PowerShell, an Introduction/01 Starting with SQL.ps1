#See modules that are currently installed
Get-Module

#See providers currently installed
Get-PSProvider

#See modules that are available, must be in a folder defined in $env:PSModulePath
$env:PSModulePath
Get-Module -ListAvailable | Out-GridView
#See available SQL modules
Get-Module -ListAvailable -Name *SQL* | Out-GridView


#SQLPS contains all the Cmdlets for SQL and SSAS, and loads the SMO Assemblies
#Bug if Azure Cmdlets are installed, you'll get warnings
Import-Module SQLPS



#What .Net Types have been added for SQLPS?
$assemblies = [appdomain]::CurrentDomain.GetAssemblies()

$assemblies | Select-Object FullName |
Where-Object -Property FullName -like "*SQL*" |  
Sort-Object FullName | Out-GridView

#SMO Assemblies are documented on MSDN
#SMO Object Reference https://msdn.microsoft.com/en-us/library/mt571730.aspx
#SMO Object Model Diagram https://msdn.microsoft.com/en-us/library/ms162209.aspx
#Most useful namespace? Microsoft.SqlServer.Management.Smo https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.aspx

#Can also add the SMO assemblies individually if needed
Add-Type -Path "C:\Program Files\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"


Get-Module

Get-Command -Module SQLASCMDLETS

Get-Command -Module SQLPS

#Using a SQL Cmdlet
Backup-SqlDatabase -Database db1 -ServerInstance DGEM -BackupFile "D:\SQLBackup\db1_$(get-date -f yyyy-MM-dd-hh-mm-ss).bak"
explorer D:\SQLBackup\

#Using Show-Command to provide a GUI for a Cmdlet, use 'By Name' parameter set
Show-Command Backup-SqlDatabase

#Using the SQL Provider
Get-PSProvider
#Compare to Start PowerShell from SSMS
Set-Location SQLSERVER:
Set-Location -Path "\SQL\DGEM\DEFAULT\Databases\AdventureWorks2014"
Get-ChildItem -Path tables


#create your server instance
$instanceName = 'DGEM'
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#see all server properties
$server | Get-Member -MemberType Property | Out-GridView


#See server property values
$server | Select-Object  "Version"
$server | Select-Object  "Edition"
$server | Select-Object * 

#only SMO properties
$smoProperties = $server |
Get-Member -MemberType "Property" |
Where-Object Definition -Like "*Smo*"
$smoProperties

#in grid
$smoProperties  | Out-GridView

#see all server methods
$server | Get-Member -MemberType Method | Out-GridView

#see database SMO properties
$server.Databases["AdventureWorks2014"].Tables |
Get-Member -MemberType "Property" |
Where-Object Definition -Like "*Smo*"