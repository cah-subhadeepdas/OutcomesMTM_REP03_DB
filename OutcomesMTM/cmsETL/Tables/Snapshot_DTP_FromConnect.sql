CREATE TABLE [cmsETL].[Snapshot_DTP_FromConnect] (
    [ClaimID]           INT            NOT NULL,
    [MTMServiceDT]      DATETIME       NOT NULL,
    [ReasonCode]        INT            NOT NULL,
    [ActionCode]        INT            NOT NULL,
    [ResultCode]        INT            NOT NULL,
    [ClaimStatus]       VARCHAR (8000) NOT NULL,
    [ClaimStatusDT]     DATETIME       NULL,
    [PatientID]         INT            NOT NULL,
    [PharmacyID]        INT            NULL,
    [NCPDP_NABP]        VARCHAR (8000) NULL,
    [DTPRecommendation] BIT            NOT NULL,
    [GPI]               VARCHAR (8000) NULL,
    [MedName]           VARCHAR (8000) NULL,
    [SuccessfulResult]  BIT            NOT NULL,
    [ClientID]          INT            NULL,
    [ContractYear]      VARCHAR (4)    NULL,
    [LoadDT]            DATETIME       DEFAULT (getdate()) NULL
);

