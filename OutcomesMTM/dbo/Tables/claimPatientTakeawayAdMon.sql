CREATE TABLE [dbo].[claimPatientTakeawayAdMon] (
    [claimPatientTakeawayAdMonID] INT            NOT NULL,
    [claimID]                     INT            NOT NULL,
    [medicationPurpose]           VARCHAR (1200) NULL,
    [directionsForUse]            VARCHAR (1200) NULL
);

