

create proc [dbo].[U_IdentificationType]
as
begin
set nocount on;
set xact_abort on;

update it
set it.[IdentificationTypeID] = ir.[IdentificationTypeID]
       ,it.[IdentificationType] = ir.[IdentificationType]
--select count(*)
from [dbo].[IdentificationType] it
join [dbo].[IdentificationTypeStaging] ir on ir.[IdentificationTypeID] = it.[IdentificationTypeID]
where 1=1

delete ir
--select count(*)
from [dbo].[IdentificationType] it
left join [dbo].[IdentificationTypeStaging] ir on ir.[IdentificationTypeID] = it.[IdentificationTypeID]
where 1=1
and ir.[IdentificationTypeID] is null

insert into [dbo].[IdentificationType] ([IdentificationTypeID], [IdentificationType])
select ir.[IdentificationTypeID]
       ,ir.[IdentificationType]
from [dbo].[IdentificationType] it
right join [dbo].[IdentificationTypeStaging] ir on ir.[IdentificationTypeID] = it.[IdentificationTypeID]
where 1=1
and it.[IdentificationTypeID] is null

end

