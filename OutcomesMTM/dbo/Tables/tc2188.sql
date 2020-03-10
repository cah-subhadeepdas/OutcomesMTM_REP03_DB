CREATE TABLE [dbo].[tc2188] (
    [Policy ID]           VARCHAR (50)   NULL,
    [Policy Name]         VARCHAR (500)  NULL,
    [Patient First Name]  VARCHAR (100)  NULL,
    [Patient Last Name]   VARCHAR (100)  NULL,
    [Patient Id]          VARCHAR (50)   NULL,
    [TIP Title]           VARCHAR (5000) NULL,
    [TIP Generation Date] VARCHAR (500)  NULL,
    [NCPDP_Provider_ID]   VARCHAR (50)   NULL,
    [Relationship_ID]     VARCHAR (50)   NULL
);


GO
CREATE NONCLUSTERED INDEX [pt]
    ON [dbo].[tc2188]([Patient Id] ASC);

