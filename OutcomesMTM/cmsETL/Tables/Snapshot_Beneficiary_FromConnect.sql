CREATE TABLE [cmsETL].[Snapshot_Beneficiary_FromConnect] (
    [BeneficiaryID]  INT            NULL,
    [ClientID]       INT            NULL,
    [ContractYear]   VARCHAR (8000) NULL,
    [BeneficiaryKey] VARCHAR (8000) NULL,
    [PatientID]      INT            NULL,
    [HICN]           VARCHAR (8000) NULL,
    [First_Name]     VARCHAR (8000) NULL,
    [MI]             VARCHAR (8000) NULL,
    [Last_Name]      VARCHAR (8000) NULL,
    [DOB]            VARCHAR (8000) NULL,
    [ActiveFromDT]   VARCHAR (8000) NULL,
    [ActiveThruDT]   VARCHAR (8000) NULL,
    [LoadDT]         DATETIME       DEFAULT (getdate()) NULL
);

