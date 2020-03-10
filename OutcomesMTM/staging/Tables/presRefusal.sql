CREATE TABLE [staging].[presRefusal] (
    [presRefusalID]   INT           NOT NULL,
    [presRefusalDesc] VARCHAR (200) NOT NULL,
    [sortOrder]       SMALLINT      NULL,
    [active]          BIT           NOT NULL
);

