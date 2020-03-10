CREATE TABLE [staging].[users] (
    [userID]                 INT           NOT NULL,
    [username]               VARCHAR (200) NULL,
    [password]               VARCHAR (500) NULL,
    [loginAttempt]           NUMERIC (1)   NULL,
    [ip]                     VARCHAR (50)  NULL,
    [lastLoginDT]            DATETIME      NULL,
    [salt]                   VARCHAR (500) NULL,
    [resetPasswordAttempt]   NUMERIC (1)   NULL,
    [token]                  VARCHAR (500) NULL,
    [completedTraining]      BIT           NOT NULL,
    [completedTrainingDT]    DATETIME      NULL,
    [active]                 BIT           NOT NULL,
    [legacyID]               INT           NULL,
    [legacySystemUserTypeID] INT           NULL,
    [legacyPassword]         VARCHAR (100) NULL,
    [legacyUserName]         VARCHAR (100) NULL,
    [legacyIDNumber]         VARCHAR (100) NULL,
    [legacyEmail]            VARCHAR (100) NULL,
    [legacyNPI]              VARCHAR (100) NULL,
    [legacySystemUserType]   VARCHAR (100) NULL,
    [createDT]               DATE          NOT NULL,
    [createBy]               VARCHAR (200) NOT NULL,
    [modDT]                  DATE          NULL,
    [modBy]                  VARCHAR (200) NULL,
    [resetPassword]          BIT           NOT NULL,
    [internal]               BIT           NULL,
    [forgotLegacyPassword]   BIT           NOT NULL,
    [pwdlastSetDate]         DATETIME      NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_users_userID]
    ON [staging].[users]([userID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_users_active_legacypassword]
    ON [staging].[users]([active] ASC, [legacyPassword] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_users_legacyID_legacySystemUserTypeID]
    ON [staging].[users]([legacyID] ASC, [legacySystemUserTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_users_username_active]
    ON [staging].[users]([username] ASC, [active] ASC);

