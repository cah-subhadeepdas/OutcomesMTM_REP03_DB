CREATE TABLE [dbo].[patientDeltaQueueStaging] (
    [PatientID]               INT           NULL,
    [PatientID_All]           VARCHAR (50)  NULL,
    [PolicyID]                INT           NULL,
    [ClientID]                INT           NULL,
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
    [PlanEffectiveDate]       DATETIME      NULL,
    [PlanTermDate]            DATETIME      NULL,
    [MTMEligibilityDate]      DATETIME      NULL,
    [MTMTermDate]             DATETIME      NULL,
    [OutcomesEligibilityDate] DATETIME      NULL,
    [OutcomesTermDate]        DATETIME      NULL,
    [HICN]                    VARCHAR (50)  NULL,
    [LTCFlag]                 BIT           NULL,
    [CMSContractNumber]       VARCHAR (50)  NULL,
    [pbp]                     VARCHAR (50)  NULL,
    [PrimaryLanguage]         VARCHAR (50)  NULL,
    [PCP]                     VARCHAR (50)  NULL,
    [MTMCriteriaFlag]         BIT           NULL,
    [StratScore]              VARCHAR (50)  NULL,
    [CMRFlag]                 BIT           NULL,
    [MemberGenKey]            VARCHAR (13)  NULL,
    [CMREligible]             BIT           NULL,
    [repositoryArchiveID]     BIGINT        NULL,
    [fileID]                  INT           NULL,
    [enterpriseChangeDate]    DATETIME      NULL,
    [changeDate]              DATETIME      NULL,
    [queueDate]               DATETIME      NOT NULL,
    [isDelete]                BIT           NOT NULL,
    [isInsert]                BIT           NOT NULL,
    [queueOrder]              INT           NOT NULL,
    [newPatientid_all]        VARCHAR (50)  NULL,
    [alternateID]             VARCHAR (50)  NULL,
    [displayID]               VARCHAR (50)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientDeltaQueueStaging]
    ON [dbo].[patientDeltaQueueStaging]([PatientID] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_IsInsert]
    ON [dbo].[patientDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([PatientID], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_IsInsert]
    ON [dbo].[patientDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([PatientID], [queueOrder], [queueDate]);

