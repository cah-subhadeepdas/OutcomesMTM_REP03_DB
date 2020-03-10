CREATE TABLE [dbo].[rptPricePerMemberPerYear] (
    [pricePerMemberPerYearID] INT      NOT NULL,
    [policyID]                INT      NOT NULL,
    [reportYear]              INT      NOT NULL,
    [reportMonth]             INT      NULL,
    [memberCount]             INT      NULL,
    [active]                  BIT      CONSTRAINT [df_rptPricePerMemberPerYear_active] DEFAULT ((0)) NOT NULL,
    [createDate]              DATETIME CONSTRAINT [df_rptPricePerMemberPerYear_createDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_rptPricePerMemberPerYear] PRIMARY KEY CLUSTERED ([pricePerMemberPerYearID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_policyID_reportYear_reportMonth]
    ON [dbo].[rptPricePerMemberPerYear]([policyID] ASC, [reportYear] ASC, [reportMonth] ASC) WITH (FILLFACTOR = 80);

