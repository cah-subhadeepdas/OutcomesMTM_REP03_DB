

create proc [dbo].[U_identificationSourceType]
as
begin
set nocount on;
set xact_abort on;


update ic
set  ic.[identificationSourceTypeID] = ir.[identificationSourceTypeID]
       ,ic.[identificationSourceType] = ir.[identificationSourceType]
--select count(*)
from [dbo].[identificationSourceType] ic
join [dbo].[identificationSourceTypeStaging] ir on ir.[identificationSourceTypeID] = ic.[identificationSourceTypeID]
where 1=1

delete ir
--select count(*)
from [dbo].[identificationSourceType] ic
left join [dbo].[identificationSourceTypeStaging] ir on ir.[identificationSourceTypeID] = ic.[identificationSourceTypeID]
where 1=1
and ir.[identificationSourceTypeID] is null

insert into [dbo].[identificationSourceType] ([identificationSourceTypeID], [identificationSourceType])
select ir.[identificationSourceTypeID]
,ir.[identificationSourceType]
from [dbo].[identificationSourceType] ic
right join [dbo].[identificationSourceTypeStaging] ir on ir.[identificationSourceTypeID] = ic.[identificationSourceTypeID]
where 1=1
and ic.[identificationSourceTypeID] is null


end

