CREATE TABLE [dbo].[TIPDetailStaging] (
    [tipdetailid] INT           NOT NULL,
    [tiptitle]    VARCHAR (100) NULL,
    [active]      BIT           NULL,
    [createdate]  DATETIME      NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[TIPDetailStaging]([tipdetailid] ASC);

