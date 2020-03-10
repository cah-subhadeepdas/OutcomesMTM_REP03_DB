CREATE TABLE [dbo].[DxResultDim] (
    [dxresultKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [dxresultid]  BIGINT   NOT NULL,
    [DXstateid]   INT      NOT NULL,
    [patientid]   INT      NULL,
    [activeasof]  DATETIME NOT NULL,
    [activethru]  DATETIME NULL,
    [iscurrent]   BIT      NOT NULL,
    CONSTRAINT [PK___DxResultDim] PRIMARY KEY CLUSTERED ([dxresultKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_DxResultDim_activeasof]
    ON [dbo].[DxResultDim]([DXstateid] ASC, [patientid] ASC, [activeasof] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_DxResultDim_activethru]
    ON [dbo].[DxResultDim]([DXstateid] ASC, [patientid] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);

