CREATE TABLE [staging].[role] (
    [roleID]     INT           NOT NULL,
    [userID]     INT           NOT NULL,
    [roleTypeID] INT           NOT NULL,
    [createDT]   DATE          NOT NULL,
    [createBy]   VARCHAR (200) NOT NULL,
    [modDT]      DATE          NULL,
    [modBy]      VARCHAR (200) NULL,
    [active]     BIT           NOT NULL,
    [Selected]   BIT           NOT NULL,
    [approved]   BIT           NULL,
    [rejected]   BIT           NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_Role_RoleID]
    ON [staging].[role]([roleID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_role_userid]
    ON [staging].[role]([userID] ASC, [roleTypeID] ASC);

