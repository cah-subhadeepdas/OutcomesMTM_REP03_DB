CREATE TABLE [staging].[fileLayout1549] (
    [fileid]                  INT          NOT NULL,
    [external_source]         VARCHAR (10) NULL,
    [external_source_code]    VARCHAR (30) NULL,
    [concept_type_id]         INT          NULL,
    [concept_value]           VARCHAR (20) NULL,
    [transaction_cd]          VARCHAR (1)  NULL,
    [match_type]              VARCHAR (2)  NULL,
    [umls_concept_identifier] VARCHAR (12) NULL,
    [rxnorm_code]             VARCHAR (10) NULL,
    [reserve]                 VARCHAR (22) NULL,
    [row_id]                  VARCHAR (15) NULL
);

