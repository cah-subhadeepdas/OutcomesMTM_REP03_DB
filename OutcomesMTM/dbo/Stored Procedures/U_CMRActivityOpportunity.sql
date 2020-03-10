




CREATE proc [dbo].[U_CMRActivityOpportunity]
as
begin
set nocount on;
set xact_abort on;


--eventually use only using delta record
--declare @changeDate datetime = 
--(
--	select min(changeDate) as changeDate 
--	from (
--		select max(changeDate) as changeDate 
--		from patientDim
--		union 
--		select max(changeDate) 
--		from patientMTMCenterDim
--	) T
--)


if(object_ID('tempdb..#tempTD') is not null)
drop table #tempTD
create table #tempTD ( 
patientid int primary key 
, outcomesTermDate datetime  
)
insert into #tempTD(patientid, outcomesTermdate)
select patientid 
, outcomesTermdate  
from ( 
	select patientid 
	, outcomesTermdate 
	, rank() over (partition by patientid order by activeasof desc) as ptRank 
	from patientDim d 
) T
where 1=1 
and ptRank = 1;

if(object_id('tempdb.dbo.#tempCMROpp') is not null) 
drop table #tempCMROpp
create table #tempCMROpp (
patientKey bigint 
, patientMTMcenterKey bigint 
, PatientID int 
, PolicyID int 
, CMSContractNumber varchar(50) 
, centerid int 
, chainid int 
, primaryPharmacy bit 
, CMREligible bit 
, outcomesTermDate datetime 
, activeAsOF datetime
, activeThru datetime
)
insert into #tempCMROpp with (tablock) ( 
patientKey 
, patientMTMcenterKey
, PatientID
, PolicyID
, CMSContractNumber
, centerid
, primaryPharmacy
, CMREligible
, outcomesTermDate
, activeAsOF
, activeThru
)
select t.patientKey 
, t.patientMTMcenterKey
, pt.PatientID
, pt.PolicyID
, pt.CMSContractNumber
, mt.centerid
, mt.primaryPharmacy
, pt.CMREligible
, td.outcomesTermDate
, t.activeAsOF
, t.activeThru
from (
	select t.patientkey
	, t.patientMTMCenterKey
	, t.activeAsOF
	, t.activeThru
	from (
		   select o.patientkey  
		   , d.patientMTMCenterKey
		   , d.patientID
		   , d.centerID
		   , case when d.activeasof >= o.activeAsOf THEN d.activeasof ELSE o.activeAsOf END as activeAsOF
		   , case when isNull(d.activeThru, '99991231') <= isNull(o.activeThru, '99991231') THEN d.activeThru ELSE o.activeThru END as activeThru
		   from patientMTMCenterDim d
		   JOIN (
					 SELECT max(patientKey) as patientKey 
					, PatientID
					, CMREligible
					, MIN(activeAsOf) AS activeAsOf
					, MAX(activeThru) AS activeThru
					FROM
					(
						   SELECT aa.*
								, aa.ranker - aa.ranker2 AS island
						   FROM
						   (
								  SELECT patientKey
								  , f.PatientID
								  , CASE WHEN f.OutcomesTermDate >= f.activeAsOf
										   THEN ISNULL(f.CMREligible, 0)
										   ELSE 0
								  END AS CMREligible -- Treat Outcomes termed member records as not CMREligible.
								  , f.activeAsOf
								  ,CASE WHEN f.OutcomesTermDate BETWEEN f.activeAsOf AND ISNULL(f.activeThru, '99991231')
										   THEN f.OutcomesTermDate
										   ELSE ISNULL(f.activeThru, '99991231')
								  END AS activeThru -- Adjust the activeThruDate where the member was CMREligible, but became Outcomes termed during the same log period.
								  , ROW_NUMBER() OVER (PARTITION BY f.PatientID ORDER BY f.activeAsOf) AS ranker
								  , DENSE_RANK() OVER (PARTITION BY f.PatientID, CASE WHEN f.OutcomesTermDate >= f.activeAsOf THEN ISNULL(f.CMREligible, 0) ELSE 0 END ORDER BY f.activeAsOf) AS ranker2
								  from outcomesMTM.dbo.patientdim AS f
             
						   ) AS aa
					) AS bb
					GROUP BY PatientID,CMREligible,Island
		   ) o on o.PatientID = d.patientid
			  AND o.activeAsOf < isnull(d.activeThru, '99991231')
			  AND isnull(o.activeThru, '99991231') >= d.activeasof
		   where 1 = 1
		   and o.CMREligible = 1
		   ------still needs testing----------
		   --and @changeDate > d.activeAsOf 
		   --and @changeDate <= isnull(d.activethru,'99991231')	
		   ------still needs testing---------- 	   
	) T
) t 
join patientDim pt on pt.patientKey = t.patientKey 
join patientMTMCenterDim mt on mt.patientMTMCenterKey = t.patientMTMCenterKey
join #tempTD td on td.patientid = pt.patientid  
where 1=1

create unique clustered index ind_patientKey_patientMTMcenterKey on #tempCMROpp(patientKey, patientMTMcenterKey);

---------------

delete o 
--select count(*) 
from CMRActivityOpportunity o
where 1=1 
and not exists (select 1
                from #tempCMROpp t
                where 1 = 1
                and o.patientKey = t.patientKey
				and o.patientMTMcenterKey = t.patientMTMcenterKey)

update o
set o.patientKey = t.patientKey
, o.patientMTMcenterKey = t.patientMTMcenterKey  
, o.PatientID = t.PatientID  
, o.PolicyID = t.PolicyID 
, o.CMSContractNumber = t.CMSContractNumber 
, o.centerid = t.centerid  
, o.primaryPharmacy = t.primaryPharmacy  
, o.CMREligible = t.CMREligible  
, o.outcomesTermDate = t.outcomesTermDate
, o.activeAsOF = t.activeAsOF 
, o.activeThru = t.activeThru 
--select count(*)
from CMRActivityOpportunity o
join #tempCMROpp t on o.patientKey = t.patientKey
					  and o.patientMTMcenterKey = t.patientMTMcenterKey
where 1  = 1
and not (isnull(o.patientKey,0) = isnull(t.patientKey,0)
		 and isnull(o.patientMTMcenterKey,0) = isnull(t.patientMTMcenterKey,0)  
		 and isnull(o.PatientID,0) = isnull(t.PatientID,0)  
		 and isnull(o.PolicyID,0) = isnull(t.PolicyID,0) 
		 and isnull(o.CMSContractNumber,'') = isnull(t.CMSContractNumber,'') 
		 and isnull(o.centerid,0) = isnull(t.centerid,0)  
		 and isnull(o.primaryPharmacy,0) = isnull(t.primaryPharmacy,0)  
		 and isnull(o.CMREligible,0) = isnull(t.CMREligible,0)  
		 and isnull(o.outcomesTermDate,'99991231') = isnull(t.outcomesTermDate,'99991231') 
		 and isnull(o.activeAsOF,'99991231') = isnull(t.activeAsOF,'99991231') 
		 and isnull(o.activeThru,'99991231') = isnull(t.activeThru,'99991231'))



--Disabling indices for CMRActivityOpportunity
ALTER INDEX [ind_patientKey_patientMTMcenterKey] ON [dbo].[CMRActivityOpportunity] DISABLE
ALTER INDEX [ind_policyid_activeasof] ON [dbo].[CMRActivityOpportunity] DISABLE
ALTER INDEX [ind_patientid] ON [dbo].[CMRActivityOpportunity] DISABLE

insert into CMRActivityOpportunity(patientKey  
, patientMTMcenterKey  
, PatientID  
, PolicyID  
, CMSContractNumber 
, centerid  
, primaryPharmacy  
, CMREligible  
, outcomesTermDate
, activeAsOF 
, activeThru                                                
)
select patientKey  
, patientMTMcenterKey  
, PatientID  
, PolicyID  
, CMSContractNumber 
, centerid  
, primaryPharmacy  
, CMREligible  
, outcomesTermDate
, activeAsOF 
, activeThru    
--select count(*)                         
from #tempCMROpp t
where 1  = 1
and not exists (select 1
                from CMRActivityOpportunity o
                where 1 = 1
                and o.patientKey = t.patientKey
				and o.patientMTMcenterKey = t.patientMTMcenterKey)

--Enabling indices for CMRActivityOpportunity
ALTER INDEX [ind_patientKey_patientMTMcenterKey] ON [dbo].[CMRActivityOpportunity] REBUILD
ALTER INDEX [ind_policyid_activeasof] ON [dbo].[CMRActivityOpportunity] REBUILD
ALTER INDEX [ind_patientid] ON [dbo].[CMRActivityOpportunity] REBUILD

END







