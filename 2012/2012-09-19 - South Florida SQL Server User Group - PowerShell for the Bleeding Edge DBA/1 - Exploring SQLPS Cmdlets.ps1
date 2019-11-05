#Exploring what's available for SQL in Powershell
Set-Location c:\
#Turn of Auto Loading of Modules, see http://technet.microsoft.com/en-us/library/hh847796.aspx
$PSModuleAutoLoadingPreference = "None"
#remove the modules if they're installed
Remove-Module "SQLPS"
Remove-Module "SQLASCMDLETS"
#list providers, no powershell
Get-PSProvider

#import sqlps
Import-Module SQLPS
#will also import SQLASCMDLETS
#some of the SQL cmdlets don't meet the stardard naming conventions (i.e. Backup*), so it will complain
Import-Module sqlps -DisableNameChecking


#note that it changes context to the default sql instance
#now we see the SqlServer provider
Get-PSProvider

#change back to C
cd C:\

#remove the modules
Remove-Module "SQLPS"
Remove-Module "SQLASCMDLETS"

#SqlServer provider no longer listed
Get-PSProvider

#next command auto-loads the SQLPS provider to provide the result. Handy!?
Get-Command -CommandType Cmdlet -Module SQLPS,SQLASCMDLETS| Select Name, Module |
Sort Module, Name |
Format-Table -AutoSize

$PSModuleAutoLoadingPreference = "All"

# Count available commands
(Get-Command).Count
# List Modules
Get-Module
#List All Available Modules
Get-Module -ListAvailable | Select-Object Name
Get-Module -All | Select-Object Name
Get-Command | Select-Object ModuleName -Unique |Sort-Object


