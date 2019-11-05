#adapted from http://richbrownesq-sqlserver.blogspot.com/2011/05/powershell-script-out-sql-objects.html

$sqlserver = "DAVEPC"
$scriptfolder = "C:\SQLScripts"
# clear existing scripts
Get-ChildItem $scriptfolder | Remove-Item

$filePath = $scriptfolder + "\Tables_" + $sqlserver + "_"


#[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-null

$srv = new-object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver
$options = new-object "Microsoft.SqlServer.Management.Smo.ScriptingOptions"
$options.AppendToFile = $false
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

foreach($db in $srv.Databases | where IsSystemObject -eq $false)
{
   $options.FileName = $filePath + $db.Name + ".sql"

   $tables = $db.Tables

   foreach($table in $tables | where IsSystemObject -eq $false)
   {
       $table.Script($options)

   }
}

explorer $scriptfolder