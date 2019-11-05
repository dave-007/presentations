#Change SQL Server and Database Settings

$instanceName = 'DGEM'
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#View and modify SQL Server Settings
$server.BackupDirectory = "D:\SQLBackup2"
#commit the change
$server.Alter()
#View Result
$server.BackupDirectory

#View in SSMS

#restore setting
$server.BackupDirectory = "D:\SQLBackup"
$server.Alter()

#View and modify database Settings
$dbName = "AdventureWorks2014"
$db = $server.Databases[$dbName]
$db | Select-Object *
$db.Trustworthy

#Change db settings
$db.Trustworthy = $true
$db.Alter()

#View Result
$db.Trustworthy

#View in SSMS

#restore setting
$db.Trustworthy = $false
$db.Alter()