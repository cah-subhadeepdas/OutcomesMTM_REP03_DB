




CREATE procedure [dbo].[U_tipActivityCenterReport]
as
begin 
set nocount on;
set xact_abort on;


--drop table #tempupdate
create table #tempupdate (
id int identity(1,1) primary key 
,tipresultstatuscenterid int
)
insert into #tempupdate (tipresultstatuscenterid) 
select p.tipresultstatuscenterid 
from tipActivityCenterReport p 
join tipActivityCenterReport_staging t on t.tipresultstatuscenterid = p.tipresultstatuscenterid    
where 1=1 
and not (
          isnull(p.tipresultstatusid,0) = isnull(t.tipresultstatusid,0) 
          and isnull(p.patientid,0) = isnull(t.patientid,0) 
          and isnull(p.centerid,0) = isnull(t.centerid,0) 
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
          and isnull(p.[Successful Paid TIPs],0) = isnull(t.[Successful Paid TIPs],0)
          and isnull(p.[Successful Pending Approval TIPs],0) = isnull(t.[Successful Pending Approval TIPs],0)
          and isnull(p.[Unsuccessful TIPs],0) = isnull(t.[Unsuccessful TIPs],0)
          and isnull(p.[Prescriber Refusal TIPs],0) = isnull(t.[Prescriber Refusal TIPs],0)
          and isnull(p.[Unable to reach prescriber after 3 attempts],0) = isnull(t.[Unable to reach prescriber after 3 attempts],0)
          and isnull(p.[Patient Refusal TIPs],0) = isnull(t.[Patient Refusal TIPs],0)
          and isnull(p.[Patient Unable to Reach TIPs],0) = isnull(t.[Patient Unable to Reach TIPs],0)
          and isnull(p.primaryPharmacy,0) = case when isnull(t.primaryPharmacy,0) = 0 then 0 else 1 end  
          and isnull(p.activeasof,'19000101') = isnull(t.activeasof,'19000101') 
          and isnull(p.activethru,'19000101') = isnull(t.activethru,'19000101')
          and isnull(p.[currently active],0) = isnull(t.[currently active],0)
          and isnull(p.[withdrawn],0) = isnull(t.[withdrawn],0)
          and isnull(p.chainid,0) = isnull(t.chainid,0)
          and isnull(p.centername,'') = isnull(t.centername,'') 
          and isnull(p.chainnm,'') = isnull(t.chainnm,'') 
          and isnull(p.ncpdp_nabp,'') = isnull(t.ncpdp_nabp,'') 
          and isnull(p.parent_organization_id,'') = isnull(t.parent_organization_id,'') 
          and isnull(p.parent_organization_name,'') = isnull(t.parent_organization_name,'') 
          and isnull(p.patientid_all,'') = isnull(t.patientid_all,'') 
          and isnull(p.policyname,'') = isnull(t.policyname,'') 
          and isnull(p.relationship_id,'') = isnull(t.relationship_id,'') 
          and isnull(p.relationship_id_name,'') = isnull(t.relationship_id_name,'') 
          and isnull(p.relationship_type,'') = isnull(t.relationship_type,'') 
          and isnull(p.tiptitle,'') = isnull(t.tiptitle,'') 
		  and isnull(p.expired,0) = isnull(t.expired,0) 
)

create nonclustered index ind_tipresultstatuscenterid on #tempupdate(tipresultstatuscenterid);


declare @batch int = 500000
Declare @mincnt bigint = 1
Declare @maxcnt bigint = (select top 1 id from #tempupdate order by id desc)
while (@mincnt <= @maxcnt)
BEGIN

		update p
		set p.tipresultstatusid = t.tipresultstatusid 
		,p.patientid = t.patientid  
		,p.centerid = t.centerid 
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
		,p.[Successful Paid TIPs] = t.[Successful Paid TIPs]
		,p.[Successful Pending Approval TIPs] = t.[Successful Pending Approval TIPs]
		,p.[Unsuccessful TIPs] = t.[Unsuccessful TIPs]
		,p.[Prescriber Refusal TIPs] = t.[Prescriber Refusal TIPs]
		,p.[Unable to reach prescriber after 3 attempts] = t.[Unable to reach prescriber after 3 attempts]
		,p.[Patient Refusal TIPs] = t.[Patient Refusal TIPs]
		,p.[Patient Unable to Reach TIPs] = t.[Patient Unable to Reach TIPs]
		,p.primaryPharmacy = case when isnull(t.primaryPharmacy,0) = 0 then 0 else 1 end  
		,p.activeasof = t.activeasof 
		,p.activethru = t.activethru
		,p.[currently active] = t.[currently active]
		,p.[withdrawn] = t.[withdrawn]
		,p.chainid = t.chainid 
		,p.centername = t.centername
		,p.chainnm = t.chainnm
		,p.ncpdp_nabp = t.ncpdp_nabp
		,p.parent_organization_id = t.parent_organization_id
		,p.parent_organization_name = t.parent_organization_name
		,p.patientid_all = t.patientid_all
		,p.policyname = t.policyname
		,p.relationship_id = t.relationship_id
		,p.relationship_id_name = t.relationship_id_name
		,p.relationship_type = t.relationship_type
		,p.tiptitle = t.tiptitle
		,p.expired = t.expired 
		--select COUNT(*) 
		from tipActivityCenterReport p 
		join tipActivityCenterReport_staging t on t.tipresultstatuscenterid = p.tipresultstatuscenterid 
		join #tempupdate u on u.tipresultstatuscenterid = t.tipresultstatuscenterid 
		where 1=1 
		and u.id >= @mincnt  
		and u.id < @mincnt+@batch

		set @mincnt = @mincnt+@batch

end

---------


declare @temp int

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	insert into tipActivityCenterReport (tipresultstatuscenterID
	, tipresultstatusid 
	, patientid 
	, centerid  
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
	, [Successful Paid TIPs]
	, [Successful Pending Approval TIPs]
	, [Unsuccessful TIPs]
	, [Prescriber Refusal TIPs]
	, [Unable to reach prescriber after 3 attempts]
	, [Patient Refusal TIPs]
	, [Patient Unable to Reach TIPs]
	, primaryPharmacy
	, activeasof 
	, activethru
	, [currently active]
	, [withdrawn]  
	, chainid 
	, centername
	, chainnm
	, ncpdp_nabp
	, parent_organization_id
	, parent_organization_name
	, patientid_all
	, policyname
	, relationship_id
	, relationship_id_name
	, relationship_type
	, tiptitle
	, expired
	)
	select top (@batch) t.tipresultstatuscenterID 
	, t.tipresultstatusid 
	, t.patientid
	, t.centerid  
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
	, t.[Successful Paid TIPs]
	, t.[Successful Pending Approval TIPs]
	, t.[Unsuccessful TIPs]
	, t.[Prescriber Refusal TIPs]
	, t.[Unable to reach prescriber after 3 attempts]
	, t.[Patient Refusal TIPs]
	, t.[Patient Unable to Reach TIPs]
	, case when isnull(t.primaryPharmacy,0) = 0 then 0 else 1 end as primaryPharmacy 
	, t.activeasof 
	, t.activethru
	, t.[currently active]
	, t.[withdrawn]
	, t.chainid 
	, t.centername
	, t.chainnm
	, t.ncpdp_nabp
	, t.parent_organization_id
	, t.parent_organization_name
	, t.patientid_all
	, t.policyname
	, t.relationship_id
	, t.relationship_id_name
	, t.relationship_type
	, t.tiptitle
	, t.expired 
	from tipActivityCenterReport_staging t 
	where 1=1 
	and not exists (
					   select 1 
					   from tipActivityCenterReport p 
					   where 1=1 
					   and t.tipresultstatuscenterid = p.tipresultstatuscenterid
	)

end

----------

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	delete top (@batch) p 
	--select COUNT(*)
	from tipActivityCenterReport p 
	where 1=1 
	and not exists (
					   select 1 
					   from tipActivityCenterReport_staging t  
					   where 1=1 
					   and t.tipresultstatuscenterid = p.tipresultstatuscenterid 
	)           


end       
                   
END








