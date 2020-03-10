CREATE TABLE [staging].[ECALevel] (
    [ecaLevelID] INT           NOT NULL,
    [ecaLevel]   TINYINT       NOT NULL,
    [ecaDesc]    VARCHAR (200) NOT NULL,
    [activeflag] BIT           NOT NULL,
    [ECAValue]   MONEY         NULL
);

