CREATE TABLE [dbo].[HUMANA_Current_Tips] (
    [TIP Generation Date]                        DATE          NULL,
    [TIP ID]                                     INT           NULL,
    [TIP Title]                                  VARCHAR (100) NULL,
    [Reason Code]                                VARCHAR (50)  NULL,
    [Reason Code Description]                    VARCHAR (50)  NULL,
    [Action Code]                                VARCHAR (50)  NULL,
    [Action Name]                                VARCHAR (50)  NULL,
    [Member ID]                                  VARCHAR (50)  NULL,
    [First Name]                                 VARCHAR (50)  NULL,
    [Last Name]                                  VARCHAR (50)  NULL,
    [Date of Birth]                              VARCHAR (50)  NULL,
    [Policy ID]                                  INT           NULL,
    [Policy Name]                                VARCHAR (100) NULL,
    [Current Primary Pharmacy NCPDP]             VARCHAR (MAX) NULL,
    [Current Primary Pharmacy Name]              VARCHAR (MAX) NULL,
    [Current % Fills at Primary Pharmacy]        VARCHAR (50)  NULL,
    [Is Current pharmacy Contracted]             VARCHAR (10)  NULL,
    [Is Current pharmacy Trained]                VARCHAR (10)  NULL,
    [Is Current pharmacy Contracted and Trained] VARCHAR (10)  NULL
);

