CREATE TABLE [dbo].[patientAdditionalInfoDim] (
    [PatientAdditionalInfoKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [PatientAdditionalInfoID]  INT      NOT NULL,
    [patientid]                INT      NOT NULL,
    [additionalinfoxml]        XML      NOT NULL,
    [activeAsOf]               DATETIME NOT NULL,
    [activeThru]               DATETIME NULL,
    [isCurrent]                BIT      NOT NULL,
    CONSTRAINT [PK_patientAdditionalInfoDim] PRIMARY KEY CLUSTERED ([PatientAdditionalInfoKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_patientAdditionalInfoDIM_activeasof]
    ON [dbo].[patientAdditionalInfoDim]([patientid] ASC, [activeAsOf] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_patientAdditionalInfoDIM_activethru]
    ON [dbo].[patientAdditionalInfoDim]([patientid] ASC, [activeThru] ASC) WITH (FILLFACTOR = 80);

