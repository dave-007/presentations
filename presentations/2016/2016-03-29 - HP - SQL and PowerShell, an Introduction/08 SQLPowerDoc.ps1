#Kendal Van Dyke's SQLPowerDoc https://sqlpowerdoc.codeplex.com/
Push-Location "$home\Documents\WindowsPowerShell"
.\Get-SqlServerInventoryToClixml.ps1 -Computername $env:COMPUTERNAME -IncludeDatabaseObjectInformation -LoggingPreference Verbose
.\Convert-SqlServerInventoryClixmlToExcel.ps1 -FromPath "$home\Documents\SQL Server Inventory - 2016-02-20-13-23.xml.gz"
Pop-Location