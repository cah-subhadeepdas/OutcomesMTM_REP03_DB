CREATE TABLE [staging].[fileLayout1548] (
    [fileid]                   INT           NOT NULL,
    [external_source]          VARCHAR (10)  NOT NULL,
    [external_source_code]     VARCHAR (30)  NOT NULL,
    [text_line_sequence]       INT           NOT NULL,
    [transaction_cd]           VARCHAR (1)   NULL,
    [representative_text_desc] VARCHAR (100) NULL,
    [reserve]                  VARCHAR (49)  NULL,
    [row_id]                   VARCHAR (15)  NULL
);

