CREATE PROCEDURE [dbo].[s_UnusedTables]
      @SinceReboot INT = 1,
	  @TableAgeDays INT = 0
AS

CREATE TABLE #UnUsedTables (
	SchemaName VARCHAR(50),
	TableName VARCHAR(255), 
	TotalRowCount BIGINT, 
	CreatedDate DATETIME, 
	LastModifiedDate DATETIME, 
	LastSQLServiceRestart DATETIME, 
	TotalSpaceKB BIGINT, 
	UsedSpaceKB BIGINT, 
	UnusedSpaceKB BIGINT,
) 

INSERT INTO #UnUsedTables
	(
		SchemaName, TableName, TotalRowCount, CreatedDate, LastModifiedDate, LastSQLServiceRestart, 
		TotalSpaceKB, UsedSpaceKB, UnusedSpaceKB
	)

	SELECT ts.SchemaName, DBTable.name, PS.row_count, DBTable.create_date, DBTable.modify_date, sqlserver_start_time,
		TotalSpaceKB, UsedSpaceKB, UnusedSpaceKB
	FROM sys.dm_os_sys_info,  
		 sys.all_objects  DBTable      
			JOIN 
		 sys.dm_db_partition_stats PS 
			ON OBJECT_NAME(PS.object_id)=DBTable.name 
			INNER JOIN
		 sys.allocation_units A 
			ON PS.partition_id = A.container_id
			INNER JOIN
		 (
			SELECT t.object_id, 
				t.Name AS TableName,
				s.Name AS SchemaName,  
				p.Rows AS RowCounts,  
				SUM(a.total_pages) * 8 AS TotalSpaceKB,  
				SUM(a.used_pages) * 8  AS UsedSpaceKB,  
				(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
			FROM  sys.tables t  
					INNER JOIN 
				  sys.indexes i 
					ON t.object_id = i.object_id  
					INNER JOIN 
				  sys.partitions p 
					ON i.object_id = p.object_id AND i.index_id = p.index_id  
					INNER JOIN 
				sys.allocation_units a 
					ON p.partition_id = a.container_id  
					LEFT OUTER JOIN 
				sys.schemas s 
					ON t.schema_id = s.schema_id
			WHERE  t.Name NOT LIKE 'dt%'  AND t.is_ms_shipped = 0  AND i.object_id > 255
			GROUP BY  t.object_id, t.Name, s.Name, p.Rows
			-- ORDER BY  t.Name
		  ) ts
			ON DBTable.object_id = ts.object_id
	WHERE DBTable.type ='U' AND NOT EXISTS (
												SELECT OBJECT_ID                       
												FROM sys.dm_db_index_usage_stats                     
												WHERE OBJECT_ID = DBTable.object_id )
	GROUP BY ts.SchemaName, 
		DBTable.name, 
		PS.row_count,
		DBTable.create_date,
		DBTable.modify_date,
		sqlserver_start_time,
		TotalSpaceKB,  
		UsedSpaceKB,  
		UnusedSpaceKB

SELECT	SUM(TotalSpaceKB) AS deadTotalSpaceKB, CAST(SUM(TotalSpaceKB) AS NUMERIC(18,6))/1000 AS deadTotalSpaceMB,
		CAST(SUM(TotalSpaceKB) AS NUMERIC(18,6))/1000000 AS deadTotalSpaceGB
FROM #UnUsedTables
WHERE	(@SinceReboot = 1 AND LastSQLServiceRestart > LastModifiedDate)
			OR 
		(@SinceReboot = 0 AND CURRENT_TIMESTAMP - @TableAgeDays > LastModifiedDate)

SELECT *
FROM #UnUsedTables
WHERE	(@SinceReboot = 1 AND LastSQLServiceRestart > LastModifiedDate)
			OR 
		(@SinceReboot = 0 AND CURRENT_TIMESTAMP - @TableAgeDays > LastModifiedDate)
ORDER BY LastModifiedDate ASC

SELECT *
FROM #UnUsedTables
WHERE	(@SinceReboot = 1 AND LastSQLServiceRestart > LastModifiedDate)
			OR 
		(@SinceReboot = 0 AND CURRENT_TIMESTAMP - @TableAgeDays > LastModifiedDate)
ORDER BY TotalSpaceKB ASC
