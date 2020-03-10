

CREATE   procedure  [dbo].[S_DDM_Store_Summary] (@Report_date  date)

AS

--========================================================================
--		Card Number:	TC-2855
--		Create Date:	03/29/2019
--		Created By:		Subha
--		Description:	DDM Store Level Details
--		Modified by:
--		Modified Date:  7/15/2019   ..  Subha Das .... TC-3092 .. Switch column J (TIPS Submitted) and Column K (Successful TIPs)
--========================================================================

BEGIN

--declare @report_date date = getdate() 
declare @BEGIN date, @END date

if ((month(@report_date) = 4 and day(@report_date) > 10 ) or (month(@report_date) in (5,6)) or (month(@report_date) = 7 and day(@report_date) <= 10 ) )
begin
set @BEGIN = cast('04-01-' + cast(year(@report_date)  as char(4) ) as date)
set @END = cast('06-30-' + cast(year(@report_date)  as char(4) ) as date)
end
else if ((month(@report_date) = 7 and day(@report_date) > 10 ) or (month(@report_date) in (8,9)) or (month(@report_date) = 10 and day(@report_date) <= 10 ) )
begin
set @BEGIN = cast('04-01-' + cast(year(@report_date)  as char(4) ) as date)
set @END = cast('09-30-' + cast(year(@report_date)  as char(4) ) as date)
end
else if ((month(@report_date) = 10 and day(@report_date) > 10 ) or (month(@report_date) in (11,12)) or (month(@report_date) = 1 and day(@report_date) <= 10 ) )
begin
set @BEGIN = cast('04-01-' + cast((case when month(@report_date) in (10,11,12) then year(@report_date) else (year(@report_date) - 1) end) as char(4) ) as date)
set @END = cast('12-31-' + cast((case when month(@report_date) in (10,11,12) then year(@report_date) else (year(@report_date) - 1) end) as char(4) ) as date)
end
else if ((month(@report_date) = 1 and day(@report_date) > 10 ) or (month(@report_date) in (2,3)) or (month(@report_date) = 4 and day(@report_date) <= 10 ) )
begin
set @BEGIN = cast('04-01-' + cast((year(@report_date) - 1) as char(4) ) as date)
set @END = cast('03-31-' +  cast(year(@report_date)  as char(4) ) as date)
end

--select @BEGIN , @END

-- [Successfull CMRs Submitted] and [CMR DTP]
;With a as 
(
select	c.centerid 
		,sum(case when car.resulttypeid in (5,6) then 1 else 0 end) as [Successful CMR]
		,sum(case when car.resulttypeid = 5 then 1 else 0 end) as [CMR DTP]
from	OutcomesMTM.dbo.clientManagerReport as car
join	OutcomesMTM.dbo.claim as c on c.claimid = car.claimID
join	OutcomesMTM.staging.users as u on u.userid = c.pharmacistID
where	1=1
		and CAST(car.mtmserviceDT as date) between @Begin and @End
		and c.claimfromCMR = 1
group by c.centerID)

-- [CMRs Submitted]
, b as
(
select	car.centerid 
		,count(distinct car.claimid) AS [CMR Claim]
from	OutcomesMTM.dbo.vw_clientmanagerreport as car
where	1=1
		and CAST(car.mtmserviceDT as date)  between @Begin and @End
		and car.claimfromcmr = 1
		and car.actiontypeid = 1
		and car.status in ('Approved - Paid', 'Approved - Not Paid', 'Pending approval')
group by car.centerID)

, h as
(
select	v.centerID
		,sum(v.claimSubmitted) as claimSubmitted
		,sum(v.claimsubbytec) as [technician]
		,isnull(cast((cast(100*sum(v.claimsubbytec) as decimal)/ nullif(cast(sum(v.claimSubmitted) as decimal),0)) as decimal(5,2)),0) as [technician percentage]
from (
		select	c.claimID
				,c.centerID
				,1 as claimSubmitted
				,case when r.roleTypeID = 4 then 1 else 0 end as claimsubbytec
				,pharmacistID
		from	outcomesMTM.dbo.Claim AS c
		--join [dbo].[vw_clientManagerReport] n on 
		left join outcomesmtm.staging.role r on r.roleID = c.documentationRoleID
		where	1=1
				and CAST(c.mtmserviceDT as date)  between @Begin and @End
				and c.statusID  in (2,6)
				and c.policyID not in (574 ,575 ,298)
				--and c.centerID = 149697
		) v
where	1=1
group by v.centerID
)

---- [Count Opportunities]
--, i as
--(
--select	tc.centerid
--		,sum(tc.[Tip Opportunities]) as OppCount
--from (
--		Select	Tc.centerid
--				,tc.[Tip Opportunities]
--		From	vw_Tipactivitycenterreport tc with (nolock) 
--		where	1=1
--				and tc.activethru >= @Begin 
--				and tc.activeasof <= @End
--		)tc
--group by tc.centerid
--)

---- [Successful Tips Submitted]
--, j as
--(
--select	centerid
--			,count(*) as [Successfull Tips Submitted] 
--from	outcomesMTM.dbo.tipActivityCenterReport as tacr
--where	policyid not in (574, 575, 298)
--		and ([Successful TIPs]=1)
--		and activethru >=@Begin
--		and activeasof<=@End
--group by centerid
--)

---- [SubTips]
--, k as
--(
--Select	centerid
--		,Count(Claimid) as SubTip
--From	claim
--where	policyid not in (574, 575, 298)
--		and mtmServiceDT between @Begin and @End
--		--and centerid in (31796,31797,149697)
--		and isTipClaim =1
--		and statusID in (2,6)
--Group by Centerid
--)

-- [Total CMR Opportunity]
, l as
(
select	cr.centerid
		,count(distinct cr.PatientID) as [Total CMR Opportunity]
from (
		select	row_number() over (partition by rp.patientID, rp.centerID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
				,rp.centerid
				,rp.PatientID
		from	outcomesMTM.dbo.vw_CMRActivityReport rp
		join	outcomesMTM.dbo.patientDim pt on pt.patientKey = rp.patientKey
		join	outcomesMTM.dbo.Policy po on po.policyID = rp.PolicyID
		left join	outcomesMTM.dbo.pharmacy ph on ph.centerid = rp.centerid
		left join	outcomesMTM.dbo.Chain ch on ch.chainid = rp.chainid
		where	1=1
				and isNull(rp.activethru, '99991231') >= @Begin
				and rp.activeasof <= @End              
	) cr
where	1=1
		and cr.[rank] = 1
group by cr.centerid
)

-- [Successful Claims Submitted]
, m as
(
select	c.centerID
		,count(*) as claimSuccess	
from	outcomesMTM.dbo.Claim c
where	1=1
		and CAST(c.mtmserviceDT as date)  between  @Begin and @End
		and c.statusID in (2,6)
		and c.resultTypeID not in (12,13,16,18)
		and c.policyID not in	(574 ,575 ,298)
		--and c.centerid = 31795
group by c.centerID 
)

-- [Successful Tips]
, n as
(
select	c.centerid
		,count(distinct c.claimid) as [Tips Submitted] --[Successful Tips]   -- TC-3092
from	OutcomesMTM.dbo.vw_clientManagerReport car
join	OutcomesMTM.dbo.claim c on c.claimid = car.claimID
join	pharmacychain p on p.centerid=car.centerid
join	Chain ch on ch.chainid=p.chainid
where	1=1
		and CAST(car.mtmserviceDT as date)  between @Begin and @End	
		and c.statusID in (2,6)
		and c.isTipClaim=1
group by c.centerid
)

-- [Tips Submitted new]
, o as
(
select	c.centerid
		,count(distinct c.claimid) as [Successful Tips]--[Tips Submitted]  -- TC-3092
from	OutcomesMTM.dbo.vw_clientManagerReport car
join	OutcomesMTM.dbo.claim c on c.claimid = car.claimID
join	pharmacychain p on p.centerid=car.centerid
join	Chain ch on ch.chainid=p.chainid
where	1=1
		and CAST(car.mtmserviceDT as date)  between @Begin and @End	
		and c.statusID in (2,6)
		and c.isTipClaim=1
		and c.resultTypeID not in (12,13,16,18)
group by c.centerid
)

-- [???]
, p as
(
SELECT	f.centername
		,f.ncpdp_nabp
		,f.centerid
		,f.tipopportunities
FROM
(
		SELECT row_number() OVER (ORDER BY centername ASC) AS [rank]
		,t.*
		FROM
		(
			SELECT	ta.centerid
					,ta.centername
					,ta.ncpdp_nabp
					,sum(ta.[tip opportunities]) AS tipopportunities
			FROM
			(
					SELECT row_number() OVER (PARTITION BY ta.tipresultstatusid, ta.centerid
							ORDER BY ta.[completed tips] DESC, ta.[unfinished tips] DESC, 
							ta.[review/resubmit tips] DESC, ta.[rejected tips] DESC, 
							ta.[currently active] DESC, ta.[withdrawn] DESC, 
							ta.tipresultstatuscenterid DESC) AS [rank]
							,ta.centerid
							,ta.centername
							,ta.ncpdp_nabp
							,[TIP Opportunities]
                                
					FROM	vw_tipactivitycenterreport ta WITH (nolock)
					WHERE	1 = 1
							AND CAST(ta.activethru as date)>= @Begin
							AND CAST(ta.activeasof as date)<= @End
							AND ta.chainid IN (9)) as ta
			WHERE	1 = 1
					AND ta.[rank] = 1
			GROUP BY ta.centerid, ta.centername, ta.ncpdp_nabp) as t
		WHERE	isnull(t.centerid,0) <> 0) as f
WHERE	1 = 1
		AND f.rank BETWEEN 1 AND 100
					--ORDER BY f.rank
)


-- Main Select --
select	ph.centerid 
		,ph.NCPDP_NABP
		,ph.centername AS [Store Name]
		,Ph.Address1 AS [Store Address]
		,Ph.AddressCity AS [City]
		,Ph.AddressState AS [State]
		,Ph.AddressPostalCode AS [Zip]
		,h.claimSubmitted AS [Total claims Submitted] --cl
		,m.claimSuccess as [Total Successfull Claims Submitted]
		--,k.SubTip as TIPS_Submitted 
		--,f.[Tips Submitted] as [Tips Submitted New]
		--,i.OppCount as [TIP Opportunities]
		--,j.[Successfull Tips Submitted]
		,n.[Tips Submitted] 
		,o.[Successful Tips]		
		,p.tipopportunities
		,b.[CMR Claim] as [CMRs Submitted]
		,a.[Successful CMR] AS [Successfull CMRs Submitted]
		,l.[Total CMR Opportunity] as [CMR Opportunities] 
		,a.[CMR DTP]
		,h.technician
		,h.[technician percentage]
--into tempdb.dbo.DDM_Store
FROM	outcomesMTM.dbo.pharmacy as ph
join	outcomesmtm.dbo.pharmacychain as pc on pc.centerid = ph.centerid
join	outcomesmtm.dbo.chain ch  on ch.chainid = pc.chainid
left join a on a.centerid = ph.centerid
left join b on b.centerid = ph.centerid
--left join c on c.centerid = ph.centerid 
--left join d on d.centerID = ph.centerID
--left join e on e.centerid = ph.centerID
--left join f on f.centerid = ph.centerid
--left join g on g.centerID = ph.centerID
left join h on h.centerID = ph.centerid
--Left join i on i.centerid = ph.centerid
--left join j on j.centerid = ph.centerid
--left join k on k.centerID = ph.centerid
left join l on l.centerid = ph.centerid
left join m on m.centerID = ph.centerid
Left join n on n.centerID = ph.centerid
Left join o on o.centerID = ph.centerid
Left join p on p.centerID = ph.centerid
WHERE ch.chaincode = '044'

END



