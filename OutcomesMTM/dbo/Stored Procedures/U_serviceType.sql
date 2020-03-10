
create proc [dbo].[U_serviceType]
as
begin
set nocount on;
set xact_abort on;

update st
set	st.[serviceTypeID] = ss.[serviceTypeID]
	,st.[serviceType] = ss.[serviceType]
--select count(*)
from outcomesMTM.dbo.serviceType st
join outcomesMTM.dbo.serviceTypeStaging ss on ss.serviceTypeID = st.serviceTypeID
where 1=1

delete st
--select count(*)
from outcomesMTM.dbo.serviceType st
left join outcomesMTM.dbo.serviceTypeStaging ss on ss.serviceTypeID = st.serviceTypeID
where 1=1
and ss.serviceTypeID is null

insert into outcomesMTM.dbo.serviceType ([serviceTypeID]
	,[serviceType]
)
select ss.[serviceTypeID]
	,ss.[serviceType]
from outcomesMTM.dbo.serviceType st
right join outcomesMTM.dbo.serviceTypeStaging ss on ss.serviceTypeID = st.serviceTypeID
where 1=1
and st.serviceTypeID is null

end 

