
CREATE PROCEDURE [dbo].[U_ClaimNote]
AS
BEGIN
   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   INSERT INTO dbo.claimNote(
      ClaimNoteID, 
      claimID, 
      notetypeID, 
      Note, 
      active, 
      createDT, 
      userID, 
      changeDate)
   SELECT
      ClaimNoteID, 
      claimID, 
      notetypeID, 
      Note, 
      active, 
      createDT, 
      userID, 
      changeDate
   FROM dbo.ClaimNoteDeltaQueueStaging  cns
   WHERE 1 = 1
     AND NOT EXISTS (SELECT 1
                     FROM dbo.ClaimNote cn
                     WHERE 1 = 1
                       AND cns.claimNoteID = cn.ClaimNoteID)

   UPDATE cn
      SET claimID = cns.claimid, 
          notetypeID = cns.notetypeid, 
          Note = cns.note,
          active = cns.active, 
          createDT = cns.CreateDt, 
          userID = cns.UserID, 
          changeDate = cns.changedate
   FROM dbo.ClaimNote cn
      JOIN dbo.ClaimNoteDeltaQueueStaging cns
         ON cn.ClaimNoteID = cns.ClaimNoteID
   WHERE cns.changeDate IS NOT NULL
     AND cns.changeDate != cn.changeDate

END
