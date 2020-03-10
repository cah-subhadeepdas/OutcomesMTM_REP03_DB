CREATE TABLE [staging].[tipstatus] (
    [tipstatusid]     INT           NOT NULL,
    [tipstatustypeid] INT           NULL,
    [tipstatus]       VARCHAR (200) NOT NULL,
    [tipstatusdesc]   VARCHAR (MAX) NULL,
    [createdate]      DATETIME      NOT NULL,
    [activeflag]      BIT           NOT NULL,
    [activeenddate]   DATETIME      NULL
);

