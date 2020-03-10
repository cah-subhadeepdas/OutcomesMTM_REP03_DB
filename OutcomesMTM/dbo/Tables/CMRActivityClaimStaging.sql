CREATE TABLE [dbo].[CMRActivityClaimStaging] (
    [claimID]               INT         NOT NULL,
    [patientid]             INT         NULL,
    [policyID]              INT         NULL,
    [centerID]              INT         NULL,
    [reasonTypeID]          INT         NULL,
    [actionTypeID]          INT         NULL,
    [resultTypeID]          INT         NULL,
    [statusID]              INT         NULL,
    [paid]                  BIT         NULL,
    [postHospitalDischarge] BIT         NULL,
    [cmrDeliveryTypeID]     INT         NULL,
    [mtmServiceDT]          DATETIME    NULL,
    [submitDT]              DATETIME    NULL,
    [Language]              VARCHAR (2) NULL,
    [changeDate]            DATETIME    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_CMRActivityClaimStaging]
    ON [dbo].[CMRActivityClaimStaging]([claimID] ASC);

