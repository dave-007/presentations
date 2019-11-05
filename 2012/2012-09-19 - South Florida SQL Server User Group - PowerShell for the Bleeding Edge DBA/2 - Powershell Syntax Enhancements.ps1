Import-Module SQLPS
Set-Location "SQLSERVER:\sql\davepc\sql2012dev\databases\adventureworks2012\tables"
# V2 Syntax
Write-Output "Here's Powershell 2 Syntax for Where-Object, the $_ represents the current pipeline object, and is confusing to new users"
Get-ChildItem | Where-Object { $_.Schema -eq "HumanResources"}
# V3 Syntax
Write-Output "Here's Powershell 3 Syntax for Where-Object using $PSItem instead of $_"
Get-ChildItem | Where-Object { $PSItem.Schema -eq "HumanResources"}
# Or even simpler
Write-Output "You can just provide the property of the object you want to filter"
Get-ChildItem | Where-Object -Property Schema -eq "HumanResources"
# Or even simpler
Write-Output "Property is a positional parameter, so if you leave -Property out, powershell assumes the first param is the Property"
Get-ChildItem | Where-Object Schema -eq "HumanResources"
