

CREATE PROCEDURE [dbo].[RXNORM_ConceptTypeFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_ConceptTypeFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_ConceptTypeFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_ConceptTypeFile(
         fileid, 
         concept_type_id, 
         transaction_cd, 
         description, 
         reserve, 
         Active)
      SELECT
         fileid, 
         concept_type_id, 
         transaction_cd, 
         description, 
         reserve, 
         1
      FROM staging.fileLayout1550
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1550

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_ConceptTypeFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

