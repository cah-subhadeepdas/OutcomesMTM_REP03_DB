CREATE TABLE [dbo].[diagnosisCodeRepositoryDim] (
    [diagnosisCodeRepositoryKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [diagnosisCodeKey]           BIGINT   NOT NULL,
    [repositoryArchiveID]        BIGINT   NULL,
    [fileid]                     INT      NULL,
    [activeAsOf]                 DATETIME NOT NULL,
    [activeThru]                 DATETIME NULL,
    [isCurrent]                  BIT      NOT NULL,
    PRIMARY KEY CLUSTERED ([diagnosisCodeRepositoryKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_diagnosisCodekey]
    ON [dbo].[diagnosisCodeRepositoryDim]([diagnosisCodeKey] ASC)
    INCLUDE([activeAsOf], [activeThru], [fileid], [isCurrent], [repositoryArchiveID]) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_diagnosisCodeKey_activeasof]
    ON [dbo].[diagnosisCodeRepositoryDim]([diagnosisCodeKey] ASC, [activeAsOf] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_diagnosisCodeKey_activethru]
    ON [dbo].[diagnosisCodeRepositoryDim]([diagnosisCodeKey] ASC, [activeThru] ASC)
    INCLUDE([fileid], [repositoryArchiveID]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_activethru]
    ON [dbo].[diagnosisCodeRepositoryDim]([activeThru] ASC)
    INCLUDE([diagnosisCodeKey], [fileid], [repositoryArchiveID]) WITH (FILLFACTOR = 80);

