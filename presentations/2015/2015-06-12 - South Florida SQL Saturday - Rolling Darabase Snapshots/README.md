# MSSQL-Rolling-DB-Snapshots

**Tags:** `sql-server` `database-snapshots` `automation` `mirroring`

MSSQL procs and job scripts to create 'rolling' database snapshots.
These scripts are part of my [Rolling Database Snapshots presentation at SQL Saturday - South Florida 2015](http://www.sqlsaturday.com/379/Sessions/Details.aspx?sid=36496)

## Files

### Presentation Slides
- [Rolling Database Snapshot - Concept Diagram.pdf](./Rolling%20Database%20Snapshot%20-%20Concept%20Diagram.pdf) - This diagrams the components of this solution, good place to start.
- [Rolling Database Snapshots.pdf](./Rolling%20Database%20Snapshots.pdf)

### SQL Scripts
- [p_CreateTimeStampedDatabaseSnapshot.sql](./p_CreateTimeStampedDatabaseSnapshot.sql) - This procedure is used to create a snapshot of a mirrored database. It creates a timestamped database snapshot in the form of: DatabaseName_ss_yyyymmdd_hhmmss. Locates the snapshot file in the same folder as the source database. Snapshot filename is DatabaseFileName_yymmdd_hhmmss.ss
- [p_RemoveOldSnapshots.sql](./p_RemoveOldSnapshots.sql) - This procedure drops the oldest database snapshots for a given database, retaining the most recent @snapshotsToKeep snapshots. Includes a parameter option to respect active connections, so that long running queries can complete.
- [fn_GetLatestSnapshot.sql](./fn_GetLatestSnapshot.sql) - Function to get the latest snapshot for a given database.
- [SQL JOB Refresh Database Snapshots script.sql](./SQL%20JOB%20Refresh%20Database%20Snapshots%20script.sql) - Creates SQL Job with two steps. First step creates a new snapshot for a given database, second step removes old snapshots for a given database. Schedule is for every minute, ADJUST SCHEDULE AS NEEDED! See step contents for examples.

### Demo Scripts
- [AdventureWorks2008R2 Insert Random Orders.ps1](./AdventureWorks2008R2%20Insert%20Random%20Orders.ps1) - PowerShell script that invokes the SQL script to create an order record. If in SQL 2008, you need to [install PowerShell and SMO from the feature pack.](https://chocolatey.org/packages/SQL2008.Powershell)
- [AdventureWorks2008R2 Insert Random Sales.SalesOrderHeader.sql](./AdventureWorks2008R2%20Insert%20Random%20Sales.SalesOrderHeader.sql)
- [Query Latest Orders From Snapshot of Mirror Database.ps1](./Query%20Latest%20Orders%20From%20Snapshot%20of%20Mirror%20Database.ps1) - Queries the 5 latest orders from both the Principal and the latest snapshot of the Mirror database to demonstrate that mirroring and snapshots are functioning. 

### What's not covered here:
Implementing database mirror is not covered, and is the DBA's (i.e. your) responsibility. 
If requested, I may include SQL script I used to set up a mirror of the AdventureWorks2008R2 database, 
but it must be customized for your environment, and some manual steps may be required.
