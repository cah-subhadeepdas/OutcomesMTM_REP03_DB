

create proc [dbo].[U_IdentificationConfigType]
as
begin
set nocount on;
set xact_abort on;


update ic
set ic.[IdentificationConfigTypeID] = ir.[IdentificationConfigTypeID]
       ,ic.[IdentificationConfigType] = ir.[IdentificationConfigType]
--select count(*)
from [dbo].[IdentificationConfigType] ic
join [dbo].[IdentificationConfigTypeStaging] ir on ir.[IdentificationConfigTypeID] = ic.[IdentificationConfigTypeID]
where 1=1

delete ir
--select count(*)
from [dbo].[IdentificationConfigType] ic
left join [dbo].[IdentificationConfigTypeStaging] ir on ir.[IdentificationConfigTypeID] = ic.[IdentificationConfigTypeID]
where 1=1
and ir.[IdentificationConfigTypeID] is null

insert into [dbo].[IdentificationConfigType] ([IdentificationConfigTypeID], [IdentificationConfigType])
select ir.[IdentificationConfigTypeID]
       ,ir.[IdentificationConfigType]
from [dbo].[IdentificationConfigType] ic
right join [dbo].[IdentificationConfigTypeStaging] ir on ir.[IdentificationConfigTypeID] = ic.[IdentificationConfigTypeID]
where 1=1
and ic.[IdentificationConfigTypeID] is null


end

