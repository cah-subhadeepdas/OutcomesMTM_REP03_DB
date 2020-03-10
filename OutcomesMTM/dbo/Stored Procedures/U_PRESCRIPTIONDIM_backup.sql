



CREATE PROCEDURE [dbo].[U_PRESCRIPTIONDIM_backup]
      @queueOrder int 
AS 
BEGIN

   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   DECLARE @changeDate DATETIME = GETDATE(); 
   DECLARE @recordCount BIGINT = 0

  

   --Create New Record In Logging Table For Start of PrescriptionDim UPDATES
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'UPDATES'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()

   --UPDATES
   UPDATE d  
      SET d.activethru = s.queueDate 
         ,d.isCurrent = 0 
   --SELECT count(*) 
   FROM prescriptionDim d --WITH (INDEX (UK_prescriptionDim_activethru))
      JOIN prescriptionDeltaQueueStaging s 
         ON  d.[patientid] = s.[patientid]
        AND d.[NCPDP_NABP] = s.[NCPDP_NABP]
        AND d.[RxNumber] = s.[RxNumber]
        AND d.[RxDate] = s.[RxDate]
        AND d.[NDC] = s.[NDC]
        AND s.queueorder = @queueOrder
   WHERE 1=1 
     AND d.activethru IS NULL 
     AND s.isDelete = 1 
     AND s.isInsert = 1
     AND NOT (    ISNULL(d.rxid,0) = ISNULL(s.rxid,0)
              AND ISNULL(d.[Qty],0.0) = ISNULL(s.[Qty],0.0) 
              AND ISNULL(d.[Supply],0.0) = ISNULL(s.[Supply],0.0) 
              AND ISNULL(d.[PatientCopay],0.0) = ISNULL(s.[PatientCopay],0.0) 
              AND ISNULL(d.[ClientPayment],0.0) = ISNULL(s.[ClientPayment],0.0) 
              AND ISNULL(d.[prid],0) = ISNULL(s.[prid],0) 
              AND ISNULL(d.[PreferredFlag],'') = ISNULL(s.[PreferredFlag],'') 
              AND ISNULL(d.[PAStepIndicator],0) = ISNULL(s.[PAStepIndicator],0) 
              AND ISNULL(d.[DAW],'') = ISNULL(s.[DAW],'') 
              AND ISNULL(d.active,0) = ISNULL(s.active,0) 
             )

   --Get number of records affected
   SET @recordCount = @@RowCount

   --Update Record In Logging Table For End of PrescriptionDim UPDATES
   UPDATE p 
      SET enddate = GETDATE() 
         ,recordcount = @recordCount
   FROM prescriptionDimDataLog p 
   WHERE 1=1 
     AND CAST(@changeDate AS DATE) = p.batchDate
     AND operation = 'UPDATES'
     AND enddate IS NULL

   ----------------------------------------------------------------------------------
   --Re-initialize @recordCount
   SET @recordCount = 0

   --Create New Record In Logging Table For Start of PrescriptionDim INSERTS
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'INSERTS'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()


 -- Disabling the pescriptiondim indexes
	--ALTER INDEX [UK_prescriptionDim_activeasof] ON [dbo].[prescriptionDim] DISABLE
	--ALTER INDEX [UK_prescriptionDim_activethru] ON [dbo].[prescriptionDim] DISABLE
	ALTER INDEX [IX__prescriptionDim__RxID] ON [dbo].[prescriptionDim] DISABLE
   --INSERTS
   INSERT INTO prescriptionDim (
       [RxID] 
      ,[patientid] 
      ,[NCPDP_NABP] 
      ,[RxNumber] 
      ,[RxDate] 
      ,[NDC] 
      ,[Qty] 
      ,[Supply] 
      ,[PatientCopay] 
      ,[ClientPayment] 
      ,[prid] 
      ,[PreferredFlag] 
      ,[PAStepIndicator] 
      ,[DAW] 
      ,[active] 
      ,[activeAsOf] 
      ,[isCurrent]) 
   SELECT 
       s.[RxID] 
      ,s.[patientid] 
      ,s.[NCPDP_NABP] 
      ,s.[RxNumber] 
      ,s.[RxDate] 
      ,s.[NDC] 
      ,s.[Qty] 
      ,s.[Supply] 
      ,s.[PatientCopay] 
      ,s.[ClientPayment] 
      ,s.[prid] 
      ,s.[PreferredFlag] 
      ,s.[PAStepIndicator] 
      ,s.[DAW] 
      ,s.[active] 
      ,s.queueDate AS activeasof 
      ,1 AS isCurrent
   --SELECT count(*) 
   FROM prescriptionDeltaQueueStaging s 
   WHERE 1=1 
     AND s.queueorder = @queueOrder
     AND s.isinsert = 1
	 AND s.isDelete = 0 --added this line for PrescriptionDim refactor
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionDim d1 --WITH (INDEX (UK_prescriptionDim_activeasof))
                     WHERE 1=1 
                       AND d1.[patientid] = s.[patientid]
                       AND d1.[NCPDP_NABP] = s.[NCPDP_NABP]	
                       AND d1.[RxNumber] = s.[RxNumber]
                       AND d1.[RxDate] = s.[RxDate]
                       AND d1.[NDC] = s.[NDC]
                       AND d1.activeasof = s.queueDate
                    )
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionDim d2 --WITH (INDEX (UK_prescriptionDim_activethru))
                     WHERE 1=1 
                       AND d2.[patientid] = s.[patientid]
                       AND d2.[NCPDP_NABP] = s.[NCPDP_NABP]
                       AND d2.[RxNumber] = s.[RxNumber]
                       AND d2.[RxDate] = s.[RxDate]
                       AND d2.[NDC] = s.[NDC]
                       AND d2.activethru IS NULL 
                    )

-- Enabling the pescriptiondim indexes
	--ALTER INDEX [UK_prescriptionDim_activeasof] ON [dbo].[prescriptionDim] REBUILD
	--ALTER INDEX [UK_prescriptionDim_activethru] ON [dbo].[prescriptionDim] REBUILD
	ALTER INDEX [IX__prescriptionDim__RxID] ON [dbo].[prescriptionDim] REBUILD

   --Get number of records affected
   SET @recordCount = @@RowCount

   --Update Record In Logging Table For End of PrescriptionDim INSERTS
   UPDATE p 
      SET enddate = GETDATE() 
         ,recordCount = @recordCount
   FROM prescriptionDimDataLog p 
   WHERE 1=1 
     AND CAST(@changeDate AS DATE) = p.batchDate
     AND operation = 'INSERTS'
     AND enddate IS NULL

   ------------------------------------------------------
   --Re-initialize @recordCount
   SET @recordCount = 0
 

 /*
   --Create New Record In Logging Table For Start of PrescriptionDim DELETES
  INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'DELETES'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()

   --prescriptionDim
   --DELETES
   UPDATE d  
      SET d.activethru = s.queueDate 
         ,d.isCurrent = 1 
   --SELECT count(*) 
   FROM prescriptionDim d --WITH (INDEX (UK_prescriptionDim_activethru))
      JOIN prescriptionDeltaQueueStaging s 
         ON  d.[patientid] = s.[patientid]
        AND d.[NCPDP_NABP] = s.[NCPDP_NABP]
        AND d.[RxNumber] = s.[RxNumber]
        AND d.[RxDate] = s.[RxDate]
        AND d.[NDC] = s.[NDC]
        AND s.queueorder = @queueOrder
   WHERE 1=1 
     AND d.activethru IS NULL
     AND s.isDelete = 1
     AND s.isInsert = 0 

   --Get number of records affected
   SET @recordCount = @@RowCount

   --Update Record In Logging Table For End of PrescriptionDim DELETES
   UPDATE p 
      SET enddate = GETDATE()
         ,recordcount = @recordCount         
   FROM prescriptionDimDataLog p 
   WHERE 1=1 
     AND CAST(@changeDate AS DATE) = p.batchDate
     AND operation = 'DELETES'
     AND enddate IS NULL
      
	  */
   -----------------------------------------------------
   --Re-initialize @recordCount
   SET @recordCount = 0

  --Create New Record In Logging Table For Start of #tempRepository INSERTS
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'tempRepository'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()

   --Check to see if #tempRepository table EXISTS
   IF(OBJECT_ID('tempdb..#tempRepository') IS NOT NULL)
      BEGIN
         DROP TABLE #tempRepository
      END

   --Create #tempRepository table
   CREATE TABLE #tempRepository (
       prescriptionKey bigint primary key 
      ,rxid bigint 
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
      JOIN prescriptionDim d  --WITH (INDEX (UK_prescriptionDim_activethru))
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
      JOIN prescriptionDim d  --WITH (INDEX (UK_prescriptionDim_activethru))
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

   --Create New Record In Logging Table For Start of prescriptionRepositoryDim UPDATES
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'tempRepositoryUpdates'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()

   --3: only inactivate updates WHERE data has changed
   --the and not represents all of the audit columns 
   UPDATE d  
      SET d.[activeThru] = s.queueDate
         ,d.[isCurrent] = 0
   --SELECT count(*) 
   FROM prescriptionRepositoryDim d --WITH (INDEX (UNC_prescriptionKey_activethru))
      JOIN #tempRepository s 
         ON  s.prescriptionkey = d.prescriptionkey  
   WHERE 1=1 
     AND d.activeThru IS NULL
     AND s.isDelete = 1 
     AND s.isInsert = 1 
     AND s.activeKey = 0 
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d1 --WITH (INDEX (UNC_prescriptionKey_activeasof))
                     WHERE 1=1 
                       AND d1.prescriptionkey = s.prescriptionkey  
                       AND d1.activeasof = s.queueDate 
	                )
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d2 --WITH (INDEX (UNC_prescriptionKey_activethru))
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

   --Create New Record In Logging Table For Start of prescriptionRepositoryDim INSERTS
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'tempRepositoryInserts'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()

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
                     FROM prescriptionRepositoryDim d1 --WITH (INDEX (UNC_prescriptionKey_activeasof))
                     WHERE 1=1 
                       AND d1.prescriptionkey = s.prescriptionkey  
                       AND d1.activeasof = s.queueDate
	                )
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d2 --WITH (INDEX (UNC_prescriptionKey_activethru))
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
   --Create New Record In Logging Table For Start of prescriptionRepositoryDim INSERTS
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'tempRepositoryInserts'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()

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
                     FROM prescriptionRepositoryDim d1 --WITH (INDEX (UNC_prescriptionKey_activeasof))
                     WHERE 1=1 
                       AND d1.prescriptionkey = s.prescriptionkey  
                       AND d1.activeasof = s.queueDate
	                )
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d2 --WITH (INDEX (UNC_prescriptionKey_activethru))
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

   ------------------------------------
   --Re-initialize @recordCount
   SET @recordCount = 0

   --Create New Record In Logging Table For Start of prescriptionRepositoryDim DELETES
   INSERT INTO prescriptionDimDataLog (
       queueOrder
      ,operation
      ,batchDate
      ,startDate)
   SELECT 
       @queueOrder
      ,'tempRepositoryDeletes'
      ,CAST(@changeDate AS DATE)
      ,GETDATE()

   --2: UPDATE true deletes
   UPDATE d  
   SET d.[activeThru] = s.queueDate
      ,d.[isCurrent] = 1 
   --SELECT count(*) 
   FROM prescriptionRepositoryDim d --WITH (INDEX (UNC_prescriptionKey_activethru))
      JOIN #tempRepository s 
         ON  s.prescriptionkey = d.prescriptionkey  
   WHERE 1=1 
     AND d.activeThru IS NULL 
     AND s.isDelete = 1 
     AND s.isInsert = 0 
     AND s.activeKey = 0 
     AND NOT EXISTS( SELECT 1 
                     FROM prescriptionRepositoryDim d1 --WITH (INDEX (UNC_prescriptionKey_activeasof))
                     WHERE 1=1 
                       AND d1.prescriptionkey = s.prescriptionkey  
                       AND d1.activeasof = s.queueDate 
                   )
	   AND NOT EXISTS( SELECT 1 
                      FROM prescriptionRepositoryDim d2  --WITH (INDEX (UNC_prescriptionKey_activethru))
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



