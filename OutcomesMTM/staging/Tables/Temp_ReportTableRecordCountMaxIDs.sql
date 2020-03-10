CREATE TABLE [staging].[Temp_ReportTableRecordCountMaxIDs] (
    [RTRCMID_ID] INT          IDENTITY (1, 1) NOT NULL,
    [TableName]  VARCHAR (75) NULL,
    [MaxID]      BIGINT       NULL,
    [RunDate]    DATE         NULL
);

