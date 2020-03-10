

CREATE PROCEDURE [dbo].[RXNORM_VarianceDescriptionFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_VarianceDescriptionFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_VarianceDescriptionFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_VarianceDescriptionFile(
         fileid, 
         variance_identifier, 
         transaction_cd, 
         variance_short_description, 
         variance_description, 
         reserve, 
         Active)
      SELECT
         fileid, 
         variance_identifier, 
         transaction_cd, 
         variance_short_description, 
         variance_description, 
         reserve, 
         1
      FROM staging.fileLayout1553
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1553

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_VarianceDescriptionFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

