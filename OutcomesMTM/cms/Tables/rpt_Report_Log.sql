﻿CREATE TABLE [cms].[rpt_Report_Log] (
    [ReportLogID]                      INT          IDENTITY (1, 1) NOT NULL,
    [BatchID]                          INT          NOT NULL,
    [ReportID]                         INT          NOT NULL,
    [ClientID]                         INT          NULL,
    [BeneficiaryID]                    INT          NULL,
    [BeneficiaryKey]                   VARCHAR (50) NULL,
    [ContractNumber]                   CHAR (5)     NULL,
    [HICN]                             VARCHAR (15) NULL,
    [FirstName]                        CHAR (30)    NULL,
    [MI]                               CHAR (1)     NULL,
    [LastName]                         CHAR (30)    NULL,
    [DOB]                              DATE         NULL,
    [MTMPCriteriaMet]                  CHAR (1)     NULL,
    [MTMPEnrollmentFromDate]           DATE         NULL,
    [MTMPEnrollmentThruDate]           DATE         NULL,
    [MTMPTargetingDate]                DATE         NULL,
    [OptOutDate]                       DATE         NULL,
    [OptOutReasonCode]                 CHAR (2)     NULL,
    [CMROffered]                       CHAR (1)     NULL,
    [CMROfferDate]                     DATE         NULL,
    [CMRReceived]                      CHAR (1)     NULL,
    [CMR_Count]                        INT          NULL,
    [CMR_CognitivelyImpairedIndicator] CHAR (1)     NULL,
    [CMR_MethodOfDeliveryCode]         CHAR (2)     NULL,
    [CMR_ProviderCode]                 CHAR (2)     NULL,
    [CMR_RecipientCode]                CHAR (2)     NULL,
    [CMR_Date1]                        DATE         NULL,
    [CMR_Date2]                        DATE         NULL,
    [CMR_Date3]                        DATE         NULL,
    [CMR_Date4]                        DATE         NULL,
    [CMR_Date5]                        DATE         NULL,
    [CMR_Topic1]                       VARCHAR (75) NULL,
    [CMR_Topic2]                       VARCHAR (75) NULL,
    [CMR_Topic3]                       VARCHAR (75) NULL,
    [CMR_Topic4]                       VARCHAR (75) NULL,
    [CMR_Topic5]                       VARCHAR (75) NULL,
    [TMR_Count]                        INT          NULL,
    [DTPR_Count]                       INT          NULL,
    [DTPC_Count]                       INT          NULL,
    [RptFromDT]                        DATE         NULL,
    [RptThruDT]                        DATE         NULL,
    [CMROfferRecipientCode]            CHAR (2)     NULL,
    [LTCIndicator]                     CHAR (1)     NULL,
    [CMR_SPTSentDate]                  DATE         NULL,
    [TMR_Date1]                        DATE         NULL,
    PRIMARY KEY CLUSTERED ([ReportLogID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__rpt_Report_Log__BatchID]
    ON [cms].[rpt_Report_Log]([BatchID] ASC);

