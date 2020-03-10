CREATE TABLE [cms].[rpt_DTP_Log] (
    [DTPLogID]               INT           IDENTITY (1, 1) NOT NULL,
    [BatchID]                INT           NOT NULL,
    [BeneficiaryID]          INT           NULL,
    [ContractNumber]         VARCHAR (5)   NULL,
    [MTMPEnrollmentFromDate] DATE          NULL,
    [MTMPEnrollmentThruDate] DATE          NULL,
    [ClaimID]                INT           NULL,
    [MTMServiceDT]           DATE          NULL,
    [GPI]                    VARCHAR (14)  NULL,
    [MedName]                VARCHAR (100) NULL,
    [ReasonCode]             CHAR (3)      NULL,
    [ActionCode]             CHAR (3)      NULL,
    [ResultCode]             CHAR (3)      NULL,
    [ClaimStatus]            VARCHAR (50)  NULL,
    [ClaimStatusDT]          DATETIME      NULL,
    [PatientID]              INT           NULL,
    [DTPRecommendation]      BIT           NULL,
    [DTPResolution]          BIT           NULL,
    PRIMARY KEY CLUSTERED ([DTPLogID] ASC)
);

