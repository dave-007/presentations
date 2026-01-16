# Get SQL Server Instances Info
Get-ItemProperty 'HKLM:\Software\Microsoft\Microsoft SQL Server\Instance Names\SQL'

foreach ($svr in get-content "S:\Presentations\SQL 2012 and Powershell\sqlinstances.txt"){
    $dt = new-object "System.Data.DataTable"
    $cn = new-object System.Data.SqlClient.SqlConnection "server=$svr;database=master;Integrated Security=sspi"
    $cn.Open()
    $sql = $cn.CreateCommand()
    $sql.CommandText = "SELECT @@SERVERNAME AS ServerName, SERVERPROPERTY('ProductVersion') AS Version, SERVERPROPERTY('ProductLevel') as SP"
    $rdr = $sql.ExecuteReader()
    $dt.Load($rdr)
    $cn.Close()
    $dt | Format-Table -autosize
}

#Another method from http://www.mssqltips.com/sqlservertip/2013/find-sql-server-instances-across-your-network-using-windows-powershell/
Stop-Service SQLBrowser
Get-Service | Where-Object name -like "*browser*"
Start-Service SQLBrowser
[System.Data.Sql.SqlDataSourceEnumerator]::Instance.GetDataSources()

# Will use Script Explorer see Get-SQLWMI is better
#Import-Module "S:\My Documents\Microsoft Script Explorer\Get-SqlWmi.ps1"
#Get-SqlWmi