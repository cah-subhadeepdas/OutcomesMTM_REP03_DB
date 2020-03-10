









CREATE procedure [dbo].[S_Humana_EMTM_PDP_report]
( @report_date date
)

 AS

 BEGIN


 
  ----For test purpose
  
 --declare @report_date date = '2018-05-15'


 --Select case when month(getdate()) = 1 then cast(year(@report_date) - 1 as varchar(4)) + '-01-01' else cast(year(@report_date) as varchar(4)) + '-01-01' end


 


declare @begin date = case when month(getdate()) = 1 then cast(year(@report_date) - 1 as varchar(4)) + '-01-01' else cast(year(@report_date) as varchar(4)) + '-01-01' end --cast(dateadd(yy,datediff(yy,0,@report_date),0) as date)
      , @end date = cast(dateadd(mm,datediff(mm,0,@report_date),0)-1 as date)
      , @sixmonthearlier date = cast(dateadd(mm,datediff(mm,0,@report_date)-6,0) as date)




 Declare  @im1_den int 
	   ,  @im2_hi_den int 
	   ,  @im2_me_den int 
	   ,  @im2_lo_den int 
	   ,  @im2_mo_den int
	   ,  @im1_num int
	   ,  @im2_hi_num int 
	   ,  @im2_me_num int 
	   ,  @im2_lo_num int 
	   ,  @im2_mo_num int
	   ,  @im1_rt varchar(7)
	   ,  @im2_hi_rt varchar(7)
	   ,  @im2_me_rt varchar(7)
 	   ,  @im2_lo_rt varchar(7)
	   ,  @im2_mo_rt varchar(7)
	   ,  @im3_den int
	   ,  @im3_num int
	   ,  @im3_rt varchar(7)
	   ,  @arm1_den int
	   ,  @arm1_num int
	   ,  @arm1_rt varchar(7)
	   ,  @arm2_den int
	   ,  @arm2_num int
	   ,  @arm2_rt varchar(7)
	   ,  @m2_den int
	   ,  @m2_hi_den int 
	   ,  @m2_me_den int 
	   ,  @m2_lo_den int 
	   ,  @m2_mo_den int
	   ,  @m2_num int
	   ,  @m2_hi_num int 
	   ,  @m2_me_num int 
	   ,  @m2_lo_num int 
	   ,  @m2_mo_num int
	   ,  @m2_rt varchar(7)
	   ,  @m2_hi_rt varchar(7)
	   ,  @m2_me_rt varchar(7)
 	   ,  @m2_lo_rt varchar(7)
	   ,  @m2_mo_rt varchar(7)
	   ,  @m3_den int
	   ,  @m3_hi_den int 
	   ,  @m3_me_den int 
	   ,  @m3_lo_den int 
	   ,  @m3_mo_den int
	   ,  @m3_num int
	   ,  @m3_hi_num int 
	   ,  @m3_me_num int 
	   ,  @m3_lo_num int 
	   ,  @m3_mo_num int
	   ,  @m3_rt varchar(7)
	   ,  @m3_hi_rt varchar(7)
	   ,  @m3_me_rt varchar(7)
 	   ,  @m3_lo_rt varchar(7)
	   ,  @m3_mo_rt varchar(7)
	   ,  @m4_den int
	   ,  @m4_hi_den int 
	   ,  @m4_me_den int 
	   ,  @m4_lo_den int 
	   ,  @m4_mo_den int
	   ,  @m4_num int
	   ,  @m4_hi_num int 
	   ,  @m4_me_num int 
	   ,  @m4_lo_num int 
	   ,  @m4_mo_num int
	   ,  @m4_rt varchar(7)
	   ,  @m4_hi_rt varchar(7)
	   ,  @m4_me_rt varchar(7)
 	   ,  @m4_lo_rt varchar(7)
	   ,  @m4_mo_rt varchar(7)
	   ,  @m5_den int
	   ,  @m5_hi_den int 
	   ,  @m5_me_den int 
	   ,  @m5_lo_den int 
	   ,  @m5_mo_den int
	   ,  @m5_num int
	   ,  @m5_hi_num int 
	   ,  @m5_me_num int 
	   ,  @m5_lo_num int 
	   ,  @m5_mo_num int
	   ,  @m5_rt varchar(7)
	   ,  @m5_hi_rt varchar(7)
	   ,  @m5_me_rt varchar(7)
 	   ,  @m5_lo_rt varchar(7)
	   ,  @m5_mo_rt varchar(7)

If object_id ('tempdb..#patientbase') is not null
drop table #patientbase
select * 
into #patientbase
from ( 
	 select row_number() over (partition by patientid order by policyid) as ranker, *
	 from (	
			select distinct pd.patientid
				 , pd.policyid
			from outcomesmtm.dbo.patientdim pd
			where 1=1
			 and isnull(activethru,'9999-12-31') >= @begin
			 and activeasof <= @end
			 and pd.policyid in (735,736,737,738)
			 and outcomeseligibilitydate between @begin and @end
			) pt
	  ) pt
where pt.ranker = 1


If object_id ('tempdb..#claimbase') is not null
drop table #claimbase

select c.claimid,pt.patientid,pt.PolicyID,c.resultTypeID,resultCode,c.reasonTypeID,rn.reasoncode,centerID, cv.validated
into #claimbase
from #patientbase pt
join outcomesmtm.dbo.claim c on c.patientid = pt.PatientID
join outcomesmtm.staging.resulttype rt on c.resultTypeID = rt.resultTypeID
join OutcomesMTM.staging.reasontype rn on c.reasonTypeID = rn.reasonTypeID
left join OutcomesMTM.staging.claimvalidation cv on cv.claimid = c.claimid
where 1=1
and statusid = 6
and c.mtmServiceDT between @begin and @end
and c.policyid in (735,736,737,738)


--*******************************IM1 and IM2**********************************

-- Collect the eligible patient count at the end of each month
if object_id('tempdb..#eligiblecount') is not null
drop table #eligiblecount 

create table #eligiblecount (policyid int,
					Endofmonth date,
					patientcount int
					)
declare @date date = dateadd(dd,-1,@begin) 
while @date < @end
Begin
	set @date = EOMONTH(@date,1)
		print @date
	insert into #eligiblecount 
	select policyid, @date, count(*)
	from outcomesmtm.dbo.patientdim
	where Policyid in (735,736,737,738)
	and @date between activeasof and isnull(activeThru, '9999-12-31')
	and OutcomesEligibilityDate >= @begin
	and OutcomestermDate >= @date
	group by policyid 

End

If object_id ('tempdb..#avgcount') is not null
drop table #avgcount
select avg(patientcount) as patientcount,policyid
into #avgcount
from #eligiblecount		
group by policyid 

If object_id ('tempdb..#IM_Den') is not null
drop table #IM_Den
select sum(patientcount) as im1_den
	  ,(select patientcount from #avgcount where policyid = 735) as im2_hi_den
	  ,(select patientcount from #avgcount where policyid = 736) as im2_me_den
	  ,(select patientcount from #avgcount where policyid = 737) as im2_lo_den
	  ,(select patientcount from #avgcount where policyid = 738) as im2_mo_den
into #IM_Den
from #avgcount


If object_id ('tempdb..#IM_Num') is not null
drop table #IM_Num

select  count(distinct PatientID) as im1_num
	 ,  count(distinct case when policyid = 735 then patientid end) as im2_hi_num
	 ,  count(distinct case when policyid = 736 then patientid end) as im2_me_num
	 ,  count(distinct case when policyid = 737 then patientid end) as im2_lo_num
	 ,  count(distinct case when policyid = 738 then patientid end) as im2_mo_num
into #IM_Num
from #claimbase
where 1=1
and resultcode not in (378,379)

If object_id ('tempdb..#IM_Rt') is not null
drop table #IM_Rt

select cast(cast(cast(im1_num as decimal)/cast(nullif(im1_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as im1_rt
	 , cast(cast(cast(im2_hi_num as decimal)/cast(nullif(im2_hi_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as im2_hi_rt
	 , cast(cast(cast(im2_me_num as decimal)/cast(nullif(im2_me_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as im2_me_rt
	 , cast(cast(cast(im2_lo_num as decimal)/cast(nullif(im2_lo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as im2_lo_rt
	 , cast(cast(cast(im2_mo_num as decimal)/cast(nullif(im2_mo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as im2_mo_rt
into #IM_Rt
from #IM_Den
cross join #IM_Num


--*******************************IM3**********************************

If object_id ('tempdb..#MTM_Base') is not null
drop table #MTM_Base

select distinct rx.NCPDP_NABP 
into #MTM_Base
from OutcomesMTM.dbo.prescriptionDim rx
join #patientbase pt on pt.PatientID = rx.patientid
--join outcomes.dbo.pharmacy ph on ph.NCPDP_NABP = rx.NCPDP_NABP
--join Pharmacy_Trained mtm on mtm.NCPDP_NABP = rx.NCPDP_NABP
where rxdate between @sixmonthearlier and @end

If object_id ('tempdb..#IM3') is not null
drop table #IM3

select  im3_num
	  , im3_den
	  , cast(cast(cast(im3_num as decimal)/cast(nullif(im3_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as im3_rt
into #IM3
from (
		select count(distinct c.centerID) as im3_num
		from #patientbase pt
		join #claimbase c on c.patientid = pt.PatientID
		join OutcomesMTM.dbo.pharmacy ph on ph.centerid = c.centerid
		join #MTM_Base mtm on mtm.NCPDP_NABP = ph.NCPDP_NABP
		where 1=1
		and c.resultcode not in (378,379)
	 ) num
cross join (select count(*) as im3_den from #MTM_Base)  den


--*******************************ARM1**********************************

If object_id ('tempdb..#ARM1') is not null
drop table #ARM1

select arm1_den
	,  arm1_num
	,  cast(cast(cast(arm1_num as decimal)/cast(nullif(arm1_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as arm1_rt
into #ARM1
from (
			  select sum(den.patientcount) as arm1_den
					 from (		
							select sum(patientcount) as patientcount
							from #avgcount
							where policyid in (735,736,737)
							
							Union
							
							select count(distinct c.patientid) as patientcount
							from #patientbase pt
							join #claimbase c on c.patientid = pt.PatientID
							where 1=1
							and c.resultcode not in (378,379)
							and pt.policyid in (738)
							) den
	 ) den
cross join (
				select count(distinct c.patientid) as arm1_num
				from  #claimbase c 
				where 1=1
				and c.resultcode not in (378,379)
			) num
         
--*******************************ARM2**********************************

If object_id ('tempdb..#ARM2') is not null
drop table #ARM2

select arm2_den
	 , arm2_num
	 , cast(cast(cast(arm2_num as decimal)/cast(NULLIF(arm2_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as arm2_rt
into #ARM2
from (
			select count(distinct c.claimID) as arm2_den
			from #patientbase pt
			join #claimbase c on pt.PatientID = c.PatientID
			where 1=1
			and c.reasonCode in (105,120,125,130,135,140,145,150,172)
			and c.resultcode not in (378,379)

		) den
cross join (
				select count(distinct c.claimID) as arm2_num
				from #patientbase pt
				join #claimbase c on pt.PatientID = c.PatientID
				where 1=1
				and c.reasonCode in (105,120,125,130,135,140,145,150,172)
		        and c.resultcode not in (378,379)
				and c.validated =1
			) num



--*******************************M2**********************************

If object_id ('tempdb..#M2_Den') is not null
drop table #M2_Den
select count(patientid) m2_den
	 , count(case when policyid = 735 then patientid end) as m2_hi_den
	 , count(case when policyid = 736 then patientid end) as m2_me_den
	 , count(case when policyid = 737 then patientid end) as m2_lo_den
	 , count(case when policyid = 738 then patientid end) as m2_mo_den
into #M2_Den
from (
			select distinct c.patientid,pt.PolicyID
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
			and c.reasonCode in (105,120,125,130,135,140,145,150,172)
			and c.resultcode not in (378,379)

			
	  ) den_base

If object_id ('tempdb..#M2_Num') is not null
drop table #M2_Num

select count(patientid) m2_num
	 , count(case when policyid = 735 then patientid end) as m2_hi_num
	 , count(case when policyid = 736 then patientid end) as m2_me_num
	 , count(case when policyid = 737 then patientid end) as m2_lo_num
	 , count(case when policyid = 738 then patientid end) as m2_mo_num
into #M2_Num
from (			
select distinct c.patientid, pt.policyid
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
			and c.reasonCode in (105,120,125,130,135,140,145,150,172)
			and c.resultcode not in (378,379)
			and c.validated =1
	  ) num_base

If object_id ('tempdb..#M2_Rt') is not null
drop table #M2_Rt

select cast(cast(cast(m2_num as decimal)/cast(NULLIF(m2_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m2_rt
	 , cast(cast(cast(m2_hi_num as decimal)/cast(NULLIF(m2_hi_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m2_hi_rt
	 , cast(cast(cast(m2_me_num as decimal)/cast(NULLIF(m2_me_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m2_me_rt
	 , cast(cast(cast(m2_lo_num as decimal)/cast(NULLIF(m2_lo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m2_lo_rt
	 , cast(cast(cast(m2_mo_num as decimal)/cast(NULLIF(m2_mo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m2_mo_rt
into #M2_Rt
from #M2_Den
cross join #M2_Num
--*******************************M3**********************************

If object_id ('tempdb..#M3_Den') is not null
drop table #M3_Den
select count(patientid) m3_den
	 , count(case when policyid = 735 then patientid end) as m3_hi_den
	 , count(case when policyid = 736 then patientid end) as m3_me_den
	 , count(case when policyid = 737 then patientid end) as m3_lo_den
	 , count(case when policyid = 738 then patientid end) as m3_mo_den
into #M3_Den
from (
			select distinct c.patientid,pt.PolicyID
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
		      and c.reasoncode = 105 and c.resultcode not in (378,379)
		) den_base

If object_id ('tempdb..#M3_Num') is not null
drop table #M3_Num

select count(patientid) m3_num
	 , count(case when policyid = 735 then patientid end) as m3_hi_num
	 , count(case when policyid = 736 then patientid end) as m3_me_num
	 , count(case when policyid = 737 then patientid end) as m3_lo_num
	 , count(case when policyid = 738 then patientid end) as m3_mo_num
into #M3_Num
from (			
select distinct c.patientid, pt.policyid
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
			and c.reasoncode = 105 and c.resultcode not in (378,379)
			and c.validated =1
	   ) num_base

If object_id ('tempdb..#M3_Rt') is not null
drop table #M3_Rt

select cast(cast(cast(m3_num as decimal)/cast(nullif(m3_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m3_rt
	 , cast(cast(cast(m3_hi_num as decimal)/cast(nullif(m3_hi_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m3_hi_rt
	 , cast(cast(cast(m3_me_num as decimal)/cast(nullif(m3_me_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m3_me_rt
	 , cast(cast(cast(m3_lo_num as decimal)/cast(nullif(m3_lo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m3_lo_rt
	 , cast(cast(cast(m3_mo_num as decimal)/cast(nullif(m3_mo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m3_mo_rt
into #M3_Rt
from #M3_Den
cross join #M3_Num
--*******************************M4**********************************

If object_id ('tempdb..#M4_Den') is not null
drop table #M4_Den

select count(patientid) m4_den
	 , count(case when policyid = 735 then patientid end) as m4_hi_den
	 , count(case when policyid = 736 then patientid end) as m4_me_den
	 , count(case when policyid = 737 then patientid end) as m4_lo_den
	 , count(case when policyid = 738 then patientid end) as m4_mo_den
into #M4_Den
from (
			select distinct c.patientid,pt.PolicyID
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
			and c.reasoncode = 120 and c.resultcode not in (378,379)
		) den_base

If object_id ('tempdb..#M4_Num') is not null
drop table #M4_Num

select count(patientid) m4_num
	 , count(case when policyid = 735 then patientid end) as m4_hi_num
	 , count(case when policyid = 736 then patientid end) as m4_me_num
	 , count(case when policyid = 737 then patientid end) as m4_lo_num
	 , count(case when policyid = 738 then patientid end) as m4_mo_num
into #M4_Num
from (			
select distinct c.patientid, pt.policyid
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
			and c.reasoncode = 120 and c.resultcode not in (378,379)
			and c.validated =1
	   ) num_base

If object_id ('tempdb..#M4_Rt') is not null
drop table #M4_Rt

select cast(cast(cast(m4_num as decimal)/cast(nullif(m4_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m4_rt
	 , cast(cast(cast(m4_hi_num as decimal)/cast(nullif(m4_hi_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m4_hi_rt
	 , cast(cast(cast(m4_me_num as decimal)/cast(nullif(m4_me_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m4_me_rt
	 , cast(cast(cast(m4_lo_num as decimal)/cast(nullif(m4_lo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m4_lo_rt
	 , cast(cast(cast(m4_mo_num as decimal)/cast(nullif(m4_mo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m4_mo_rt
into #M4_Rt
from #M4_Den
cross join #M4_Num
			
		


--*******************************M5**********************************

If object_id ('tempdb..#M5_Den') is not null
drop table #M5_Den

select count(patientid) m5_den
	 , count(case when policyid = 735 then patientid end) as m5_hi_den
	 , count(case when policyid = 736 then patientid end) as m5_me_den
	 , count(case when policyid = 737 then patientid end) as m5_lo_den
	 , count(case when policyid = 738 then patientid end) as m5_mo_den
into #M5_Den
from (
			select distinct c.patientid,pt.PolicyID
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
			and c.reasoncode in (140,145) and c.resultcode not in (378,379)
		) den_base

If object_id ('tempdb..#M5_Num') is not null
drop table #M5_Num

select count(patientid) m5_num
	 , count(case when policyid = 735 then patientid end) as m5_hi_num
	 , count(case when policyid = 736 then patientid end) as m5_me_num
	 , count(case when policyid = 737 then patientid end) as m5_lo_num
	 , count(case when policyid = 738 then patientid end) as m5_mo_num
into #M5_Num
from (			
select distinct c.patientid, pt.policyid
			from #patientbase pt
			join #claimbase c on c.patientid = pt.PatientID
			where 1=1
			and c.reasoncode in (140,145) and c.resultcode not in (378,379)
			and c.validated =1
	   ) num_base

If object_id ('tempdb..#M5_Rt') is not null
drop table #M5_Rt

select cast(cast(cast(m5_num as decimal)/cast(nullif(m5_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m5_rt
	 , cast(cast(cast(m5_hi_num as decimal)/cast(nullif(m5_hi_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m5_hi_rt
	 , cast(cast(cast(m5_me_num as decimal)/cast(nullif(m5_me_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m5_me_rt
	 , cast(cast(cast(m5_lo_num as decimal)/cast(nullif(m5_lo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m5_lo_rt
	 , cast(cast(cast(m5_mo_num as decimal)/cast(nullif(m5_mo_den,0) as decimal) * 100 as decimal(5,1)) as varchar(5)) + '%' as m5_mo_rt
into #M5_Rt
from #M5_Den
cross join #M5_Num
			


set  @im1_den = (select im1_den from #IM_Den)
set  @im2_hi_den = (select im2_hi_den from #IM_Den)
set  @im2_me_den = (select im2_me_den from #IM_Den)
set  @im2_lo_den = (select im2_lo_den from #IM_Den)
set  @im2_mo_den = (select im2_mo_den from #IM_Den)
set  @im1_num = (select im1_num from #IM_Num)
set  @im2_hi_num = (select im2_hi_num from #IM_Num)
set  @im2_me_num = (select im2_me_num from #IM_Num)
set  @im2_lo_num = (select im2_lo_num from #IM_Num)
set  @im2_mo_num = (select im2_mo_num from #IM_Num)
set  @im1_rt = (select im1_rt from #IM_Rt)
set  @im2_hi_rt = (select isnull(im2_hi_rt,0) from #IM_Rt)
set  @im2_me_rt = (select isnull(im2_me_rt,0) from #IM_Rt)
set  @im2_lo_rt = (select isnull(im2_lo_rt,0) from #IM_Rt)
set  @im2_mo_rt = (select isnull(im2_mo_rt,0) from #IM_Rt)
set  @im3_den = (select im3_den from #IM3)
set  @im3_num = (select im3_num from #IM3)
set  @im3_rt = (select im3_rt from #IM3)
set  @arm1_den = (select arm1_den from #ARM1)
set  @arm1_num = (select arm1_num from #ARM1)
set  @arm1_rt = (select arm1_rt from #ARM1)
set  @arm2_den = (select arm2_den from #ARM2)
set  @arm2_num = (select arm2_num from #ARM2)
set  @arm2_rt = (select arm2_rt from #ARM2)
set  @m2_den = (select m2_den from #M2_Den)
set  @m2_hi_den = (select m2_hi_den from #M2_Den)
set  @m2_me_den = (select m2_me_den from #M2_Den)
set  @m2_lo_den = (select m2_lo_den from #M2_Den)
set  @m2_mo_den = (select m2_mo_den from #M2_Den)
set  @m2_num = (select m2_num from #M2_Num)
set  @m2_hi_num = (select m2_hi_num from #M2_Num)
set  @m2_me_num = (select m2_me_num from #M2_Num)
set  @m2_lo_num = (select m2_lo_num from #M2_Num)
set  @m2_mo_num = (select m2_mo_num from #M2_Num)
set  @m2_rt = (select m2_rt from #M2_Rt)
set  @m2_hi_rt = (select isnull(m2_hi_rt,0) from #M2_Rt)
set  @m2_me_rt = (select isnull(m2_me_rt,0) from #M2_Rt)
set  @m2_lo_rt = (select isnull(m2_lo_rt,0) from #M2_Rt)
set  @m2_mo_rt = (select isnull(m2_mo_rt,0) from #M2_Rt)
set  @m3_den = (select m3_den from #M3_Den)
set  @m3_hi_den = (select m3_hi_den from #M3_Den)
set  @m3_me_den = (select m3_me_den from #M3_Den)
set  @m3_lo_den = (select m3_lo_den from #M3_Den)
set  @m3_mo_den = (select m3_mo_den from #M3_Den)
set  @m3_num = (select m3_num from #M3_Num)
set  @m3_hi_num = (select m3_hi_num from #M3_Num)
set  @m3_me_num = (select m3_me_num from #M3_Num)
set  @m3_lo_num = (select m3_lo_num from #M3_Num)
set  @m3_mo_num = (select m3_mo_num from #M3_Num)
set  @m3_rt = (select m3_rt from #M3_Rt)
set  @m3_hi_rt = (select isnull(m3_hi_rt,0) from #M3_Rt)
set  @m3_me_rt = (select isnull(m3_me_rt,0) from #M3_Rt)
set  @m3_lo_rt = (select isnull(m3_lo_rt,0) from #M3_Rt)
set  @m3_mo_rt = (select isnull(m3_mo_rt,0) from #M3_Rt)
set  @m4_den = (select m4_den from #M4_Den)
set  @m4_hi_den = (select m4_hi_den from #M4_Den)
set  @m4_me_den = (select m4_me_den from #M4_Den)
set  @m4_lo_den = (select m4_lo_den from #M4_Den)
set  @m4_mo_den = (select m4_mo_den from #M4_Den)
set  @m4_num = (select m4_num from #M4_Num)
set  @m4_hi_num = (select m4_hi_num from #M4_Num)
set  @m4_me_num = (select m4_me_num from #M4_Num)
set  @m4_lo_num = (select m4_lo_num from #M4_Num)
set  @m4_mo_num = (select m4_mo_num from #M4_Num)
set  @m4_rt = (select m4_rt from #M4_Rt)
set  @m4_hi_rt = (select isnull(m4_hi_rt,0) from #M4_Rt)
set  @m4_me_rt = (select isnull(m4_me_rt,0) from #M4_Rt)
set  @m4_lo_rt = (select isnull(m4_lo_rt,0) from #M4_Rt)
set  @m4_mo_rt = (select isnull(m4_mo_rt,0) from #M4_Rt)
set  @m5_den = (select m5_den from #M5_Den)
set  @m5_hi_den = (select m5_hi_den from #M5_Den)
set  @m5_me_den = (select m5_me_den from #M5_Den)
set  @m5_lo_den = (select m5_lo_den from #M5_Den)
set  @m5_mo_den = (select m5_mo_den from #M5_Den)
set  @m5_num = (select m5_num from #M5_Num)
set  @m5_hi_num = (select m5_hi_num from #M5_Num)
set  @m5_me_num = (select m5_me_num from #M5_Num)
set  @m5_lo_num = (select m5_lo_num from #M5_Num)
set  @m5_mo_num = (select m5_mo_num from #M5_Num)
set  @m5_rt = (select m5_rt from #M5_Rt)
set  @m5_hi_rt = (select isnull(m5_hi_rt,0) from #M5_Rt)
set  @m5_me_rt = (select isnull(m5_me_rt,0) from #M5_Rt)
set  @m5_lo_rt = (select isnull(m5_lo_rt,0) from #M5_Rt)
set  @m5_mo_rt = (select isnull(m5_mo_rt,0) from #M5_Rt)

IF object_id ('tempdb..#final_report') IS NOT NULL
DROP TABLE #final_report

CREATE TABLE #final_report(
Measure VARCHAR(100)
,Numerator VARCHAR(20)
,Denominator VARCHAR(20)
,Rate VARCHAR(20)
,Rep_order INT
)

INSERT INTO #final_report
(Measure,Numerator,Denominator,Rate,Rep_order)
SELECT 'Percentage of targeted beneficiaries with at least one medication therapy issue',@arm1_num,@arm1_den,@arm1_rt,1
UNION
SELECT 'Percentage of MTM recommendations that were implemented',@arm2_num,@arm2_den,@arm2_rt,2
UNION
SELECT 'Percentage of total membership all tiers that has had any service performed',@im1_num,@im1_den,@im1_rt,4
UNION
SELECT RIGHT(SPACE(100)+'High',100),@im2_hi_num,@im2_hi_den,@im2_hi_rt,6
UNION
SELECT RIGHT(SPACE(100)+'Medium',100),@im2_me_num,@im2_me_den,@im2_me_rt,7
UNION
SELECT RIGHT(SPACE(100)+'Low',100),@im2_lo_num,@im2_lo_den,@im2_lo_rt,8
UNION
SELECT RIGHT(SPACE(100)+'Monitoring',100),@im2_mo_num,@im2_mo_den,@im2_mo_rt,9
UNION
SELECT 'Percentage of pharmacies providing services',@im3_num,@im3_den,@im3_rt,10
UNION
SELECT 'Prevalence of services identified and addressed for unique members',@m2_num,@m2_den,@m2_rt,11
UNION
SELECT RIGHT(SPACE(100)+'High',100),@m2_hi_num,@m2_hi_den,@m2_hi_rt,12
UNION
SELECT RIGHT(SPACE(100)+'Medium',100),@m2_me_num,@m2_me_den,@m2_me_rt,13
UNION
SELECT RIGHT(SPACE(100)+'Low',100),@m2_lo_num,@m2_lo_den,@m2_lo_rt,14
UNION
SELECT RIGHT(SPACE(100)+'Monitoring',100),@m2_mo_num,@m2_mo_den,@m2_mo_rt,15
UNION
SELECT 'Prevalence of beneficiaries with Cost Efficacy drug therapy problem successfully resolved',@m3_num,@m3_den,@m3_rt,16
UNION
SELECT RIGHT(SPACE(100)+'High',100),@m3_hi_num,@m3_hi_den,@m3_hi_rt,17
UNION
SELECT RIGHT(SPACE(100)+'Medium',100),@m3_me_num,@m3_me_den,@m3_me_rt,18
UNION
SELECT RIGHT(SPACE(100)+'Low',100),@m3_lo_num,@m3_lo_den,@m3_lo_rt,19
UNION
SELECT RIGHT(SPACE(100)+'Monitoring',100),@m3_mo_num,@m3_mo_den,@m3_mo_rt,20
UNION
SELECT 'Prevalence of beneficiaries with a Needs Therapy drug therapy problem successfully resolved',@m4_num,@m4_den,@m4_rt,21
UNION
SELECT RIGHT(SPACE(100)+'High',100),@m4_hi_num,@m4_hi_den,@m4_hi_rt,22
UNION
SELECT RIGHT(SPACE(100)+'Medium',100),@m4_me_num,@m4_me_den,@m4_me_rt,23
UNION
SELECT RIGHT(SPACE(100)+'Low',100),@m4_lo_num,@m4_lo_den,@m4_lo_rt,24
UNION
SELECT RIGHT(SPACE(100)+'Monitoring',100),@m4_mo_num,@m4_mo_den,@m4_mo_rt,25
UNION
SELECT 'Prevalence of beneficiaries with an Adverse Drug Reaction drug therapy problem successfully resolved',@m5_num,@m5_den,@m5_rt,26
UNION
SELECT RIGHT(SPACE(100)+'High',100),@m5_hi_num,@m5_hi_den,@m5_hi_rt,27
UNION
SELECT RIGHT(SPACE(100)+'Medium',100),@m5_me_num,@m5_me_den,@m5_me_rt,28
UNION
SELECT RIGHT(SPACE(100)+'Low',100),@m5_lo_num,@m5_lo_den,@m5_lo_rt,29
UNION
SELECT RIGHT(SPACE(100)+'Monitoring',100),@m5_mo_num,@m5_mo_den,@m5_mo_rt,30

SELECT Measure,Numerator,Denominator,Rate
FROM #final_report
ORDER BY Rep_order

END








