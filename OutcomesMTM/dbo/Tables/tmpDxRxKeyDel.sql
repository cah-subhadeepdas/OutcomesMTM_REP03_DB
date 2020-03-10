CREATE TABLE [dbo].[tmpDxRxKeyDel] (
    [id]      INT    IDENTITY (1, 1) NOT NULL,
    [dxrxKey] BIGINT NULL
);


GO
CREATE CLUSTERED INDEX [CL_dxrxKey]
    ON [dbo].[tmpDxRxKeyDel]([dxrxKey] ASC);

