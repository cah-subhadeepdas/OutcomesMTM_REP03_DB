

Create     PROCEDURE [dbo].[S_CareSource_ClaimsNew_Daily_AdHoc] 
	
AS
DECLARE @clientName VARCHAR(50)
DECLARE @fromDate DATE
DECLARE @thruDate DATE
DECLARE @ROWCOUNT INT

SET @clientName = 'CareSource'
SET @fromDate = '2018-01-03'--CAST(DATEADD(DAY,-1,GETDATE()) AS DATE)
SET @thruDate = '2018-01-04'--CAST(GETDATE() AS DATE)
--SELECT @ROWCOUNT = COUNT([CLAIM ID]) FROM outcomesmtm.dbo.[vw_Client_DailyClaims_RPT] dc WHERE dc.CreateDT >= DATEADD(DAY, -1, GETDATE()) AND dc.CreateDT< GETDATE() OR dc.statusDT  >=  DATEADD(DAY, -1, GETDATE()) AND dc.statusDT< GETDATE()

SELECT @ROWCOUNT = COUNT([CLAIM ID]) FROM outcomesmtm.dbo.[vw_Client_DailyClaims_RPT] dc WHERE dc.CreateDT >= @fromDate AND dc.CreateDT< @thruDate OR dc.statusDT  >=  @fromDate AND dc.statusDT< @thruDate



IF (@ROWCOUNT>0)
BEGIN
	SELECT   
	  [Claim ID]
	, [Policy ID]
	, [Policy Name]
	, [MTM Service Date]
	, [Status]
	, [Validation Status]
	, [Member ID]
	, [Patient Last Name]
	, [Patient First Name]
	, [Patient DOB]
	, [Patient Gender]
	, [Patient Phone]
	, [NABP]
	, [Pharmacy Name]
	, [State Delivered]
	, [RPH License Number] 
	, [RPH Name]
	, [Reason Number]
	, [Reason Name]
	, [Action Number]
	, [Action Name]
	, [Result Number]
	, [Result Name]
	, [Severity Level]
	, [Level Name]
	, [AIM Dollar Value]
	, [MTM Claim Fee]
	, SUBSTRING([Additional Notes], 1, 500) AS [Additional Notes]
	, [Method of Delivery]
	, [Claim Associated With A CMR]
	, [Claim Is A Tip Flag] 
	, [Tip Detail Id Number]
	, [Tip Title]
	, [Tip Identification Date] 
	, [Final Rx]
	, [Final Rx Quantity]
	, [Final Rx Day Supply]
	, [Final Rx GPI]
	, [Final Rx Product Name]
	, [Initial Rx]
	, [Initial Rx Quantity]
	, [Initial Rx Day Supply]
	, [Initial Rx GPI]
	, [Initial Rx Product Name]
	, [Initial Prescriber NPI]
	, [Initial Prescriber Name]
	, [Adherence - Too many medications or doses per day]
	, [Adherence - Forgets to take on routine days]
	, [Adherence - Forgets to take on non-routine days]
	, [Feels medication is not helping]
	, [Feels medication is not needed]
	, [Experienced side effects]
	, [Concerned about potential side effects]
	, [Medication cost is too high]
	, [Decreased cognitive function]
	, [Limitations on activities of daily living]
	, [Transportation limitations prevent pharmacy access]
	, [Patient taking differently than written directions]
	, [Refill request delay]
	, [No barrier identified]
	, [Pharmacy error in directions/delivery/medication]
	, [Refill Attestation]
	, [Patient Refusal Reason]
	, [Presciber Refusal Reason]
	, [Paid Date]
	, [Date Submitted]
	, [Last Updated Date]
	, [Documented User Role]
	, [Documentation User]
	, [CMS Contract Number]
	, [PBP]
	, [Time It Took To Complete MTM Service]
	, [Health Test Value]
	, [PCP Name]
	, [Preg Test Result]
	, [Is Legacy Service Type Claim]
	, [Is Essential Service Type Claim]
	, [Is Star Service Type Claim]

	FROM outcomesmtm.dbo.[vw_Client_DailyClaims_RPT] dc
	WHERE 1=1
	AND ((dc.CreateDT >= @fromDate and dc.CreateDT < @thruDate) 
			OR (dc.statusDT >= @fromDate and dc.statusDT < @thruDate))
	AND EXISTS (
		SELECT 1
		FROM outcomesmtm.dbo.Policy po
		JOIN outcomesmtm.dbo.Contract co
			ON co.ContractID = po.contractID
		JOIN outcomesmtm.dbo.Client cl
			ON cl.clientID = co.ClientID
		WHERE 1=1
		AND cl.clientName = @clientName
		AND po.policyID = dc.[Policy ID]
	)
 END 

ELSE

BEGIN
	SELECT   top 1 
	  [Claim ID]											= 999999999					
	, [Policy ID]											= NULL
	, [Policy Name]											= ''
	, [MTM Service Date]									= ''
	, [Status]												= ''
	, [Validation Status]									= ''
	, [Member ID]											= ''
	, [Patient Last Name]									= ''
	, [Patient First Name]									= ''
	, [Patient DOB]											= ''
	, [Patient Gender]										= ''
	, [Patient Phone]										= ''
	, [NABP]												= ''
	, [Pharmacy Name]										= ''
	, [State Delivered]										= ''
	, [RPH License Number]									= ''
	, [RPH Name]											= ''
	, [Reason Number]										= NULL
	, [Reason Name]											= ''
	, [Action Number]										= NULL
	, [Action Name]											= ''
	, [Result Number]										= NULL
	, [Result Name]											= ''
	, [Severity Level]										= NULL
	, [Level Name]											= ''
	, [AIM Dollar Value]									= NULL
	, [MTM Claim Fee]										= NULL
	, [Additional Notes]									= ''
	, [Method of Delivery]									= ''
	, [Claim Associated With A CMR]							= ''
	, [Claim Is A Tip Flag]									= ''
	, [Tip Detail Id Number]								= ''
	, [Tip Title]											= ''
	, [Tip Identification Date]								= ''
	, [Final Rx]											= ''
	, [Final Rx Quantity]									= NULL
	, [Final Rx Day Supply]									= NULL
	, [Final Rx GPI]										= ''
	, [Final Rx Product Name]								= ''
	, [Initial Rx]											= ''
	, [Initial Rx Quantity]									= NULL
	, [Initial Rx Day Supply]								= NULL
	, [Initial Rx GPI]										= ''
	, [Initial Rx Product Name]								= ''
	, [Initial Prescriber NPI]								= ''
	, [Initial Prescriber Name]								= ''
	, [Adherence - Too many medications or doses per day]	= ''
	, [Adherence - Forgets to take on routine days]			= ''
	, [Adherence - Forgets to take on non-routine days]		= ''
	, [Feels medication is not helping]						= ''
	, [Feels medication is not needed]						= ''
	, [Experienced side effects]							= ''
	, [Concerned about potential side effects]				= ''
	, [Medication cost is too high]							= ''
	, [Decreased cognitive function]						= ''
	, [Limitations on activities of daily living]			= ''
	, [Transportation limitations prevent pharmacy access]	= ''
	, [Patient taking differently than written directions]	= ''
	, [Refill request delay]								= ''
	, [No barrier identified]								= ''
	, [Pharmacy error in directions/delivery/medication]	= ''
	, [Refill Attestation]									= ''
	, [Patient Refusal Reason]								= ''
	, [Presciber Refusal Reason]							= ''
	, [Paid Date]											= ''
	, [Date Submitted]										= ''
	, [Last Updated Date]									= ''
	, [Documented User Role]								= ''
	, [Documentation User]									= ''
	, [CMS Contract Number]									= ''
	, [PBP]													= ''
	, [Time It Took To Complete MTM Service]				= NULL
	, [Health Test Value]									= NULL
	, [PCP Name]											= ''
	, [Preg Test Result]									= ''
	, [Is Legacy Service Type Claim]						= ''
	, [Is Essential Service Type Claim]						= ''
	, [Is Star Service Type Claim]							= ''
	from  outcomesmtm.dbo.[vw_Client_DailyClaims_RPT] dc
	WHERE 1=1
	AND ((dc.CreateDT >= @fromDate and dc.CreateDT < @thruDate) 
			OR (dc.statusDT >= @fromDate and dc.statusDT < @thruDate))
	AND EXISTS (
		SELECT 1
		FROM outcomesmtm.dbo.Policy po
		JOIN outcomesmtm.dbo.Contract co
			ON co.ContractID = po.contractID
		JOIN outcomesmtm.dbo.Client cl
			ON cl.clientID = co.ClientID
		WHERE 1=1
		AND cl.clientName = @clientName
		AND po.policyID = dc.[Policy ID] )
 END




 





