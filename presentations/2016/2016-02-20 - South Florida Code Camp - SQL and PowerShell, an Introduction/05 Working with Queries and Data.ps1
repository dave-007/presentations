$query = @"
SELECT TOP 100 Title, FirstName, LastName
FROM AdventureWorks2014.Person.Person
"@

$result = Invoke-Sqlcmd -ServerInstance DGEM -Query $query
$result | Get-Member


#You want it in Excel?
$result | Export-CSV -Path "$env:TEMP\result.csv"  -Force -NoTypeInformation
Invoke-Expression "$env:TEMP\result.csv"