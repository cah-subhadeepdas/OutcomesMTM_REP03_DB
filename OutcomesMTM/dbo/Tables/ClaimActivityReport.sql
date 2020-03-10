CREATE TABLE [dbo].[ClaimActivityReport] (
    [claimActivityReportID]            INT            IDENTITY (1, 1) NOT NULL,
    [claimID]                          INT            NULL,
    [statusID]                         INT            NULL,
    [statusNM]                         VARCHAR (50)   NULL,
    [serviceTypeID]                    INT            NULL,
    [serviceType]                      VARCHAR (50)   NULL,
    [mtmserviceDT]                     DATE           NULL,
    [patientID]                        INT            NULL,
    [CMSContractNumber]                VARCHAR (50)   NULL,
    [policyID]                         INT            NULL,
    [policyName]                       VARCHAR (100)  NULL,
    [policyTypeID]                     INT            NULL,
    [policyType]                       VARCHAR (100)  NULL,
    [clientID]                         INT            NULL,
    [clientName]                       VARCHAR (100)  NULL,
    [paid]                             INT            NULL,
    [reasontypeID]                     INT            NULL,
    [actiontypeID]                     INT            NULL,
    [resulttypeID]                     INT            NULL,
    [isTipClaim]                       INT            NULL,
    [MTM CenterID]                     VARCHAR (50)   NULL,
    [chainID]                          INT            NULL,
    [Pharmacy Chain]                   VARCHAR (1000) NULL,
    [AIM]                              MONEY          NULL,
    [charges]                          MONEY          NULL,
    [payable]                          INT            NULL,
    [validated]                        INT            NULL,
    [processed]                        INT            NULL,
    [payment]                          MONEY          NULL,
    [claimCount]                       INT            NULL,
    [TipClaim]                         INT            NULL,
    [PharmacistClaim]                  INT            NULL,
    [CMRClaims]                        INT            NULL,
    [PatientEd/Monitoring]             INT            NULL,
    [PatientConsultation]              INT            NULL,
    [PrescriberConsultation]           INT            NULL,
    [SuccessfulPrescriberConsultation] INT            NULL,
    [SuccessfulPatientConsultation]    INT            NULL,
    [PrescriberRefusal]                INT            NULL,
    [UnableToReachPrescriber]          INT            NULL,
    [PatientRefusal]                   INT            NULL,
    [UnableToReachPatient]             INT            NULL,
    [PatientClaims]                    INT            NULL,
    CONSTRAINT [PK_ClaimActivityReport] PRIMARY KEY CLUSTERED ([claimActivityReportID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_claimid]
    ON [dbo].[ClaimActivityReport]([claimID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_policyid_mtmservicedate]
    ON [dbo].[ClaimActivityReport]([policyID] ASC, [mtmserviceDT] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_chainid_mtmserviceDT_mtmCenterid]
    ON [dbo].[ClaimActivityReport]([chainID] ASC, [mtmserviceDT] ASC, [MTM CenterID] ASC) WITH (FILLFACTOR = 80);

