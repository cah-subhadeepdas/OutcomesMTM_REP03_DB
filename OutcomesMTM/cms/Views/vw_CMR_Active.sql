


CREATE      VIEW [cms].[vw_CMR_Active]

AS

	select
		SourceSystem
		,CMRID
		,ClaimID
		,MTMServiceDT
		,ReasonCode
		,ActionCode
		,ResultCode
		,ClaimStatus
		,ClaimStatusDT
		,PatientID
		,PharmacyID
		,NCPDP_NABP
		,CMRWithSPT
		,CMRSuccess  --// added 2019
		,CMROffer
		,CMRID_Source
		,CognitivelyImpairedIndicator
		,MethodOfDeliveryCode
		,ProviderCode
		,RecipientCode
		,AuthorizedRepresentative
		,Topic01
		,Topic02
		,Topic03
		,Topic04
		,Topic05
		,MAPCount
		,SPTDate  --// added 2019
		,SPTReturnDate  --// added 2019
		,LTC_Actual = cmr.LTC  --// added 2019
		,LTCIndicator = case when cmr.LTC = 1 then 'Y' when cmr.LTC = 0 then 'N' else 'U' end  --// added 2019
		,SnapshotID
		,ClientID
		,ContractYear
		,IsCurrent
	from cms.vw_CMR_History cmr
	where 1=1
	and cmr.IsCurrent = 1

	UNION ALL

	select
		SourceSystem
		,CMRID
		,ClaimID = NULL
		,MTMServiceDT
		,ReasonCode = NULL
		,ActionCode = NULL
		,ResultCode = NULL
		,ClaimStatus = NULL
		,ClaimStatusDT = NULL
		,PatientID
		,PharmacyID = NULL
		,NCPDP_NABP = NULL
		,CMRWithSPT
		,CMRSuccess = 1  --// added 2019
		,CMROffer
		,CMRID_Source
		,CognitivelyImpairedIndicator
		,MethodOfDeliveryCode
		,ProviderCode
		,RecipientCode
		,AuthorizedRepresentative
		,Topic01 = NULL
		,Topic02 = NULL
		,Topic03 = NULL
		,Topic04 = NULL
		,Topic05 = NULL
		,MAPCount = NULL
		,SPTDate   --// added 2019
		,SPTReturnDate = NULL  --// added 2019
		,LTC_Actual = LTC  --// added 2019
		,LTCIndicator = case when LTC = 1 then 'Y' when LTC = 0 then 'N' else 'U' end   --// added 2019
		,SnapshotID
		,ClientID
		,ContractYear
		,IsCurrent
		--select *
	from cms.vw_CMRSupplemental_Active

