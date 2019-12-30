#Adapted from http://richbrownesq-sqlserver.blogspot.com/2011/05/powershell-script-out-sql-objects.html

#Script tables from all user databases
$sqlserver = "DGEM"
$scriptfolder = "D:\SQLScripts\tables\"
#Create folder if doesn't exist
if ((Test-Path $scriptfolder)-EQ $false)
{
    New-Item -ItemType Directory -Path $scriptfolder
}

# clear existing scripts
Get-ChildItem $scriptfolder | Remove-Item

$filePath = $scriptfolder + "Tables_" + $sqlserver + "_"


#[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-null

$srv = new-object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver
$options = new-object "Microsoft.SqlServer.Management.Smo.ScriptingOptions"
#Compare these to SSMS Generate Scripts options
$options.AppendToFile = $true
$options.ToFileOnly = $true
$options.ClusteredIndexes = $true
$options.NonClusteredIndexes = $true
$options.DriAll = $true

#try to set all SCriptingOption properties to true
foreach($prop in $options)
{
if ($prop.GetType().Name -eq "Boolean")
    {
    $prop = $true
    }
}

#Script the Adventureworks tables
foreach($db in $srv.Databases | where Name -Like "AdventureWorks*")
{
   $options.FileName = $filePath + $db.Name + ".sql"

   $tables = $db.Tables

   foreach($table in $tables | where IsSystemObject -eq $false)
   {
       $table.Script($options)

   }


}


explorer $scriptfolder

#What kinds of database items can we script?
Import-Module -Verbose -FullyQualifiedName "C:\Program Files (x86)\Microsoft SQL Server\130\Tools\PowerShell\Modules\SQLPS" 
Get-ChildItem SQLSERVER:\sql\dgem\default\databases\adventureworks2014