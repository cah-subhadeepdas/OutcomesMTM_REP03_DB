CREATE TABLE [dbo].[claimStatus] (
    [claimStatusID] INT      NOT NULL,
    [claimID]       INT      NOT NULL,
    [statusID]      INT      NOT NULL,
    [active]        BIT      NOT NULL,
    [createDT]      DATETIME NOT NULL,
    [roleID]        INT      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_claimid_active]
    ON [dbo].[claimStatus]([claimID] ASC, [active] ASC)
    INCLUDE([statusID], [createDT]) WITH (FILLFACTOR = 80);

