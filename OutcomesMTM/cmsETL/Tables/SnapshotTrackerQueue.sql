CREATE TABLE [cmsETL].[SnapshotTrackerQueue] (
    [id]                INT      IDENTITY (1, 1) NOT NULL,
    [SFRQueueid]        INT      NULL,
    [clientid]          INT      NULL,
    [contractyear]      INT      NULL,
    [Snapshotid]        INT      NULL,
    [OverwriteSnapshot] CHAR (1) NULL
);

