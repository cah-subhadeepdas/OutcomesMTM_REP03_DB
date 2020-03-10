CREATE TABLE [dbo].[claimPatientTakeaway] (
    [claimPatientTakeawayID] INT         NOT NULL,
    [claimID]                INT         NOT NULL,
    [takeawayDate]           DATE        NOT NULL,
    [takeawayLanguage]       VARCHAR (2) NOT NULL,
    [takeawayVersion]        INT         NOT NULL
);

