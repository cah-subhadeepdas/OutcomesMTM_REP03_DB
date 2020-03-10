CREATE TABLE [dbo].[RXNORM_ExternalCodeRelationships] (
    [rxxexrelid]                 INT           IDENTITY (1, 1) NOT NULL,
    [fileid]                     INT           NOT NULL,
    [external_source]            VARCHAR (10)  NOT NULL,
    [external_source_code_1]     VARCHAR (30)  NOT NULL,
    [external_source_code_2]     VARCHAR (30)  NOT NULL,
    [transaction_cd]             VARCHAR (1)   NULL,
    [relationship_type_2_to_1]   VARCHAR (4)   NULL,
    [detail_relationship_2_to_1] VARCHAR (100) NULL,
    [reserve]                    VARCHAR (49)  NULL,
    [Active]                     BIT           NOT NULL,
    [CreateDate]                 DATETIME      CONSTRAINT [DF__RXNORM_ExternalCodeRelationships__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_ExternalCodeRelationships__fileid__ext_src__ext_src_code_1__ext_src_code_2] UNIQUE NONCLUSTERED ([fileid] ASC, [external_source] ASC, [external_source_code_1] ASC, [external_source_code_2] ASC)
);

