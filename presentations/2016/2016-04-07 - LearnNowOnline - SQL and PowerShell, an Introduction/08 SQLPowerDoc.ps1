#Kendal Van Dyke's SQLPowerDoc https://sqlpowerdoc.codeplex.com/
Push-Location "$home\Documents\WindowsPowerShell"
#perform the inventory, store the result in compressed xml file
.\Get-SqlServerInventoryToClixml.ps1 -Computername $env:COMPUTERNAME -IncludeDatabaseObjectInformation -LoggingPreference Verbose
#get inventory filename
$inventoryArchiveFile = Get-ChildItem -Filter *.gz | Select -First 1
#convert the inventory file to a set of inventory reports in Excel 
.\Convert-SqlServerInventoryClixmlToExcel.ps1 -FromPath $inventoryArchiveFile.FullName
Pop-Location