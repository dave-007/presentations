<#
#######################
PowerShell Providers
#######################
PowerShell providers expose various functionalities in a standard format.
They are exposed as drives like your file system.
Let's explore these now.

#>
Get-Help about_Providers
Get-PSProvider

# What commands can we run? Typically these:
Get-Command *-Item
Get-Command *-Location 

# Let's start with the registry

Get-PSProvider Registry 
Set-Location HKCU:\  #Equivalent of cd or change directory
Set-Location .\Software  #Equivalent of cd or change directory
Get-ChildItem
New-Item -Name _DeleteMe
Remove-Item .\_DeleteMe

Set-Location HKLM:
Get-ChildItem #Permissions still apply in PowerShell, we're not administrator.


#Back to file system
Set-Location C:\MyScripts
Get-ChildItem $env:TEMP
Get-ChildItem $env:TEMP -Filter *.log
Get-ChildItem $env:TEMP -Filter *.log -Recurse



#Look at contents of other providers
Get-ChildItem Function:\
Get-ChildItem Variable:\
Get-ChildItem Environment:\

# Additional providers can be installed for SQL Server, Exchange, Active Directory, etc.