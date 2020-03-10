CREATE TABLE [staging].[CMS_DTP_STG] (
    [PatientID]         INT           NULL,
    [ClientID]          INT           NULL,
    [ContractYear]      VARCHAR (4)   NULL,
    [ClaimID]           INT           NULL,
    [mtmServiceDT]      DATETIME      NULL,
    [ReasonCode]        INT           NULL,
    [ActionCode]        INT           NULL,
    [ResultCode]        INT           NULL,
    [ClaimStatus]       VARCHAR (50)  NULL,
    [ClaimStatusDT]     DATETIME      NULL,
    [PharmacyNABP]      VARCHAR (50)  NULL,
    [DTPRecommendation] INT           NULL,
    [GPI]               VARCHAR (100) NULL,
    [MedName]           VARCHAR (300) NULL,
    [SuccessfulResult]  INT           NULL,
    [DataSetTypeID]     INT           NULL
);

