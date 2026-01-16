#See login failures in log

$machineName = "DAVEPC" 
$instanceName = "SQL2012DEV" 
$folder = "S:\Presentations\SQL 2012 and Powershell";
$timestamp = (Get-Date -Format "yyyy-MM-dd_hmmtt").ToString()
$filename = $folder + "\ErrorLog_" + $timestamp + ".csv"
$sqlServer = new-object ("Microsoft.SqlServer.Management.Smo.Server") "$machineName\$instanceName" 
$logtextpattern = "*roll*"
#note the use of ` as an escape character, hides the crlf, makes more readable code
$sqlServer.ReadErrorLog() `
| Where-Object -Property Text -Like $logtextpattern  `
| Sort-Object -Property LogDate -Descending `
| Select-Object -First 10 `
| Export-Csv -Path $filename -NoTypeInformation

#display errors in notepad
explorer $filename

#email the errors to an admin
Send-MailMessage `
-SmtpServer "davepc" `
-To "administrator@davepc" `
-From "powershell@davepc" `
-Subject "Error Log - $timestamp" `
-Body "Recent Login Errors" `
-Attachments $filename

#try with Out-GridView, use the filter
#$sqlServer.ReadErrorLog() | Out-GridView