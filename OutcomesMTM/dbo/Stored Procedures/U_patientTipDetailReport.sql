



CREATE procedure [dbo].[U_patientTipDetailReport]
as
begin 
set nocount on;
set xact_abort on;

--drop table #tempupdate
create table #tempupdate (
id int identity(1,1) primary key 
,tipresultID int   
)
insert into #tempupdate (tipresultID) 
select p.tipresultid 
from patientTipDetailReport p 
join patientTipDetailReport_staging t on t.tipresultID = p.tipresultID 
where 1=1 
and not (
          isnull(p.patientid_all,'') = isnull(t.patientid_all,'')    
          and isnull(p.First_Name,'') = isnull(t.First_Name,'')    
          and isnull(p.last_name,'') = isnull(t.last_name,'')   
          and isnull(p.DOB,'19000101') = isnull(t.DOB,'19000101')   
          and isnull(p.primaryPharmacy,0) = isnull(t.primaryPharmacy,0)    
          and isnull(p.pctFillatCenter,0.00) = isnull(t.pctFillatCenter,0.00)   
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
          and isnull(p.pharmacyCnt,0) = isnull(t.pharmacyCnt,0)
          and isnull(p.PharmacyNABPList,'') = isnull(t.PharmacyNABPList,'') 
          and isnull(p.pharmacyNameList,'') = isnull(t.pharmacyNameList,'') 
          and isnull(p.primaryPharmacyList,'') = isnull(t.primaryPharmacyList,'')
          and isnull(p.NPI,'') = isnull(t.NPI,'') 
          and isnull(p.Primary_NCPDP_NABP,'') = isnull(t.Primary_NCPDP_NABP,'')
          and isnull(p.Primary_PharmacyName,'') = isnull(t.Primary_PharmacyName,'')
          and isnull(p.phone,'') = isnull(t.phone,'')
          and isnull(p.Address1,'') = isnull(t.Address1,'')
          and isnull(p.Address2,'') = isnull(t.Address2,'')
          and isnull(p.City,'') = isnull(t.City,'')
          and isnull(p.state,'') = isnull(t.state,'')
          and isnull(p.ZipCode,'') = isnull(t.ZipCode,'')       
		  and isnull(p.TipExpirationDT,'19000101') = isnull(t.TipExpirationDT,'19000101')                                     
                                                                     
)

create nonclustered index ind_1 on #tempupdate (tipresultid)

declare @batch int = 500000
Declare @mincnt bigint = 1
Declare @maxcnt bigint = (select top 1 id from #tempupdate order by id desc)
while (@mincnt <= @maxcnt)
BEGIN

		update p
		set p.patientid_all = t.patientid_all 
		, p.First_Name = t.First_Name
		, p.last_name = t.last_name 
		, p.DOB = t.DOB 
		, p.primaryPharmacy = t.primaryPharmacy
		, p.pctFillatCenter = t.pctFillatCenter 
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
		, p.pharmacyCnt = t.pharmacyCnt  
		, p.PharmacyNABPList = t.PharmacyNABPList
		, p.pharmacyNameList = t.pharmacyNameList
		, p.primaryPharmacyList = t.primaryPharmacyList
		, p.NPI = t.NPI
		, p.Primary_NCPDP_NABP = t.Primary_NCPDP_NABP
		, p.Primary_PharmacyName = t.Primary_PharmacyName
		, p.phone = t.phone
		, p.Address1 = t.Address1
		, p.Address2 = t.Address2
		, p.City = t.City
		, p.state = t.state
		, p.ZipCode = t.ZipCode
		, p.TipExpirationDT = t.TipExpirationDT 
		--select COUNT(*) 
		from patientTipDetailReport p 
		join patientTipDetailReport_staging t on t.tipresultID = p.tipresultID 
		join #tempupdate u on u.tipresultid = t.tipresultid
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

	insert into patientTipDetailReport (tipresultID 
	, patientid_all 
	, First_Name
	, last_name 
	, DOB  
	, primaryPharmacy
	, pctFillatCenter 
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
	, pharmacyCnt 
	, PharmacyNABPList 
	, pharmacyNameList 
	, primaryPharmacyList
	, NPI
	, Primary_NCPDP_NABP
	, Primary_PharmacyName
	, phone
	, address1
	, address2
	, city
	, state
	, zipCode
	, TipExpirationDT
	)
	select top (@batch) tipresultID 
	, patientid_all 
	, First_Name
	, last_name 
	, DOB 
	, primaryPharmacy
	, pctFillatCenter 
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
	, pharmacyCnt 
	, PharmacyNABPList 
	, pharmacyNameList 
	, primaryPharmacyList
	, NPI
	, Primary_NCPDP_NABP
	, Primary_PharmacyName
	, phone
	, address1
	, address2
	, city
	, state
	, zipCode
	, TipExpirationDT
	from patientTipDetailReport_staging t 
	where 1=1 
	and not exists (
		select 1 
		from patientTipDetailReport p 
		where 1=1 
		and t.tipresultID = p.tipresultID
	)

end

----------

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	delete top (@batch) p 
	--select COUNT(*)
	from patientTipDetailReport p 
	where 1=1 
	and not exists (
		select 1 
		from patientTipDetailReport_staging t  
		where 1=1 
		and t.tipresultID = p.tipresultID 
	)       
	
end           

END


