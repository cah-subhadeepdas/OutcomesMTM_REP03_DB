
CREATE PROCEDURE [dbo].[ZZ_U_medRecDIM]
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

	--medRecDim 
	--DELETES
	UPDATE d  
	   SET d.activethru = s.queueDate, 
          d.[iscurrent] = 1 
	--SELECT count(*) 
	FROM medRecDim d 
	   JOIN medRecDeltaQueueStaging s 
         ON d.patientid = s.patientid
        AND d.dischargedate = s.dischargedate
	WHERE 1=1 
	  AND d.activethru IS NULL 
	  AND s.isDelete = 1 
	  AND s.isInsert = 0
		 
	--UPDATES
	UPDATE d  
	   SET d.activethru = s.queueDate, 
          d.[isCurrent] = 0 
	--SELECT count(*) 
	FROM medRecDim d 
      JOIN medRecDeltaQueueStaging s 
         ON d.patientid = s.patientid
        AND d.dischargedate = s.dischargedate
	WHERE 1=1 
	  AND d.activethru IS NULL 
	  AND s.isDelete = 1 
	  AND s.isInsert = 1 
     AND d.medRecID = s.medRecID

   --INSERTS
   INSERT INTO medRecDim (
      medRecID, 
      PatientID, 
      dischargeDate, 
      dischargeFromLocationID, 
      dischargeToLocationID, 
      dischargingPRID, 
      PCPPRID, 
      active, 
      repositoryArchiveID, 
      fileid, 
      changeDate, 
      enterpriseChangeDate, 
      activeasof, 
      iscurrent	
	) 
	SELECT 
      s.medRecID, 
      s.PatientID, 
      s.dischargeDate, 
      s.dischargeFromLocationID, 
      s.dischargeToLocationID, 
      s.dischargingPRID, 
      s.PCPPRID, 
      s.active, 
      s.repositoryArchiveID, 
      s.fileid, 
      s.changeDate, 
      s.enterpriseChangeDate, 
	   s.[queueDate], 
	   1 as isCurrent
	--SELECT count(*) 
	FROM medRecDeltaQueueStaging s 
	WHERE 1=1 
	  AND s.isInsert = 1 
	  AND NOT EXISTS (SELECT 1 
                     FROM medRecDim d1
                     WHERE 1=1 
                       AND d1.patientid = s.patientid
                       AND d1.dischargedate = s.dischargedate
                       AND d1.activeasof = s.queueDate
		              )
	  AND NOT EXISTS (SELECT 1 
                     FROM medRecDim d2
                     WHERE 1=1 
                       AND d2.patientid = s.patientid
                       AND d2.dischargedate = s.dischargedate
                       AND d2.activethru IS NULL 
                    )

END
