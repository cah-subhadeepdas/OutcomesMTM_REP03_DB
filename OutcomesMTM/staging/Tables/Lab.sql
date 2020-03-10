CREATE TABLE [staging].[Lab] (
    [LabID]          INT           NOT NULL,
    [LabNM]          VARCHAR (100) NOT NULL,
    [Active]         BIT           NOT NULL,
    [CreateDT]       DATETIME      NOT NULL,
    [CreateByUserID] INT           NOT NULL,
    [ModDT]          DATETIME      NULL,
    [ModByUserID]    INT           NULL,
    [SortOrder]      INT           NULL
);

