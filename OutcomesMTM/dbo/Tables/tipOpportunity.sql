CREATE TABLE [dbo].[tipOpportunity] (
    [tipOpportunityID] BIGINT   NOT NULL,
    [tipresultID]      BIGINT   NOT NULL,
    [patientid]        INT      NOT NULL,
    [tipDetailID]      INT      NOT NULL,
    [createDate]       DATETIME NOT NULL,
    [expirationDate]   DATETIME NULL,
    [changeDate]       DATETIME DEFAULT (getdate()) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_tipOpportunity_tipOpportunityID]
    ON [dbo].[tipOpportunity]([tipOpportunityID] ASC);

