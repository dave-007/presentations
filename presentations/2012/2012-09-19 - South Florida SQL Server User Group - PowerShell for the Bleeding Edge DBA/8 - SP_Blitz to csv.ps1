#Thanks to Brent Ozar for sp_Blitz!
#Get the latest sp_blitz script
Set-ExecutionPolicy RemoteSigned
Import-Module SQLPS -DisableNameChecking
$sqlinstance = "DAVEPC"
$folder = "S:\My Documents\Presentations\SQL 2012 and Powershell";
$reportpath = Join-Path $folder "blitzreport2013_2.csv"
# V2
# $blitzscript = (New-Object System.Net.WebClient).DownloadString("http://i.brentozar.com/scripts/sp_blitz.txt")
# V3
$blitzscript = (Invoke-WebRequest -Uri "http://i.brentozar.com/scripts/sp_blitz.txt").content 
#create the blitz proc on the server instance
Invoke-Sqlcmd -HostName $sqlinstance -Query $blitzscript
#call sp_blitz and capture the result in csvalias
Invoke-Sqlcmd -HostName $sqlinstance -Query "sp_blitz" `
| Export-Csv -path $reportpath -noTypeInformation
#open the file
explorer $reportpath