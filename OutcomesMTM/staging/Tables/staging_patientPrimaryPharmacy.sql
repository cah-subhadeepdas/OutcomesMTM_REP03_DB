CREATE TABLE [staging].[staging_patientPrimaryPharmacy] (
    [patientPrimaryPharmacyID] INT             NOT NULL,
    [patientid]                INT             NULL,
    [centerid]                 INT             NULL,
    [primaryPharmacy]          BIT             NULL,
    [pctFillatCenter]          DECIMAL (20, 2) NULL,
    [pctFillatChain]           DECIMAL (20, 2) NULL,
    [changeDate]               DATETIME        NULL
);

