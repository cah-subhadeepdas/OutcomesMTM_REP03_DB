CREATE TABLE [dbo].[CMR_Tracking_PriorityHealth] (
    [ID]               INT  IDENTITY (1, 1) NOT NULL,
    [patientID]        INT  NULL,
    [policyID]         INT  NULL,
    [TrueTargetDT]     DATE NULL,
    [OutcomesTermDate] DATE NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

