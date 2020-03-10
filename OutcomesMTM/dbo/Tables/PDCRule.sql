CREATE TABLE [dbo].[PDCRule] (
    [PDCruleID]   INT           IDENTITY (1, 1) NOT NULL,
    [PDCruleName] VARCHAR (100) NULL,
    [active]      BIT           NOT NULL,
    CONSTRAINT [PK_PDCrule] PRIMARY KEY CLUSTERED ([PDCruleID] ASC) WITH (FILLFACTOR = 80)
);

