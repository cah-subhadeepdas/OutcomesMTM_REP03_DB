CREATE TABLE [cmsETL].[tmr_2019] (
    [PatientID] INT  NULL,
    [ClientID]  INT  NULL,
    [TMRDate]   DATE NULL
);


GO
CREATE CLUSTERED INDEX [IX_tmr_2019]
    ON [cmsETL].[tmr_2019]([PatientID] ASC, [ClientID] ASC, [TMRDate] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_tmr_2019_patient_clientid]
    ON [cmsETL].[tmr_2019]([ClientID] ASC, [PatientID] ASC);

