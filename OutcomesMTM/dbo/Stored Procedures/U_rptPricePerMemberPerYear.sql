

-- =============================================
-- Author:		Paul Dickey
-- Create date: 10/20/2016
-- Description:	After SSIS moves data from Repository's rptPricePerMemberPerYear table to Reporting's rptPricePerMemberPerYearStaging table, this proc
--				updates Reporting's rptPricePerMemberPerYear table with the data in Reporting's rptPricePerMemberPerYearStaging table.
-- Exec Time:   00:00:01.578 on 10/20/2016
-- =============================================
CREATE PROCEDURE [dbo].[U_rptPricePerMemberPerYear]
AS 
BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Update Existing
	UPDATE targets
	SET targets.policyID=sources.policyID
	,targets.reportYear=sources.reportYear
	,targets.reportMonth=sources.reportMonth
	,targets.memberCount=sources.memberCount
	,targets.createDate=sources.createDate
	,targets.active=sources.active
	FROM OutcomesMTM.dbo.rptPricePerMemberPerYearStaging AS sources
	JOIN OutcomesMTM.dbo.rptPricePerMemberPerYear AS targets ON sources.pricePerMemberPerYearID=targets.pricePerMemberPerYearID

	-- Insert New
	INSERT INTO OutcomesMTM.dbo.rptPricePerMemberPerYear
	(
		pricePerMemberPerYearID
		,policyID
		,reportYear
		,reportMonth
		,memberCount
		,createDate
		,active
	)
	SELECT sources.pricePerMemberPerYearID
	,sources.policyID
	,sources.reportYear
	,sources.reportMonth
	,sources.memberCount
	,sources.createDate
	,sources.active
	FROM OutcomesMTM.dbo.rptPricePerMemberPerYearStaging AS sources
	LEFT JOIN OutcomesMTM.dbo.rptPricePerMemberPerYear AS targets ON sources.pricePerMemberPerYearID=targets.pricePerMemberPerYearID
	WHERE targets.pricePerMemberPerYearID IS NULL

	-- Deactivate records absent from the staging table.
	UPDATE targets
	SET targets.active=0
	FROM OutcomesMTM.dbo.rptPricePerMemberPerYearStaging AS sources
	RIGHT JOIN OutcomesMTM.dbo.rptPricePerMemberPerYear AS targets ON sources.pricePerMemberPerYearID=targets.pricePerMemberPerYearID
	WHERE sources.pricePerMemberPerYearID IS NULL

END




