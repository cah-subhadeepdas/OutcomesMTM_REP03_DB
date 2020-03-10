CREATE TABLE [cmsETL].[Snapshot_MMTPEnrollment_FromConnect] (
    [MTMPEnrollmentID]                INT            NULL,
    [ClientID]                        INT            NULL,
    [ContractYear]                    VARCHAR (8000) NULL,
    [PatientID]                       INT            NULL,
    [PolicyID]                        VARCHAR (8000) NULL,
    [ContractNumber]                  VARCHAR (8000) NULL,
    [MTMPTargetingDate]               VARCHAR (8000) NULL,
    [MTMPEnrollmentFromDate_Actual]   VARCHAR (8000) NULL,
    [MTMPEnrollmentFromDate_Last]     VARCHAR (8000) NULL,
    [MTMPEnrollmentThruDate]          VARCHAR (8000) NULL,
    [MTMPEnrollmentThruDate_Inferred] VARCHAR (8000) NULL,
    [OptOutReasonCode]                VARCHAR (8000) NULL,
    [OptOutReasonCode_Inferred]       VARCHAR (8000) NULL,
    [ActiveFromTT]                    VARCHAR (8000) NULL,
    [ActiveThruTT]                    VARCHAR (8000) NULL,
    [LoadDT]                          DATETIME       DEFAULT (getdate()) NULL
);

