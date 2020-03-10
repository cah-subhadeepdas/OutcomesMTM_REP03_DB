CREATE TABLE [dbo].[ZZ_diagnosisCodeDim] (
    [diagnosisCodeKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [diagnosisCodeID]  BIGINT   NOT NULL,
    [PatientID]        INT      NOT NULL,
    [ICDCodeID]        INT      NOT NULL,
    [diagnosisDate]    DATE     NOT NULL,
    [prid]             BIGINT   NULL,
    [active]           BIT      NOT NULL,
    [activeAsOf]       DATETIME NOT NULL,
    [activeThru]       DATETIME NULL,
    [isCurrent]        BIT      NOT NULL,
    CONSTRAINT [PK__diagnosisCodeDim] PRIMARY KEY CLUSTERED ([diagnosisCodeKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_diagnosisCodeDIM_activeasof]
    ON [dbo].[ZZ_diagnosisCodeDim]([PatientID] ASC, [ICDCodeID] ASC, [diagnosisDate] ASC, [activeAsOf] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_diagnosisCodeDIM_activethru]
    ON [dbo].[ZZ_diagnosisCodeDim]([PatientID] ASC, [ICDCodeID] ASC, [diagnosisDate] ASC, [activeThru] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_diagnosisCodeID]
    ON [dbo].[ZZ_diagnosisCodeDim]([diagnosisCodeID] ASC)
    INCLUDE([active], [activeAsOf], [activeThru], [diagnosisCodeKey], [diagnosisDate], [ICDCodeID], [isCurrent], [PatientID], [prid]) WITH (FILLFACTOR = 80);

