

-- ==========================================================================================
-- Author:	RAM RAVI
-- Create date: 05-29-2019
-- Description:	Pharmacy Network Extract Report which is part of the CVS Adherence Initiative
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		05/29/2019	Ram Ravi    	TC-2966 
-- ==========================================================================================

CREATE   VIEW [dbo].[vw_CVS_PharmacyNetworkExtract]
AS 


SELECT rtrim(ltrim(ph.NCPDP_NABP)) AS [NCPDP]
	 , rtrim(ltrim(ph.NPI))		   AS [NPI]
	 , r.ProgramID	               AS [ReImbursement Program ID]
FROM OutcomesMTM.dbo.[Contracted_Trained_mtmcenters] ph
JOIN OutcomesMTM.dbo.CVS_ReimbursementIDs r ON 1=1
WHERE 1=1
AND ph.contracted = 1
AND ph.active = 1
AND isnull(ph.[Number of Trained Pharmacists], 0) <> 0

