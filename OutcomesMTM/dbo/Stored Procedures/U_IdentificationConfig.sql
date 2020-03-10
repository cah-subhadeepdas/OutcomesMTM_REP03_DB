

create proc [dbo].[U_IdentificationConfig]
as
begin
set nocount on;
set xact_abort on;



update ic
set ic.[identificationConfigID] = ir.[identificationConfigID]
       ,ic.[identificationConfigName] = ir.[identificationConfigName]
       ,ic.[identificationTypeID] = ir.[identificationTypeID]
       ,ic.[PolicyID] = ir.[PolicyID]
       ,ic.[contractyear] = ir.[contractyear]
       ,ic.[serviceTypeID] = ir.[serviceTypeID]
       ,ic.[patientActivate] = ir.[patientActivate]
       ,ic.[cmrActivate] = ir.[cmrActivate]
       ,ic.[identificationConfigTypeID] = ir.[identificationConfigTypeID]
       ,ic.[ID] = ir.[ID]
       ,ic.[identificationDXTypeID] = ir.[identificationDXTypeID]
       ,ic.[identificationRXTypeID] = ir.[identificationRXTypeID]
       ,ic.[identificationTipTypeID] = ir.[identificationTipTypeID]
       ,ic.[active] = ir.[active]
       ,ic.[activeasof] = ir.[activeasof]
       ,ic.[activethru] = ir.[activethru]
       ,ic.[identificationSourceTypeID] = ir.[identificationSourceTypeID]
--select count(*)
from [dbo].[IdentificationConfig] ic
join [dbo].[IdentificationConfigStaging] ir on ir.[identificationConfigID] = ic.[identificationConfigID]
where 1=1

delete ir
--select count(*)
from [dbo].[IdentificationConfig] ic
left join [dbo].[IdentificationConfigStaging] ir on ir.[identificationConfigID] = ic.[identificationConfigID]
where 1=1
and ir.[identificationConfigID] is null


insert into [dbo].[IdentificationConfig] ([identificationConfigID]
       ,[identificationConfigName]
       ,[identificationTypeID]
       ,[PolicyID]
       ,[contractyear]
       ,[serviceTypeID]
       ,[patientActivate]
       ,[cmrActivate]
       ,[identificationConfigTypeID]
       ,[ID]
       ,[identificationDXTypeID]
       ,[identificationRXTypeID]
       ,[identificationTipTypeID]
       ,[active]
       ,[activeasof]
       ,[activethru]
       ,[identificationSourceTypeID]
)
select ir.[identificationConfigID]
       ,ir.[identificationConfigName]
       ,ir.[identificationTypeID]
       ,ir.[PolicyID]
       ,ir.[contractyear]
       ,ir.[serviceTypeID]
       ,ir.[patientActivate]
       ,ir.[cmrActivate]
       ,ir.[identificationConfigTypeID]
       ,ir.[ID]
       ,ir.[identificationDXTypeID]
       ,ir.[identificationRXTypeID]
       ,ir.[identificationTipTypeID]
       ,ir.[active]
       ,ir.[activeasof]
       ,ir.[activethru]
       ,ir.[identificationSourceTypeID]
from [dbo].[IdentificationConfig] ic
right join [dbo].[IdentificationConfigStaging] ir on ir.[identificationConfigID] = ic.[identificationConfigID]
where 1=1
and ic.[identificationConfigID] is null

end

