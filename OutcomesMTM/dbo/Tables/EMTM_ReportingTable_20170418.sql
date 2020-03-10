﻿CREATE TABLE [dbo].[EMTM_ReportingTable_20170418] (
    [RecordID]                   INT           IDENTITY (1, 1) NOT NULL,
    [ParentRecordID]             INT           NULL,
    [SourceClaimID]              INT           NULL,
    [SourceReasonCode]           INT           NULL,
    [SourceActionCode]           INT           NULL,
    [SourceResultCode]           INT           NULL,
    [SourceCurrentEncounterCode] INT           NULL,
    [SourceStatus]               VARCHAR (50)  NULL,
    [SourceCreateDT]             DATETIME      NULL,
    [SourceChangeDT]             DATETIME      NULL,
    [EMTM_RecordID]              INT           NULL,
    [EncounterVersion]           INT           NULL,
    [CMSContractID]              VARCHAR (5)   NULL,
    [PBPID]                      CHAR (3)      NULL,
    [HICN]                       VARCHAR (12)  NULL,
    [EncounterSequence]          INT           NULL,
    [EncounterDate]              DATE          NULL,
    [EncounterCode]              VARCHAR (18)  NULL,
    [EncounterCodeDesc]          VARCHAR (100) NULL,
    [ProviderID]                 VARCHAR (10)  NULL,
    [ProviderType]               VARCHAR (10)  NULL,
    [OtherProviderTypeDesc]      VARCHAR (100) NULL,
    [ServiceLocation]            VARCHAR (6)   NULL,
    [DrugID01]                   INT           NULL,
    [DrugID02]                   INT           NULL,
    [DrugID03]                   INT           NULL,
    [DrugID04]                   INT           NULL,
    [DrugID05]                   INT           NULL,
    [DrugID06]                   INT           NULL,
    [DrugID07]                   INT           NULL,
    [DrugID08]                   INT           NULL,
    [DrugID09]                   INT           NULL,
    [DrugID10]                   INT           NULL,
    [DMEPOS]                     VARCHAR (5)   NULL,
    [INCENTIVE]                  VARCHAR (100) NULL,
    [CostShrAmt]                 MONEY         NULL,
    [HumanaSourceMemberID]       VARCHAR (30)  NULL,
    [HumanaSourcePlatformCode]   VARCHAR (2)   NULL,
    [HumanaIDCardMemberID]       VARCHAR (12)  NULL,
    [CreateDt]                   DATETIME      CONSTRAINT [DF_EMTM_ReportingTable_20170418_CreateDT] DEFAULT (getdate()) NOT NULL,
    [UpdatedField]               VARCHAR (MAX) NULL,
    [ChangeDt]                   DATETIME      NULL,
    [IsCurrent]                  BIT           CONSTRAINT [DF_EMTM_ReportingTable_20170418_IsCurrent] DEFAULT ((1)) NULL,
    [HasError]                   BIT           CONSTRAINT [DF_EMTM_ReportingTable_20170418_HasError] DEFAULT ((0)) NULL,
    [ErrorCorrected]             BIT           CONSTRAINT [DF_EMTM_ReportingTable_20170418_ErrorCorrected] DEFAULT ((0)) NULL,
    [IsExported]                 BIT           NULL,
    [ExportFileName]             VARCHAR (100) NULL,
    [ExportFileDate]             DATETIME      NULL,
    CONSTRAINT [PK_EMTM_ReportingTable_20170418] PRIMARY KEY CLUSTERED ([RecordID] ASC)
);

