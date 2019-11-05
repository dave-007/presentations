#backup from SQL 2008 R2
Set-Location SQLSERVER:\SQL\davepc\default
Backup-SqlDatabase -Database eb -BackupFile C:\SQLBackup\eb_20121002_1.bak -BackupSetDescription "backup desc" -BackupSetName "backup name" -Checksum -CompressionOption On
#restore to sql 2012
Set-Location SQLSERVER:\SQL\davepc\sql2012dev
$RelocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("eb", "c:\SQL2012Data\eb.mdf")
$RelocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("eb_Log", "c:\SQL2012log\eb_log.ldf")
Restore-SqlDatabase -Database eb_restore -ReplaceDatabase -BackupFile C:\SQLBackup\eb_20121002_1.bak -Checksum -RelocateFile $RelocateData,$RelocateLog