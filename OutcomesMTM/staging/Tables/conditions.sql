CREATE TABLE [staging].[conditions] (
    [conditionid]     INT           NOT NULL,
    [dxid]            VARCHAR (50)  NULL,
    [conditionNM]     VARCHAR (200) NOT NULL,
    [conditiontypeID] INT           NOT NULL,
    [display]         BIT           NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_Conditions_conditionID_DXID]
    ON [staging].[conditions]([conditionid] ASC, [dxid] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [UNC_Conditions_conditiontypeID]
    ON [staging].[conditions]([conditiontypeID] ASC) WITH (FILLFACTOR = 100);

