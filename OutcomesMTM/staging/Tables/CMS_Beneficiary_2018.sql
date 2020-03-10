CREATE TABLE [staging].[CMS_Beneficiary_2018] (
    [PatientID]      INT          NULL,
    [BeneficiaryID]  INT          NULL,
    [ClientID]       INT          NULL,
    [ContractYear]   VARCHAR (4)  NULL,
    [BeneficiaryKey] VARCHAR (50) NULL,
    [HICN]           VARCHAR (15) NULL,
    [First_Name]     VARCHAR (30) NULL,
    [MI]             VARCHAR (1)  NULL,
    [Last_Name]      VARCHAR (30) NULL,
    [DOB]            DATE         NULL,
    [ActiveFromDT]   DATETIME     NULL,
    [ActiveThruDT]   DATETIME     NULL,
    [ranker]         BIGINT       NULL,
    [DataSetTypeID]  INT          NULL
);

