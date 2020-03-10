CREATE TABLE [cms].[rpt_CMROffer_Log] (
    [CMROfferLogID]          INT         IDENTITY (1, 1) NOT NULL,
    [BatchID]                INT         NOT NULL,
    [BeneficiaryID]          INT         NULL,
    [ContractNumber]         VARCHAR (5) NULL,
    [MTMPEnrollmentFromDate] DATE        NULL,
    [MTMPEnrollmentThruDate] DATE        NULL,
    [PatientID]              INT         NULL,
    [CMROfferDate]           DATE        NULL,
    [CMROfferID]             INT         NULL,
    [ClaimID]                INT         NULL,
    [RptRank]                TINYINT     NULL,
    [CMROfferRecipientCode]  CHAR (2)    NULL,
    PRIMARY KEY CLUSTERED ([CMROfferLogID] ASC)
);

