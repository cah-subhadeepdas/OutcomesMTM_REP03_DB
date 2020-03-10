CREATE TABLE [dbo].[pharmacy] (
    [centerid]          BIGINT        NOT NULL,
    [centername]        VARCHAR (100) NULL,
    [legacykey]         INT           NULL,
    [roledesc]          VARCHAR (50)  NULL,
    [NCPDP_NABP]        VARCHAR (50)  NULL,
    [NPI]               VARCHAR (50)  NULL,
    [FEDERALTAXID]      VARCHAR (50)  NULL,
    [PHONE]             VARCHAR (50)  NULL,
    [FAX]               VARCHAR (50)  NULL,
    [EMAIL]             VARCHAR (200) NULL,
    [AddressName]       VARCHAR (100) NULL,
    [Address1]          VARCHAR (50)  NULL,
    [Address2]          VARCHAR (50)  NULL,
    [AddressCity]       VARCHAR (50)  NULL,
    [AddressState]      CHAR (2)      NULL,
    [AddressPostalCode] VARCHAR (50)  NULL,
    [contracted]        BIT           NULL,
    [active]            BIT           NULL,
    CONSTRAINT [PK_pharmacy] PRIMARY KEY CLUSTERED ([centerid] ASC) WITH (FILLFACTOR = 80)
);

