

CREATE PROCEDURE [dbo].[RXNORM_RetiredExternalConceptFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_RetiredExternalConceptFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_RetiredExternalConceptFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_RetiredExternalConceptFile(
         fileid, 
         external_source_1, 
         external_source_code_1, 
         external_source_2, 
         external_source_code_2, 
         transaction_cd, 
         version_release_start, 
         version_release_stop, 
         cardinality, 
         reserve, 
         Active)
      SELECT
         fileid, 
         external_source_1, 
         external_source_code_1, 
         external_source_2, 
         external_source_code_2, 
         transaction_cd, 
         version_release_start, 
         version_release_stop, 
         cardinality, 
         reserve,
         1
      FROM staging.fileLayout1554
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1554

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_RetiredExternalConceptFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

