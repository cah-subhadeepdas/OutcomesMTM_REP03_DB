CREATE TABLE [staging].[TIPDetail_tip] (
    [tipdetailid]     INT            NOT NULL,
    [tiptitle]        VARCHAR (100)  NOT NULL,
    [formulary]       BIT            NOT NULL,
    [overview]        VARCHAR (8000) NULL,
    [lookback]        INT            NOT NULL,
    [createdate]      DATETIME       NOT NULL,
    [active]          BIT            NOT NULL,
    [reasonTypeID]    INT            NULL,
    [actionTypeID]    INT            NULL,
    [ecaLevelID]      INT            NULL,
    [isAgeDependent]  BIT            NULL,
    [startAge]        INT            NULL,
    [endAge]          INT            NULL,
    [StarTip]         BIT            NULL,
    [directLoadTip]   BIT            NULL,
    [longitudinalTip] BIT            NULL,
    [publishTip]      BIT            NULL,
    [tipTypeID]       SMALLINT       NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_TipDetail_TipDetailID]
    ON [staging].[TIPDetail_tip]([tipdetailid] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_TipDetail_StarTip]
    ON [staging].[TIPDetail_tip]([StarTip] ASC);

