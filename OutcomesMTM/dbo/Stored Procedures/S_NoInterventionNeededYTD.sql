



CREATE   procedure [dbo].[S_NoInterventionNeededYTD]

AS

BEGIN 
SET NOCOUNT ON;
SET XACT_ABORT ON;


If object_id('tempdb..#TEMP') is not null
drop table #TEMP

select p.patientid_all
, cl.clientName as [Client]
, po.policyid
, po.policyname
, td.tipdetailid as [TipID]
, td.tiptitle
, ts.tipstatus as [NIN Reason]
, tip.[createdate] as [Tip Identification Date]
, trs.createdate as [Date Submitted]
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [Pharmacy Name]
, ph.ncpdp_nabp as [Pharmacy NCPDP]
, ph.addressstate as [State Delivered]
, replace(replace(replace(ph1.centername,char(9),''),char(10),''),char(13),'')  as [Primary Pharmacy Name]
, ph1.ncpdp_nabp as [Primary Pharmacy NCPDP]
, case when ph.centerid = ph1.centerid then 'Y' else 'N' end as [Documented Pharmacy the Primary Pharmacy?]
, ppp1.pctFillatCenter as [Percent Patient Fills at Documented Pharmacy]
INTO #TEMP
from	outcomes.dbo.vw_tipresult tra
		join outcomes.dbo.tipresultstatus trs on trs.tipresultid = tra.tipresultid
		join outcomes.dbo.tipresultstatuscenter trsc on trsc.tipresultstatusid = trs.tipresultstatusid --and trsc.active = 1
		join outcomes.dbo.tipstatus ts on ts.tipstatusid = trs.tipstatusid
		join outcomes.dbo.tipstatustype tst on tst.tipstatustypeid = ts.tipstatustypeid 
		join outcomes.dbo.pharmacy ph on ph.centerid = trsc.centerid
		join outcomes.dbo.patient p on p.patientid = tra.patientid
		join outcomes.dbo.policy po on po.policyid = p.policyid
		left join outcomes.dbo.ClientContractPolicyView po1 with(nolock) on po1.policyid = p.policyid -- TC-2337
		left join outcomes.dbo.Client cl on p.ClientID = cl.clientID -- TC-2337
		join outcomes.dbo.tipdetail td on td.tipdetailid = tra.tipdetailid
		left join outcomes.dbo.patientprimarypharmacy ppp on ppp.patientid = p.patientid and ppp.primarypharmacy = 1
		left join outcomes.dbo.pharmacy ph1 on ph1.centerid = ppp.centerid
		left join outcomes.dbo.patientPrimaryPharmacyFillPct ppp1 on ppp1.centerid = ph.centerid and ppp1.patientid = p.patientid
		left join (
                select distinct ts.tipstatus, tra.tipresultid, tra.patientid, tra.active, trs.createdate, trs.activeenddate, td.TIPTitle, td.TIPDetailID, rt.ReasonCode
                from tip.dbo.tipresult_active tra with (nolock)
                join outcomes.dbo.tipresultstatus trs
                             on trs.tipresultid = tra.tipresultid
                join tip.dbo.tipstatus ts with (nolock)
                             on ts.tipstatusid = trs.tipstatusid
                join outcomes.dbo.TIPDetail td with (nolock)
                           on td.tipdetailID = tra.tipdetailID
                join outcomes.dbo.TIPDetailRule tdr with (nolock)
                             on tdr.tipdetailid = tra.tipdetailID
							 and trs.createdate >= tdr.activeasof 
							 and trs.createdate <= isnull(tdr.activethru,'9999-12-31')
				join outcomes.dbo.reasonType rt with (nolock)
							on rt.reasonTypeID = tdr.reasonTypeID

                where 1=1
                --and tra.patientid = 51803230
				and ts.tipstatus = 'TIP Identified'
                --and tdr.directLoadTIP <> 1
				

       ) tip
                on 	tip.patientid = p.patientid   
				and	tip.tipdetailid = td.tipdetailid
				

where	1=1
		and tst.tipstatusTypeID = 2
		and year(trs.createdate) = year(getdate())


		
select 
patientid_all
,[Client]
,policyid
,policyname
,[TipID]
,tiptitle
,[NIN Reason]
,[Tip Identification Date]
,[Date Submitted]
,[Pharmacy Name]
,[Pharmacy NCPDP]
,[State Delivered]
,[Primary Pharmacy Name]
,[Primary Pharmacy NCPDP]
,[Documented Pharmacy the Primary Pharmacy?]
,[Percent Patient Fills at Documented Pharmacy]

from 
(select 
patientid_all
,[Client]
,policyid
,policyname
,[TipID]
,tiptitle
,[NIN Reason]
,[Tip Identification Date]
,[Date Submitted]
,[Pharmacy Name]
,[Pharmacy NCPDP]
,[State Delivered]
,[Primary Pharmacy Name]
,[Primary Pharmacy NCPDP]
,[Documented Pharmacy the Primary Pharmacy?]
,[Percent Patient Fills at Documented Pharmacy]
, row_number() over (partition by patientid_all,[TipID] order by [TIP Identification Date]) as rn from #Temp) as T
where rn=1
 --and year([TIP Identification Date]) = year(getdate())

END

