#scripting db objects
$instanceName = 'DGEM'
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#View and modify SQL Server Settings
$server | Select-Object *
$server.BackupDirectory = "D:\SQLBackup2"
#commit the change
$server.Alter()
#View Result
$server.BackupDirectory

#View in SSMS

#restore setting
$server.BackupDirectory = "D:\SQLBackup"
$server.Alter()

$dbName = "AdventureWorks2014"
$db = $server.Databases[$dbName]
$db | Select-Object *
#Change db settings
$db.Trustworthy = $true
$db.Alter()

#View Result
$db.Trustworthy

#View in SSMS

#restore setting
$db.Trustworthy = $false
$db.Alter()