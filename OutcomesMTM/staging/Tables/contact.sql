CREATE TABLE [staging].[contact] (
    [contactID]  INT           NOT NULL,
    [userID]     INT           NOT NULL,
    [email]      VARCHAR (100) NULL,
    [phone]      VARCHAR (50)  NULL,
    [fax]        VARCHAR (50)  NULL,
    [firstNM]    VARCHAR (50)  NULL,
    [mi]         CHAR (3)      NULL,
    [lastNM]     VARCHAR (50)  NULL,
    [dob]        DATE          NULL,
    [ssn]        VARCHAR (15)  NULL,
    [npi]        VARCHAR (50)  NULL,
    [gender]     CHAR (1)      NULL,
    [employeeID] VARCHAR (100) NULL,
    [createDT]   DATE          NOT NULL,
    [createBy]   VARCHAR (200) NOT NULL,
    [modDT]      DATE          NULL,
    [modBy]      VARCHAR (200) NULL,
    [CompanyNM]  VARCHAR (100) NULL,
    [JobTitle]   VARCHAR (200) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_contact_contactID]
    ON [staging].[contact]([contactID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_contact_userid]
    ON [staging].[contact]([userID] ASC);

