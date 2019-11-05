<#
Purpose:
Integrate SQL SMO and Google Data Tables

Sources:
Google Chart Gallery
https://developers.google.com/chart/interactive/docs/gallery
Google tree Map
https://developers.google.com/chart/interactive/docs/gallery/treemap

http://sqlserverpowershell.com/2013/02/01/powershell-script-to-get-size-of-all-tables-in-sql-server/
Zachary Loeber
http://www.the-little-things.net/
Scott Newman
http://sqlserverpowershell.com/
#>

$presentations = "D:\Google Drive\Presentations"
Set-Location "$presentations\SQL and PowerShell - HP for LNO"

#load needed function, let's us take PowerShell objects and represent them as Javascript arrays
. .\PSScripts\ConvertTo-JSArray.ps1

#load html template to render tree map
$HTMLReportTemplatePath = ".\PSScripts\TreeTableTemplate.html"
#look at the template
notepad ".\PSScripts\TreeTableTemplate.html"


#use SMO to get table sizes
Add-Type -Path "C:\Program Files\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
$instanceName = 'DGEM'
$databaseName = 'AdventureWorksDW2014'
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$database = $server.Databases[$databaseName]

#Create a collection of objects, each with a table and size
$outputs = @();
$outputsDataTableRootNode = New-Object -TypeName PSObject -Property @{
        Table =  $databaseName
        Database = "null"
        #Schema = "dbo"
        Size = 0
    }

$outputs += $outputsDataTableRootNode
$outputs | gm
foreach($table in $database.Tables)
{
    $output = New-Object -TypeName PSObject -Property @{
        Table =  $table.Name
        Database = $database.Name
        #Schema = $table.Schema
        Size = [Math]::Truncate(($table.DataSpaceUsed * 1024) / 1MB)
    }
    $outputs += $output
}


$outputs
$outputsDataTable = $outputs | 
Select-Object Table,Database,Size | 
Where-Object {($_.Size -gt 0 -or $_.Database -eq "null")} |  
Sort-Object Size -Descending  | 
ConvertTo-JSArray -IncludeHeader
$outputsDataTable

$HTMLReportOutputPath = (Join-Path -Path $env:TEMP -ChildPath "TreeMap$(get-date -f yyyy-MM-dd-hh-mm-ss).html")
$HTMLReportOutputPath
$HTMLReportContent = (Get-Content $HTMLReportTemplatePath).Replace('<dataTablePlaceholder>',$outputsDataTable)
$HTMLReportContent | Out-File $HTMLReportOutputPath -Encoding ascii
Invoke-Expression $HTMLReportOutputPath