CREATE TABLE [staging].[fileLayout1544] (
    [fileid]                  INT          NOT NULL,
    [field_identifier]        VARCHAR (4)  NOT NULL,
    [field_description]       VARCHAR (35) NULL,
    [field_type]              VARCHAR (1)  NULL,
    [field_length]            INT          NULL,
    [implied_decimal_flag]    VARCHAR (1)  NULL,
    [decimal_places]          INT          NULL,
    [field_validation_flag]   VARCHAR (1)  NULL,
    [field_abbreviation_flag] VARCHAR (1)  NULL,
    [reserve]                 VARCHAR (16) NULL,
    [row_id]                  VARCHAR (15) NULL
);

