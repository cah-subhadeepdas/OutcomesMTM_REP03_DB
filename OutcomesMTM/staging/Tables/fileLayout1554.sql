CREATE TABLE [staging].[fileLayout1554] (
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
    [row_id]                 VARCHAR (15) NULL
);

