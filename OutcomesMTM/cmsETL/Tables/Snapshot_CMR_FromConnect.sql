﻿CREATE TABLE [cmsETL].[Snapshot_CMR_FromConnect] (
    [CMRID]                        INT            NULL,
    [ClaimID]                      INT            NULL,
    [MTMServiceDT]                 VARCHAR (8000) NULL,
    [ReasonCode]                   VARCHAR (8000) NULL,
    [ActionCode]                   INT            NULL,
    [ResultCode]                   INT            NULL,
    [ClaimStatus]                  VARCHAR (8000) NULL,
    [ClaimStatusDT]                VARCHAR (8000) NULL,
    [PatientID]                    INT            NULL,
    [PharmacyID]                   INT            NULL,
    [NCPDP_NABP]                   VARCHAR (8000) NULL,
    [CMRWithSPT]                   VARCHAR (8000) NULL,
    [CMROffer]                     VARCHAR (8000) NULL,
    [CMRID_Source]                 VARCHAR (8000) NULL,
    [CognitivelyImpairedIndicator] VARCHAR (8000) NULL,
    [MethodOfDeliveryCode]         VARCHAR (8000) NULL,
    [ProviderCode]                 VARCHAR (8000) NULL,
    [RecipientCode]                VARCHAR (8000) NULL,
    [AuthorizedRepresentative]     VARCHAR (8000) NULL,
    [Topic01]                      VARCHAR (8000) NULL,
    [Topic02]                      VARCHAR (8000) NULL,
    [Topic03]                      VARCHAR (8000) NULL,
    [Topic04]                      VARCHAR (8000) NULL,
    [Topic05]                      VARCHAR (8000) NULL,
    [MAPCount]                     INT            NULL,
    [SPTDate]                      VARCHAR (8000) NULL,
    [LTC]                          VARCHAR (8000) NULL,
    [ClientID]                     INT            NULL,
    [ContractYear]                 VARCHAR (4)    NULL,
    [LoadDT]                       DATETIME       NULL,
    [SPTReturnDate]                VARCHAR (8000) NULL,
    [CMRSuccess]                   VARCHAR (8000) NULL,
    [CMRRecipientRationale]        VARCHAR (8000) NULL
);

