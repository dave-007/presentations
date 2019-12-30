
# tail the error log
$instanceName = "DAVEPC\SQL2012DEV" 
$sqlServer = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$sqlServerCurrentErrorLogFile = Join-Path $sqlServer.ErrorLogPath "ERRORLOG"
#$sqlServerCurrentErrorLogFile
Get-Content -Path $sqlServerCurrentErrorLogFile -Wait