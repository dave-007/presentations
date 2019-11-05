#See what capabilities we can use in the free DBATools module
#See http://dbatools.io for more info
#Start-Process "http://dbatools.io"
#look in the PSGallery repository
Find-Module -Name dbatools
Get-Module -Name DBATools -ListAvailable 
Install-Module dbatools -Verbose
#Might find a later version than what you have installed, could use..
Update-dbatools
#Update-Module dbatools
Get-Module -Name DBATools -ListAvailable 
Get-Command -Module DBATools | Out-GridView

#Let's try some of these commands
#You need sp_whoisactive on any SQL Server you manage!
Update-SqlWhoIsActive

#start a transaction to view it
Show-SqlWhoIsActive -SqlServer . 

#Gather SQL Server info
Get-Command -Module DBATools -Verb Get

Get-DiskSpace -Server .

Get-DbaDatabaseFreespace -SqlServer . -Databases AdventureWorks2014,db1
Get-DbaDatabaseFreespace -SqlServer . | Where-Object {$PSItem.PercentUsed -gt 80}

Get-DbaRestoreHistory -SqlServer . -Since 2016-01-01

Get-SqlMaxMemory -SqlServer .

Get-SqlServerKey -SqlServers DGEM

Get-DetachedDbInfo -MDF "D:\Sample Projects\publish\App_Data\Database.mdf" -SqlServer .

Expand-SqlTLogResponsibly -SqlServer . -TargetLogSizeMB 512 -IncrementSizeMB 128 -WhatIf -Verbose

Get-DbaTcpPort -SqlServer .
#Document or script out logins, server configurations
Export-SqlLogin -ServerInstance . -FilePath c:\temp\logins.sql
notepad c:\temp\logins.sql

Export-SqlSpConfigure -ServerInstance . -Path c:\temp\spconfigure.sql
notepad c:\temp\spconfigure.sql

#Manage indexes
Find-SqlDuplicateIndex -SqlServer . -FilePath c:\temp\duplicateindexes.sql
notepad c:\temp\duplicateindexes.sql

Find-SqlUnusedIndex -SqlServer . -FilePath c:\temp\unusedindexes.sql


<# 
    Other cool DBATools cmdlets
    Start-SqlMigration 
    handle all the details of migrating a sql server
    Can also handle these details with indivdual cmdlets:
    Get-Command -Verb Copy -Module DBATools

    Reset-SqlAdmin 
    locked out of a sql server? easy way to reset SA
#>


