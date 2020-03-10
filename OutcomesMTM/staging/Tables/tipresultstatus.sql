CREATE TABLE [staging].[tipresultstatus] (
    [tipresultstatusid] INT      NOT NULL,
    [tipresultid]       INT      NULL,
    [tipstatusid]       INT      NULL,
    [active]            BIT      NULL,
    [createdate]        DATETIME NULL,
    [activeenddate]     DATETIME NULL,
    [claimID]           BIGINT   NULL,
    [tipOpportunityID]  BIGINT   NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_tipResultStatus_tipResultStatusID]
    ON [staging].[tipresultstatus]([tipresultstatusid] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_tipResultStatus_active_tipresultid_tipstatusid]
    ON [staging].[tipresultstatus]([active] ASC, [tipresultid] ASC, [tipstatusid] ASC);

