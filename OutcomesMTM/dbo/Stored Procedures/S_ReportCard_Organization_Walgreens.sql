
CREATE proc [dbo].[S_ReportCard_Organization_Walgreens] (@PolicyID int, @State VARCHAR(2))
as 
begin 

DECLARE @Start_date VARCHAR(10)
DECLARE @End_date VARCHAR(10)
-- Beginning of year (if current month is Jan. then beginning of last year)		

--case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '0101' else cast(year(getdate()) as varchar(4)) + '0101' end *****(Old logic)*********

SET @Start_date =  cast(year(getdate()) as varchar(4)) + '-01-01'  --New logic (First day of current year) Changed by Santhosh TC-2611

-- Date of yesterday
SET @End_date = cast(getdate()-1 as date)

--if(object_ID('tempdb..#chainRollUp') is not null)
--begin
--		drop table #chainRollUp
--end
--create table #chainRollUp 
--(
--		ID int identity (1,1) primary key
--		, Preferred int
--		, [Organization Category Size] int
--		, [Organization Name] varchar(100)
--		, RelationshipID varchar(50)
--		, NABP varchar(50)
--)

DECLARE @chainRollUp TABLE
(
		ID int identity (1,1) primary key
		, Preferred int
		, [Organization Category Size] int
		, [Organization Name] varchar(100)
		, RelationshipID varchar(50)
		, NABP varchar(50)
)

insert into @chainrollup select 1  ,  1  ,  'Walgreens Co. '  ,  '226'  ,  NULL
insert into @chainrollup select 1  ,  1  ,  'Walgreens Co. '  ,  'A10'  ,  NULL
insert into @chainrollup select 1  ,  1  ,  'Walgreens Co. '  ,  'A13'  ,  NULL

if(object_ID('tempdb..#org') is not null)
begin
		drop table #org
end
create table #org 
(
		orgID int identity (1,1) primary key
		, [Organization Name] varchar(100)
		, [Organization Category Size] int
)

insert into #org ([Organization Name], [Organization Category Size])
select	distinct [organization Name]
		, [Organization Category Size] 
from	@chainrollup
where	1=1 

if(object_ID('tempdb..#Org2Center') is not null)
begin
		drop table #Org2Center
end
create table #org2Center
(
		orgID int 
		, centerid int
		, NCPDP_NABP varchar (50) 
		primary key (orgid, centerid) 
)

;with ch as 
(
	select	cr.[Organization Name]
			, p.centerid
			, p.NCPDP_NABP 
	from	@chainRollUp cr
			join outcomesMTM.dbo.chain c on c.chainCode = cr.RelationshipID 
			join outcomesMTM.dbo.pharmacychain pc on pc.chainid = c.chainid
			join outcomesMTM.dbo.pharmacy p on p.centerid = pc.centerid
	where	1=1

),
ph as 
(
    select	cr.[Organization Name]
			, p.centerid
			, p.NCPDP_NABP
    from	@chainRollUp cr
			join outcomesMTM.dbo.pharmacy p on p.NCPDP_NABP = cr.NABP
    where	1=1
)
insert into #Org2Center (orgid, centerid, NCPDP_NABP) 
select	o.orgid
		, t.centerid
		, t.NCPDP_NABP  
from 
(
		select	ch.[Organization Name]
				, ch.centerid
				, ch.NCPDP_NABP
		from	ch
		where	1=1
			union
		select	ph.[Organization Name]
				, ph.centerid
				, ph.NCPDP_NABP
		from	ph
		where	1=1
) t
join #org o on o.[Organization Name] = t.[Organization Name]
where 1=1

-----------------
-- Main select --
-----------------
select 
		c1.policyID
		, c1.policyName
		, c1.chainnm
		, c1.CMROpportunity
		, c1.completedCMRs
		, c1.CMRCompletionRate
		, c1.[CMRs with Drug Therapy Problems Identified]
		, c1.[CMRs with Drug Therapy Problems Identified Rate]
from	 
			(
				select	u.orgID				
						, u.PolicyID
						, u.policyName
						, u.chainnm
						, count(distinct u.PatientID) as CMROpportunity
						, sum(u.CMRCompleted) as completedCMRs
						, isnull(cast(cast((cast(sum(u.CMRCompleted) as decimal)/nullif(cast(count(distinct u.PatientID) as decimal), 0)) as decimal (5,2))* 100 as int), 0) as [CMRCompletionRate]
						, sum(u.CMRWithDrugProblems) as [CMRs with Drug Therapy Problems Identified]
						, isnull(cast(cast((cast(sum(u.CMRWithDrugProblems) as decimal)/nullif(cast(sum(u.CMRCompleted) as decimal), 0)) as decimal (5,2))* 100 as int), 0) as [CMRs with Drug Therapy Problems Identified Rate]
				from 
					(
						select	row_number() over (partition by rp.patientID, oc.orgID 
											order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc
															, rp.patientKey, rp.patientMTMCenterKey) as rank
								, rp.PatientID
								, rp.PolicyID
								, p.policyName
								, rp.centerid
								, c.chainnm
								, oc.orgID
								, case when CAST(rp.mtmServiceDT as date) between @Start_date and @End_date AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRCompleted
								, case when CAST(rp.mtmServiceDT as date) between @Start_date and @End_date AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRWithDrugProblems
						from	vw_CMRActivityReport rp
								join #org2Center oc on oc.centerid = rp.centerid
								join patientDim pd on pd.patientKey = rp.patientKey
								join policy p on p.policyID = rp.policyID
								join pharmacy ph on ph.centerID = rp.centerID
								left join chain c on c.chainID = rp.chainID
						where	1=1
								AND isNull(rp.activethru, '99991231') >= @Start_date
								AND CAST(rp.activeasof as date) <= @End_date
								AND rp.primaryPharmacy = 1 
								--30 day include
								AND (
										(rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN CAST(rp.activeasof as date)> @Start_date THEN CAST(rp.activeasof as date) ELSE @Start_date END, @End_date) >= 30)
										OR
										(rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN CAST(rp.activeasof as date)> @Start_date THEN CAST(rp.activeasof as date) ELSE @Start_date END, CASE WHEN CAST(rp.activethru as date)> @End_date THEN @End_date ELSE CAST(rp.activethru as date) END) >= 30)
										OR
										(CAST(rp.mtmServiceDT as date)BETWEEN @Start_date AND @End_date AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
										AND
										(rp.claimcenterID = rp.centerid)
									)
								AND c.chainid in (46, 389, 390)
								AND p.policyID in (@PolicyID)
								AND ph.AddressState in (@State)
					) u
				where	1 = 1
						and u.rank = 1
				group by u.orgID, u.PolicyID, u.policyName, u.chainnm
			) c1
where	1=1


end
