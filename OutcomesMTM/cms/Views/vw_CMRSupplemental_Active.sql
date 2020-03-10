
CREATE     VIEW [cms].[vw_CMRSupplemental_Active]

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
		,SPTDate
		,LTC
		,SnapshotID
		,ClientID
		,ContractYear
		,IsCurrent
	from cms.vw_CMRSupplemental_History cmrs
	where 1=1
	and cmrs.IsCurrent = 1

