CREATE TABLE [dbo].[RXNORM_RetiredExternalConceptFile] (
    [rxxretid]               INT          IDENTITY (1, 1) NOT NULL,
    [fileid]                 INT          NOT NULL,
    [external_source_1]      VARCHAR (10) NOT NULL,
    [external_source_code_1] VARCHAR (30) NOT NULL,
    [external_source_2]      VARCHAR (10) NOT NULL,
    [external_source_code_2] VARCHAR (30) NOT NULL,
    [transaction_cd]         VARCHAR (1)  NULL,
    [version_release_start]  VARCHAR (40) NULL,
    [version_release_stop]   VARCHAR (40) NULL,
    [cardinality]            VARCHAR (4)  NULL,
    [reserve]                VARCHAR (43) NULL,
    [Active]                 BIT          NOT NULL,
    [CreateDate]             DATETIME     CONSTRAINT [DF__RXNORM_RetiredExternalConceptFile__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_RetiredExternalConceptFile__fileid__ext_src_1__ext_src_code_1__ext_src_2__ext_src_code_2] UNIQUE NONCLUSTERED ([fileid] ASC, [external_source_1] ASC, [external_source_code_1] ASC, [external_source_2] ASC, [external_source_code_2] ASC)
);

