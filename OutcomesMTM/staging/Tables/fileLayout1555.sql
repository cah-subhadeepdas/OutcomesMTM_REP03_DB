CREATE TABLE [staging].[fileLayout1555] (
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
    [row_id]                  VARCHAR (15) NULL
);

