CREATE TABLE [dbo].[prescriptionDimDataLog] (
    [prescriptionDataLogID] INT          IDENTITY (1, 1) NOT NULL,
    [queueorder]            INT          NULL,
    [operation]             VARCHAR (50) NULL,
    [batchDate]             DATE         NULL,
    [startDate]             DATETIME     NULL,
    [endDate]               DATETIME     NULL,
    [recordCount]           BIGINT       NULL
);

