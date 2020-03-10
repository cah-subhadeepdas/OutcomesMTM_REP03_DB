

create proc [dbo].[U_IdentificationConfigCriteria]
as
begin
set nocount on;
set xact_abort on;


update ic
set ic.[IdentificationConfigCriteriaID] = ir.[IdentificationConfigCriteriaID]
       ,ic.[IdentificationConfigID] = ir.[IdentificationConfigID]
       ,ic.[DxMinCount] = ir.[DxMinCount]
       ,ic.[RxGPIlength] = ir.[RxGPIlength]
       ,ic.[RxLookbackbyMonth] = ir.[RxLookbackbyMonth]
       ,ic.[RxMinCount] = ir.[RxMinCount]
       ,ic.[RxCostLookbackbyMonth] = ir.[RxCostLookbackbyMonth]
       ,ic.[RxCost] = ir.[RxCost]
       ,ic.[TipMinCount] = ir.[TipMinCount]
       ,ic.[FrequencybyMonth] = ir.[FrequencybyMonth]
       ,ic.[ageDependent] = ir.[ageDependent]
       ,ic.[minAge] = ir.[minAge]
       ,ic.[maxAge] = ir.[maxAge]
--select count(*)
from [dbo].[IdentificationConfigCriteria] ic
join [dbo].[IdentificationConfigCriteriaStaging] ir on ir.[IdentificationConfigCriteriaID] = ic.[IdentificationConfigCriteriaID]
where 1=1

delete ir
--select count(*)
from [dbo].[IdentificationConfigCriteria] ic
left join [dbo].[IdentificationConfigCriteriaStaging] ir on ir.[IdentificationConfigCriteriaID] = ic.[IdentificationConfigCriteriaID]
where 1=1
and ir.[IdentificationConfigCriteriaID] is null


insert into [dbo].[IdentificationConfigCriteria] ([IdentificationConfigCriteriaID]
       ,[IdentificationConfigID]
       ,[DxMinCount]
       ,[RxGPIlength]
       ,[RxLookbackbyMonth]
       ,[RxMinCount]
       ,[RxCostLookbackbyMonth]
       ,[RxCost]
       ,[TipMinCount]
       ,[FrequencybyMonth]
       ,[ageDependent]
       ,[minAge]
       ,[maxAge]
)
select ir.[IdentificationConfigCriteriaID]
       ,ir.[IdentificationConfigID]
       ,ir.[DxMinCount]
       ,ir.[RxGPIlength]
       ,ir.[RxLookbackbyMonth]
       ,ir.[RxMinCount]
       ,ir.[RxCostLookbackbyMonth]
       ,ir.[RxCost]
       ,ir.[TipMinCount]
       ,ir.[FrequencybyMonth]
       ,ir.[ageDependent]
       ,ir.[minAge]
       ,ir.[maxAge]
from [dbo].[IdentificationConfigCriteria] ic
right join [dbo].[IdentificationConfigCriteriaStaging] ir on ir.[IdentificationConfigCriteriaID] = ic.[IdentificationConfigCriteriaID]
where 1=1
and ic.[IdentificationConfigCriteriaID] is null

end

