CREATE TABLE [staging].[DxStates] (
    [dxid]      UNIQUEIDENTIFIER NOT NULL,
    [dxTitle]   NVARCHAR (50)    NULL,
    [expired]   BIT              NOT NULL,
    [createDT]  SMALLDATETIME    NOT NULL,
    [dxStateID] INT              NOT NULL
);

