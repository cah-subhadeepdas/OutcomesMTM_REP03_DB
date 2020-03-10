CREATE TABLE [dbo].[patientRepositoryDim] (
    [patientRepositoryKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [patientKey]           BIGINT   NOT NULL,
    [repositoryArchiveID]  BIGINT   NULL,
    [fileid]               INT      NULL,
    [activeAsOf]           DATETIME NOT NULL,
    [activeThru]           DATETIME NULL,
    [isCurrent]            BIT      NOT NULL,
    PRIMARY KEY CLUSTERED ([patientRepositoryKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_patientKey_activeasof]
    ON [dbo].[patientRepositoryDim]([patientKey] ASC, [activeAsOf] ASC)
    INCLUDE([repositoryArchiveID], [fileid]) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_patientKey_activethru]
    ON [dbo].[patientRepositoryDim]([patientKey] ASC, [activeThru] ASC)
    INCLUDE([repositoryArchiveID], [fileid]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_patientKey]
    ON [dbo].[patientRepositoryDim]([patientKey] ASC)
    INCLUDE([repositoryArchiveID], [fileid], [activeAsOf], [activeThru], [isCurrent]) WITH (FILLFACTOR = 80);

