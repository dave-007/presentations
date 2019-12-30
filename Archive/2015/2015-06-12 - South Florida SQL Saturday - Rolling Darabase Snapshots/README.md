# MSSQL-Rolling-DB-Snapshots
MSSQL procs and job scripts to create 'rolling' database snapshots.
These scripts are part of my [Rolling Database Snapshots presentation at SQL Saturday - South Florida 2015](http://www.sqlsaturday.com/379/Sessions/Details.aspx?sid=36496)

## Files included:
### Rolling Database Snapshot - Concept Diagram.pdf
This diagrams the components of this solution, good place to start.


### p_CreateTimeStampedDatabaseSnapshot.sql
This procedure is used to create a snapshot of a mirrored database.
It creates a timestamped database nameshot in the form of:
DatabaseName_ss_yyyymmdd_hhmmss
Locates the snapshot file in the same folder as the source database
Snapshotfilename is DatabaseFileName_yymmdd_hhmmss.ss

### p_RemoveOldSnapshots.sql
This procedure drops the oldest database snapshots for a given database,
retaining the most recent @snapshotsToKeep snapshots.
Includes a parameter option to respect active connections, so that long running queries can complete.

### fn_GetLatestSnapshot.sql
This procedure drops the oldest database snapshots for a given database,
retaining the most recent @snapshotsToKeep snapshots.
Includes a parameter option to respect active connections, so that long running queries can complete.

### SQL JOB Refresh Database Snapshots script.sql
Creates SQL Job with two steps. First step creates a new snapshot for a given database, second step removes old snapshots for a given database.
Schedule is for every minute, ADJUST SCHEDULE AS NEEDED!
See step contents for examples.

## Other Scripts
You can use the above scripts to implement your own solution. 
Scripts referenced below are ones I used in my demo. All hard coded to use the C:\scripts folder.
If you enjoy SQL and PowerShell scripting you might find them useful.


#### AdventureWorks2008R2 Insert Random Orders.ps1
#### AdventureWorks2008R2 Insert Random Sales.SalesOrderHeader.sql
Powershell script that invokes the SQL script to create an order record. If in SQL 2008, you need to [install PowerShell and SMO from the feature pack.](https://chocolatey.org/packages/SQL2008.Powershell)

#### Query Latest Orders From Snapshot of Mirror Database.ps1
Queries the 5 latest orders from both the Principal and the latest snapshot of the Mirror database to demonstrate that mirroring and snapshots are functioning. 

### What's not covered here:
Implementing database mirror is not covered, and is the DBA's (i.e. your) responsibility. 
If requested, I may include SQL script I used to set up a mirror of the AdventureWorks2008R2 database, 
but it must be customized for your environment, and some manual steps may be required.
