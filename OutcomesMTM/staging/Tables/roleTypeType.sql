CREATE TABLE [staging].[roleTypeType] (
    [roleTypeTypeID]   INT           NOT NULL,
    [roleTypeTypeName] VARCHAR (100) NOT NULL,
    [createDate]       DATETIME      NOT NULL,
    [createByUser]     VARCHAR (100) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_roleTypeType_roleTypeTypeID]
    ON [staging].[roleTypeType]([roleTypeTypeID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_roleTypeType_roleTypeTypeID]
    ON [staging].[roleTypeType]([roleTypeTypeID] ASC);

