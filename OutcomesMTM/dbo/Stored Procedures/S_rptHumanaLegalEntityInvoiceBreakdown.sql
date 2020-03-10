

-- ==========================================================================================
-- Author:		Paul Dickey
-- Create date: 10/20/2016
-- Description:	This proc is used by the SSRS report named humanaLegalEntityInvoiceBreakdown.rdl, which is a report
--				of the number of members who were plan active in each monthly Humana eligibility file, broken out
--				by Source Code, Entity Number, and Entity Name.  Meredith in Client Services or Luke in Accounting
--				use the report for billing Humana.
-- Exec Time:   00:00:00.003 on 10/20/2016
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		10/20/2016	Paul Dickey		Created proc
-- ==========================================================================================
CREATE PROCEDURE [dbo].[S_rptHumanaLegalEntityInvoiceBreakdown]
@fileID INT
AS
BEGIN

	SELECT *
	FROM dbo.rptHumanaLegalEntityInvoiceBreakdown AS hleib
	WHERE hleib.fileID=@fileID
	AND hleib.active=1

END


