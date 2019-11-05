#Work with the Server object to view SQL configuration

$instanceName = "DGEM"
$server = New-Object -TypeName 'Microsoft.SqlServer.Management.Smo.Server' -ArgumentList $instanceName
$server | Get-Member
$server | Select-Object -Property * 
#Explore some of the methods on the Server object
$server | Get-Member -MemberType Method
$server.Script()
$server.ReadErrorLog()
$server.GetPropertySet() | Select-Object -Property Name,Value 