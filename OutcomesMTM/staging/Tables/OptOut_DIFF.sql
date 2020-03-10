CREATE TABLE [staging].[OptOut_DIFF] (
    [clientID]                        INT           NOT NULL,
    [clientName]                      VARCHAR (100) NULL,
    [BeneficiaryID]                   INT           NOT NULL,
    [PatientID]                       INT           NOT NULL,
    [PatientID_All]                   VARCHAR (50)  NULL,
    [HICN]                            VARCHAR (15)  NOT NULL,
    [First_Name]                      VARCHAR (30)  NOT NULL,
    [MI]                              VARCHAR (1)   NOT NULL,
    [Last_Name]                       VARCHAR (30)  NOT NULL,
    [DOB]                             DATE          NOT NULL,
    [ContractYear]                    CHAR (4)      NOT NULL,
    [ContractNumber]                  CHAR (5)      NOT NULL,
    [MTMPEnrollmentFromDate]          DATE          NOT NULL,
    [MTMPTargetingDate]               DATE          NULL,
    [MTMPEnrollmentThruDate]          DATE          NOT NULL,
    [OptOutDate]                      DATE          NULL,
    [OptOutReasonCode]                VARCHAR (2)   NOT NULL,
    [MTMPEnrollmentThruDate_INFERRED] DATE          NULL,
    [OptOutDate_INFERRED]             DATE          NULL,
    [OptOutReasonCode_INFERRED]       VARCHAR (2)   NOT NULL,
    [OptOut_DIFF]                     VARCHAR (4)   NOT NULL
);

