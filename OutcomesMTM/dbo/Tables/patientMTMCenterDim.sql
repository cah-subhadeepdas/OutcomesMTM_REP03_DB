CREATE TABLE [dbo].[patientMTMCenterDim] (
    [patientMTMCenterKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [patientmtmcenterID]  INT      NOT NULL,
    [patientid]           INT      NOT NULL,
    [centerid]            INT      NOT NULL,
    [primaryPharmacy]     BIT      NULL,
    [activeasof]          DATETIME NOT NULL,
    [activethru]          DATETIME NULL,
    PRIMARY KEY CLUSTERED ([patientMTMCenterKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UK_patientMTMCenterDim_activeasof]
    ON [dbo].[patientMTMCenterDim]([patientid] ASC, [centerid] ASC, [activeasof] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [UK_patientMTMCenterDim_activethru]
    ON [dbo].[patientMTMCenterDim]([patientid] ASC, [centerid] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_patientmtmcenterID]
    ON [dbo].[patientMTMCenterDim]([patientmtmcenterID] ASC)
    INCLUDE([patientid], [centerid], [primaryPharmacy], [activeasof], [activethru]) WITH (FILLFACTOR = 80);

