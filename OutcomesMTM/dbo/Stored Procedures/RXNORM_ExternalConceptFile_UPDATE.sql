

CREATE PROCEDURE [dbo].[RXNORM_ExternalConceptFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_ExternalConceptFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_ExternalConceptFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_ExternalConceptFile(
         fileid, 
         external_source, 
         external_source_code, 
         transaction_cd, 
         umls_concept_identifier, 
         external_type, 
         external_source_set, 
         rxnorm_code, 
         reserve, 
         Active)
      SELECT
         fileid, 
         external_source, 
         external_source_code, 
         transaction_cd, 
         umls_concept_identifier, 
         external_type, 
         external_source_set, 
         rxnorm_code, 
         reserve, 
         1
      FROM staging.fileLayout1547
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1547

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_ExternalConceptFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

