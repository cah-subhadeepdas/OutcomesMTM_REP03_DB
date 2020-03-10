

-- ==========================================================================================
-- Author:		Paul Dickey
-- Create date: 10/20/2016
-- Description:	This proc is used by the SSRS report named humanaLegalEntityInvoiceBreakdown.rdl, which is a report
--				of the number of members who were plan active in each monthly Humana eligibility file, broken out
--				by Source Code, Entity Number, and Entity Name.  Meredith in Client Services or Luke in Accounting
--				use the report for billing Humana.  This proc is used to populate the drop down list of files.
-- Exec Time:   00:00:00.003 on 10/20/2016
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		10/20/2016	Paul Dickey		Created proc
-- ==========================================================================================
CREATE PROCEDURE [dbo].[S_rptHumanaLegalEntityInvoiceBreakdown_File]
AS
BEGIN

	SELECT DISTINCT hleib.fileID
	,CONVERT(VARCHAR(10), hleib.fileLoadDate, 111) + ' - ' + hleib.[fileName] AS fileDisplayName
	FROM dbo.rptHumanaLegalEntityInvoiceBreakdown AS hleib
	ORDER BY hleib.fileID DESC

END


