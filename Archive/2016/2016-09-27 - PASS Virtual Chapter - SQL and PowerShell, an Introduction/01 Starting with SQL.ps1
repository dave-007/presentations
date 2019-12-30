#Note: I have SQL 2014 SP1 and SQL 2016 installed for this demo
#See modules that are currently installed
Get-Module

#See providers currently installed
Get-PSProvider
#A Windows PowerShell provider allows any data store to be exposed like a file system as if it were a mounted drive.
#examples
Get-ChildItem HKCU:\Console
Get-ChildItem Variable:
Get-ChildItem Env:
#See modules that are available, must be in a folder defined in $env:PSModulePath
$env:PSModulePath
Get-Module -ListAvailable | Out-GridView
#See available SQL modules
Get-Module -ListAvailable -Name *SQL* | Out-GridView


#SQLPS contains all the Cmdlets for SQL and SSAS, and loads the SMO Assemblies
#Bug if Azure Cmdlets are installed, you'll get warnings
#This is the SQL 2014 version
Import-Module SQLPS
#Notice some issues:
# slow
# warnings on 'non approved verbs'
#conflicts with SQL Azure PowerShell Modules
# changes shell location to PS SQLSERVER:\ NO OTHER MODULE DOES THIS EVER!
# fix that!
Set-Location "C:"
Get-Command -Module SQLPS
#it's an array of objects, so I can use methods that work on arrays
(Get-Command -Module SQLPS).Count
Remove-Module SQLPS


#SQL 2016 has an updated SQLPS with improvements
#using the FullyQualifiedName to differentiate from the SQL 2014 version
#adding -Verbose parameter to see what's happening under the hood
Import-Module -Verbose -FullyQualifiedName "C:\Program Files (x86)\Microsoft SQL Server\130\Tools\PowerShell\Modules\SQLPS" 
# fast
# better warning
# leaves location alone
# community requested changes and they listened!

# get the command names from this module and store them in a variable
$SQLPSCommands = Get-Command -Module SQLPS | Select Name
$SQLPSCommands| Out-Gridview
($SQLPSCommands).Count #same as before
#Remove-Module SQLPS

#Also have module for SQL Analysis Services
Get-Module
Get-Command -Module SQLASCMDLETS




#New SQL PowerShell Module, SQLServer
#Future SQL PowerShell improvements will be in this module
<#
#address a bug I'm having with SQLServer Module

Import-Module : The following error occurred while loading the extended type data 
file: Error in TypeData "Microsoft.SqlServer.Management.Smo.NamedSmoObject": The 
member DefaultKeyPropertySet is already present.

Remove-TypeData "Microsoft.SqlServer.Management.Smo.NamedSmoObject"

#>
#import the new module
Import-Module SQLServer
$SQLServerCommands = Get-Command -Module SQLServer | Select Name
$SQLServerCommands | Out-GridView
($SQLServerCommands).Count #48
Remove-Module SQLServer

#Difference between SQLPS and SQLServer module commands?
Compare-Object -ReferenceObject $SQLPSCommands -DifferenceObject $SQLServerCommands


#What .Net Types are used in SQLPS/SQLServer Modules?
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

#What SQL instances are running? Easiest way is to check the registry
(get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances

#Using a SQL Cmdlet
Backup-SqlDatabase -Database db1 -ServerInstance DGEM -BackupFile "D:\SQLBackup\db1_$(get-date -f yyyy-MM-dd-hh-mm-ss).bak"
explorer D:\SQLBackup\

#Using Show-Command to provide a GUI for a Cmdlet, use 'By Name' parameter set
Show-Command Backup-SqlDatabase
Backup-SqlDatabase -WhatIf -Database db2 -ServerInstance DGEM -BackupFile D:\SQLBackup\db2_20160928.bak

#Using the SQL Provider
Get-PSProvider
#Compare to Start PowerShell from SSMS
Set-Location SQLSERVER:
Set-Location -Path "\SQL\DGEM\DEFAULT\Databases\AdventureWorks2014"
Get-ChildItem -Path tables


#Use an SMO object
#create your server instance
$instanceName = 'DGEM'
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#see all server properties
$server | Get-Member -MemberType Property | Out-GridView


#See server property values
$server | Select-Object  "Version"
$server | Select-Object  "Edition"
#all properties, this takes a while
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