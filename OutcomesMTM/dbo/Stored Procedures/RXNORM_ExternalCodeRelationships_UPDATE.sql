

CREATE PROCEDURE [dbo].[RXNORM_ExternalCodeRelationships_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_ExternalCodeRelationships

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_ExternalCodeRelationships r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_ExternalCodeRelationships(
         fileid, 
         external_source, 
         external_source_code_1, 
         external_source_code_2, 
         transaction_cd, 
         relationship_type_2_to_1, 
         detail_relationship_2_to_1, 
         reserve, 
         Active)
      SELECT
         fileid, 
         external_source, 
         external_source_code_1, 
         external_source_code_2, 
         transaction_cd, 
         relationship_type_2_to_1, 
         detail_relationship_2_to_1, 
         reserve, 
         1
      FROM staging.fileLayout1552
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1552

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_ExternalCodeRelationships r
      WHERE fileID = @maxFileID
     
   END CATCH

END

