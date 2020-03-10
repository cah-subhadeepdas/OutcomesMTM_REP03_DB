

CREATE PROCEDURE [dbo].[RXNORM_DataDictionaryFile_UPDATE]
   (@FileID int)
AS
BEGIN
   DECLARE @maxFileID int

   SELECT 
      @maxFileID = fileID
   FROM dbo.RXNORM_DataDictionaryFile

   UPDATE r
      SET Active = 0
   FROM dbo.RXNORM_DataDictionaryFile r
   WHERE fileID = @maxFileID

   BEGIN TRY

      INSERT INTO dbo.RXNORM_DataDictionaryFile(
         fileid, 
         field_identifier, 
         field_description, 
         field_type, 
         field_length, 
         implied_decimal_flag, 
         decimal_places, 
         field_validation_flag, 
         field_abbreviation_flag, 
         reserve, 
         Active)
      SELECT
         fileid, 
         field_identifier, 
         field_description, 
         field_type, 
         field_length, 
         implied_decimal_flag, 
         decimal_places, 
         field_validation_flag, 
         field_abbreviation_flag, 
         reserve, 
         1
      FROM staging.fileLayout1544
      WHERE fileID = @FileID

      TRUNCATE TABLE staging.fileLayout1544

   END TRY
   BEGIN CATCH

      UPDATE r
         SET Active = 1
      FROM dbo.RXNORM_DataDictionaryFile r
      WHERE fileID = @maxFileID
     
   END CATCH

END

