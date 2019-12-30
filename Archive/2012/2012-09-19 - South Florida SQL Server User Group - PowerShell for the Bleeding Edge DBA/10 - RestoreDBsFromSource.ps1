## Title: RestoreDBsFromSource.ps1
## Author: David Cobb sql@davidcobb.net
## Purpose: Restores backups enumerated in $DBs from designated network share ($BackupRoot) onto target server(s) designated in $SQLServers.
## Assumptions: 
##		Database backups are stored  at $BackupRoot, with subfolder for each database, with filename matching $pattern.
## 		SQL Servers are default instances.
##		Target servers store data and logs at $DataFilePath and $LogFilePath
##		Target databases already exist
##		Rather than run against list of servers, only run against local server, determined by $env:COMPUTERNAME. Can run against multiple servers.
##		Rather than run against DBs declared in DBList.txt, enumerating list of databases in script or param.
##		Uses Y: drive letter
## History:
## 7/3/12 Created
## 7/10/12 modified $BackupRoot, reorganized, added comments

##IMPORTS
Import-Module 'sqlps' -DisableNameChecking
##Invoke-SqlCmd -Query "SELECT @@VERSION"

##FUNCTIONS
function Get-ScriptDirectory
{
$Invocation = (Get-Variable MyInvocation -Scope 1).Value
Split-Path $Invocation.MyCommand.Path
}

##SET PERMISSIONS
##Set-ExecutionPolicy Unrestricted -Scope CurrentUser

##SET CONFIGURATION VARIABLES
##todo: make params that default to value set in script. $SQLServers, $DBs, $BackupRoot


$ErrorActionPreference='Stop'  ##fail if script if anything breaks

$networkretrycount = 10
##$SQLServers = Get-Content .\SQLServerList.txt
$SQLServers = $env:COMPUTERNAME

##run against local db server
$DBs = Get-Content "S:\Presentations\SQL 2012 and Powershell\DBList.txt"
## $DBs = "db1,db2,db3"
$BackupRoot = '\\davepc\sqlbackup'
##todo determine paths below from SQL Server. In our case it's standard for each
$DataFilePath = 'C:\SQL2012Data'
$LogFilePath = 'C:\SQL2012Log'

$d = Get-Date
Write-Output "Starting RestoreDBsFromSource.ps1 powershell script at $d . Setting variables"



##GATHER ALL THE .BAK FILES PATHS IN THE BACKUP ROOT TO A LOCAL VARIABLE
Write-Output "Attemption to access network drive $BackupRoot"
$testpath = test-Path "Y:"
if ($testpath -eq $false)
{
	Write-Output "Creating map Y: to $BackupRoot"
	New-PSDrive -name "Y" -PSProvider FileSystem -Root $BackupRoot ##Y: doesn't work consistently
	Write-Output "Created map to $BackupRoot"
}
else
{
	Write-Output "Found map "Y:" to $BackupRoot"
}
try
{
	$AllBackups =  Get-ChildItem -Path "Y:" -Include "*.bak" -Recurse
}
catch
{
	return "Failed to access network share $BackupRoot Error: $error"
	exit
}
## loop runs 1 time for 1 SQL Server
foreach($s in $SQLServers)
{
	$loc = Set-Location "SQLSERVER:\SQL\$s\SQL2012DEV" 
	Write-Output "Current Location: $loc"  
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
        $pattern = "{0}_backup*.bak" -f $db
        ##Write-Output $pattern
		
		## FIND THE BACKUP FOLDER FOR THIS DATABASE
        $matches = $AllBackups | Where-Object {$_.Directory -like "*$db"}
		if ($matches -eq $null)
		{
			Write-Output "No matching backup found for $db. Is Drive Y: being used elsewhere?"
		}
		else
		{
			##Write-Output $matches
			
			##LOCATE THE MOST RECENT BACKUP FILENAME
			$BackupFileObject = $matches | sort -Property Name -Descending | Select-Object -first 1
			$BackupFile = $BackupFileObject.Name 
			$BackupFilePath ="{0}\{1}" -f $BackupPath, $BackupFile
			Write-Output "Located most recent backup for $db : $BackupFilePath"
			#Write-Output $BackupFilePath
			
			##SET DB SINGLE USER, DROPPING CONNECTIONS PRIOR TO RESTORE
			Write-Output "Set $db database on $s to single user"
			Invoke-Sqlcmd "ALTER DATABASE $db SET SINGLE_USER WITH ROLLBACK AFTER 10" -SuppressProviderContextWarning
		
			##DETERMINE THE LOGICAL FILENAMES FOR RESTORING
			##Write-Output "Determine Logical Names"
			$command = "RESTORE FILELISTONLY  FROM DISK = '{0}'" -f $BackupFilePath
			$filelist = Invoke-Sqlcmd $command -SuppressProviderContextWarning
			foreach ($file in $filelist)
			{
				if ($file.Type -eq "D")
					{
							$datalogicalname = $file.LogicalName 
					}
				elseif ($file.Type -eq "L")
					{
						$loglogicalname = $file.LogicalName
					}
			}
			##PERFORM RESTORE
			##Restore-SqlDatabase -Database $db -BackupFile '$BackupFilePath' -ReplaceDatabase
			$dstart = Get-Date
			Write-Output "Start restoring $db from $BackupFilePath onto $s at $dstart"
			$command = "RESTORE DATABASE {0} FROM DISK = '{1}' WITH REPLACE, MOVE '{4}' TO '{2}\{0}_Data.mdf', MOVE '{5}' TO '{3}\{0}_Log.ldf'" -f $db,$BackupFilePath,$DataFilePath,$LogFilePath,$datalogicalname,$loglogicalname
			##Write-Output $command
			try
			{
				Invoke-Sqlcmd $command -SuppressProviderContextWarning -ConnectionTimeout 1200 -QueryTimeout 0  ## 20 minutes to restore?
				$dcomplete = Get-Date
				$diff = $dcomplete - $dstart
				Write-Output "Restore completed successfully at $dcomplete with duration $diff ."## Results: $restore_result"
			}
			catch
			{
				$derror = Get-Date
				$differror = $derror - $dstart
				Write-Error "Restore failed at $derror with duration $differror . Error: $error"
			}
			$d = Get-Date
			## GO BACK TO MULTI-USER
			Write-Output "Set $db database on $s to multi-user"
			$command = "ALTER DATABASE $db SET MULTI_USER"
			Invoke-Sqlcmd $command -SuppressProviderContextWarning
			$d = Get-Date
			Write-Output "Completed restore processing for db $db on server $s at $d ."
		}
    }
}
$d = Get-Date
Write-Output "Completing powershell script at $d ."
Remove-PSDrive -name "Y" ##Powershell is inconsistent here, Create-PSDrive with "Y:" but delete it with "Y"