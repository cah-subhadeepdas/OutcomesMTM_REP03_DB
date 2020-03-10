

CREATE PROCEDURE [dbo].[RXNORM_ValidationTranslationFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_Validation_TranslationFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_Validation_TranslationFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_Validation_TranslationFile(
         fileid, 
         field_identifier, 
         field_value, 
         language_code, 
         value_description, 
         value_abbreviation, 
         reserve, 
         Active)
      SELECT
         fileid, 
         field_identifier, 
         field_value, 
         language_code, 
         value_description, 
         value_abbreviation, 
         reserve, 
         1
      FROM staging.fileLayout1545
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1545

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_ValidationTranslationFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

