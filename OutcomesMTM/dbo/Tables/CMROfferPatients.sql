CREATE TABLE [dbo].[CMROfferPatients] (
    [ID]             INT          IDENTITY (1, 1) NOT NULL,
    [patientID]      INT          NULL,
    [policyID]       INT          NULL,
    [CMREnrollBegin] DATE         NULL,
    [ContractNumber] VARCHAR (25) NULL,
    [patientID_All]  VARCHAR (25) NULL,
    [HICN]           VARCHAR (25) NULL,
    [carrier]        VARCHAR (50) NULL,
    [account]        VARCHAR (50) NULL,
    [group]          VARCHAR (50) NULL,
    [First_Name]     VARCHAR (50) NULL,
    [Last_Name]      VARCHAR (50) NULL,
    [MI]             VARCHAR (25) NULL,
    [DOB]            DATE         NULL,
    [CMREnrollEnd]   DATE         NULL,
    [termdate]       DATE         NULL,
    [Termed]         BIT          NULL,
    [OptOut]         BIT          NULL,
    [PreviousCMR]    BIT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

