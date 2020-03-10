

CREATE procedure [dbo].[U_tipActivityReport]
as
begin 
set nocount on;
set xact_abort on;

--drop table #tempupdate
create table #tempupdate (
id int identity(1,1) primary key 
,tipresultstatusid int
)
insert into #tempupdate (tipresultstatusid) 
select p.tipresultstatusid 
from tipActivityReport p 
join tipActivityReport_staging t on t.tipresultstatusid = p.tipresultstatusid    
where 1=1 
and not (
	isnull(p.patientid,0) = isnull(t.patientid,0)  
	and isnull(p.tipdetailid,0) = isnull(t.tipdetailid,0)  
	and isnull(p.policyid,0) = isnull(t.policyid,0) 
	and isnull(p.tiptype,'') = isnull(t.tiptype,'') 
	and isnull(p.[30dayrule],0) = isnull(t.[30dayrule],0)  
	and isnull(p.[TIP Opportunities],0) = isnull(t.[TIP Opportunities],0) 
	and isnull(p.[TIP Activity],0) = isnull(t.[TIP Activity],0)
	and isnull(p.[Approved TIPs],0) = isnull(t.[Approved TIPs],0)
	and isnull(p.[Pending Approval TIPs],0) = isnull(t.[Pending Approval TIPs],0)
	and isnull(p.[Review/resubmit TIPs],0) = isnull(t.[Review/resubmit TIPs],0)
	and isnull(p.[Rejected TIPs],0) = isnull(t.[Rejected TIPs],0)
	and isnull(p.[Unfinished TIPs],0) = isnull(t.[Unfinished TIPs],0)
	and isnull(p.[No intervention Necessary TIPs],0) = isnull(t.[No intervention Necessary TIPs],0)
	and isnull(p.[Completed TIPs],0) = isnull(t.[Completed TIPs],0)
	and isnull(p.[Successful TIPs],0) = isnull(t.[Successful TIPs],0)
	and isnull(p.[Successful Approved TIPs],0) = isnull(t.[Successful Approved TIPs],0)
	and isnull(p.[Successful Pending Approval TIPs],0) = isnull(t.[Successful Pending Approval TIPs],0)
	and isnull(p.[Unsuccessful TIPs],0) = isnull(t.[Unsuccessful TIPs],0)
	and isnull(p.[Prescriber Refusal TIPs],0) = isnull(t.[Prescriber Refusal TIPs],0)
	and isnull(p.[Unable to reach prescriber after 3 attempts],0) = isnull(t.[Unable to reach prescriber after 3 attempts],0)
	and isnull(p.[Patient Refusal TIPs],0) = isnull(t.[Patient Refusal TIPs],0)
	and isnull(p.[Patient Unable to Reach TIPs],0) = isnull(t.[Patient Unable to Reach TIPs],0)
	and isnull(p.activeasof,'19000101') = isnull(t.activeasof,'19000101') 
	and isnull(p.activethru,'19000101') = isnull(t.activethru,'19000101')
	and isnull(p.[currently active],0) = isnull(t.[currently active],0)
	and isnull(p.[withdrawn],0) = isnull(t.[withdrawn],0)
)

create nonclustered index ind_tipresultstatusid on #tempupdate(tipresultstatusid);


update p
set p.patientid = t.patientid    
,p.tipdetailid = t.tipdetailid  
,p.policyid = t.policyid 
,p.tiptype = t.tiptype 
,p.[30dayrule] = t.[30dayrule]  
,p.[TIP Opportunities] = t.[TIP Opportunities] 
,p.[TIP Activity] = t.[TIP Activity]
,p.[Approved TIPs] = t.[Approved TIPs]
,p.[Pending Approval TIPs] = t.[Pending Approval TIPs]
,p.[Review/resubmit TIPs] = t.[Review/resubmit TIPs]
,p.[Rejected TIPs] = t.[Rejected TIPs]
,p.[Unfinished TIPs] = t.[Unfinished TIPs]
,p.[No intervention Necessary TIPs] = t.[No intervention Necessary TIPs]
,p.[Completed TIPs] = t.[Completed TIPs]
,p.[Successful TIPs] = t.[Successful TIPs]
,p.[Successful Approved TIPs] = t.[Successful Approved TIPs]
,p.[Successful Pending Approval TIPs] = t.[Successful Pending Approval TIPs]
,p.[Unsuccessful TIPs] = t.[Unsuccessful TIPs]
,p.[Prescriber Refusal TIPs] = t.[Prescriber Refusal TIPs]
,p.[Unable to reach prescriber after 3 attempts] = t.[Unable to reach prescriber after 3 attempts]
,p.[Patient Refusal TIPs] = t.[Patient Refusal TIPs]
,p.[Patient Unable to Reach TIPs] = t.[Patient Unable to Reach TIPs]
,p.activeasof = t.activeasof 
,p.activethru = t.activethru
,p.[currently active] = t.[currently active]
,p.[withdrawn] = t.[withdrawn]
--select COUNT(*) 
from tipActivityReport p 
join tipActivityReport_staging t on t.tipresultstatusid = p.tipresultstatusid 
join #tempupdate u on u.tipresultstatusid = t.tipresultstatusid 
where 1=1 


---------


insert into tipActivityReport (tipresultstatusid 
, patientid 
, tipdetailid  
, policyid  
, tiptype 
, [30dayrule]   
, [TIP Opportunities] 
, [TIP Activity] 
, [Approved TIPs] 
, [Pending Approval TIPs] 
, [Review/resubmit TIPs] 
, [Rejected TIPs] 
, [Unfinished TIPs] 
, [No intervention Necessary TIPs] 
, [Completed TIPs]
, [Successful TIPs]
, [Successful Approved TIPs]
, [Successful Pending Approval TIPs]
, [Unsuccessful TIPs]
, [Prescriber Refusal TIPs]
, [Unable to reach prescriber after 3 attempts]
, [Patient Refusal TIPs]
, [Patient Unable to Reach TIPs]
, activeasof 
, activethru
, [currently active]
, [withdrawn]  
)
select t.tipresultstatusid 
, t.patientid 
, t.tipdetailid  
, t.policyid  
, t.tiptype 
, t.[30dayrule]   
, t.[TIP Opportunities] 
, t.[TIP Activity] 
, t.[Approved TIPs] 
, t.[Pending Approval TIPs] 
, t.[Review/resubmit TIPs] 
, t.[Rejected TIPs] 
, t.[Unfinished TIPs] 
, t.[No intervention Necessary TIPs] 
, t.[Completed TIPs]
, t.[Successful TIPs]
, t.[Successful Approved TIPs]
, t.[Successful Pending Approval TIPs]
, t.[Unsuccessful TIPs]
, t.[Prescriber Refusal TIPs]
, t.[Unable to reach prescriber after 3 attempts]
, t.[Patient Refusal TIPs]
, t.[Patient Unable to Reach TIPs]
, t.activeasof 
, t.activethru
, t.[currently active]
, t.[withdrawn]
from tipActivityReport_staging t 
where 1=1 
and not exists (
		select 1 
		from tipActivityReport p 
		where 1=1 
		and t.tipresultstatusid = p.tipresultstatusid
)

----------

delete p 
--select COUNT(*)
from tipActivityReport p 
where 1=1 
and not exists (
		select 1 
		from tipActivityReport_staging t  
		where 1=1 
		and t.tipresultstatusid = p.tipresultstatusid 
) 		
		


END


