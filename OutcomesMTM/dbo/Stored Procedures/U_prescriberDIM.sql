
CREATE PROCEDURE [dbo].[U_prescriberDIM]
AS 
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

   --Update Existing Records in prescriberDim table
   UPDATE p
      SET p.ClientID = pdsq.ClientID,
          p.PrescriberID = pdsq.PrescriberID,
          p.PrescriberFirstName = pdsq.PrescriberFirstName,
          p.PrescriberLastName = pdsq.PrescriberLastName,
          p.PrescriberAddress1 = pdsq.PrescriberAddress1,
          p.PrescriberAddress2 = pdsq.PrescriberAddress2,
          p.PrescriberCity = pdsq.PrescriberCity,
          p.PrescriberState = pdsq.PrescriberState,
          p.PrescriberZip = pdsq.PrescriberZip,
          p.PrescriberFax = pdsq.PrescriberFax,
          p.PrescriberPhone = pdsq.PrescriberPhone,
          p.prescriberTypeID = pdsq.prescriberTypeID,
          p.changeDate = pdsq.changeDate,
          p.enterpriseChangeDate = pdsq.enterpriseChangeDate
   FROM prescriberDim p
      JOIN prescriberDeltaQueueStaging pdsq
         ON p.prid = pdsq.prid

   --Insert New Records Into PrescriberDim Table
   INSERT INTO prescriberDim(
	   prid,
	   ClientID,
	   PrescriberID,
	   PrescriberFirstName,
	   PrescriberLastName,
	   PrescriberAddress1,
	   PrescriberAddress2,
	   PrescriberCity,
	   PrescriberState,
	   PrescriberZip,
	   PrescriberFax,
	   PrescriberPhone,
	   prescriberTypeID,
	   changeDate,
	   enterpriseChangeDate)
   SELECT
      prid, 
      ClientID, 
      PrescriberID, 
      PrescriberFirstName, 
      PrescriberLastName, 
      PrescriberAddress1, 
      PrescriberAddress2, 
      PrescriberCity, 
      PrescriberState, 
      PrescriberZip, 
      PrescriberFax, 
      PrescriberPhone, 
      prescriberTypeID, 
      changeDate, 
      enterpriseChangeDate
   FROM prescriberDeltaQueueStaging
   WHERE prid not in (SELECT prid 
                      FROM prescriberDim)

END