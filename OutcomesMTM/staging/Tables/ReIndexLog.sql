CREATE TABLE [staging].[ReIndexLog] (
    [id]                           INT             NULL,
    [database_name]                VARCHAR (1000)  NULL,
    [object_name]                  VARCHAR (1000)  NULL,
    [schema_name]                  VARCHAR (1000)  NULL,
    [object_desc]                  VARCHAR (1000)  NULL,
    [index_name]                   VARCHAR (1000)  NULL,
    [index_desc]                   VARCHAR (1000)  NULL,
    [avg_fragmentation_in_percent] DECIMAL (20, 2) NULL,
    [is_disabled]                  INT             NULL,
    [rundate]                      DATETIME        NULL,
    [action_taken]                 VARCHAR (1000)  NULL,
    [action_Start]                 DATETIME        NULL,
    [action_end]                   DATETIME        NULL,
    [record_count]                 BIGINT          NULL,
    [table_size_MB]                INT             NULL,
    [index_size_MB]                INT             NULL,
    [SQL_Command]                  VARCHAR (8000)  NULL
);

