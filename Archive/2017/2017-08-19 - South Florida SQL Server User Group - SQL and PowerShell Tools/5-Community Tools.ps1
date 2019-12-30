 #PowerShell 5.1 has PowerShellGet & PackageManagement modules, 
 #allowing you to discover and install community scripts and modules.

 #Modules & scripts can be downloaded manually from https://www.powershellgallery.com/

 #Use as your own risk! 
 #Understand any script or resource you download from the internet before using.
 Set-Location C:\scripts

 Get-Command -Module PowerShellGet

 $SQLModules = Find-Module -Filter SQL
 $SQLModules | Select-Object -Property Name,Description | Format-Table -Wrap

 $SQLScripts = Find-Script -Filter SQL
 $SQLScripts | Select-Object -Property Name,Description | Format-Table -Wrap

#Let's investigate dbatools
#https://dbatools.io/functions/
#UnInstall-Module -Name dbatools -Verbose
#Remove-Module dbatools
Install-Module -Name dbatools -Verbose -Force

Get-Command -Module dbatools



Test-DbaServerName -SqlServer DGEM

Test-SqlNetworkLatency -SqlServer DGEM

Test-DbaVirtualLogFile -SqlServer DGEM

'DGEM','DGEM\SQL2016' | Get-DbaDatabaseFreespace  |
    Select-Object -Property SqlServer,DatabaseName,Filename,UsedSpaceMB,FreeSpaceMB,PercentUsed |
        Format-Table -AutoSize

Get-DbaRestoreHistory -SqlServer DGEM |
  Format-Table -AutoSize

Copy-SqlLogin -Source DGEM -Destination DGEM\SQL2016 -WhatIf


Get-DbaTcpPort -SqlServer DGEM

Get-SqlServerKey

Get-SqlRegisteredServerName -SqlServer DGEM

Show-Command Copy-SqlDatabase

Copy-SqlDatabase -Destination DGEM\SQL2016 -DetachAttach -Reattach -Source DGEM -Databases db1,db2 -WhatIf