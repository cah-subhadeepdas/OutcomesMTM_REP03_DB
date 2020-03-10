CREATE TABLE [dbo].[ClaimNote] (
    [ClaimNoteID] BIGINT        NOT NULL,
    [claimID]     INT           NULL,
    [notetypeID]  SMALLINT      NULL,
    [Note]        VARCHAR (MAX) NULL,
    [active]      BIT           NULL,
    [createDT]    DATETIME      NULL,
    [userID]      INT           NULL,
    [changeDate]  DATETIME      NULL
);

