CREATE TABLE [staging].[fileLayout1547] (
    [fileid]                  INT          NOT NULL,
    [external_source]         VARCHAR (10) NOT NULL,
    [external_source_code]    VARCHAR (30) NOT NULL,
    [transaction_cd]          VARCHAR (1)  NULL,
    [umls_concept_identifier] VARCHAR (12) NULL,
    [external_type]           VARCHAR (10) NULL,
    [external_source_set]     VARCHAR (10) NULL,
    [rxnorm_code]             VARCHAR (10) NULL,
    [reserve]                 VARCHAR (13) NULL,
    [row_id]                  VARCHAR (15) NULL
);

