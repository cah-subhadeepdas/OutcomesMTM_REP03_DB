CREATE TABLE [dbo].[DxRxDim] (
    [dxrxKey]    BIGINT   IDENTITY (1, 1) NOT NULL,
    [dxrxid]     BIGINT   NOT NULL,
    [DXstateid]  INT      NOT NULL,
    [patientid]  INT      NOT NULL,
    [rxid]       BIGINT   NOT NULL,
    [activeasof] DATETIME NOT NULL,
    [activethru] DATETIME NULL,
    [iscurrent]  BIT      NOT NULL,
    CONSTRAINT [PK___DxRxDim] PRIMARY KEY CLUSTERED ([dxrxKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_dxstateID_PatientID_RXID_activeasof]
    ON [dbo].[DxRxDim]([DXstateid] ASC, [patientid] ASC, [rxid] ASC, [activeasof] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_dxstateID_PatientID_RXID_activethru]
    ON [dbo].[DxRxDim]([DXstateid] ASC, [patientid] ASC, [rxid] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_patientid_dxrxid]
    ON [dbo].[DxRxDim]([patientid] ASC, [dxrxKey] ASC) WITH (FILLFACTOR = 80);

