CREATE TABLE [dbo].[AdherenceMonitorQueueStaging] (
    [AdherenceMonitorQueueID]       INT      NOT NULL,
    [centerID]                      INT      NULL,
    [AdherenceMonitorID]            INT      NULL,
    [AdherenceMonitorYear]          SMALLINT NULL,
    [AdherenceMonitorQuarter]       TINYINT  NULL,
    [AdherenceMonitorQueueStatusID] SMALLINT NULL,
    [QueueStart]                    DATE     NULL,
    [QueueEnd]                      DATE     NULL,
    [claimID]                       INT      NULL,
    [ModifyDT]                      DATETIME NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[AdherenceMonitorQueueStaging]([AdherenceMonitorQueueID] ASC);

