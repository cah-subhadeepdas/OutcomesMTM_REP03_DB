CREATE TABLE [dbo].[prescriptionRepositoryDim] (
    [prescriptionRepositoryKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [prescriptionKey]           BIGINT   NOT NULL,
    [repositoryArchiveID]       BIGINT   NULL,
    [fileid]                    INT      NULL,
    [activeAsOf]                DATETIME NOT NULL,
    [activeThru]                DATETIME NULL,
    [isCurrent]                 BIT      NOT NULL,
    PRIMARY KEY CLUSTERED ([prescriptionRepositoryKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_prescriptionKey_activeasof]
    ON [dbo].[prescriptionRepositoryDim]([prescriptionKey] ASC, [activeAsOf] ASC)
    INCLUDE([fileid], [repositoryArchiveID]) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_prescriptionKey_activethru]
    ON [dbo].[prescriptionRepositoryDim]([prescriptionKey] ASC, [activeThru] ASC)
    INCLUDE([fileid], [repositoryArchiveID]) WITH (FILLFACTOR = 80);

