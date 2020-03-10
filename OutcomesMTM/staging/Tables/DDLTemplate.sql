CREATE TABLE [staging].[DDLTemplate] (
    [table_catalog]    VARCHAR (8000) NULL,
    [table_schema]     VARCHAR (8000) NULL,
    [table_name]       VARCHAR (8000) NULL,
    [column_name]      VARCHAR (8000) NULL,
    [ordinal_position] SMALLINT       NULL,
    [data_type]        VARCHAR (100)  NULL,
    [primary_key]      VARCHAR (100)  NULL,
    [column_default]   VARCHAR (8000) NULL,
    [is_nullable]      VARCHAR (8)    NULL
);

