CREATE TABLE [cmsETL].[FileLoad] (
    [FileID]       INT            IDENTITY (1, 1) NOT NULL,
    [FileNM]       VARCHAR (255)  NOT NULL,
    [FilePath]     VARCHAR (8000) NULL,
    [FileTypeID]   INT            DEFAULT ((0)) NOT NULL,
    [LoadDT]       DATETIME       DEFAULT (getdate()) NOT NULL,
    [ActiveFromDT] DATETIME       DEFAULT (getdate()) NOT NULL,
    [ActiveThruDT] DATETIME       DEFAULT ('9999-12-31') NOT NULL,
    PRIMARY KEY CLUSTERED ([FileID] ASC)
);

