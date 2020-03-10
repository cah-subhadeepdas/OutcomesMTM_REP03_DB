

CREATE   VIEW [cms].[vw_ValidationRuleRunResult_Active_PivotUID]
AS

	select distinct
		vrrr.ValidationDataSet
		, vrrr.BatchKey
		, vrrr.BatchValue
		, vrrr.CreateDT
		, vrrr.ClientID
		, vrrr.ContractYear
		, vrrr.FileID
		, vrrr.ContractNumber
		, vrrr.UIDKey
		, vrrr.UIDValue
		, Severity1_Count_Batch = isnull(vrrr2.Severity1_Count_Batch,0)  --sum( case when vrrr.SeverityLevel = 1 then 1 else 0 end ) over (partition by vrrr.ValidationDataSet, vrrr.BatchKey, vrrr.BatchValue)
		, Severity2_Count_Batch = isnull(vrrr2.Severity2_Count_Batch,0)  --sum( case when vrrr.SeverityLevel = 2 then 1 else 0 end ) over (partition by vrrr.ValidationDataSet, vrrr.BatchKey, vrrr.BatchValue)
		, Severity3_Count_Batch = isnull(vrrr2.Severity3_Count_Batch,0)  --sum( case when vrrr.SeverityLevel = 3 then 1 else 0 end ) over (partition by vrrr.ValidationDataSet, vrrr.BatchKey, vrrr.BatchValue)
		, SeverityLevel_Min_Batch = isnull(vrrr2.SeverityLevel_Min_Batch,99)  --min(vrrr.SeverityLevel) over (partition by vrrr.ValidationDataSet, vrrr.BatchKey, vrrr.BatchValue)
		, ValidationCheck_InternalQA_CSV = stuff((  --// ValidationRuleDescription
					select '|' + vrrr2.ValidationRuleDescription
					from cms.vw_ValidationRuleRunResult_Active vrrr2
					where 1=1
					and vrrr.BatchKey = vrrr2.BatchKey
					and vrrr.BatchValue = vrrr2.BatchValue
					and vrrr.CreateDT = vrrr2.CreateDT
					and vrrr.UIDKey = vrrr2.UIDKey
					and vrrr.UIDValue = vrrr2.UIDValue
					and isnull(vrrr2.ValidationRuleDescription,'') <> ''
					order by vrrr2.ValidationRuleDescription
					for XML PATH('')), 1, 1, '')
		, ValidationCheck_InternalQA_CSV2 = stuff((  --// ValidationRuleDescription
					select '|' + vrrr2.ValidationRuleDescription + ' ' + vrrr2.ValidationData
					from cms.vw_ValidationRuleRunResult_Active vrrr2
					where 1=1
					and vrrr.BatchKey = vrrr2.BatchKey
					and vrrr.BatchValue = vrrr2.BatchValue
					and vrrr.CreateDT = vrrr2.CreateDT
					and vrrr.UIDKey = vrrr2.UIDKey
					and vrrr.UIDValue = vrrr2.UIDValue
					and isnull(vrrr2.ValidationRuleDescription,'') <> ''
					order by vrrr2.ValidationRuleDescription
					for XML PATH('')), 1, 1, '')
		, ValidationCheck_CSV = stuff(( --// External_Error_Description
					select '|' + vrrr2.External_Error_Description
					from cms.vw_ValidationRuleRunResult_Active vrrr2
					where 1=1
					and vrrr.BatchKey = vrrr2.BatchKey
					and vrrr.BatchValue = vrrr2.BatchValue
					and vrrr.CreateDT = vrrr2.CreateDT
					and vrrr.UIDKey = vrrr2.UIDKey
					and vrrr.UIDValue = vrrr2.UIDValue
					and isnull(vrrr2.External_Error_Description,'') <> ''
					order by vrrr2.External_Error_Description
					for XML PATH('')), 1, 1, '')
		, ValidationAction_CSV = stuff(( --// External_Action_Details
					select '|' + vrrr2.External_Action_Details
					from cms.vw_ValidationRuleRunResult_Active vrrr2
					where 1=1
					and vrrr.BatchKey = vrrr2.BatchKey
					and vrrr.BatchValue = vrrr2.BatchValue
					and vrrr.CreateDT = vrrr2.CreateDT
					and vrrr.UIDKey = vrrr2.UIDKey
					and vrrr.UIDValue = vrrr2.UIDValue
					and isnull(vrrr2.External_Action_Details,'') <> ''
					order by vrrr2.External_Action_Details
					for XML PATH('')), 1, 1, '')
	from cms.vw_ValidationRuleRunResult_Active vrrr
	outer apply (
		select top 1
			Severity1_Count_Batch = sum( case when vrrr99.SeverityLevel = 1 then 1 else 0 end ) over (partition by vrrr99.ValidationDataSet, vrrr99.BatchKey, vrrr99.BatchValue)
			, Severity2_Count_Batch = sum( case when vrrr99.SeverityLevel = 2 then 1 else 0 end ) over (partition by vrrr99.ValidationDataSet, vrrr99.BatchKey, vrrr99.BatchValue)
			, Severity3_Count_Batch = sum( case when vrrr99.SeverityLevel = 3 then 1 else 0 end ) over (partition by vrrr99.ValidationDataSet, vrrr99.BatchKey, vrrr99.BatchValue)
			, SeverityLevel_Min_Batch = min(vrrr99.SeverityLevel) over (partition by vrrr99.ValidationDataSet, vrrr99.BatchKey, vrrr99.BatchValue)
		from cms.vw_ValidationRuleRunResult_Active vrrr99
		where 1=1
		and vrrr99.ValidationRuleResultStatus = 1
		and vrrr99.BatchKey = vrrr.BatchKey
		and vrrr99.BatchValue = vrrr.BatchValue
	) vrrr2
	where 1=1


