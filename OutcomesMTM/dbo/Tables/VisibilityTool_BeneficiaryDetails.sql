CREATE TABLE [dbo].[VisibilityTool_BeneficiaryDetails] (
    [PatientID_All]                      VARCHAR (50)    NULL,
    [HICN]                               VARCHAR (50)    NULL,
    [First_Name]                         VARCHAR (50)    NULL,
    [Last_Name]                          VARCHAR (50)    NULL,
    [DOB]                                DATETIME        NULL,
    [MTMPEnrollmentID]                   INT             NULL,
    [PatientID]                          INT             NULL,
    [PolicyID]                           INT             NULL,
    [ContractYear]                       SMALLINT        NULL,
    [ContractNumber]                     VARCHAR (5)     NULL,
    [MTMPEnrollmentFromDate]             DATE            NULL,
    [MTMPEnrollmentThruDate]             DATE            NULL,
    [OptOutDate]                         DATE            NULL,
    [OptOutReasonCode]                   VARCHAR (2)     NULL,
    [MTMPTargetingDate]                  DATE            NULL,
    [IdentificationConfigID]             INT             NULL,
    [IdentificationRunID]                INT             NULL,
    [ActiveFromTT]                       DATETIME        NULL,
    [ActiveThruTT]                       DATETIME        NULL,
    [CreateDT]                           DATETIME        NULL,
    [ChangeDT]                           DATETIME        NULL,
    [MTMPEnrollmentFromDate_InfoJSON]    NVARCHAR (MAX)  NULL,
    [MTMPTargetingDate_InfoJSON]         NVARCHAR (MAX)  NULL,
    [HashCheck]                          BINARY (32)     NULL,
    [MTMPEnrollment_ActionTrigger]       NVARCHAR (4000) NULL,
    [MTMPEnrollment_IdentificationRunID] NVARCHAR (4000) NULL,
    [MTMPEnrollment_CMROfferSource]      NVARCHAR (4000) NULL,
    [MTMPEnrollment_ClaimID]             NVARCHAR (4000) NULL,
    [MTMPEnrollment_fileID]              NVARCHAR (4000) NULL,
    [MTMPEnrollment_changeDate]          NVARCHAR (4000) NULL,
    [MTMPTargeting_ActionTrigger]        NVARCHAR (4000) NULL,
    [MTMPTargeting_IdentificationRunID]  NVARCHAR (4000) NULL,
    [MTMPTargeting_CMROfferSource]       NVARCHAR (4000) NULL,
    [MTMPTargeting_ClaimID]              NVARCHAR (4000) NULL,
    [MTMPTargeting_fileID]               NVARCHAR (4000) NULL,
    [MTMPTargeting_changeDate]           NVARCHAR (4000) NULL,
    [Enrollment_ApprovedDate]            DATETIME        NULL,
    [Targeting_ApprovedDate]             DATETIME        NULL,
    [OptOutDT_Other]                     DATETIME        NULL,
    [OptOutReasonCode_Other]             VARCHAR (25)    NULL,
    [cmr_Count]                          INT             NULL,
    [cmrOffer_count]                     INT             NULL,
    [tmr_Count]                          INT             NULL,
    [tmr_Min]                            DATETIME        NULL,
    [HICN_Reported]                      VARCHAR (15)    NULL,
    [ReportRunDate]                      DATETIME        CONSTRAINT [DF_VisibilityTool_BeneficiaryDetails_ReportRunDate] DEFAULT (getdate()) NULL,
    [ClientId]                           INT             NULL,
    [ClientName]                         VARCHAR (100)   NULL,
    [DxCount]                            INT             NULL,
    [RxSum]                              DECIMAL (20, 2) NULL,
    [RxCount]                            INT             NULL,
    [MI]                                 VARCHAR (50)    NULL,
    [MTMPEnrollment_MTMEligibilityDate]  NVARCHAR (4000) NULL,
    [MTMPEnrollment_CMRTargetedDate]     NVARCHAR (4000) NULL,
    [MTMPTargeting_MTMEligibilityDate]   NVARCHAR (4000) NULL,
    [MTMPTargeting_CMRTargetedDate]      NVARCHAR (4000) NULL
);


GO
CREATE NONCLUSTERED INDEX [NC_VisibilityTool_BeneficiaryDetails]
    ON [dbo].[VisibilityTool_BeneficiaryDetails]([PatientID] ASC)
    INCLUDE([PatientID_All], [HICN], [ContractYear], [ClientId], [PolicyID], [ContractNumber], [First_Name], [Last_Name], [DOB]);


GO
CREATE NONCLUSTERED INDEX [NC_VisibilityTool_PatientidAll]
    ON [dbo].[VisibilityTool_BeneficiaryDetails]([PatientID_All] ASC, [ClientId] ASC, [ContractYear] ASC, [HICN] ASC);

