#See  error messages in SQL Server log, and save to CSV

$machineName = "DGEM" 
$folder = "D:\Logs";
$timestamp = (Get-Date -Format "yyyy-MM-dd_hmmtt").ToString()
$filename = $folder + "\ErrorLog_" + $timestamp + ".csv"
$sqlServer = new-object ("Microsoft.SqlServer.Management.Smo.Server") "$machineName" 
$logtextpattern = "*backup*"

#ReadErrorLog is a Method of the SQL Server object
$sqlServer | get-Member -MemberType Method

$sqlServer.ReadErrorLog() |
Where-Object -Property Text -Like $logtextpattern  | 
Sort-Object -Property LogDate -Descending | 
Select-Object -First 10 | 
Export-Csv -Path $filename -NoTypeInformation

#display error file
explorer $filename

$errorList = Get-Content $filename
#email the errors to an admin
#use SMTP4DEV, great tool to test local email sends. https://chocolatey.org/packages/smtp4dev
Send-MailMessage `
-SmtpServer "DGEM" `
-To "administrator@davepc" `
-From "powershell@davepc" `
-Subject "Error Log - $timestamp" `
-Body "Recent Login Errors: $errorList" #`
#-Attachments $filename

#try with Out-GridView, use the filter
#$sqlServer.ReadErrorLog() | Out-GridView



#Can also access windows event log
Get-EventLog -LogName Application -Newest 100 

Get-EventLog -LogName Application -Newest 100 -Message "*SQL*"

Get-EventLog -LogName Application -Source "MSSQLSERVER" -Newest 100 

Get-EventLog -LogName Application -Source "MSSQLSERVER" -Newest 100 -Message "*memory*"

Get-EventLog -LogName Application -EntryType Information -Source "MSSQLSERVER" -Newest 100 
