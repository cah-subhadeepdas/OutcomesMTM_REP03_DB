CREATE TABLE [dbo].[ReportTracker] (
    [JobID]                      UNIQUEIDENTIFIER NULL,
    [JobName]                    NVARCHAR (128)   NULL,
    [LastRunDateTime]            DATETIME         NULL,
    [LastRunStatus]              VARCHAR (9)      NULL,
    [LastRunDuration (HH:MM:SS)] VARCHAR (8)      NULL,
    [LastRunStatusMessage]       NVARCHAR (4000)  NULL,
    [NextRunDateTime]            DATETIME         NULL
);

