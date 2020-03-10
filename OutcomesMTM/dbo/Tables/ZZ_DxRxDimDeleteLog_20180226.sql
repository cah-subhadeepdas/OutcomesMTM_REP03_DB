CREATE TABLE [dbo].[ZZ_DxRxDimDeleteLog_20180226] (
    [dxrxKey]    BIGINT   NOT NULL,
    [dxrxid]     BIGINT   NOT NULL,
    [DXstateid]  INT      NOT NULL,
    [patientid]  INT      NOT NULL,
    [rxid]       BIGINT   NOT NULL,
    [activeasof] DATETIME NOT NULL,
    [activethru] DATETIME NULL,
    [iscurrent]  BIT      NOT NULL,
    CONSTRAINT [PK_DxRxDimDeleteLog] PRIMARY KEY CLUSTERED ([dxrxKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_PatientID]
    ON [dbo].[ZZ_DxRxDimDeleteLog_20180226]([patientid] ASC);

