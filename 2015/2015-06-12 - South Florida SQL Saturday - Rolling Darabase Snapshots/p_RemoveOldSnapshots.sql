/*
PURPOSE: This procedure drops the oldest database snapshots for a given database,
retaining the most recent @snapshotsToKeep snapshots.

*/
USE master

IF EXISTS ( SELECT  0
            FROM    sys.procedures
            WHERE   NAME = 'p_RemoveOldSnapshots' )
    DROP PROC p_RemoveOldSnapshots
GO

CREATE PROC p_RemoveOldSnapshots
    (
      @sourceDatabaseName SYSNAME = NULL ,
      @snapshotsToKeep INT = 3 ,
      @respectActiveConnections BIT = 0
	)
AS
	SET NOCOUNT ON
    DECLARE @snapshotCount INT ,
        @snapshotsToRemove INT ,
        @SQL VARCHAR(MAX) ,
        @nextDatabase SYSNAME


    SELECT  @snapshotCount = COUNT(0)
    FROM    sys.databases
    WHERE   source_database_id = DB_ID(@sourceDatabaseName)
--ORDER BY create_date

    SET @snapshotsToRemove = @snapshotCount - @snapshotsToKeep

    IF @snapshotsToRemove < 1
        BEGIN
            PRINT 'Only found ' + CONVERT(VARCHAR(5), @snapshotCount)
                + ' snapshots for ' + @sourceDatabaseName + ', keeping up to '
                + CONVERT(VARCHAR(5), @snapshotsToKeep)
                + ', so nothing was done. Exiting..'
        END
    ELSE
        BEGIN
            PRINT 'Found ' + CONVERT(VARCHAR(5), @snapshotCount)
                + ' snapshots, only keeping '
                + CONVERT(VARCHAR(5), @snapshotsToKeep)
                + ', so removing the oldest '
                + CONVERT(VARCHAR(5), @snapshotsToRemove) + ' snapshot(s):'
	--get the @snapshotsToRemove oldest snapshots
            SELECT TOP ( @snapshotsToRemove )
                    name
            INTO    #snapshotDatabasesToRemove
            FROM    sys.databases
            WHERE   source_database_id = DB_ID(@sourceDatabaseName)
            ORDER BY create_date

            SET @nextDatabase = 'init'
            WHILE @nextDatabase IS NOT NULL
                BEGIN
                    SELECT TOP 1
                            @nextDatabase = name
                    FROM    #snapshotDatabasesToRemove
                    ORDER BY NAME
		

                    IF @@ROWCOUNT = 1 --still database snapshots to drop
                        BEGIN
			--Check for active connections
                            IF EXISTS ( SELECT  0
                                        FROM    sys.sysprocesses
                                        WHERE   dbid = DB_ID(@nextDatabase) )
                                AND @respectActiveConnections = 1
                                BEGIN
                                    PRINT 'There are active connections to the database snapshot '
                                        + @nextDatabase
                                        + ' and @respectActiveConnections is on, so skipping this database.'
                                END
                            ELSE
                                BEGIN
                                    SET @SQL = 'DROP DATABASE ['
                                        + @nextDatabase + ']' ---give existing queries up to 5 minutes to complete
                                    EXEC (@SQL)
                                    PRINT 'Dropped snapshot ' + @nextDatabase
                                END

                            DELETE  FROM #snapshotDatabasesToRemove
                            WHERE   name = @nextDatabase
                        END
                    ELSE
                        BEGIN
                            SET @nextDatabase = NULL
                        END

                END
            DROP TABLE #snapshotDatabasesToRemove
	
	--Verify results
            SELECT  @snapshotCount = COUNT(0)
            FROM    sys.databases
            WHERE   source_database_id = DB_ID(@sourceDatabaseName)

            PRINT 'There are now ' + CONVERT(VARCHAR(5), @snapshotCount)
                + ' snapshots of ' + @sourceDatabaseName + ' remaining.'
        END
	SET NOCOUNT OFF
GO

--EXEC p_RemoveOldSnapshots 'DFClients', 5
