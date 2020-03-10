

CREATE PROCEDURE [dbo].[RXNORM_InternaltoExternalCross_Reference_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_InternaltoExternalCrossReference

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_InternaltoExternalCrossReference r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_InternaltoExternalCrossReference(
         fileid, 
         external_source, 
         external_source_code, 
         concept_type_id, 
         concept_value, 
         transaction_cd, 
         match_type, 
         umls_concept_identifier, 
         rxnorm_code, 
         reserve, 
         Active)
      SELECT
         fileid, 
         external_source, 
         external_source_code, 
         concept_type_id, 
         concept_value, 
         transaction_cd, 
         match_type, 
         umls_concept_identifier, 
         rxnorm_code, 
         reserve, 
         1
      FROM staging.fileLayout1549
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1549

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_InternaltoExternalCrossReference r
      WHERE fileID = @maxFileID
     
   END CATCH

END

