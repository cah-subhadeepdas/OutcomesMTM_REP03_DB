CREATE   VIEW [cms].[vw_ValidationRuleRunResult_Active]
AS

	select
		vrr.ValidationRuleRunID
		, vrr.ValidationDataSet
		, vrr.BatchKey
		, vrr.BatchValue
		, vrr.CreateDT
		, vrr.ClientID
		, vrr.ContractYear
		, vrr.FileID
		, vrr.ContractNumber
		, vrr.IsCurrent
		, vrr.ValidationRuleDescription
		, vrr.External_RuleID
		, vrr.External_Error_Description
		, vrr.External_Action_Details
		, vrr.SeverityLevel
		, vrrr.ValidationRuleRunResultID
		, vrrr.ValidationRuleResultStatus
		, vrrr.UIDKey
		, vrrr.UIDValue
		, vrrr.ValidationData
	from cms.vw_ValidationRuleRun_Active vrr
	left join cms.ValidationRuleRunResult_new vrrr
		on vrrr.ValidationRuleRunID = vrr.ValidationRuleRunID
	where 1=1

