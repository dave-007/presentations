## Title: RestoreDBsFromSourceV2.ps1
## Author: David Cobb sql@davidcobb.net
## Purpose: Restores backups enumerated in $DBs from designated network share ($BackupRoot) onto target server(s) designated in $SQLServers.
## Assumptions: 
##      DBList param contains list of databases to restore
##		Database backups are stored  at $BackupRoot, with subfolder for each database, with filename matching $pattern.
## 		SQL Servers are default instances.
##		Target servers store data and logs at $DataFilePath and $LogFilePath
##		Rather than run against list of servers, only run against local server, determined by $env:COMPUTERNAME. Can run against multiple servers.
##		
## Cautions:
##      Restores over existing database, rolling back any current transactions. Meant to use in development environment.
## History:
## 7/3/12 Created
## 7/10/12 modified $BackupRoot, reorganized, added comments
## 10/24/12 Modifying for use on SQL 2008 R2 Servers
## 2/6/13 Modify to initialize ps environment. Also pass in $DBList as param for flexibility
## 2/18/13 Works if target database doesn't exist, uses backupDrive, not drive letter.
## 2/19/13 cleaned up old code and updated TODO and comments
## TODO:
## Use proper PowerShell template to create a module or cmdlet from this code.


##PARAMS
# pass in DBList

param
(
[parameter(Mandatory = $true)]
[string[]]$DBList
)

##IMPORTS

##FUNCTIONS

## solve Invoke-Sqlcmd timeout problem per http://www.scarydba.com/2010/04/16/powershell-smo-problem/
function Invoke-Sqlcmd2
{
param(
[string]$ServerInstance,
##[string]$Database,
[string]$Query,
[Int32]$QueryTimeout=30
)
$conn=new-object System.Data.SqlClient.SQLConnection
$conn.ConnectionString=”Server={0};Integrated Security=True” -f $ServerInstance,$Database
$conn.Open()
$cmd=new-object system.Data.SqlClient.SqlCommand($Query,$conn)
$cmd.CommandTimeout=$QueryTimeout
$ds=New-Object system.Data.DataSet
$da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
[void]$da.fill($ds)
$ds.Tables[0]
$conn.Close()
}


## INITIALIZE SQLPS ENVIRONMENT
# get the current folder
$currentFolder = Split-Path $MyInvocation.MyCommand.Path

#TODO: Determine SQL version and choose initialization method
#Only need next line on SQL 2012
Import-Module 'sqlps' -DisableNameChecking
# Only need next line on 2008 R2
##. (Join-Path $currentFolder Initialize-SqlPsEnvironment.ps1) | Out-Null



##SET PERMISSIONS
##Who needs permissions? :)
##Set-ExecutionPolicy Unrestricted -Scope CurrentUser

##SET CONFIGURATION VARIABLES
##TODO: make params that default to value set in script. $SQLServers, $DBs, $BackupRoot

$ErrorActionPreference='Stop'  ##fail if script if anything breaks
$networkretrycount = 10
#TODO: Add smarts about instances
$SQLServers = $env:COMPUTERNAME
$DBs = $DBList # defined in param
$BackupRoot = '\\davepc\backup'
##TODO determine paths below from SQL Server. 
$DataFilePath = 'S:\SQLData'
$LogFilePath = 'S:\SQLLog'

$d = Get-Date
Write-Output "Starting RestoreDBsFromSource.ps1 powershell script at $d . Setting variables"



##GATHER ALL THE .BAK FILES PATHS IN THE BACKUP ROOT TO A LOCAL VARIABLE
Write-Output "Attemption to access network drive $BackupRoot"
$testpath = test-Path "backupDrive:"
if ($testpath -eq $false)
{
	Write-Output "Creating map drive to $BackupRoot"
	New-PSDrive -name "backupDrive" -PSProvider FileSystem -Root $BackupRoot | Out-Null ##Y: doesn't work consistently
	Write-Output "Created map to $BackupRoot"
}
else
{
	Write-Output "Found map drive to $BackupRoot"
}
try
{
	$AllBackups =  Get-ChildItem -Path "backupDrive:" -Include "*.bak" -Recurse
}
catch
{
	return "Failed to access network share $BackupRoot Error: $error"
	exit
}

## Connect to SQL Server
## runs 1 time for 1 SQL Server
$s = $SQLServers

$loc = "SQLSERVER:\SQL\$s\DEFAULT" 
Set-Location $loc
Write-Output "Current Location: $loc" 
## ensure restore doesn't timeout per http://social.msdn.microsoft.com/Forums/eu/sqlsmoanddmo/thread/689b06bc-35f5-406e-8153-df9ff1c353bd 
$server = Get-Item $loc
$server.ConnectionContext.StatementTimeout = 65534
##Get-Location	d$ = Get-Date
Write-Output "Restoring designated databases to $s"
foreach($db in $DBs)
{
	Write-Output "Starting restore process for $db"
    ## INIT VARIABLES
	##use None for default value so the log output is readable, easier to find issue.
    $BackupPath = "None"
    $pattern = "None"
    $matches = $null
    $BackupFileObject = "None"
    $BackupFile = "None"
    $BackupPath = "{0}\{1}" -f $BackupRoot,$db
    ##Write-Output "$BackupPath"
    #Backup pattern assumes .\databasename\databasename_backup_yyyymmddhhmmss.bak
    #TODO: Flexible backup pattern.
    $pattern = "{0}_backup*.bak" -f $db
    ##Write-Output $pattern
		
	## FIND THE BACKUP FOLDER FOR THIS DATABASE
    $matches = $AllBackups | Where-Object {$_.Directory -like "*$db"}
	if ($matches -eq $null)
	{
		Write-Output "No matching backup found for $db. Valid database, with backups?"
	}
	else
	{
		##LOCATE THE MOST RECENT BACKUP FILENAME
		$BackupFileObject = $matches | sort -Property Name -Descending | Select-Object -first 1
		$BackupFile = $BackupFileObject.Name 
		$BackupFilePath ="{0}\{1}" -f $BackupPath, $BackupFile
		Write-Output "Located most recent backup for $db : $BackupFilePath"
		#Write-Output $BackupFilePath
			
    
        ##DETERMINE IF DB EXISTS
        $dbCheck = Get-ChildItem $loc\databases | Where-Object {$_.Name -eq $db}
        if ($dbCheck -eq $null)
        {
            Write-Output "Database $db does not exist."
        }
        else
        {
			##IF SO, SET DB SINGLE USER, KICK OUT USERS, DROPPING CONNECTIONS PRIOR TO RESTORE
			Write-Output "Set $db database on $s to single user"
			Invoke-Sqlcmd "ALTER DATABASE $db SET SINGLE_USER WITH ROLLBACK AFTER 5" -SuppressProviderContextWarning
        }
		##DETERMINE THE LOGICAL FILENAMES FOR RESTORING
        ##DETERMINE PHYSICALNAME FOR RESTORING
		$command = "RESTORE FILELISTONLY  FROM DISK = '{0}'" -f $BackupFilePath
		$filelist = Invoke-Sqlcmd $command -SuppressProviderContextWarning
		foreach ($file in $filelist)
		{
			if ($file.Type -eq "D")
				{
						$datalogicalname = $file.LogicalName 
                        $dataphysicalname = Split-Path $file.PhysicalName -leaf
				}
			elseif ($file.Type -eq "L")
				{
					$loglogicalname = $file.LogicalName
                    $logphysicalname = Split-Path $file.PhysicalName -leaf
				}
		}
		##PERFORM RESTORE
		##TODO: Restore-SqlDatabase -Database $db -BackupFile '$BackupFilePath' -ReplaceDatabase
		$dstart = Get-Date
		Write-Output "Start restoring $db from $BackupFilePath onto $s at $dstart"
		$command = "RESTORE DATABASE {0} FROM DISK = '{1}' WITH REPLACE, MOVE '{4}' TO '{2}\{6}', MOVE '{5}' TO '{3}\{7}'" -f $db,$BackupFilePath,$DataFilePath,$LogFilePath,$datalogicalname,$loglogicalname,$dataphysicalname,$logphysicalname
		##Write-Output $command
		try
		{
            ## use custom Invoke-SqlCmd to avoid timeout
			Invoke-Sqlcmd2 $s $command -QueryTimeout 0  ## 20 minutes to restore?
			$dcomplete = Get-Date
			$diff = $dcomplete - $dstart
			Write-Output "Restore completed successfully at $dcomplete with duration $diff ."
		}
		catch
		{
			$derror = Get-Date
			$differror = $derror - $dstart
			Write-Error "Restore failed at $derror with duration $differror . Error: $error"
		}
        finally
        {
			## GO BACK TO MULTI-USER IF DATABASE EXISTED
            if ($dbCheck -eq $null)
            {
			    Write-Output "Set $db database on $s to multi-user"
			    $command = "ALTER DATABASE $db SET MULTI_USER"
			    Invoke-Sqlcmd $command -SuppressProviderContextWarning
            }
        }
		$d = Get-Date
		Write-Output "Completed restore processing for db $db on server $s at $d ."
	}
}

$d = Get-Date
Write-Output "Completing powershell script at $d ."
Remove-PSDrive -name "backupDrive"