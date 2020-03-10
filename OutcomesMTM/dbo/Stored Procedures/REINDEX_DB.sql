--DROP TABLE #TempIndex
--drop procedure [dbo].[REINDEX_DB]
CREATE PROCEDURE [dbo].[REINDEX_DB] 
AS
BEGIN
   SET XACT_ABORT ON;
   SET NOCOUNT ON;

   DECLARE @intCurrentRecord INT
   DECLARE @intMaxRecord INT
   DECLARE @intMinFragPercentage INT
   DECLARE @intMaxFragPercentage INT
   DECLARE @intRebuildBaseRecordCount INT
   DECLARE @dteRunDate DateTime
   DECLARE @strIndexName varchar(1000)
   DECLARE @strSchemaName varchar(1000)
   DECLARE @strObjectName varchar(1000)
   DECLARE @strSQL VARCHAR(8000)  

   --DEBUG 
   DECLARE @Debug int
   SET @Debug = 0

   --Initialize Variables
   SET @intCurrentRecord = 0
   SET @intMaxRecord = 0
   SET @intMinFragPercentage = 5
   SET @intMaxFragPercentage = 30
   SET @intRebuildBaseRecordCount = 5000000 -- 5M
   SET @dteRunDate = GETDATE()
   SET @strIndexName = ''
   SET @strSchemaName = ''
   SET @strObjectName = ''
   SET @strSQL = ''

   ----Check IF Log Table exists -- DROP table IF it does
   --IF OBJECT_ID('staging.ReIndexLog') IS NOT NULL
   --   BEGIN
	  --    DROP TABLE staging.ReIndexLog
   --   END

   ----Create Log Table
   --CREATE TABLE staging.ReIndexLog (
   --    [id] INT 
   --   ,[database_name] VARCHAR(1000) 
   --   ,[object_name] VARCHAR(1000)
   --   ,[schema_name] VARCHAR(1000)
   --   ,[object_desc] VARCHAR(1000)
   --   ,[index_name] VARCHAR(1000)
   --   ,[index_desc] VARCHAR(1000) 
   --   ,avg_fragmentation_in_percent DECIMAL(20,2) 
   --   ,is_disabled INT
   --   ,rundate DATETIME
   --   ,action_taken VARCHAR(1000)
   --   ,action_Start DATETIME
   --   ,action_end DATETIME
   --   ,record_count BIGINT
   --   ,table_size_MB DECIMAL(12, 3)
   --   ,index_size_MB DECIMAL(12, 3),
   --   ,SQL_Command VARCHAR(8000))

   --Populate ReIndexLog With action_start for #TempIndex table build         
   INSERT INTO staging.ReIndexLog (
      ID,
      action_taken,
      action_start,
      rundate
     )
   VALUES (
      0,
      'Build #TempIndex table',
      getdate(),
      @dteRunDate
     )

   --Create #TempIndex table
   CREATE TABLE #TempIndex (
       [id] INT IDENTITY(1,1)
      ,[database_name] VARCHAR(1000)
      ,[object_name] VARCHAR(1000)
      ,[schema_name] VARCHAR(1000)
      ,[object_desc] VARCHAR(1000)
      ,[index_name] VARCHAR(1000)
      ,[index_desc] VARCHAR(1000)
      ,avg_fragmentation_in_percent DECIMAL(20,2)
      ,is_disabled INT
      ,record_count BIGINT
      ,table_size_MB INT
      ,index_size_MB INT
   ) 

   --Load Index Table with CLUSTERED and NONCLUSTERED Indexes
   --   with a fragmentation of => @intMinFragPercentage 
   --   OR the index has been disabled
   INSERT INTO #TempIndex (
       --[id],
       [database_name] 
      ,[object_name] 
      ,[schema_name]
      ,[object_desc]
      ,[index_name] 
      ,[index_desc] 
      ,avg_fragmentation_in_percent 
      ,is_disabled
      ,record_count)
   SELECT 
       --ROW_NUMBER() over (order by i.type_desc, ips.OBJECT_ID) as [id], 
       DB_NAME(db_id()) as [database_name]
      ,o.name as [object_name]
      ,s.name as [scehma_name]
      ,o.type_desc as [object_desc]
      ,i.name as [index_name]
      ,i.type_desc as [index_desc] 
      ,ips.avg_fragmentation_in_percent
      ,i.is_disabled
      ,ps.row_count
   FROM sys.indexes i 
      INNER JOIN sys.objects o 
         ON o.object_id = i.object_id 
      INNER JOIN sys.schemas s 
         ON o.schema_id = s.schema_id
      INNER JOIN sys.dm_db_partition_stats ps 
         ON o.object_id = ps.object_id
      INNER JOIN sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) ips 
         ON ips.OBJECT_ID = i.OBJECT_ID 
        AND ips.index_id = i.index_id 
        AND ips.database_id = DB_ID()
   WHERE o.type_desc = 'USER_TABLE'
     AND i.type_desc in ('CLUSTERED', 'NONCLUSTERED')
     AND ps.index_id = 1
     AND (   
             ips.avg_fragmentation_in_percent >= @intMinFragPercentage 
          OR 
             i.is_disabled = 1
         ) 

   --Populate Log Table will all records from #TempIndex Table
   --   leaving run information blank
   INSERT INTO staging.ReIndexLog (
       [id] 
      ,[database_name] 
      ,[object_name] 
      ,[schema_name]
      ,[object_desc] 
      ,[index_name]
      ,[index_desc] 
      ,avg_fragmentation_in_percent 
      ,is_disabled 
      ,rundate
      ,record_count)
   SELECT 
       [id] 
      ,[database_name] 
      ,[object_name]
      ,[schema_name] 
      ,[object_desc] 
      ,[index_name]
      ,[index_desc] 
      ,avg_fragmentation_in_percent 
      ,is_disabled
      ,@dteRunDate
      ,record_count
   FROM #tempindex

   --Populate ReIndexLog With action_end for #TempIndex table build
   UPDATE staging.ReIndexLog 
      SET action_end = getdate()
   WHERE action_taken = 'Build #TempIndex table'
     AND rundate = @dteRunDate

--**************************
--***  CLUSTERED INDEXES ***
--**************************

   --SET Loop to REORGANIZE CLUSTERED indexes
   --   with fragmentation >= @intMinFragPercentage and < @intMaxFragPercentage
   SELECT
       @intCurrentRecord = ISNULL(MIN(ID), 1), --IF NULL Set to 1, so loop will not run if there are NO records meeting the criteria 
       @intMaxRecord = ISNULL(MAX(ID), 0) -- IF NULL Set to 0, so loop will not run if there are NO records meeting the criteria
   FROM #TempIndex
   WHERE avg_fragmentation_in_percent >= @intMinFragPercentage 
     AND avg_fragmentation_in_percent < @intMaxFragPercentage
	  AND is_disabled = 0
     AND record_count < @intRebuildBaseRecordCount
     AND index_desc = 'CLUSTERED'

   --Start Loop
   WHILE @intCurrentRecord <= @intMaxRecord
      BEGIN --REORGANIZE CLUSTERED INDEX

         --Populate StartTime Run Data in Log Table
         UPDATE staging.ReIndexLog 
            SET action_start = getdate()
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'CLUSTERED'

         --Set Variables for this Iteration
         SELECT
            @strIndexName = [index_name],
            @strSchemaName = [schema_name],
            @strObjectName = [object_name]
         FROM #TempIndex i 
			WHERE id = @intCurrentRecord

         IF @strSchemaName != 'staging' 
            BEGIN
               --Create Dynamic SQL to REORGANIZE Current Index
		         SET @strSQL = 'ALTER INDEX ' 
                           + '[' + @strIndexName + ']'
                           + ' ON [' + @strSchemaName + '].[' + @strObjectName + ']' 
                           + ' REORGANIZE; '

		         IF @Debug = 1
                  BEGIN
                     PRINT (@strSQL)
                  END

               --RUN Dynamic SQL to REORGANIZE Current Index
		         EXEC (@strSQL) 
            END
         ELSE
            BEGIN
               SET @strSQL = 'SKIPPED -- Staging Table'
            END

         --Populate EndTime and Action Run Data in Log Table
		   UPDATE staging.ReIndexLog 
            SET action_taken = 'REORGANIZE: CLUSTERED', 
                action_end = getdate(),
                SQL_Command = @strSQL 
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'CLUSTERED'

         --Iterate Loop
         IF @intCurrentRecord != @intMaxRecord
            BEGIN
               SELECT
                   @intCurrentRecord = MIN(ID) 
               FROM #TempIndex
               WHERE avg_fragmentation_in_percent >= @intMinFragPercentage 
                 AND avg_fragmentation_in_percent < @intMaxFragPercentage
                 AND record_count < @intRebuildBaseRecordCount
	              AND is_disabled = 0
                 AND index_desc = 'CLUSTERED'
                 AND ID > @intCurrentRecord
            END
         ELSE
            BEGIN
               SET @intCurrentRecord = @intMaxRecord + 1
            END

	   END --REORGANIZE CLUSTERED INDEX

   --SET Loop to REBUILD CLUSTERED indexes
   --   with fragmentation > @intMaxFragPercentage OR Index Disabled OR Record Count > Than Base Record Count
   SELECT
       @intCurrentRecord = ISNULL(MIN(ID), 1), --IF NULL Set to 1, so loop will not run if there are NO records meeting the criteria 
       @intMaxRecord = ISNULL(MAX(ID), 0) -- IF NULL Set to 0, so loop will not run if there are NO records meeting the criteria
   FROM #TempIndex
   WHERE index_desc = 'CLUSTERED'
     AND (   avg_fragmentation_in_percent > @intMaxFragPercentage
	       OR 
             is_disabled = 1
          OR 
             record_count >= @intRebuildBaseRecordCount
         )
    
   --Start Loop
   WHILE @intCurrentRecord <= @intMaxRecord
      BEGIN --REBUID CLUSTERED INDEX

         --Populate StartTime Run Data in Log Table
         UPDATE staging.ReIndexLog 
            SET action_start = getdate() 
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'CLUSTERED'

         --Set Variables for this Iteration
         SELECT
            @strIndexName = [index_name],
            @strSchemaName = [schema_name],
            @strObjectName = [object_name]
         FROM #TempIndex 
			WHERE id = @intCurrentRecord

         IF @strSchemaName != 'staging' 
            BEGIN
               --Create Dynamic SQL to REBUILD Current Index
               SET @strSQL = 'ALTER INDEX ' 
                  + '[' + @strIndexName + ']'
                  + ' ON [' + @strSchemaName + '].[' + @strObjectName + ']' 
                  + ' REBUILD WITH (FILLFACTOR = 80,  ONLINE = ON, maxdop = 1 ); '

		         IF @Debug = 1
                  BEGIN
                     PRINT (@strSQL)
                  END

               --RUN Dynamic SQL to REBUILD Current Index
		         EXEC (@strSQL) 
            END
         ELSE
            BEGIN
               SET @strSQL = 'SKIPPED -- Staging Table'
            END

         --Populate EndTime and Action Run Data in Log Table
		   UPDATE staging.ReIndexLog 
            SET action_taken = 'REBUILD: CLUSTERED', 
                action_end = getdate(),
                SQL_Command = @strSQL  
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'CLUSTERED'

         --Iterate Loop
         IF @intCurrentRecord != @intMaxRecord
            BEGIN
               SELECT
                   @intCurrentRecord = MIN(ID) 
               FROM #TempIndex
               WHERE ID > @intCurrentRecord
                 AND index_desc = 'CLUSTERED'
                 AND (   avg_fragmentation_in_percent > @intMaxFragPercentage
	                   OR 
                         is_disabled = 1
                      OR
                         record_count >= @intRebuildBaseRecordCount
                     )
            END
         ELSE
            BEGIN
               SET @intCurrentRecord = @intMaxRecord + 1
            END

	   END --REBUILD CLUSTERED INDEX

--*****************************
--***  NONCLUSTERED INDEXES ***
--*****************************

   --SET Loop to REORGANIZE NONCLUSTERED indexes
   --   with fragmentation >= @intMinFragPercentage and < @intMaxFragPercentage

   --Initialize Varaibles
   SELECT
       @intCurrentRecord = ISNULL(MIN(ID), 1), --IF NULL Set to 1, so loop will not run if there are NO records meeting the criteria 
       @intMaxRecord = ISNULL(MAX(ID), 0) -- IF NULL Set to 0, so loop will not run if there are NO records meeting the criteria
   FROM #TempIndex
   WHERE avg_fragmentation_in_percent >= @intMinFragPercentage 
     AND avg_fragmentation_in_percent < @intMaxFragPercentage
	  AND is_disabled = 0
     AND index_desc = 'NONCLUSTERED'
     AND record_count < @intRebuildBaseRecordCount   

   --Start Loop
   WHILE @intCurrentRecord <= @intMaxRecord
      BEGIN --REORGANIZE NONCLUSTERED INDEX

         --Populate StartTime Run Data in Log Table
         UPDATE staging.ReIndexLog 
            SET action_start = getdate() 
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'NONCLUSTERED'

         --Set Variables for this Iteration
         SELECT
            @strIndexName = [index_name],
            @strSchemaName = [schema_name],
            @strObjectName = [object_name]
         FROM #TempIndex 
			WHERE id = @intCurrentRecord

         --Create Dynamic SQL to REORGANIZE Current Index
         IF @strSchemaName != 'staging' 
            BEGIN
               --Create Dynamic SQL to REORGANIZE Current Index
		         SET @strSQL = 'ALTER INDEX ' 
                           + '[' + @strIndexName + ']'
                           + ' ON [' + @strSchemaName + '].[' + @strObjectName + ']' 
                           + ' REORGANIZE; '

		         IF @Debug = 1
                  BEGIN
                     PRINT (@strSQL)
                  END

               --RUN Dynamic SQL to REORGANIZE Current Index
		         EXEC (@strSQL) 
            END
         ELSE
            BEGIN
               SET @strSQL = 'SKIPPED -- Staging Table'
            END

         --Populate EndTime and Action Run Data in Log Table
		   UPDATE staging.ReIndexLog 
            SET action_taken = 'REORGANIZE: NONCLUSTERED', 
                action_end = getdate(),
                SQL_Command = @strSQL  
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'NONCLUSTERED'

         --Iterate Loop
         IF @intCurrentRecord != @intMaxRecord
            BEGIN
               SELECT
                   @intCurrentRecord = MIN(ID) 
               FROM #TempIndex
               WHERE avg_fragmentation_in_percent >= @intMinFragPercentage 
                 AND avg_fragmentation_in_percent < @intMaxFragPercentage
                 AND record_count < @intRebuildBaseRecordCount
	              AND is_disabled = 0
                 AND index_desc = 'NONCLUSTERED'
                 AND ID > @intCurrentRecord
            END
         ELSE
            BEGIN
               SET @intCurrentRecord = @intMaxRecord + 1
            END

	   END --REORGANIZE NONCLUSTERED INDEX

   --SET Loop to REBUILD NONCLUSTERED indexes
   --   with fragmentation > @intMaxFragPercentage OR Index Disabled OR Record Count > Than Base Record Count

   --Initialize Varaibles
   SELECT
       @intCurrentRecord = ISNULL(MIN(ID), 1), --IF NULL Set to 1, so loop will not run if there are NO records meeting the criteria 
       @intMaxRecord = ISNULL(MAX(ID), 0) -- IF NULL Set to 0, so loop will not run if there are NO records meeting the criteria
   FROM #TempIndex
   WHERE index_desc = 'NONCLUSTERED' 
     AND (   avg_fragmentation_in_percent > @intMaxFragPercentage
	       OR 
             is_disabled = 1
          OR 
             record_count >= @intRebuildBaseRecordCount
         )

   --Start Loop
   WHILE @intCurrentRecord <= @intMaxRecord
      BEGIN --REBUID NONCLUSTERED INDEX

         --Populate StartTime Run Data in Log Table
         UPDATE staging.ReIndexLog 
            SET action_start = getdate() 
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'NONCLUSTERED'

         --Set Variables for this Iteration
         SELECT
            @strIndexName = [index_name],
            @strSchemaName = [schema_name],
            @strObjectName = [object_name]
         FROM #TempIndex 
			WHERE ID = @intCurrentRecord

         IF @strSchemaName != 'staging' 
            BEGIN
               --Create Dynamic SQL to REBUILD Current Index
               SET @strSQL = 'ALTER INDEX ' 
                  + '[' + @strIndexName + ']'
                  + ' ON [' + @strSchemaName + '].[' + @strObjectName + ']' 
                  + ' REBUILD WITH (FILLFACTOR = 80,  ONLINE = ON, maxdop = 1 ); '

		         IF @Debug = 1
                  BEGIN
                     PRINT (@strSQL)
                  END

               --RUN Dynamic SQL to REBUILD Current Index
		         EXEC (@strSQL) 
            END
         ELSE
            BEGIN
               SET @strSQL = 'SKIPPED -- Staging Table'
            END

         --Populate EndTime and Action Run Data in Log Table
		 UPDATE staging.ReIndexLog 
            SET action_taken = 'REBUILD: NONCLUSTERED', 
                action_end = getdate(),
                SQL_Command = @strSQL  
         WHERE ID = @intCurrentRecord
           AND rundate = @dteRunDate
           AND index_desc = 'NONCLUSTERED'

         --Iterate Loop
         IF @intCurrentRecord != @intMaxRecord
            BEGIN
               SELECT
                   @intCurrentRecord = MIN(ID) 
               FROM #TempIndex
               WHERE ID > @intCurrentRecord
                 AND index_desc = 'NONCLUSTERED'
                 AND (   avg_fragmentation_in_percent > @intMaxFragPercentage
	                   OR 
                         is_disabled = 1
                      OR
                         record_count >= @intRebuildBaseRecordCount
                     )
            END
         ELSE
            BEGIN
               SET @intCurrentRecord = @intMaxRecord + 1
            END

	   END --REBUILD NONCLUSTERED INDEX

--*************************
--*** UPDATE STATISTICS ***
--*************************

   --SET @intMaxRecord
   SELECT
      @intMaxRecord = MAX(ID) + 1
   FROM staging.ReIndexLog
   WHERE rundate = @dteRunDate

   --Populate ReIndexLog With action_start for UPDATE STATISTICS 
   INSERT INTO staging.ReIndexLog (
      ID,
      action_taken,
      action_start,
      rundate
     )
   VALUES (
      @intMaxRecord,
      'UPDATE STATISTICS',
      getdate(),
      @dteRunDate
     )

   --RUN UPDATE STATISTICS
   EXEC sp_updatestats

   --Populate ReIndexLog With action_end for UPDATE STATISTICS 
   UPDATE staging.ReIndexLog 
      SET action_end = getdate()
   WHERE action_taken = 'UPDATE STATISTICS'
     AND rundate = @dteRunDate

END