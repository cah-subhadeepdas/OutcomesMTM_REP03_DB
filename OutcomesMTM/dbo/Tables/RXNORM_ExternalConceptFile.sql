CREATE TABLE [dbo].[RXNORM_ExternalConceptFile] (
    [rxxexconid]              INT          IDENTITY (1, 1) NOT NULL,
    [fileid]                  INT          NOT NULL,
    [external_source]         VARCHAR (10) NOT NULL,
    [external_source_code]    VARCHAR (30) NOT NULL,
    [transaction_cd]          VARCHAR (1)  NULL,
    [umls_concept_identifier] VARCHAR (12) NULL,
    [external_type]           VARCHAR (10) NULL,
    [external_source_set]     VARCHAR (10) NULL,
    [rxnorm_code]             VARCHAR (10) NULL,
    [reserve]                 VARCHAR (13) NULL,
    [Active]                  BIT          NOT NULL,
    [CreateDate]              DATETIME     CONSTRAINT [DF__RXNORM_ExternalConceptFile__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_ExternalConceptFile__fileid__external_source__external_source_code] UNIQUE NONCLUSTERED ([fileid] ASC, [external_source] ASC, [external_source_code] ASC)
);

