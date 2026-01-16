break  #prevent F5

#I'm using ISE Steroids
#http://www.powertheshell.com/isesteroids2-2/download/
#I'm extending PowerShell ISE with VariableExplorer
#https://gallery.technet.microsoft.com/PowerShell-ISE-VariableExpl-fef9ff01
Import-Module VariableExplorer.psm1

#Check PowerShell Version, using 5.1
$PSVersionTable

#See what SQL related modules are available on your machine
Get-Module -ListAvailable -Name *SQL*

#See modules loaded into your session
Get-Module

#SQLPS Module is deprecated, new development is in the SQLServer Module 

#Remove SQLPS from your session before using SQLServer module, they conflict!
Remove-Module -Name SQLPS

#SQLServer module is available from the PowerShellGet, via Package Management, formerly OneGet
#PowerShellGet is the Package Manager for PowerShell https://www.PowerShellGallery.com

#Good post on big picture of PowerShellGet:
#https://blogs.msdn.microsoft.com/mvpawardprogram/2014/10/06/package-management-for-powershell-modules-with-powershellget/
#Investigate PowerShellGet, update to latest if prompted
Get-Command -Module PowerShellGet
Get-PackageProvider
Get-InstalledModule
Find-Module SQL*

Remove-Module SQLPS
Install-Module -Name SQLServer -Force -Verbose  #May need -Force if previous version exists

<#
#Other module management commands
Get-Command -Noun Module
Import-Module -Name SQLServer
Remove-Module -Name SQLServer
Uninstall-Module -Name SQLServer
#>

Get-Module -ListAvailable -Name SQL*
#SQLServer Module is installed outside SQL Program Folders, separate releases
Get-Module -Name SQLServer | Select-Object -ExpandProperty ModuleBase -First 1

#Show loaded SQL assemblies
 [System.AppDomain]::CurrentDomain.GetAssemblies() | 
    Where-Object -Property ManifestModule -Like *SQL* |
      Select-Object -Property ManifestModule |
        Sort-Object -Property ManifestModule

$SQLServerCommands = Get-Command -Module SQLServer
$SQLServerCommands
$SQLServerCommands | Measure-Object

#More functionality is coming to SQLServer module in SQL vnext, check the Trello board!
#https://trello.com/b/NEerYXUU/powershell-sql-client-tools-sqlps-ssms


#explore some SQLServer Module commands, use a . for default instance, or .\INSTANCENAME for named instance
Get-Command -Module SQLServer -Verb Get
Get-Command -Module SQLServer -Noun *Avail*
Get-Help Add-SqlAvailabilityDatabase -Examples
Get-SqlDatabase -ServerInstance .
Get-SqlLogin -ServerInstance .\SQL2016
Get-SqlErrorLog -ServerInstance . -Since Yesterday
Get-SQLAgentJob -ServerInstance .

#These commands are returning collections of objects
Get-SQLAgentJob -ServerInstance . -Name 'Test Job' | Get-Member

#Cleanup
#Remove-Module -Name SQLPS
Remove-Module -Name SQLServer


