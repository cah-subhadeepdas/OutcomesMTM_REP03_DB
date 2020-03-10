CREATE TABLE [dbo].[ClaimNoteDeltaQueueStaging] (
    [ClaimNoteID] BIGINT        NOT NULL,
    [claimID]     INT           NULL,
    [notetypeID]  SMALLINT      NULL,
    [Note]        VARCHAR (MAX) NULL,
    [active]      BIT           NULL,
    [createDT]    DATETIME      NULL,
    [userID]      INT           NULL,
    [changeDate]  DATETIME      NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [claimNotedeltaqueuestaging_claimid_changedate_createdt_notetypeid]
    ON [dbo].[ClaimNoteDeltaQueueStaging]([claimID] ASC, [changeDate] ASC, [createDT] ASC, [notetypeID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [claimNotedeltaqueuestaging_claimNoteid]
    ON [dbo].[ClaimNoteDeltaQueueStaging]([ClaimNoteID] ASC);

