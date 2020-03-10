CREATE TABLE [dbo].[MTMPEnrollment] (
    [MTMPEnrollmentID]       INT      NOT NULL,
    [PatientID]              INT      NOT NULL,
    [ContractYear]           SMALLINT NOT NULL,
    [ContractNumber]         CHAR (5) NULL,
    [MTMPEnrollmentFromDate] DATE     NOT NULL,
    [MTMPEnrollmentThruDate] DATE     NULL,
    [IdentificationConfigID] INT      NULL,
    [IdentificationRunID]    INT      NULL,
    [ActiveFromTT]           DATETIME NOT NULL,
    [ActiveThruTT]           DATETIME NOT NULL,
    [OptOutReasonCode]       CHAR (2) NULL,
    [policyid]               INT      NULL,
    [MTMPTargetingDate]      DATE     NULL
);

