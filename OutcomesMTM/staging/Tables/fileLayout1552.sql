CREATE TABLE [staging].[fileLayout1552] (
    [fileid]                     INT           NOT NULL,
    [external_source]            VARCHAR (10)  NOT NULL,
    [external_source_code_1]     VARCHAR (30)  NOT NULL,
    [external_source_code_2]     VARCHAR (30)  NOT NULL,
    [transaction_cd]             VARCHAR (1)   NULL,
    [relationship_type_2_to_1]   VARCHAR (4)   NULL,
    [detail_relationship_2_to_1] VARCHAR (100) NULL,
    [reserve]                    VARCHAR (49)  NULL,
    [row_id]                     VARCHAR (15)  NULL
);

