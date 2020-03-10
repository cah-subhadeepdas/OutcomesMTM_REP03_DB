CREATE TABLE [dbo].[patientPrimaryPharmacyDim] (
    [patientPrimaryPharmacyKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [patientPrimaryPharmacyID]  INT      NOT NULL,
    [patientid]                 INT      NOT NULL,
    [centerid]                  INT      NOT NULL,
    [primaryPharmacy]           BIT      NOT NULL,
    [activeAsOf]                DATETIME NOT NULL,
    [activeThru]                DATETIME NULL,
    PRIMARY KEY CLUSTERED ([patientPrimaryPharmacyKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_patientPrimaryPharmacyDim_activeasof]
    ON [dbo].[patientPrimaryPharmacyDim]([patientid] ASC, [centerid] ASC, [activeAsOf] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_patientPrimaryPharmacyDim_activethru]
    ON [dbo].[patientPrimaryPharmacyDim]([patientid] ASC, [centerid] ASC, [activeThru] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_patientPrimaryPharmacyID]
    ON [dbo].[patientPrimaryPharmacyDim]([patientPrimaryPharmacyID] ASC)
    INCLUDE([activeAsOf], [activeThru], [centerid], [patientid], [primaryPharmacy]) WITH (FILLFACTOR = 80);

