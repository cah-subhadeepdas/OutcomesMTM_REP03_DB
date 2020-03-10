CREATE TABLE [dbo].[ZZ_DxRxDim_old_20180226] (
    [dxrxKey]    BIGINT   IDENTITY (1, 1) NOT NULL,
    [dxrxid]     BIGINT   NOT NULL,
    [DXstateid]  INT      NOT NULL,
    [patientid]  INT      NOT NULL,
    [rxid]       BIGINT   NOT NULL,
    [activeasof] DATETIME NOT NULL,
    [activethru] DATETIME NULL,
    [iscurrent]  BIT      NOT NULL,
    CONSTRAINT [PK___DxRxDim_old] PRIMARY KEY CLUSTERED ([dxrxKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_dxstateID_PatientID_RXID_activeasof_old]
    ON [dbo].[ZZ_DxRxDim_old_20180226]([DXstateid] ASC, [patientid] ASC, [rxid] ASC, [activeasof] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_dxstateID_PatientID_RXID_activethru_old]
    ON [dbo].[ZZ_DxRxDim_old_20180226]([DXstateid] ASC, [patientid] ASC, [rxid] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_patientid_dxrxid_old]
    ON [dbo].[ZZ_DxRxDim_old_20180226]([patientid] ASC, [dxrxKey] ASC) WITH (FILLFACTOR = 80);

