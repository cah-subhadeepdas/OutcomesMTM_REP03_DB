CREATE TABLE [staging].[tipresultstatuscenter] (
    [tipresultstatuscenterID] INT      NOT NULL,
    [tipresultstatusid]       INT      NULL,
    [centerid]                INT      NULL,
    [active]                  BIT      NULL,
    [createdate]              DATETIME NULL,
    [activeenddate]           DATETIME NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_tipResultStatusCenter_tipResultStatusCenterID]
    ON [staging].[tipresultstatuscenter]([tipresultstatuscenterID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_tipResultStatusCenter_active_TipResultStatusID_CenterID]
    ON [staging].[tipresultstatuscenter]([active] ASC, [tipresultstatusid] ASC, [centerid] ASC);

