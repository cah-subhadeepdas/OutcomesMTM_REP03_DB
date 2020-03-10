CREATE TABLE [dbo].[CMRActivityClaim] (
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
CREATE UNIQUE CLUSTERED INDEX [UC_CMRActivityClaim]
    ON [dbo].[CMRActivityClaim]([claimID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_statusid]
    ON [dbo].[CMRActivityClaim]([statusID] ASC)
    INCLUDE([claimID], [patientid], [policyID], [centerID], [reasonTypeID], [actionTypeID], [resultTypeID], [paid], [postHospitalDischarge], [cmrDeliveryTypeID], [mtmServiceDT], [submitDT], [changeDate]) WITH (FILLFACTOR = 80);

