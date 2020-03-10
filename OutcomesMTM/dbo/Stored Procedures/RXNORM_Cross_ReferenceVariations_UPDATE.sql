

CREATE PROCEDURE [dbo].[RXNORM_Cross_ReferenceVariations_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_CrossReferenceVariations

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_CrossReferenceVariations r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_CrossReferenceVariations(
         fileid, 
         external_source, 
         external_source_code, 
         concept_type_id, 
         concept_value, 
         variance_identifier, 
         transaction_cd, 
         reserve, 
         Active)
      SELECT
         fileid, 
         external_source, 
         external_source_code, 
         concept_type_id, 
         concept_value, 
         variance_identifier, 
         transaction_cd, 
         reserve, 
         1
      FROM staging.fileLayout1551
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1551

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_CrossReferenceVariations r
      WHERE fileID = @maxFileID
     
   END CATCH

END

