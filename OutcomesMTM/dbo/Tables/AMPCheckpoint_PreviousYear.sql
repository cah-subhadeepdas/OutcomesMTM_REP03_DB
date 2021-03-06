﻿CREATE TABLE [dbo].[AMPCheckpoint_PreviousYear] (
    [patientid_all]                         VARCHAR (50)   NULL,
    [policyName]                            NVARCHAR (100) NULL,
    [first_Name]                            VARCHAR (50)   NULL,
    [last_Name]                             VARCHAR (50)   NULL,
    [DOB]                                   DATETIME       NULL,
    [yearofUse]                             SMALLINT       NULL,
    [bonusEligible]                         BIT            NULL,
    [mtmserviceDT]                          DATETIME       NULL,
    [TIP_TITLE]                             VARCHAR (100)  NOT NULL,
    [Medication/dose name of completed TIP] VARCHAR (300)  NULL,
    [statusNM]                              VARCHAR (50)   NOT NULL,
    [ncpdp_nabp]                            VARCHAR (50)   NULL,
    [centername]                            VARCHAR (100)  NULL,
    [primaryPharmacyStatus]                 VARCHAR (3)    NOT NULL,
    [chainCode]                             VARCHAR (100)  NULL,
    [chainNM]                               VARCHAR (1000) NULL,
    [Q2:Medication/dose name]               VARCHAR (300)  NULL,
    [Q2:Adherence Monitoring]               DATETIME       NULL,
    [Q2:Start date]                         DATE           NULL,
    [Q2:End date]                           DATE           NULL,
    [Q2:Result code]                        VARCHAR (1000) NULL,
    [Q3:Medication/dose name]               VARCHAR (300)  NULL,
    [Q3:Adherence Monitoring]               DATETIME       NULL,
    [Q3:Start date]                         DATE           NULL,
    [Q3:End date]                           DATE           NULL,
    [Q3:Result code]                        VARCHAR (1000) NULL,
    [Q4:Medication/dose name]               VARCHAR (300)  NULL,
    [Q4:Adherence Monitoring]               DATETIME       NULL,
    [Q4:Start date]                         DATE           NULL,
    [Q4:End date]                           DATE           NULL,
    [Q4:Result code]                        VARCHAR (1000) NULL,
    [disEnrolledDate]                       DATETIME       NULL,
    [termdate]                              DATETIME       NULL,
    [ReportRunDate]                         DATE           CONSTRAINT [DF_AMPCheckpointData_PreviousYear_ReportRunDate] DEFAULT (getdate()) NULL,
    [ReportYear]                            SMALLINT       CONSTRAINT [DF_AMPCheckpoint_PreviousYear_ReportYear] DEFAULT (datepart(year,getdate())) NULL,
    [TotalOpportunities_CheckpointCount]    SMALLINT       NULL,
    [Current_AMP_Status]                    VARCHAR (1000) NULL,
    [QuarterEnrolled]                       SMALLINT       NULL,
    [TotalSuccessful_CheckpointCount]       SMALLINT       NULL,
    [TotalCompleted_CheckpointCount]        SMALLINT       NULL,
    [IsQ2Complete]                          SMALLINT       NULL,
    [IsQ3Complete]                          SMALLINT       NULL,
    [IsQ4Complete]                          SMALLINT       NULL,
    [IsQ2Successful]                        SMALLINT       NULL,
    [IsQ3Successful]                        SMALLINT       NULL,
    [IsQ4Successful]                        SMALLINT       NULL,
    [IsQ2Opportunity]                       SMALLINT       NULL,
    [IsQ3Opportunity]                       SMALLINT       NULL,
    [IsQ4Opportunity]                       SMALLINT       NULL,
    [PolicyId]                              INT            NULL
);

