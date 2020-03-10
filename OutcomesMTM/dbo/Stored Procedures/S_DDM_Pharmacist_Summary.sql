

CREATE   procedure  [dbo].[S_DDM_Pharmacist_Summary] (@Report_date  date)

AS

--========================================================================
--		Card Number:	TC-2855
--		Create Date:	03/29/2019
--		Created By:		Subha
--		Description:	DDM Pharmacist Level Details
--		Modified by:
--		Modified Date:
--========================================================================

BEGIN

--declare @report_date date = '03-10-2019'--getdate() 
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

if object_id('tempdb..#queryold') is not null
drop table  #queryold 
if object_id('tempdb..#user') is not null
drop table  #user 
if object_id('tempdb..#c1') is not null
drop table  #c1 
if object_id('tempdb..#pm') is not null
drop table  #pm 
if object_id('tempdb..#cs') is not null
drop table  #cs 
if object_id('tempdb..#cm') is not null
drop table  #cm 



select u.userid, c.centerid, count(distinct c.patientid) as [Patients Served], count(distinct c.claimid) as [Claims Submitted] into #c1
			from	OutcomesMTM.dbo.vw_clientManagerReport car
					join OutcomesMTM.dbo.claim c on c.claimid = car.claimID
					join OutcomesMTM.staging.users u on u.userid = c.pharmacistID
					join pharmacychain p on p.centerid=car.centerid
					join Chain ch on ch.chainid=p.chainid
			where	1=1
					and car.mtmserviceDT between @BEGIN and @END
					and ch.chainid = 9
					and c.statusID not in (3,5)
				 --  and u.userID IN (26642)--(198395,26633,26642,57365)
			group by u.userid, c.centerID


select pm.centerid, count(distinct pt.patientID) as [EligiblePatient] into #pm
			from outcomesMTM.dbo.patientMTMCenterDim pm
			join (

				select distinct pt.patientID
				--select count(distinct pt.patientID)
				from outcomesMTM.dbo.patientDim pt
				where	1=1
						and isnull(pt.activethru, '99991231') >= @BEGIN
						and pt.policyid not in (10,20)
						and pt.activeasof <= @END
				) pt on pt.patientID = pm.patientid
			where	1=1
					and isnull(pm.activethru, '99991231') >= @BEGIN
					and pm.activeasof <= @END
			group by pm.centerid

select u.userid--sum(case when car.isTipClaim = 1 or car.claimfromcmr = 1 then 1 else 0 end) as [Pushed Claim]
			--, sum(car.PharmacistClaim) as [Pulled Claim]
			 ,sum(CASE WHEN (car.isTipClaim = 0  AND c.actionTypeID <> 1 )THEN 1 ELSE 0 END) AS [Pulled Claim]
			, sum(case when car.claimfromcmr=1 then 1 else 0 end) AS [CMR Claim]
			, sum(case when car.resulttypeid in (5,6) then 1 else 0 end) as [Successful CMR]
			, sum(case when car.resulttypeid = 5 then 1 else 0 end) as [CMR DTP]
			, sum(case when car.resulttypeid = 6 then 1 else 0 end) as [CMR NO DTP]
			--, sum(car.isTIPClaim) AS [TIP Claim]
			, sum(case when car.resulttypeID not in(12,13,16,18) and car.isTipClaim=1 then 1 else 0 end) as [Successful TIP] into #cs
			from	OutcomesMTM.dbo.vw_clientManagerReport car
					join OutcomesMTM.dbo.claim c on c.claimid = car.claimID
					join OutcomesMTM.staging.users u on u.userid = c.pharmacistID
					join pharmacychain p on p.centerid=car.centerid
					join Chain ch on ch.chainid=p.chainid
			where	1=1
					and car.mtmserviceDT between @BEGIN and @END
					and ch.chainid = 9
					and c.statusID not in (3,5)
				--and u.userID=57365

			group by u.userid

SELECT centerid,
             count(DISTINCT u.patientid) AS [Total CMR Opportunity] into #cm
     
FROM
  (SELECT row_number() OVER (PARTITION BY rp.patientid,
                                          rp.centerid
                             ORDER BY isnull(rp.resulttypeid, 90),
                                      rp.mtmservicedt DESC, rp.patientkey,
                                                            rp.patientmtmcenterkey) AS rank,
                            ph.centername, ph.ncpdp_nabp, rp.centerid, rp.chainid, rp.patientid
   FROM vw_cmractivityreport rp
   JOIN patientdim pd ON pd.patientkey = rp.patientkey
   JOIN policy p ON p.policyid = rp.policyid
   JOIN pharmacy ph ON ph.centerid = rp.centerid
   LEFT JOIN CHAIN c ON c.chainid = rp.chainid
   WHERE 1=1
     AND isnull(rp.activethru, '99991231') >= @BEGIN
     AND rp.activeasof <= @END
     
     AND rp.chainid IN (9) 
	 ) u
WHERE 1 = 1
  AND u.rank = 1
GROUP BY ncpdp_nabp,centerid,centername

--create indices for the temp tables to expedite joins
create unique nonclustered index IX_c1 on #c1 (userid , centerid) ; 
create unique nonclustered index IX_c1 on #pm (centerid) ; 
create unique nonclustered index IX_c1 on #cs (userid) ; 
create unique nonclustered index IX_c1 on #cm (centerid) ; 

select distinct 
u.userID
, c.firstNM as [PHARMACIST FIRST NAME] 
, c.lastNM as [PHARMACIST LAST NAME]
, u.username as [PHARMACIST USERNAME]
, count(distinct cl.centerid) as [STORES RPH SUBMITTED CLAIMS FOR]
, sum(cl.[Patients Served]) as [TOTAL PATIENTS SERVICED]
, sum(pm.[EligiblePatient]) as [COMBINED ELIGIBLE PATIENT COUNT]
, sum(cl.[Claims Submitted]) as [TOTAL OUTCOMES CLAIMS SUBMITTED]  --not using in final
, cs.[CMR Claim] as [TOTAL CMRS SUBMITTED]
, cs.[Successful CMR] as [SUCCESSFUL CMRS SUBMITTED]
, sum(cm.[Total CMR Opportunity]) as [CMR OPPORTUNITIES]
, cs.[CMR DTP] as [CMRS WITH DRUG THERAPY PROBLEMS]
, cs.[CMR NO DTP] as [CMRS WITHOUT DRUG THERAPY PROBLEMS]
, cs.[Successful TIP] as [TIPS SUCCESSFUL]
, cs.[Pulled Claim] as [PULLED CLAIMS SUBMITTED]
--, sum(ta.[Total TIP Opportunities]) as [COMBINED TIP OPPORTUNITIES]
--, cs.[TIP Claim] as [TIPS COMPLETED]
--,ta.tipopportunities
into #queryold

 from OutcomesMTM.staging.users u
 join OutcomesMTM.staging.userCenter uc on uc.userID = u.userID
 join OutcomesMTM.staging.contact c on c.userID = u.userID
 join OutcomesMTM.staging.role r on r.userID = u.userID
 join OutcomesMTM.staging.roleType rt on rt.roleTypeID = r.roleTypeID
 join OutcomesMTM.dbo.pharmacy ph on ph.centerid = uc.centerID
 join OutcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
 join OutcomesMTM.dbo.chain ch on ch.chainid = pc.chainid
 join #c1 cl on cl.userID = u.userID and cl.centerID = ph.centerid

 join #pm pm on pm.centerid = cl.centerid

 join #cs cs on cs.userID = u.userID 

left join #cm cm on cm.centerid = cl.centerid



 where 1=1
 and ch.chaincode = '044'
 and u.active = 1
 --and uc.active = 1
 and r.active = 1
 and rt.active = 1
 and rt.roleTypeID = 1
 group by  u.userID, u.username, c.firstNM, c.lastNM,  cs.[CMR Claim], cs.[Successful CMR], cs.[CMR DTP], cs.[CMR NO DTP],  cs.[Successful TIP] ,cs.[Pulled Claim]


--DECLARE @BEGIN DATE = '20180401'
--DECLARE @END DATE	= '20180630'


if object_id('tempdb..#User') is not null
drop table  #User 	
select distinct  
   u.userID
  ,u.username as [USERNAME]
 , c.firstNM  as [User First name]
 , c.lastNM as [User Last Name]
 ,ph.centerid as [CenterID]
 into #User
 from OutcomesMTM.staging.users u
 join OutcomesMTM.staging.userCenter uc on uc.userID = u.userID
 join OutcomesMTM.staging.contact c on c.userID = u.userID
 join OutcomesMTM.staging.role r on r.userID = u.userID
 join OutcomesMTM.staging.roleType rt on rt.roleTypeID = r.roleTypeID
 join OutcomesMTM.dbo.pharmacy ph on ph.centerid = uc.centerID
 join OutcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
 join OutcomesMTM.dbo.chain ch on ch.chainid = pc.chainid
 where 1=1
 and ch.chaincode = '044'
 and u.active = 1
 --and uc.active = 1

 and r.active = 1
 and rt.active = 1
 and rt.roleTypeID = 1



--select * from #queryold where userid= (26642)
if object_id('tempdb..#SuccessClaims') is not null
drop table  #SuccessClaims 	
select u.userid, count(distinct c.claimid) as [Total Successful Claims Submitted]
into #SuccessClaims
	from	OutcomesMTM.dbo.vw_clientManagerReport car
	join OutcomesMTM.dbo.claim c on c.claimid = car.claimID
	join OutcomesMTM.staging.users u on u.userid = c.pharmacistID
	join (select distinct userID from #user) US on U.userID=US.userID --and c.centerID=US.CenterID
	join pharmacychain p on p.centerid=car.centerid
	join Chain ch on ch.chainid=p.chainid
where	1=1
	and car.mtmserviceDT between @BEGIN and @END
	and p.chainid = 9
	and c.statusID in (2,6)
	and c.resultTypeID not in (12,13,16,18) -- business need
	group by u.userid
	order by 1

if object_id('tempdb..#TipsSubmitted') is not null
drop table  #TipsSubmitted 	
select u.userid, count(distinct c.claimid) as [Tips Submitted]
into #TipsSubmitted
	from	OutcomesMTM.dbo.vw_clientManagerReport car
					join OutcomesMTM.dbo.claim c on c.claimid = car.claimID
					join OutcomesMTM.staging.users u on u.userid = c.pharmacistID
						join pharmacychain p on p.centerid=car.centerid
	                    join Chain ch on ch.chainid=p.chainid
			where	1=1
					and car.mtmserviceDT between @BEGIN and @END
					and p.chainid = 9
					and c.statusID not in (3,5)
					and c.isTipClaim=1
					--and u.userid =98555
			group by u.userid

					
	
if object_id('tempdb..#tipopportunity') is not null
drop table  #tipopportunity 
SELECT f.centername,
       f.ncpdp_nabp,
	   f.centerid,
       f.tipopportunities
 into #tipopportunity     
FROM
  (SELECT row_number() OVER (
                             ORDER BY centername ASC) AS [rank],
                            t.*
   FROM
     (SELECT ta.centerid,
             ta.centername,
             ta.ncpdp_nabp,
             sum(ta.[tip opportunities]) AS tipopportunities
                  FROM
        (SELECT row_number() OVER (PARTITION BY ta.tipresultstatusid,
                                                ta.centerid
                                   ORDER BY ta.[completed tips] DESC, ta.[unfinished tips] DESC, ta.[review/resubmit tips] DESC, ta.[rejected tips] DESC, ta.[currently active] DESC, ta.[withdrawn] DESC, ta.tipresultstatuscenterid DESC) AS [rank],ta.centerid,
             ta.centername,
             ta.ncpdp_nabp,
			 [TIP Opportunities]
                                
         FROM vw_tipactivitycenterreport ta WITH (nolock)
         WHERE 1 = 1
           AND ta.activethru >= @BEGIN
           AND ta.activeasof <= @END
                    AND ta.chainid IN (9) ) ta
      WHERE 1 = 1
        AND ta.[rank] = 1
      GROUP BY ta.centerid,
               ta.centername,
               ta.ncpdp_nabp) t
   WHERE isnull(t.centerid,0) <> 0 ) f
WHERE 1 = 1
  AND f.rank BETWEEN 1 AND 100
ORDER BY f.rank


if object_id('tempdb..#tipcount') is not null
drop table  #tipcount 
	select u.userID,sum(tt.tipopportunities) as tipopps--, sum ( st.[Successful TIPs]) as [Successful TIPs]
	--, [TIPs Submitted] as [TIPs Submitted]
	into #tipcount
	from #User u 
    join #tipopportunity tt on u.CenterID= tt.centerid
	join(

		select u.userid, c.centerid, count(distinct c.patientid) as [Patients Served], count(distinct c.claimid) as [Claims Submitted]
			from	OutcomesMTM.dbo.vw_clientManagerReport car
					join OutcomesMTM.dbo.claim c on c.claimid = car.claimID
					join OutcomesMTM.staging.users u on u.userid = c.pharmacistID
					join pharmacychain p on p.centerid=car.centerid
					join Chain ch on ch.chainid=p.chainid
			where	1=1
					and car.mtmserviceDT between @BEGIN and @END
					and ch.chainid = 9
					and c.statusID not in (3,5)
				 --  and u.userID IN (26642)--(198395,26633,26642,57365)
			group by u.userid, c.centerID
					) cl on cl.userID = u.userID and cl.centerID = tt.centerid
    group by u.userID


	select QO.[PHARMACIST FIRST NAME] as [First Name]
	,Qo.[PHARMACIST LAST NAME] as [Last Name]
	,QO.[PHARMACIST USERNAME] as [Username]
	,qo.[STORES RPH SUBMITTED CLAIMS FOR]
	,qo.[COMBINED ELIGIBLE PATIENT COUNT]
	,Qo.[TOTAL PATIENTS SERVICED] 
	,Qo.[PULLED CLAIMS SUBMITTED]
	,QO.[TOTAL OUTCOMES CLAIMS SUBMITTED]
	,SC.[Total Successful Claims Submitted]
	--,QO.[TIPs Submitted]
	,TS.[TIPs Submitted]
	,TC.[tipopps] as [Tip Opportunities]
	,Qo.[TIPS SUCCESSFUL] as [Successful Tips]
	,Qo.[TOTAL CMRS SUBMITTED]
	,Qo.[SUCCESSFUL CMRS SUBMITTED]
	,Qo.[CMR OPPORTUNITIES]
	,QO.[CMRS WITH DRUG THERAPY PROBLEMS]
	,Qo.[CMRS WITHOUT DRUG THERAPY PROBLEMS]
	
	--into tempdb.dbo.DDM_Pharmacist
	from #queryold QO join #tipcount TC on Qo.userID=TC.userID
	left join #SuccessClaims as SC on SC.userID=QO.userID
	left join #TipsSubmitted as TS on TS.userID=Qo.userID
	order by 1,2

END