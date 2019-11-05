#get all services
Write-Output "All Services"
# use format-table to control display 
#backtick is an escape character, useful for formatting your PoSh code
Get-Service  `
| Format-Table name, ServiceType, status, CanStop, -auto

# try it with out-gridview
Get-Service `
| Out-GridView 
#what about just sql services?
Write-Output "Some SQL Services"
Get-Service | Where-Object -Property Name -Like '*SQL*'
#hmm, where is reporting services, not named sql, but in the display name
Write-Output "All SQL Services"
Get-Service | Where-Object -Property DisplayName -Like '*SQL*'
#which sql services are stopped?
Write-Output "Stopped SQL Services"
Get-Service `
| Where-Object -Property DisplayName -Like '*SQL*' `
| Where-Object -Property Status -EQ Stopped 

# Alternate method using SMO, see http://msdn.microsoft.com/en-us/library/ms162567.aspx
#Get a managed computer instance
$mc = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer
$mc.Services 