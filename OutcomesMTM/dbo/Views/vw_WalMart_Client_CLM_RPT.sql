

CREATE VIEW dbo.vw_WalMart_Client_CLM_RPT
AS
SELECT	crv.claimid
	,crv.policyID
	,crv.policyNM
	,Convert(VARCHAR, crv.MTMSERVICEDT, 110) AS [MTM Service Date]
	,crv.STATUS
	,CASE 
		WHEN crv.claimValidationProcessed = 0
			AND isnull(crv.claimValidationPaymentProcessed, 0) = 0
			AND crv.validated = 0
			THEN 'Validation in progress'
		WHEN crv.claimValidationProcessed = 1
			AND isnull(crv.claimValidationPaymentProcessed, 0) = 0
			AND crv.validated = 0
			THEN 'Validation payment Rejected'
		WHEN (
				crv.claimValidationProcessed = 0
				OR crv.claimValidationProcessed = 1
				)
			AND isnull(crv.claimValidationPaymentProcessed, 0) = 0
			AND crv.validated = 1
			THEN 'Validation payment pending'
		WHEN crv.claimValidationProcessed = 1
			AND crv.claimValidationPaymentProcessed = 1
			AND crv.validated = 1
			THEN 'Validation payment paid'
		ELSE ''
		END AS [Validation Status]
	,crv.memberID
	,crv.MemberLastNM AS [Patient Last Name]
	,crv.MemberFirstNM AS [Patient First Name]
	,convert(VARCHAR, crv.Memberdob, 110) AS [Patient DOB]
	,crv.MemberGender AS [Patient Gender]
	,crv.MemberPhone AS [Patient Phone]
	,crv.PharmacyNABP AS NABP
	,crv.PharmacyName AS [Pharmacy Name]
	,crv.PharmacyState AS [State Delivered]
	,crv.PharmacistlicenseNumber AS [RPh License Number]
	,crv.pharmacistlastNM + ', ' + crv.pharmacistFirstNM AS [RPh Name]
	,crv.reason AS [Reason Number]
	,crv.reasonNM AS [Reason Name]
	,crv.action AS [Action Number]
	,crv.actionNM AS [Action Name]
	,crv.result AS [Result Number]
	,crv.resultNM AS [Result Name]
	,crv.serveritylevel AS [Serverity Level]
	,crv.serveritylevelNM AS [Level Name]
	,crv.estimated_cost AS [Severity Level Dollars]
	,crv.charges AS [MTM Claim FEE]
	,REPLACE(REPLACE(REPLACE(crv.additionalnotes, CHAR(10), ''), CHAR(13), ''), CHAR(9), '') AS [Additional Notes]
	,REPLACE(REPLACE(REPLACE(crv.ECAexplanation, CHAR(10), ''), CHAR(13), ''), CHAR(9), '') AS [Severity Level Rationale]
	,crv.face2face AS [Intervention Face-to-Face]
	,crv.claimfromcmr AS [Claim Associated with a CMR]
	,crv.isTipClaim AS [Claim is a TIP Flag]
	,crv.tipResultID AS [TIP Identification Number]
	,crv.tiptitle AS [TIP Title]
	,crv.tipidentificationdate AS [TIP Identification Date]
	,crv.newMedRxNumber AS [Final Rx]
	,crv.newMedMetricQuantity AS [Final Rx Qty]
	,crv.newMedDaysSupply AS [Final Rx Day Supply]
	,crv.newMedGpi AS [Final Rx GPI]
	,crv.newMedName AS [Final Rx Product Name]
	,crv.currentMedRxNumber AS [Initial Rx]
	,crv.currentMedMetricQuantity AS [Initial Rx Qty]
	,crv.currentMedDaysSupply AS [Initial Rx Day Supply]
	,crv.currentMedGpi AS [Initial Rx GPI]
	,crv.currentMedName AS [Initial Rx Product Name]
	,crv.currentPrescriberNPI AS [Initial Prescriber NPI]
	,crv.currentMedPrescriber AS [Initial Prescriber Name]
	,crv.[Adherence - Too many medications or doses per day]
	,crv.[Adherence - Forgets to take on routine days]
	,crv.[Adherence - Forgets to take on non-routine days]
	,crv.[Feels medication is not helping]
	,crv.[Feels medication is not needed]
	,crv.[Experienced side effects]
	,crv.[Concerned about potential side effects]
	,crv.[Medication cost is too high]
	,crv.[Decreased cognitive function]
	,crv.[Limitations on activities of daily living]
	,crv.[Transportation limitations prevent pharmacy access]
	,crv.paiddate AS [Paid Date]
	,Convert(VARCHAR, crv.claimSubmitDT, 110) AS [Date Submitted]
	,Convert(VARCHAR, crv.lastupdatedt, 110) AS [Last Updated Date]
	,crv.documentationRole AS [Documentation User Role]
	,crv.documentationFirstNM + ' ' + crv.documentationLastNM AS [Documentation User]
	,crv.memberCMSContractNumber AS [CMS Contract Number]
	,crv.primarypharmacy AS [Primary Pharmacy Flag]
	,crv.pctfillatCenter AS [%Patient Fills at NABP]
	,crv.pctfillatChain AS [%Patient Fills at Chain]
	,isnull(crv.numberOfNotes, 0) AS numberOfNotes
	,crv.timeToComplete AS [Time it took to complete the MTM Service (min)]
	,crv.healthTestValue
	,crv.PCPName
	,crv.pregTestResult
FROM dbo.clientManagerReport crv
LEFT JOIN dbo.pharmacychain pc on pc.centerid = crv.centerid
WHERE 1 = 1
AND pc.chainid = 48
and year(crv.createDT) = year(getdate())
and (year(crv.createdt) = year(getdate()) or year(crv.statusdt) = year(getdate()))