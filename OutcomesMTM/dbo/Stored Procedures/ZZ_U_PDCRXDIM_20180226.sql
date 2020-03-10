


CREATE procedure [dbo].[ZZ_U_PDCRXDIM_20180226]
as 
begin
set nocount on;
set xact_abort on;


if(object_id('tempdb..#queueOrder') is not null)
drop table #queueOrder
create table #queueOrder (
queueOrderID int identity(1,1) primary key 
, queueOrder int 
)
insert into #queueOrder (queueOrder) 
select distinct queueOrder 
from PDCRXDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--DELETES
	update d  
	set d.activethru = s.queueDate
	, d.[isCurrent] = 1 
	--select count(*) 
	from PDCRXDim d 
	join PDCRXDeltaQueueStaging s on d.patientid = s.patientid
									and d.pdcRuleID = s.pdcRuleID
									and d.RXID = s.RXID
									and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 0
		 

	--UPDATES
	update d  
	set d.activethru = s.queueDate
	, d.[isCurrent] = 0 
	--select count(*) 
	from PDCRXDim d 
	join PDCRXDeltaQueueStaging s on d.patientid = s.patientid
									and d.pdcRuleID = s.pdcRuleID
									and d.RXID = s.RXID
									and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and not (
		isnull(d.[PDCRXID],0) = isnull(s.[PDCRXID],0)
	)


	insert into PDCRXDim (
	[PDCRXID] 
	,[PDCruleID] 
	,[PatientID] 
	,[RXID] 
	,[activeAsOf] 
	,[isCurrent]
	) 
	select s.[PDCRXID] 
	,s.[PDCruleID] 
	,s.[PatientID] 
	,s.[RXID] 
	,s.[queueDate] 
	,1 as isCurrent
	--select count(*) 
	from PDCRXDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder
	and s.isInsert = 1 
	and not exists (
			select 1 
			from PDCRXDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.pdcRuleID = s.pdcRuleID 
			and d1.RXID = s.RXID 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from PDCRXDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.pdcRuleID = s.pdcRuleID 
			and d2.RXID = s.RXID 
			and d2.activethru is null 
		)

set @cnt = @cnt + 1 

end--end loop



END











