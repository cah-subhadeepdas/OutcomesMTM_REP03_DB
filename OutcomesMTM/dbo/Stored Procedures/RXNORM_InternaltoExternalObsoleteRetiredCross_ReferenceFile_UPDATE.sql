

CREATE PROCEDURE [dbo].[RXNORM_InternaltoExternalObsoleteRetiredCross_ReferenceFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_InternaltoExternalObsolete_RetiredCrossReferenceFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_InternaltoExternalObsolete_RetiredCrossReferenceFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_InternaltoExternalObsolete_RetiredCrossReferenceFile(
         fileid, 
         external_source, 
         external_source_code, 
         concept_type_id, 
         concept_value, 
         transaction_cd, 
         reserve_1, 
         umls_concept_identifier, 
         rxnorm_code, 
         status_code, 
         reserve_2, 
         Active)
      SELECT
         fileid, 
         external_source, 
         external_source_code, 
         concept_type_id, 
         concept_value, 
         transaction_cd, 
         reserve_1, 
         umls_concept_identifier, 
         rxnorm_code, 
         status_code, 
         reserve_2, 
         1
      FROM staging.fileLayout1555
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1555

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_InternaltoExternalObsolete_RetiredCrossReferenceFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

