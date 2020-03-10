CREATE TABLE [dbo].[CMRActivityOpportunity] (
    [CMRActivityOpportunityID] INT          IDENTITY (1, 1) NOT NULL,
    [patientKey]               BIGINT       NULL,
    [patientMTMcenterKey]      BIGINT       NULL,
    [PatientID]                INT          NULL,
    [PolicyID]                 INT          NULL,
    [CMSContractNumber]        VARCHAR (50) NULL,
    [centerid]                 INT          NULL,
    [primaryPharmacy]          BIT          NULL,
    [CMREligible]              BIT          NULL,
    [activeAsOF]               DATETIME     NULL,
    [activeThru]               DATETIME     NULL,
    [outcomesTermDate]         DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([CMRActivityOpportunityID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ind_patientKey_patientMTMcenterKey]
    ON [dbo].[CMRActivityOpportunity]([patientKey] ASC, [patientMTMcenterKey] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_policyid_activeasof]
    ON [dbo].[CMRActivityOpportunity]([PolicyID] ASC, [activeAsOF] ASC)
    INCLUDE([patientKey], [patientMTMcenterKey], [PatientID], [centerid], [activeThru]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_patientid]
    ON [dbo].[CMRActivityOpportunity]([PatientID] ASC) WITH (FILLFACTOR = 80);

