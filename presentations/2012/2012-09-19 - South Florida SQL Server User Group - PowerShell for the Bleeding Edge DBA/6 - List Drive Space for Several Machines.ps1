# from http://gallery.technet.microsoft.com/scriptcenter/List-for-several-machines-1baf6df0

<# 
 .SYNOPSIS 
    List for several machines the drives with size, free size and the percentage of free space. 
 .DESCRIPTION 
    An important duty of a DBA is to check frequently the free space of the drives the SQL Server is using to avoid a database crash if a drive is full.     
    With this PowerShell script you can easily check all drives for all servers in the given list. You can configure threshold value for Warning & Alarm level. 
    Requires permission to connect to and fetch WMI data from the machine(s). 
 .NOTES 
    Author  : Olaf Helper 
    Requires: PowerShell Version 1.0 
 .LINK 
    TechNet Get-WmiObject 
        http://technet.microsoft.com/en-us/library/dd315295.aspx 
#> 
 
# Configuration data. 
# Add your machine names to check for to the list: 
[Array] $servers = "DAVEPC","localhost"; 
[float] $levelWarn  = 20.0;  # Warn-level in percent. 
[float] $levelAlarm = 10.0;  # Alarm-level in percent. 
 
# Defining output format for each column. 
$fmtDrive =@{label="Drv"      ;alignment="left"  ;width=3  ;Expression={$_.DeviceID};}; 
$fmtName  =@{label="Vol Name" ;alignment="left"  ;width=15 ;Expression={$_.VolumeName};}; 
$fmtSize  =@{label="Size MB"  ;alignment="right" ;width=12 ;Expression={$_.Size / 1048576};; FormatString="N0";}; 
$fmtFree  =@{label="Free MB"  ;alignment="right" ;width=12 ;Expression={$_.FreeSpace / 1048576}    ; FormatString="N0";}; 
$fmtPerc  =@{label="Free %"   ;alignment="right" ;width=10 ;Expression={100.0 * $_.FreeSpace / $_.Size}; FormatString="N1";}; 
$fmtMsg   =@{label="Message"  ;alignment="left"  ;width=12 ; ` 
              Expression={     if (100.0 * $_.FreeSpace / $_.Size -le $levelAlarm) {"Alarm !!!"} ` 
                           elseif (100.0 * $_.FreeSpace / $_.Size -le $levelWarn)  {"Warning !"} };}; 
 
foreach($server in $servers) 
{ 
    $disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3"; 
     
    Write-Output ("Server: {0}`tDrives #: {1}" -f $server, $disks.Count); 
    Write-Output $disks | Format-Table $fmtDrive, $fmtName, $fmtSize, $fmtFree, $fmtPerc, $fmtMsg; 
}