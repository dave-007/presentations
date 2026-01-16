<#
###########
WMI and CIM
###########

CIM is the Common Information Model – http://www.dmtf.org/standards/cim

Provides a common definition of management information 
for systems, networks, applications and services.

Windows Management Instrumentation (WMI) is Windows implementation of CIM.


More info: http://richardspowershellblog.wordpress.com/2012/01/06/wmi-and-cim/


#>
#WMI has been around since the beginning
Get-Command -Name *WMI* -CommandType Cmdlet 
#CIM Cmdlets are new in PowerShell 3
Get-Command -Name *CIM* -CommandType Cmdlet 


# See the Win32_* classes
$Type = "Win32"
$WMI = Get-WmiObject -List | Where-Object -Property Name -Match $Type
$WMI | Out-GridView

# Some commonly used WMI Classes
$bios = Get-WmiObject -Class Win32_BIOS
$processor = Get-WmiObject -Class Win32_Processor
$disk = Get-WmiObject -Class Win32_DiskDrive


# We can create our own object from these objects using a hash table
Get-Help about_Hash_Tables

$info = @{}

$info.Manufacturer = $bios.Manufacturer
$info.Processor = $processor.Name
$info.DiskModel = $disk.Model

Write-Output $info
