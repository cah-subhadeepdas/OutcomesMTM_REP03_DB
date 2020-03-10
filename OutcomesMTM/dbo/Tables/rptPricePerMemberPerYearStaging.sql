CREATE TABLE [dbo].[rptPricePerMemberPerYearStaging] (
    [pricePerMemberPerYearID] INT      NOT NULL,
    [policyID]                INT      NOT NULL,
    [reportYear]              INT      NOT NULL,
    [reportMonth]             INT      NULL,
    [memberCount]             INT      NULL,
    [active]                  BIT      NOT NULL,
    [createDate]              DATETIME NOT NULL,
    CONSTRAINT [PK_rptPricePerMemberPerYearStaging] PRIMARY KEY CLUSTERED ([pricePerMemberPerYearID] ASC) WITH (FILLFACTOR = 90)
);

