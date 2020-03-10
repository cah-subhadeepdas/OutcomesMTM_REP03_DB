CREATE TABLE [dbo].[patientDim] (
    [patientKey]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [PatientID]               INT           NOT NULL,
    [PatientID_All]           VARCHAR (50)  NULL,
    [ClientID]                INT           NULL,
    [PolicyID]                INT           NULL,
    [CMSContractNumber]       VARCHAR (50)  NULL,
    [HICN]                    VARCHAR (50)  NULL,
    [LTCFlag]                 BIT           NULL,
    [planeffectivedate]       DATETIME      NULL,
    [plantermdate]            DATETIME      NULL,
    [MTMEligibilityDate]      DATETIME      NULL,
    [MTMTermDate]             DATETIME      NULL,
    [OutcomesEligibilityDate] DATETIME      NULL,
    [OutcomesTermDate]        DATETIME      NULL,
    [CMREligible]             BIT           NULL,
    [First_Name]              VARCHAR (50)  NULL,
    [MI]                      VARCHAR (1)   NULL,
    [Last_Name]               VARCHAR (50)  NULL,
    [Gender]                  VARCHAR (1)   NULL,
    [DOB]                     DATETIME      NULL,
    [Address1]                VARCHAR (50)  NULL,
    [Address2]                VARCHAR (50)  NULL,
    [City]                    VARCHAR (50)  NULL,
    [State]                   VARCHAR (2)   NULL,
    [ZipCode]                 VARCHAR (50)  NULL,
    [Phone]                   VARCHAR (50)  NULL,
    [other_info]              VARCHAR (100) NULL,
    [pbp]                     VARCHAR (50)  NULL,
    [PrimaryLanguage]         VARCHAR (50)  NULL,
    [PCP]                     VARCHAR (50)  NULL,
    [MTMCriteriaFlag]         BIT           NULL,
    [StratScore]              VARCHAR (50)  NULL,
    [CMRFlag]                 BIT           NULL,
    [MemberGenKey]            VARCHAR (13)  NULL,
    [activeAsOf]              DATETIME      NOT NULL,
    [activeThru]              DATETIME      NULL,
    [isCurrent]               BIT           NOT NULL,
    [newPatientid_all]        VARCHAR (50)  NULL,
    [alternateID]             VARCHAR (50)  NULL,
    [displayID]               VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([patientKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_patientid_activeasof]
    ON [dbo].[patientDim]([PatientID] ASC, [activeAsOf] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_patientid_activethru]
    ON [dbo].[patientDim]([PatientID] ASC, [activeThru] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_policyID]
    ON [dbo].[patientDim]([PolicyID] ASC)
    INCLUDE([patientKey], [PatientID], [activeAsOf], [activeThru], [OutcomesTermDate], [plantermdate]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_PatientID]
    ON [dbo].[patientDim]([PatientID] ASC)
    INCLUDE([activeAsOf], [activeThru], [Address1], [Address2], [City], [ClientID], [CMREligible], [CMRFlag], [CMSContractNumber], [DOB], [First_Name], [Gender], [HICN], [isCurrent], [Last_Name], [LTCFlag], [MemberGenKey], [MI], [MTMCriteriaFlag], [MTMEligibilityDate], [MTMTermDate], [other_info], [OutcomesEligibilityDate], [OutcomesTermDate], [PatientID_All], [patientKey], [pbp], [PCP], [Phone], [planeffectivedate], [plantermdate], [PolicyID], [PrimaryLanguage], [State], [StratScore], [ZipCode]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_activethru]
    ON [dbo].[patientDim]([activeThru] ASC)
    INCLUDE([patientKey], [PatientID]) WITH (FILLFACTOR = 80);

