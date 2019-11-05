/*
PURPOSE:
This procedure is used to create a snapshot of a mirrored database.
It creates a timestamped database nameshot in the form of:
DatabaseName_ss_yyyymmdd_hhmmss
Locates the snapshot file in the same folder as the source database
Snapshotfilename is DatabaseFileName_yymmdd_hhmmss.ss
USAGE:
EXEC p_CreateTimeStampedDatabaseSnapshot 'DFClients'
Adapted from John Huang script: http://www.sqlnotes.info/2011/10/03/a-procedure-for-creating-database-snapshot/
*/
IF EXISTS ( SELECT  0
            FROM    sys.procedures
            WHERE   NAME = 'p_CreateTimeStampedDatabaseSnapshot' )
    DROP PROC p_CreateTimeStampedDatabaseSnapshot
GO

CREATE PROCEDURE p_CreateTimeStampedDatabaseSnapshot (@SourceDatabaseName SYSNAME = NULL)
AS
BEGIN
	DECLARE @datestr VARCHAR(30)
		,@snapshotName SYSNAME
		,@snapshotDataFileSuffix VARCHAR(30)
		,@oldestSnapshot VARCHAR(50)
		,@snapshotsToKeep INT = 5
		,@snapshotsAvailable INT
		,@sql NVARCHAR(MAX)
		,@Proc SYSNAME = 'master..sp_executesql'
	DECLARE @t TABLE (
		NAME SYSNAME
		,physical_name SYSNAME
		,i INT identity(1, 1)
		)

	SELECT @datestr = CONVERT(VARCHAR(30), getdate(), 120)

	SELECT @datestr = REPLACE(REPLACE(REPLACE(@datestr, ':', ''), ' ', '_'), '-', '')

	SET @SnapshotName = @SourceDatabaseName + '_ss_' + @datestr
	SET @snapshotDataFileSuffix = '_' + @datestr + '.ss'
	SET XACT_ABORT ON

	SELECT @SourceDatabaseName = ISNULL(@SourceDatabaseName, db_name())

	SELECT @SQL = N'SELECT name, physical_name FROM master.sys.master_files WHERE type = 0 and database_id = DB_ID(''' + @SourceDatabaseName + ''')'

	INSERT INTO @t
	EXEC @Proc @SQL

	SELECT @SQL = 'CREATE DATABASE ' + QUOTENAME(@SnapshotName) + ' on '

	SELECT @SQL = @SQL + '(NAME = ' + QUOTENAME(NAME) + ', FILENAME = ''' + physical_name + @snapshotDataFileSuffix + '''),'
	FROM @t
	WHERE i > 1

	SELECT @SQL = @SQL + '(NAME = ' + QUOTENAME(NAME) + ', FILENAME = ''' + physical_name + @snapshotDataFileSuffix + ''')'
	FROM @t
	WHERE i = 1

	SELECT @SQL = @SQL + ' AS SNAPSHOT OF ' + QUOTENAME(@SourceDatabaseName) + ' ;'

	EXEC (@SQL)
		--PRINT @SQL
END
GO


