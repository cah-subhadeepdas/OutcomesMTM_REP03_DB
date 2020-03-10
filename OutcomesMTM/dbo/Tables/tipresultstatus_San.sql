CREATE TABLE [dbo].[tipresultstatus_San] (
    [tipresultstatusid] INT      IDENTITY (1, 1) NOT NULL,
    [tipresultid]       INT      NULL,
    [tipstatusid]       INT      NULL,
    [active]            BIT      NULL,
    [createdate]        DATETIME NULL,
    [activeenddate]     DATETIME NULL,
    [claimID]           BIGINT   NULL,
    [tipOpportunityID]  BIGINT   NOT NULL,
    PRIMARY KEY CLUSTERED ([tipresultstatusid] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_claimid]
    ON [dbo].[tipresultstatus_San]([claimID] ASC)
    INCLUDE([tipOpportunityID]) WITH (FILLFACTOR = 80);

