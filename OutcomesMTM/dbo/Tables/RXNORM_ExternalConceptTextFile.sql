CREATE TABLE [dbo].[RXNORM_ExternalConceptTextFile] (
    [rxxextxtid]               INT           IDENTITY (1, 1) NOT NULL,
    [fileid]                   INT           NOT NULL,
    [external_source]          VARCHAR (10)  NOT NULL,
    [external_source_code]     VARCHAR (30)  NOT NULL,
    [text_line_sequence]       INT           NOT NULL,
    [transaction_cd]           VARCHAR (1)   NULL,
    [representative_text_desc] VARCHAR (100) NULL,
    [reserve]                  VARCHAR (49)  NULL,
    [Active]                   BIT           NOT NULL,
    [CreateDate]               DATETIME      CONSTRAINT [DF__RXNORM_ExternalConceptTextFile__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_ExternalConceptTextFile__fileid__external_source__external_source_code__text_line_sequence] UNIQUE NONCLUSTERED ([fileid] ASC, [external_source] ASC, [external_source_code] ASC, [text_line_sequence] ASC)
);

