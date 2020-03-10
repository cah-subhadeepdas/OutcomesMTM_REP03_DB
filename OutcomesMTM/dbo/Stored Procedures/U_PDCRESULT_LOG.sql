CREATE procedure [dbo].[U_PDCRESULT_LOG]
as 
begin
set nocount on;
set xact_abort on;

--PDCResultDim 
update d  
set d.[activeThru] = s.queueDate
, d.[isCurrent] = case when (s.isInsert = 0 or s.active = 0) then 1 else 0 end
--select count(*) 
from PDCResultDim d 
join PDCResultDeltaQueueStaging s on d.PDCResultid = s.PDCResultid 
where 1=1 
and d.activeThru is null 
and s.isDelete = 1 

insert into PDCResultDim (
PDCresultID
,PDCruleID
,PatientID
,coveredDays
,minIndexDate
,maxIndexDate
,GPI
,[activeAsOf] 
,[isCurrent]
) 
select s.PDCresultID
,s.PDCruleID
,s.PatientID
,s.coveredDays
,s.minIndexDate
,s.maxIndexDate
,s.GPI
,s.[queueDate] 
,1 as isCurrent
--select count(*) 
from PDCResultDeltaQueueStaging s 
where 1=1 
and s.isInsert = 1
and s.active = 1  
and not exists (
		select 1 
		from PDCResultDim d
		where 1=1 
		and d.PDCResultID = s.PDCResultID 
		and d.activeasof = s.queueDate
	)

END




