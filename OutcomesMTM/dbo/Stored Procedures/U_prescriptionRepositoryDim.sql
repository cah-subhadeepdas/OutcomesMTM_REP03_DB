

CREATE PROCEDURE [dbo].[U_prescriptionRepositoryDim]
      @queueOrder int 
AS 
BEGIN

   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   DECLARE @changeDate DATETIME = GETDATE(); 
   DECLARE @recordCount BIGINT = 0

   --Re-initialize @recordCount
   SET @recordCount = 0

  --Create New Record In Logging Table For Start of #tempRepository INSERTS
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate
      ,endDate)
   SELECT 
       @queueOrder
      ,'tempRepository'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()
      ,NULL

   --Check to see if #tempRepository table EXISTS
   IF(OBJECT_ID('tempdb..#tempRepository') IS NOT NULL)
      BEGIN
         DROP TABLE #tempRepository
      END

   --Create #tempRepository table
   CREATE TABLE #tempRepository (
       prescriptionKey bigint primary key 
      ,rxid int 
      ,repositoryArchiveID bigint 
      ,fileid int  
      ,isDelete bit 
      ,isInsert bit 
      ,queuedate datetime  
      ,activeKey bit)

   --INSERT Active Records into #tempRespository Table 
   INSERT INTO #tempRepository WITH (TABLOCK) (
       prescriptionKey
      ,rxid
      ,repositoryArchiveID
      ,fileid
      ,isDelete
      ,isInsert
      ,queuedate
      ,activeKey)
   SELECT 
       d.prescriptionKey
      ,s.rxid 
      ,s.repositoryarchiveid
      ,s.fileid
      ,s.isDelete
      ,s.isInsert
      ,s.queueDate 
      ,1 AS activeKey 
   FROM prescriptionDeltaQueueStaging s 
      JOIN prescriptionDim d  WITH (INDEX (UK_prescriptionDim_activethru))
         ON  d.[NCPDP_NABP] = s.[NCPDP_NABP]
        AND d.[patientid] = s.[patientid]
        AND d.[RxNumber] = s.[RxNumber]
        AND d.[RxDate] = s.[RxDate]
        AND d.[NDC] = s.[NDC]
        AND s.queueorder = @queueOrder
   WHERE 1=1 
     AND d.activethru IS NULL 
     AND s.isInsert = 1  
     AND NOT EXISTS(SELECT 1 
                     FROM prescriptionRepositoryDim r 
                     WHERE 1=1 
                       AND r.prescriptionkey = d.prescriptionkey 
                       AND ISNULL(r.repositoryArchiveID,0) = ISNULL(s.repositoryArchiveID,0) 
                       AND ISNULL(r.fileid,0) = ISNULL(s.fileid,0)
                       AND r.activethru IS NULL
                    ) 

   --Get number of records affected
   SET @recordCount = @@RowCount

   --INSERT Inactive Records into #tempRespository Table 
   INSERT INTO #tempRepository WITH (TABLOCK) (
       prescriptionKey
      ,rxid
      ,repositoryArchiveID
      ,fileid
      ,isDelete
      ,isInsert
      ,queuedate
      ,activeKey)
   SELECT 
       d.prescriptionKey
      ,s.rxid 
      ,s.repositoryarchiveid
      ,s.fileid
      ,s.isDelete
      ,s.isInsert
      ,s.queueDate 
      ,0 AS activeKey 
   FROM prescriptionDeltaQueueStaging s 
      JOIN prescriptionDim d  WITH (INDEX (UK_prescriptionDim_activethru))
         ON  d.[NCPDP_NABP] = s.[NCPDP_NABP]
        AND d.[patientid] = s.[patientid]
        AND d.[RxNumber] = s.[RxNumber]
        AND d.[RxDate] = s.[RxDate]
        AND d.[NDC] = s.[NDC]
        AND s.queueorder = @queueOrder
      JOIN prescriptionRepositoryDim r 
         ON  r.prescriptionKey = d.prescriptionKey 
        AND r.activethru IS NULL  
   WHERE 1=1 
     AND (
             (    s.isDelete = 1 
              AND s.isinsert = 0
             ) 
		    OR 
             (    s.isDelete = 1  
              AND EXISTS (SELECT 1 
                          FROM #tempRepository t 
                          WHERE 1=1 
                           AND t.rxid = s.rxid 
                           AND t.prescriptionKey <> d.prescriptionkey
                          )
             )
         ) 
   
   --Get number of records affected
   SET @recordCount = @recordCount + @@RowCount

   --Update Record In Logging Table For End of #tempRepository INSERTS
   UPDATE p 
      SET enddate = GETDATE() 
         ,recordCount = @recordCount
   FROM prescriptionDimDataLog p 
   WHERE 1=1 
     AND CAST(@changeDate AS DATE) = p.batchDate
     AND operation = 'tempRepository'
     AND enddate IS NULL

   --------------------------
   --Re-initialize @recordCount
   SET @recordCount = 0

   --Create New Record In Logging Table For Start of prescriptionRepositoryDim INSERTS
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate
      ,endDate)
   SELECT 
       @queueOrder
      ,'tempRepositoryInserts'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()
      ,NULL

   --4: only insert updates that have been turned off or new inserts 
   --the (d.activethru IS NULL or d.activethru = s.queueDate) is to handle 
   --if a new repository archive file turns off the record
   INSERT INTO prescriptionRepositoryDim (
       prescriptionkey
      ,repositoryarchiveid
      ,fileid   
      ,activeasof 
      ,iscurrent) 
   SELECT 
       s.prescriptionkey
      ,s.repositoryarchiveid
      ,s.fileid   
      ,s.queueDate AS activeasof 
      ,1 AS isCurrent
   --SELECT count(*) 
   FROM #tempRepository s
   WHERE 1=1 
     AND s.isinsert = 1
     AND s.activeKey = 1 
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d1 WITH (INDEX (UNC_prescriptionKey_activeasof))
                     WHERE 1=1 
                       AND d1.prescriptionkey = s.prescriptionkey  
                       AND d1.activeasof = s.queueDate
	                )
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d2 WITH (INDEX (UNC_prescriptionKey_activethru))
                     WHERE 1=1 
                       AND d2.prescriptionkey = s.prescriptionkey  
                       AND d2.activethru IS NULL 
	                  )

   --Get number of records affected
   SET @recordCount = @@RowCount

   --Update Record In Logging Table For End of prescriptionRepositoryDim INSERTS
   UPDATE p 
      SET enddate = GETDATE() 
         ,recordCount = @recordCount
   FROM prescriptionDimDataLog p 
   WHERE 1=1 
     AND CAST(@changeDate AS DATE) = p.batchDate
     AND operation = 'tempRepositoryInserts'
     AND enddate IS NULL

   ------------------
   --Re-initialize @recordCount
   SET @recordCount = 0

   --Create New Record In Logging Table For Start of prescriptionRepositoryDim UPDATES
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate
      ,endDate)
   SELECT 
       @queueOrder
      ,'tempRepositoryUpdates'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()
      ,NULL

   --3: only inactivate updates WHERE data has changed
   --the and not represents all of the audit columns 
   UPDATE d  
      SET d.[activeThru] = s.queueDate
         ,d.[isCurrent] = 0
   --SELECT count(*) 
   FROM prescriptionRepositoryDim d WITH (INDEX (UNC_prescriptionKey_activethru))
      JOIN #tempRepository s 
         ON  s.prescriptionkey = d.prescriptionkey  
   WHERE 1=1 
     AND d.activeThru IS NULL
     AND s.isDelete = 1 
     AND s.isInsert = 1 
     AND s.activeKey = 0 
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d1 WITH (INDEX (UNC_prescriptionKey_activeasof))
                     WHERE 1=1 
                       AND d1.prescriptionkey = s.prescriptionkey  
                       AND d1.activeasof = s.queueDate 
	                )
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d2 WITH (INDEX (UNC_prescriptionKey_activethru))
                     WHERE 1=1 
                       AND d2.prescriptionkey = s.prescriptionkey  
                       AND d2.activethru = s.queueDate 
                   )

   --Get number of records affected
   SET @recordCount = @@RowCount

   --Update Record In Logging Table For End of prescriptionRepositoryDim UPDATES
   UPDATE p 
      SET enddate = GETDATE() 
         ,recordCount = @recordCount
   FROM prescriptionDimDataLog p 
   WHERE 1=1 
     AND CAST(@changeDate AS DATE) = p.batchDate
     AND operation = 'tempRepositoryUpdates'
     AND enddate IS NULL

   ------------------------------------
   --Re-initialize @recordCount
   SET @recordCount = 0

   --Create New Record In Logging Table For Start of prescriptionRepositoryDim DELETES
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate
      ,endDate)
   SELECT 
       @queueOrder
      ,'tempRepositoryDeletes'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()
      ,NULL

   --2: UPDATE true deletes
   UPDATE d  
   SET d.[activeThru] = s.queueDate
      ,d.[isCurrent] = 1 
   --SELECT count(*) 
   FROM prescriptionRepositoryDim d WITH (INDEX (UNC_prescriptionKey_activethru))
      JOIN #tempRepository s 
         ON  s.prescriptionkey = d.prescriptionkey  
   WHERE 1=1 
     AND d.activeThru IS NULL 
     AND s.isDelete = 1 
     AND s.isInsert = 0 
     AND s.activeKey = 0 
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d1 WITH (INDEX (UNC_prescriptionKey_activeasof))
                     WHERE 1=1 
                       AND d1.prescriptionkey = s.prescriptionkey  
                       AND d1.activeasof = s.queueDate 
                   )
	   AND NOT EXISTS( SELECT 1 
                      FROM prescriptionRepositoryDim d2  WITH (INDEX (UNC_prescriptionKey_activethru))
                      WHERE 1=1 
                        AND d2.prescriptionkey = s.prescriptionkey  
                        AND d2.activethru = s.queueDate 
	                 )

   --Get number of records affected
   SET @recordCount = @@RowCount

   --Update Record In Logging Table For End of prescriptionRepositoryDim DELETES
   UPDATE p 
      SET enddate = GETDATE() 
         ,recordCount = @recordCount
   FROM prescriptionDimDataLog p 
   WHERE 1=1 
     AND CAST(@changeDate AS DATE) = p.batchDate
     AND operation = 'tempRepositoryDeletes'
     AND enddate IS NULL

END


