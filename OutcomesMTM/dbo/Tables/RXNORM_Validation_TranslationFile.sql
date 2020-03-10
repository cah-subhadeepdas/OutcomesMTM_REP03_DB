CREATE TABLE [dbo].[RXNORM_Validation_TranslationFile] (
    [rxxvalid]           INT          IDENTITY (1, 1) NOT NULL,
    [fileid]             INT          NOT NULL,
    [field_identifier]   VARCHAR (4)  NULL,
    [field_value]        VARCHAR (15) NULL,
    [language_code]      INT          NULL,
    [value_description]  VARCHAR (40) NULL,
    [value_abbreviation] VARCHAR (15) NULL,
    [reserve]            VARCHAR (20) NULL,
    [Active]             BIT          NOT NULL,
    [CreateDate]         DATETIME     CONSTRAINT [DF__RXNORM_Validation_TranslationFile__CreateDate] DEFAULT (getdate()) NOT NULL
);

