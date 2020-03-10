



CREATE PROCEDURE [dbo].[U_rptHumanaLegalEntityInvoiceBreakdown]
AS 
BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Update Existing
	UPDATE targets
	SET targets.fileID=sources.fileID
	,targets.fileLoadDate=sources.fileLoadDate
	,targets.fileName=sources.fileName
	,targets.sourceCode=sources.sourceCode
	,targets.legalEntityNumber=sources.legalEntityNumber
	,targets.legalEntityName=sources.legalEntityName
	,targets.recordCount=sources.recordCount
	,targets.createDate=sources.createDate
	,targets.active=sources.active
	FROM OutcomesMTM.dbo.rptHumanaLegalEntityInvoiceBreakdownStaging AS sources
	JOIN OutcomesMTM.dbo.rptHumanaLegalEntityInvoiceBreakdown AS targets ON sources.humanaLegalEntityInvoiceBreakdownID=targets.humanaLegalEntityInvoiceBreakdownID

	-- Insert New
	INSERT INTO OutcomesMTM.dbo.rptHumanaLegalEntityInvoiceBreakdown
	(
		humanaLegalEntityInvoiceBreakdownID
		,fileID
		,fileLoadDate
		,fileName
		,sourceCode
		,legalEntityNumber
		,legalEntityName
		,recordCount
		,createDate
		,active
	)
	SELECT sources.humanaLegalEntityInvoiceBreakdownID
	,sources.fileID
	,sources.fileLoadDate
	,sources.fileName
	,sources.sourceCode
	,sources.legalEntityNumber
	,sources.legalEntityName
	,sources.recordCount
	,sources.createDate
	,sources.active
	FROM OutcomesMTM.dbo.rptHumanaLegalEntityInvoiceBreakdownStaging AS sources
	LEFT JOIN OutcomesMTM.dbo.rptHumanaLegalEntityInvoiceBreakdown AS targets ON sources.humanaLegalEntityInvoiceBreakdownID=targets.humanaLegalEntityInvoiceBreakdownID
	WHERE targets.humanaLegalEntityInvoiceBreakdownID IS NULL

	-- Deactivate records absent from the staging table.
	UPDATE targets
	SET targets.active=0
	FROM OutcomesMTM.dbo.rptHumanaLegalEntityInvoiceBreakdownStaging AS sources
	RIGHT JOIN OutcomesMTM.dbo.rptHumanaLegalEntityInvoiceBreakdown AS targets ON sources.humanaLegalEntityInvoiceBreakdownID=targets.humanaLegalEntityInvoiceBreakdownID
	WHERE sources.humanaLegalEntityInvoiceBreakdownID IS NULL

END



