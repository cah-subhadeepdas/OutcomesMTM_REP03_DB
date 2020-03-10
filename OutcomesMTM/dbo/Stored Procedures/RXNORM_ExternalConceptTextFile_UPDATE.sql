

CREATE PROCEDURE [dbo].[RXNORM_ExternalConceptTextFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_ExternalConceptTextFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_ExternalConceptTextFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_ExternalConceptTextFile(
         fileid, 
         external_source, 
         external_source_code, 
         text_line_sequence, 
         transaction_cd, 
         representative_text_desc, 
         reserve, 
         Active)
      SELECT
         fileid, 
         external_source, 
         external_source_code, 
         text_line_sequence, 
         transaction_cd, 
         representative_text_desc, 
         reserve, 
         1
      FROM staging.fileLayout1548
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1548

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_ExternalConceptTextFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

