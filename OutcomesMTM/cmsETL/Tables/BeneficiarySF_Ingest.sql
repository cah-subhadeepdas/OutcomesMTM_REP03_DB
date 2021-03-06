﻿CREATE TABLE [cmsETL].[BeneficiarySF_Ingest] (
    [OMTM_ID]                   INT            NOT NULL,
    [ClientName]                VARCHAR (8000) NULL,
    [MemberID]                  VARCHAR (8000) NULL,
    [FirstName]                 VARCHAR (8000) NULL,
    [MiddleInitial]             VARCHAR (8000) NULL,
    [LastName]                  VARCHAR (8000) NULL,
    [DOB]                       VARCHAR (8000) NULL,
    [HICN_MBI]                  VARCHAR (8000) NULL,
    [ContractNumber]            VARCHAR (8000) NULL,
    [MTMPEnrollmentStartDate]   VARCHAR (8000) NULL,
    [MTMPTargetingDate]         VARCHAR (8000) NULL,
    [OptOutDate]                VARCHAR (8000) NULL,
    [OptOutReasonCode]          VARCHAR (8000) NULL,
    [BeneficiaryMatchCheck]     VARCHAR (8000) NULL,
    [ValidationCheck]           VARCHAR (8000) NULL,
    [ActionRequiredOnCheck]     VARCHAR (8000) NULL,
    [BeneficiaryMatch_OMTM_IDs] VARCHAR (8000) NULL,
    [SelectMasterOMTM_ID]       VARCHAR (8000) NULL,
    [RemoveMember]              VARCHAR (8000) NULL,
    [Filename]                  VARCHAR (8000) NULL,
    [LoadDate]                  DATETIME       DEFAULT (getdate()) NOT NULL
);

