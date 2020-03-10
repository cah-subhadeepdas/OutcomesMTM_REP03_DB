CREATE TABLE [cmsETL].[CVS_Patient_MasterStage_20190101] (
    [masterID]                  BIGINT       NULL,
    [fileID]                    INT          NULL,
    [ClientID]                  INT          NULL,
    [PatientID_All]             VARCHAR (50) NULL,
    [PolicyID]                  INT          NULL,
    [First_Name]                VARCHAR (50) NULL,
    [MI]                        VARCHAR (50) NULL,
    [Last_Name]                 VARCHAR (50) NULL,
    [DOB]                       VARCHAR (50) NULL,
    [HICN]                      VARCHAR (50) NULL,
    [PlanEffectiveDate]         VARCHAR (50) NULL,
    [PlanTermDate]              VARCHAR (50) NULL,
    [MTMEligibilityDate]        VARCHAR (50) NULL,
    [MTMTermDate]               VARCHAR (50) NULL,
    [dateofdeath]               VARCHAR (50) NULL,
    [OptOutReasonCode]          VARCHAR (50) NULL,
    [outcomes_terminationDate]  VARCHAR (50) NULL,
    [outcomes_optOutReasonCode] VARCHAR (50) NULL,
    [CMSContractNumber]         VARCHAR (50) NULL,
    [PBP]                       VARCHAR (50) NULL,
    [memberAltID]               VARCHAR (50) NULL
);

