CREATE TABLE [staging].[DxRxLog_temp] (
    [identificationRunID] INT    NULL,
    [patientID]           INT    NULL,
    [dxstateid]           INT    NULL,
    [rxid]                BIGINT NULL
);


GO
CREATE CLUSTERED INDEX [IDX]
    ON [staging].[DxRxLog_temp]([patientID] ASC, [identificationRunID] ASC, [dxstateid] ASC, [rxid] ASC);

