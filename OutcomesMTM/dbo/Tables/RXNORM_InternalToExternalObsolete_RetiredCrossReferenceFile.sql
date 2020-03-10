CREATE TABLE [dbo].[RXNORM_InternalToExternalObsolete_RetiredCrossReferenceFile] (
    [rxxxorid]                INT          IDENTITY (1, 1) NOT NULL,
    [fileid]                  INT          NOT NULL,
    [external_source]         VARCHAR (10) NOT NULL,
    [external_source_code]    VARCHAR (30) NOT NULL,
    [concept_type_id]         INT          NOT NULL,
    [concept_value]           VARCHAR (20) NOT NULL,
    [transaction_cd]          VARCHAR (1)  NULL,
    [reserve_1]               VARCHAR (2)  NULL,
    [umls_concept_identifier] VARCHAR (12) NULL,
    [rxnorm_code]             VARCHAR (10) NULL,
    [status_code]             VARCHAR (1)  NULL,
    [reserve_2]               VARCHAR (37) NULL,
    [Active]                  BIT          NOT NULL,
    [CreateDate]              DATETIME     CONSTRAINT [DF__RXNORM_InternalToExternalObsolete_RetiredCrossReferenceFile__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_InternalToExternalObsolete_RetiredCrossReferenceFile__fileid__ext_src__ext_src_cd__concept_type_id__concept_value] UNIQUE NONCLUSTERED ([fileid] ASC, [external_source] ASC, [external_source_code] ASC, [concept_type_id] ASC, [concept_value] ASC)
);

