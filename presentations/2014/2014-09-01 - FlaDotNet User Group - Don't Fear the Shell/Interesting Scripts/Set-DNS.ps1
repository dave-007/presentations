function Set-DNS ($DNSServer = "default", $ComputerName = ".")
{ 
    $session = New-CimSession -ComputerName $ComputerName

    if ($DNSServer -eq "default")
    {
        Get-NetIPInterface | ForEach-Object -Process {Set-DnsClientServerAddress -InterfaceIndex $PSItem.IfIndex -ResetServerAddresses -CimSession $session}
    }
    else
    {
        Get-NetIPInterface | ForEach-Object -Process {Set-DnsClientServerAddress -InterfaceIndex $PSItem.IfIndex -ServerAddresses $DNSServer -CimSession $session}
    }
}