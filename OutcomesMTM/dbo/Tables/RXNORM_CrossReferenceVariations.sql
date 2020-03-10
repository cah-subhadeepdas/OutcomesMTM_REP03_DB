CREATE TABLE [dbo].[RXNORM_CrossReferenceVariations] (
    [rxxxvarid]            INT          IDENTITY (1, 1) NOT NULL,
    [fileid]               INT          NOT NULL,
    [external_source]      VARCHAR (10) NULL,
    [external_source_code] VARCHAR (30) NULL,
    [concept_type_id]      INT          NULL,
    [concept_value]        VARCHAR (20) NULL,
    [variance_identifier]  INT          NULL,
    [transaction_cd]       VARCHAR (1)  NULL,
    [reserve]              VARCHAR (25) NULL,
    [Active]               BIT          NOT NULL,
    [CreateDate]           DATETIME     CONSTRAINT [DF__RXNORM_CrossReferenceVariations__CreateDate] DEFAULT (getdate()) NOT NULL
);

