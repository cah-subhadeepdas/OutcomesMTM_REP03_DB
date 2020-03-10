CREATE TABLE [staging].[states] (
    [stateID]   INT           IDENTITY (1, 1) NOT NULL,
    [stateName] NVARCHAR (50) NULL,
    [stateAbbr] NCHAR (10)    NULL
);

