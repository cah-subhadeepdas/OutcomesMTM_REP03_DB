
create proc [dbo].[U_TIPDetailRule]
as
begin
set nocount on;
set xact_abort on;


update td
set td.[TIPDetailRuleID] = ts.[TIPDetailRuleID]
	,td.[tipdetailid] = ts.[tipdetailid]
	,td.[overview] = ts.[overview]
	,td.[formulary] = ts.[formulary]
	,td.[lookback] = ts.[lookback]
	,td.[reasonTypeID] = ts.[reasonTypeID]
	,td.[actionTypeID] = ts.[actionTypeID]
	,td.[ecaLevelID] = ts.[ecaLevelID]
	,td.[isAgeDependent] = ts.[isAgeDependent]
	,td.[startAge] = ts.[startAge]
	,td.[endAge] = ts.[endAge]
	,td.[StarTip] = ts.[StarTip]
	,td.[directLoadTip] = ts.[directLoadTip]
	,td.[longitudinalTip] = ts.[longitudinalTip]
	,td.[publishTip] = ts.[publishTip]
	,td.[YTDRange] = ts.[YTDRange]
	,td.[targetedPDC] = ts.[targetedPDC]
	,td.[targetedPDCPCT] = ts.[targetedPDCPCT]
	,td.[targetedPDCRatioMin] = ts.[targetedPDCRatioMin]
	,td.[targetedPDCRatioMax] = ts.[targetedPDCRatioMax]
	,td.[PDCRange] = ts.[PDCRange]
	,td.[PDCRangeMin] = ts.[PDCRangeMin]
	,td.[PDCRangeMax] = ts.[PDCRangeMax]
	,td.[generateOnSupply] = ts.[generateOnSupply]
	,td.[generateOnSupplyRule] = ts.[generateOnSupplyRule]
	,td.[generateOnSupplyRuleValue] = ts.[generateOnSupplyRuleValue]
	,td.[TIPTypeID] = ts.[TIPTypeID]
	,td.[active] = ts.[active]
	,td.[activeasof] = ts.[activeasof]
	,td.[activethru] = ts.[activethru]
	,td.[defaultRegenerationDays] = ts.[defaultRegenerationDays]
	,td.[NINRegenerationDays] = ts.[NINRegenerationDays]
--select count(*)
from outcomesMTM.dbo.TIPDetailRule td
join outcomesMTM.dbo.TIPDetailRuleStaging ts on ts.[TIPDetailRuleID] = td.TIPDetailRuleID
where 1=1

delete td
--select count(*)
from outcomesMTM.dbo.TIPDetailRule td
left join outcomesMTM.dbo.TIPDetailRuleStaging ts on ts.[TIPDetailRuleID] = td.TIPDetailRuleID
where 1=1
and ts.TIPDetailRuleID is null

insert into outcomesMTM.dbo.TIPDetailRule ([TIPDetailRuleID]
	,[tipdetailid]
	,[overview]
	,[formulary]
	,[lookback]
	,[reasonTypeID]
	,[actionTypeID]
	,[ecaLevelID]
	,[isAgeDependent]
	,[startAge]
	,[endAge]
	,[StarTip]
	,[directLoadTip]
	,[longitudinalTip]
	,[publishTip]
	,[YTDRange]
	,[targetedPDC]
	,[targetedPDCPCT]
	,[targetedPDCRatioMin]
	,[targetedPDCRatioMax]
	,[PDCRange]
	,[PDCRangeMin]
	,[PDCRangeMax]
	,[generateOnSupply]
	,[generateOnSupplyRule]
	,[generateOnSupplyRuleValue]
	,[TIPTypeID]
	,[active]
	,[activeasof]
	,[activethru]
	,[defaultRegenerationDays]
	,[NINRegenerationDays]
)
select ts.[TIPDetailRuleID]
	,ts.[tipdetailid]
	,ts.[overview]
	,ts.[formulary]
	,ts.[lookback]
	,ts.[reasonTypeID]
	,ts.[actionTypeID]
	,ts.[ecaLevelID]
	,ts.[isAgeDependent]
	,ts.[startAge]
	,ts.[endAge]
	,ts.[StarTip]
	,ts.[directLoadTip]
	,ts.[longitudinalTip]
	,ts.[publishTip]
	,ts.[YTDRange]
	,ts.[targetedPDC]
	,ts.[targetedPDCPCT]
	,ts.[targetedPDCRatioMin]
	,ts.[targetedPDCRatioMax]
	,ts.[PDCRange]
	,ts.[PDCRangeMin]
	,ts.[PDCRangeMax]
	,ts.[generateOnSupply]
	,ts.[generateOnSupplyRule]
	,ts.[generateOnSupplyRuleValue]
	,ts.[TIPTypeID]
	,ts.[active]
	,ts.[activeasof]
	,ts.[activethru]
	,ts.[defaultRegenerationDays]
	,ts.[NINRegenerationDays]
from outcomesMTM.dbo.TIPDetailRule td
right join outcomesMTM.dbo.TIPDetailRuleStaging ts on ts.[TIPDetailRuleID] = td.TIPDetailRuleID
where 1=1
and td.TIPDetailRuleID is null

end 

