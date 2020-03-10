CREATE TABLE [staging].[patRefusal] (
    [patRefusalID]   INT           NOT NULL,
    [patRefusalDesc] VARCHAR (200) NOT NULL,
    [cmrActive]      INT           NOT NULL,
    [sortOrder]      INT           NOT NULL,
    [claimActive]    BIT           NOT NULL
);

