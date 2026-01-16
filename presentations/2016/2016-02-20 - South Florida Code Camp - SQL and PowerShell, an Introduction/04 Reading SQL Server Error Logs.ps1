#See  error messages in SQL Server log, and save to CSV

$machineName = "DGEM" 
$folder = "D:\Logs";
$timestamp = (Get-Date -Format "yyyy-MM-dd_hmmtt").ToString()
$filename = $folder + "\ErrorLog_" + $timestamp + ".csv"
$sqlServer = new-object ("Microsoft.SqlServer.Management.Smo.Server") "$machineName" 
$logtextpattern = "*"
#note the use of ` as an escape character, hides the crlf, makes more readable code
$sqlServer.ReadErrorLog() |
Where-Object -Property Text -Like $logtextpattern  | 
Sort-Object -Property LogDate -Descending | 
Select-Object -First 10 | 
Export-Csv -Path $filename -NoTypeInformation

#display errors in notepad
explorer $filename

#email the errors to an admin
#use SMTP4DEV, great tool to test local email sends.
Send-MailMessage `
-SmtpServer "DGEM" `
-To "administrator@davepc" `
-From "powershell@davepc" `
-Subject "Error Log - $timestamp" `
-Body "Recent Login Errors" `
-Attachments $filename

#try with Out-GridView, use the filter
#$sqlServer.ReadErrorLog() | Out-GridView



#Can also access windows event log
Get-EventLog -LogName Application | Select-Object -Last 100
Get-EventLog -LogName Application -EntryType Error -Source "MSSQL`$SQL2016" | Select-Object -Property Message -Last 1 

Get-EventLog -LogName Application -Source "MSSQLSERVER" -Newest 100 