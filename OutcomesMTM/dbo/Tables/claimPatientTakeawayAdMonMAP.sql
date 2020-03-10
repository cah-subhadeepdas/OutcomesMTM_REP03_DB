CREATE TABLE [dbo].[claimPatientTakeawayAdMonMAP] (
    [claimPatientTakeawayAdMonMAPID] INT            NOT NULL,
    [claimID]                        INT            NOT NULL,
    [medProblem]                     VARCHAR (1200) NULL,
    [medAction]                      VARCHAR (1200) NULL,
    [sortOrder]                      SMALLINT       NOT NULL
);

