CREATE TABLE [dbo].[AdherenceMonitorQueueStatusStaging] (
    [AdherenceMonitorQueueStatusID]          SMALLINT       NOT NULL,
    [AdherenceMonitorQueueStatus]            VARCHAR (100)  NOT NULL,
    [AdherenceMonitorQueueStatusDescription] VARCHAR (1000) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[AdherenceMonitorQueueStatusStaging]([AdherenceMonitorQueueStatusID] ASC);

