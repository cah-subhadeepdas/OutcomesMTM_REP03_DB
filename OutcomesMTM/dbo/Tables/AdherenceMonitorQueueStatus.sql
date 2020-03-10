CREATE TABLE [dbo].[AdherenceMonitorQueueStatus] (
    [AdherenceMonitorQueueStatusID]          SMALLINT       NOT NULL,
    [AdherenceMonitorQueueStatus]            VARCHAR (100)  NOT NULL,
    [AdherenceMonitorQueueStatusDescription] VARCHAR (1000) NOT NULL,
    PRIMARY KEY CLUSTERED ([AdherenceMonitorQueueStatusID] ASC) WITH (FILLFACTOR = 80)
);

