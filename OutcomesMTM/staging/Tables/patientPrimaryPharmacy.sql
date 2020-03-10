CREATE TABLE [staging].[patientPrimaryPharmacy] (
    [patientPrimaryPharmacyID] INT             NOT NULL,
    [patientid]                INT             NULL,
    [centerid]                 INT             NULL,
    [primaryPharmacy]          BIT             NULL,
    [pctFillatCenter]          DECIMAL (20, 2) NULL,
    [pctFillatChain]           DECIMAL (20, 2) NULL,
    [changeDate]               DATETIME        NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientPrimaryPharmacy_patientID_centerID]
    ON [staging].[patientPrimaryPharmacy]([patientid] ASC, [centerid] ASC);

