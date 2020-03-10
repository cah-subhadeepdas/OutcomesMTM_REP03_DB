CREATE TABLE [staging].[CMS_MTMPEnrollment_2018] (
    [PatientID]                       INT         NULL,
    [ClientID]                        INT         NULL,
    [ContractYear]                    VARCHAR (4) NULL,
    [MTMPEnrollmentID]                INT         NULL,
    [PolicyID]                        INT         NULL,
    [ContractNumber]                  VARCHAR (5) NULL,
    [MTMPTargetingDate]               DATE        NULL,
    [MTMPEnrollmentFromDate_Actual]   DATE        NULL,
    [MTMPEnrollmentFromDate_Last]     DATE        NULL,
    [MTMPEnrollmentThruDate]          DATETIME    NULL,
    [MTMPEnrollmentThruDate_Inferred] DATETIME    NULL,
    [OptOutReasonCode]                VARCHAR (2) NULL,
    [OptOutReasonCode_Inferred]       VARCHAR (2) NULL,
    [ActiveFromTT]                    DATETIME    NULL,
    [ActiveThruTT]                    DATETIME    NULL,
    [DataSetTypeID]                   INT         NULL
);

