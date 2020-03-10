CREATE TABLE [dbo].[CMROfferPatient_ST] (
    [patientid]         INT          NULL,
    [policyid]          INT          NULL,
    [CMREnrollBegin]    DATE         NULL,
    [CMSContractNumber] VARCHAR (50) NULL,
    [PatientID_All]     VARCHAR (50) NULL,
    [HICN]              VARCHAR (50) NULL,
    [First_Name]        VARCHAR (50) NULL,
    [MI]                VARCHAR (1)  NULL,
    [last_name]         VARCHAR (50) NULL,
    [DOB]               DATETIME     NULL,
    [CMREnrollEnd]      DATETIME     NULL,
    [OutcomesTermDate]  DATETIME     NULL,
    [Termed]            INT          NULL,
    [OptOut]            INT          NULL,
    [PreviousCMR]       INT          NULL
);

