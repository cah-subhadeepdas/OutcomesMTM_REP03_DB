CREATE TABLE [dbo].[AdherenceMonitorQueue] (
    [AdherenceMonitorQueueID]       INT      NOT NULL,
    [centerID]                      INT      NULL,
    [AdherenceMonitorID]            INT      NULL,
    [AdherenceMonitorYear]          SMALLINT NULL,
    [AdherenceMonitorQuarter]       TINYINT  NULL,
    [AdherenceMonitorQueueStatusID] SMALLINT NULL,
    [QueueStart]                    DATE     NULL,
    [QueueEnd]                      DATE     NULL,
    [claimID]                       INT      NULL,
    [ModifyDT]                      DATETIME NULL,
    PRIMARY KEY CLUSTERED ([AdherenceMonitorQueueID] ASC) WITH (FILLFACTOR = 80)
);

