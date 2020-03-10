CREATE TABLE [staging].[TC_Requests] (
    [ID]        INT            IDENTITY (1, 1) NOT NULL,
    [RefID]     VARCHAR (255)  NULL,
    [DataInput] NVARCHAR (MAX) NULL,
    [SQLScript] VARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

