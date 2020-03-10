



CREATE procedure [dbo].[U_patientCenterTipDetailReport]
as
begin 
set nocount on;
set xact_abort on;

--drop table #tempupdate
create table #tempupdate (
id int identity(1,1) primary key 
,tipresultstatusID int   
)
insert into #tempupdate (tipresultstatusID) 
select p.tipresultstatusID  
from patientCenterTipDetailReport p 
join patientCenterTipDetailReport_staging t on t.tipresultstatusID = p.tipresultstatusID 
where 1=1 
and not (
          isnull(p.centerid,0) = isnull(t.centerid,0) 
          and isnull(p.NCPDP_NABP,'') = isnull(t.NCPDP_NABP,'')  
          and isnull(p.centername,'') = isnull(t.centername,'')   
          and isnull(p.patientid_all,'') = isnull(t.patientid_all,'')    
          and isnull(p.First_Name,'') = isnull(t.First_Name,'')    
          and isnull(p.last_name,'') = isnull(t.last_name,'')   
          and isnull(p.DOB,'19000101') = isnull(t.DOB,'19000101')   
          and isnull(p.address1,'') = isnull(t.address1,'')    
          and isnull(p.address2,'') = isnull(t.address2,'')    
          and isnull(p.city,'') = isnull(t.city,'')     
          and isnull(p.state,'') = isnull(t.state,'')    
          and isnull(p.zipcode,'') = isnull(t.zipcode,'')   
          and isnull(p.phone,'') = isnull(t.phone,'')   
          and isnull(p.primaryPharmacy,0) = isnull(t.primaryPharmacy,0)    
          and isnull(p.pctFillatCenter,0.00) = isnull(t.pctFillatCenter,0.00)   
          and isnull(p.pctFillatChain,0.00) = isnull(t.pctFillatChain,0.00)   
          and isnull(p.policyid,0) = isnull(t.policyid,0)   
          and isnull(p.policyname,'') = isnull(t.policyname,'')   
          and isnull(p.TipGenerationDT,'19000101') = isnull(t.TipGenerationDT,'19000101')   
          and isnull(p.reasontypeid,0) = isnull(t.reasontypeid,0)  
          and isnull(p.reasoncode,0) = isnull(t.reasoncode,0)   
          and isnull(p.reasonTypeDesc,'') = isnull(t.reasonTypeDesc,'')   
          and isnull(p.actionTypeID,0) = isnull(t.actionTypeID,0)   
          and isnull(p.actionCode,0) = isnull(t.actionCode,0)   
          and isnull(p.actionNM,'') = isnull(t.actionNM,'')   
          and isnull(p.ecaLevelID,0) = isnull(t.ecaLevelID,0)     
          and isnull(p.tiptitle,'') = isnull(t.tiptitle,'')   
          and isnull(p.tiptype,'') = isnull(t.tiptype,'')
          and isnull(p.NPI,'') = isnull(t.NPI,'')
          and isnull(p.Pharmacy_Address1,'') = isnull(t.Pharmacy_Address1,'')
          and isnull(p.Pharmacy_Address2,'') = isnull(t.Pharmacy_Address2,'')
          and isnull(p.Pharmacy_city,'') = isnull(t.Pharmacy_city,'')
          and isnull(p.Pharmacy_state,'') = isnull(t.Pharmacy_state,'')
          and isnull(p.Pharmacy_zip,'') = isnull(t.Pharmacy_zip,'')
		  and isnull(p.TipExpirationDT,'19000101') = isnull(t.TipExpirationDT,'19000101')                                     
)

create nonclustered index ind_1 on #tempupdate(tipresultstatusID)


declare @batch int = 500000
Declare @mincnt bigint = 1
Declare @maxcnt bigint = (select top 1 id from #tempupdate order by id desc)
while (@mincnt <= @maxcnt)
BEGIN

		update p
		set p.centerid = t.centerid 
		, p.NCPDP_NABP = t.NCPDP_NABP
		, p.centername = t.centername 
		, p.patientid_all = t.patientid_all 
		, p.First_Name = t.First_Name
		, p.last_name = t.last_name 
		, p.DOB = t.DOB 
		, p.address1 = t.address1 
		, p.address2 = t.address2 
		, p.city = t.city 
		, p.state = t.state 
		, p.zipcode = t.zipcode 
		, p.phone = t.phone 
		, p.primaryPharmacy = t.primaryPharmacy
		, p.pctFillatCenter = t.pctFillatCenter 
		, p.pctFillatChain = t.pctFillatChain
		, p.policyid = t.policyid 
		, p.policyname = t.policyname 
		, p.TipGenerationDT = t.TipGenerationDT
		, p.reasontypeid = t.reasontypeid 
		, p.reasoncode = t.reasoncode 
		, p.reasonTypeDesc = t.reasonTypeDesc
		, p.actionTypeID = t.actionTypeID 
		, p.actionCode = t.actionCode
		, p.actionNM = t.actionNM
		, p.ecaLevelID = t.ecaLevelID
		, p.tiptitle = t.tiptitle 
		, p.tiptype = t.tiptype 
		, p.NPI = t.NPI 
		, p.Pharmacy_Address1 = t.Pharmacy_Address1 
		, p.Pharmacy_Address2 = t.Pharmacy_Address2 
		, p.Pharmacy_city = t.Pharmacy_city 
		, p.Pharmacy_state = t.Pharmacy_state 
		, p.Pharmacy_zip = t.Pharmacy_zip 
		, p.TipExpirationDT = t.TipExpirationDT 
		--select COUNT(*) 
		from patientCenterTipDetailReport p 
		join patientCenterTipDetailReport_staging t on t.tipresultstatusID = p.tipresultstatusID 
		join #tempupdate u on u.tipresultstatusid = t.tipresultstatusid 
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

	insert into patientCenterTipDetailReport (tipresultstatusID 
	, centerid  
	, NCPDP_NABP
	, centername 
	, patientid_all 
	, First_Name
	, last_name 
	, DOB 
	, address1 
	, address2 
	, city 
	, state 
	, zipcode 
	, phone 
	, primaryPharmacy
	, pctFillatCenter 
	, pctFillatChain
	, policyid 
	, policyname 
	, TipGenerationDT
	, reasontypeid 
	, reasoncode 
	, reasonTypeDesc
	, actionTypeID 
	, actionCode
	, actionNM
	, ecaLevelID
	, tiptitle 
	, tiptype 
	, NPI
	, Pharmacy_Address1
	, Pharmacy_Address2
	, Pharmacy_city
	, Pharmacy_state
	, Pharmacy_zip
	, TipExpirationDT
	)
	select top (@batch) tipresultstatusID 
	, centerid  
	, NCPDP_NABP
	, centername 
	, patientid_all 
	, First_Name
	, last_name 
	, DOB 
	, address1 
	, address2 
	, city 
	, state 
	, zipcode 
	, phone 
	, primaryPharmacy
	, pctFillatCenter 
	, pctFillatChain
	, policyid 
	, policyname 
	, TipGenerationDT
	, reasontypeid 
	, reasoncode 
	, reasonTypeDesc
	, actionTypeID 
	, actionCode
	, actionNM
	, ecaLevelID
	, tiptitle 
	, tiptype 
	, NPI
	, Pharmacy_Address1
	, Pharmacy_Address2
	, Pharmacy_city
	, Pharmacy_state
	, Pharmacy_zip
	, TipExpirationDT
	from patientCenterTipDetailReport_staging t 
	where 1=1 
	and not exists (
		select 1 
		from patientCenterTipDetailReport p 
		where 1=1 
		and t.tipresultstatusID = p.tipresultstatusID
	)

end

----------

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	delete top (@batch) p 
	--select COUNT(*)
	from patientCenterTipDetailReport p 
	where 1=1 
	and not exists (
		select 1 
		from patientCenterTipDetailReport_staging t  
		where 1=1 
		and t.tipresultstatusID = p.tipresultstatusID 
	)                  
               
end    

end 


