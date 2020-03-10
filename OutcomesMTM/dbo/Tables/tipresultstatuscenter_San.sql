CREATE TABLE [dbo].[tipresultstatuscenter_San] (
    [tipresultstatuscenterID] INT      IDENTITY (1, 1) NOT NULL,
    [tipresultstatusid]       INT      NULL,
    [centerid]                INT      NULL,
    [active]                  BIT      NULL,
    [createdate]              DATETIME NULL,
    [activeenddate]           DATETIME NULL,
    PRIMARY KEY CLUSTERED ([tipresultstatuscenterID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_centerid_active]
    ON [dbo].[tipresultstatuscenter_San]([centerid] ASC, [active] ASC)
    INCLUDE([tipresultstatusid]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_tipresultstatusid_centerid]
    ON [dbo].[tipresultstatuscenter_San]([tipresultstatusid] ASC, [centerid] ASC) WITH (FILLFACTOR = 80);

