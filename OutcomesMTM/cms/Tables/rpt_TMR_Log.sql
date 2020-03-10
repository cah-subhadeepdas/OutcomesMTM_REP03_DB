CREATE TABLE [cms].[rpt_TMR_Log] (
    [TMRLogID]               INT         IDENTITY (1, 1) NOT NULL,
    [BatchID]                INT         NULL,
    [BeneficiaryID]          INT         NULL,
    [ContractNumber]         VARCHAR (5) NULL,
    [MTMPEnrollmentFromDate] DATE        NULL,
    [MTMPEnrollmentThruDate] DATE        NULL,
    [PatientID]              INT         NULL,
    [TMRDate]                DATE        NULL,
    [TMRID]                  BIGINT      NULL,
    PRIMARY KEY CLUSTERED ([TMRLogID] ASC)
);

