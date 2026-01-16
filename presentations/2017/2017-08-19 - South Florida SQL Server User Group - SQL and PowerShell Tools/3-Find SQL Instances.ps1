# Work with the ManagedComputer object to find local SQL instances
# https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.wmi.managedcomputer.aspx
$instanceName = "DGEM" #IP, machine name, etc
$managedComputer = New-Object -TypeName 'Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer' -ArgumentList $instanceName

#list server instances
$managedComputer.ServerInstances
$managedComputer.ServerInstances | Select-Object -Property Name,URN
