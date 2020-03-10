
--Author:- Santhosh K Thopu
--Description:- Gathering data for all policies to compare Prior day with current, in Patient Trending Report

 
CREATE   procedure [dbo].[zzzI_Patient_And_TIP_Trending_Report] 
AS
BEGIN



/*Getting All Active patients for YTD*/
Drop table If exists #Patient
Select distinct PatientID,ClientID,policyID,p.CMREligible
Into #Patient
From outcomesMTM.dbo.patientdim p With(NOLOCK)
Where 1=1
and Year(p.OutcomesEligibilityDate) =year(getdate())
and p.isCurrent=1
and OutcomesTermDate>=Getdate()


Create Clustered index IRX on #patient(PolicyID)
--Select count(*) from #Patient



/*MTM Center*/
Drop table if Exists #PatientCenter
Select distinct p.patientid, p.PolicyID
into #PatientCenter
From [dbo].[patientMTMCenterDim] pph With(Nolock)
join #Patient p With(Nolock) on pph.patientid=p.PatientID  and pph.activethru is nULL
Join pharmacy ph With(Nolock) on pph.centerID=ph.centerid
                  and ph.active=1
				  and ph.contracted=1
				  and ph.NCPDP_NABP not Like '99%'
				  


/*TIP Opportunities*/
Drop table If Exists #TIPOpporunities 
SELECT distinct tp.tipresultstatusid,tp.PolicyID
Into #TIPOpporunities
FROM [OutcomesMTM].[dbo].[vw_tipActivityCenterReport] tp With(Nolock)
--Join #Patient p on tp.patientid=p.PatientID
Where 1=1
and tp.[TIP Opportunities]=1
and Year(tp.activeasof)=Year(Getdate())



/*Active TIPS*/
Drop table If Exists #TIPActive
SELECT distinct tp.tipresultstatusid,tp.PolicyID
Into #TIPActive
FROM [OutcomesMTM].[dbo].[vw_tipActivityCenterReport] tp With(Nolock)
--Join #Patient p on tp.patientid=p.PatientID
Where 1=1
and tp.[currently active]=1
and Year(tp.activeasof)=Year(Getdate())



/*TIPS With GPI*/
Drop table if exists #TipWithGPI
Select distinct tr.TIPresultid,p.PatientID,p.PolicyID
Into #TipWithGPI
from [AOCWPAPSQL02].[Outcomes].[dbo].[TIPResult] tr With(Nolock)
Join #Patient p With(Nolock) on p.PatientID=tr.patientid 
                                   and tr.GPI IS NOT NULL 
								   and tr.active=1
           
Create clustered Index IDXGP on #TipWithGPI(PatientID,PolicyID)





/*TIPS WithDrawn*/
Drop table If Exists #TIPWithDrawnX
SELECT 
Distinct  tp.tipresultstatusid,tp.PolicyID,tp.withdrawn,tp.activeasof,tp.activethru
--,tp.policyid
Into #TIPWithDrawnX
FROM [OutcomesMTM].[dbo].[vw_tipActivityCenterReport] tp With(Nolock)
Where 1=1
--and tp.withdrawn=1
and Year(tp.activeasof)=Year(Getdate())


Drop table If Exists #TIPWithDrawn
Select 
Sum(withdrawn1) as [WithDrawn]
,PolicyID
Into #TIPWithDrawn
From 
(
Select 
Row_Number()Over(partition by tipresultstatusid Order by withdrawn) as Ranker
,PolicyID
,Case when activethru>Getdate() then 0 else withdrawn END AS withdrawn1
from #TIPWithDrawnX with(nolock)
)T
Where 1=1
and Ranker =1
Group by PolicyID



/*TIPS Expired*/
Drop table If Exists #TIPExpired
SELECT  Distinct  tp.tipresultstatusid,tp.PolicyID
Into #TIPExpired
FROM [OutcomesMTM].[dbo].[vw_tipActivityCenterReport] tp with(nolock)
--Join #Patient p on tp.patientid=p.PatientID
Where 1=1
and tp.expired=1
and Year(tp.activeasof)=Year(Getdate())




/*OPTEDOUT CODES*/
Drop table If Exists #PatientOptout
Select Distinct pt.PatientID,ISNULL(pot.patientOptOutTermReasonID,0) as PatientOptoutCode,pt.PolicyID
Into #PatientOptout
From Patientdim pt With(Nolock)
join [AOCWPAPSQL02].Outcomes.dbo.patientOptOut pot With(Nolock) on pt.PatientID=pot.PatientID
and Year(pot.createDT)=year(Getdate())
and pt.isCurrent=1


--Select * from #PatientOptout po
--Where po.PolicyID=829

Drop Table If exists #ALLPatientOptOut
Select Distinct
pp.policyID
,PR1.[Count of 01 Optout patients]
,PR2.[Count of 02 Optout patients] 
,PR3.[Count of 03 Optout patients]
,PR4.[Count of 99 Optout patients]
Into #ALLPatientOptOut
From Policy pp
Left Join (
      Select po.PolicyID,Count(*) as [Count of 01 Optout patients]
      From #PatientOptout po
      Where 1=1
      and po.PatientOptoutCode=1
	  Group by po.PolicyID
)PR1 on PR1.PolicyID=pp.policyID
Left Join (
      Select po.PolicyID,Count(*) as [Count of 02 Optout patients]
      From #PatientOptout po
      Where 1=1
      and po.PatientOptoutCode=2
	  Group by po.PolicyID
)PR2 on PR2.PolicyID=pp.policyID
Left Join (
      Select po.PolicyID,Count(*) as [Count of 03 Optout patients]
      From #PatientOptout po
      Where 1=1
      and po.PatientOptoutCode=3
	  Group by po.PolicyID
)PR3 on PR3.PolicyID=pp.policyID
Left Join (
      Select po.PolicyID,Count(*) as [Count of 99 Optout patients]
      From #PatientOptout po
      Where 1=1
      and po.PatientOptoutCode=99
	  Group by po.PolicyID
)PR4 on PR4.PolicyID=pp.policyID
Where 1=1

Group by 
pp.policyID
,PR1.[Count of 01 Optout patients]
,PR2.[Count of 02 Optout patients] 
,PR3.[Count of 03 Optout patients]
,PR4.[Count of 99 Optout patients]






/*Pre Final Query*/
Drop table IF exists #PreFinal
Select 
cl.clientID
,Cl.clientName
,po.policyID
,po.policyName
,T1.[Count Of Active patients]
,T2.[Count Of Active patients At MTM Centers] 
,T3.[Count Of TIP Opportunities YTD]
,T4.[Count Of Active TIPS]
,T5.[Count Of WithDrawn TIPS]
,T6.[Count Of Expired TIPS]
,TG1.[Count OF Active TIPS With GPI]
,TA.[Count of 01 Optout patients]
,TA.[Count of 02 Optout patients]
,TA.[Count of 03 Optout patients]
,TA.[Count of 99 Optout patients]
INTO #PreFinal
From Policy po with(nolock)
Join Contract ct with(nolock) on po.contractID=ct.contractID and po.policyID Not IN(10,20) --and po.policyID In(581,829,378,737,498)
Join Client cl with(nolock) on cl.clientID=ct.clientID
Left Join 
(
    Select Count(*) as [Count Of Active patients],p.PolicyID
    From #Patient p with(nolock)
    Group by p.PolicyID
)T1 On T1.PolicyID=po.policyID
Left Join 
(
    Select Count(*) as [Count Of Active patients At MTM Centers],p.PolicyID
    From #PatientCenter p with(nolock)
    Group by p.PolicyID
)T2 On T2.PolicyID=po.policyID
Left Join 
(
    Select Count(*) as [Count Of TIP Opportunities YTD],p.PolicyID
    From #TIPOpporunities p with(nolock)
    Group by p.PolicyID
)T3 On T3.PolicyID=po.policyID
Left Join 
(
    Select Count(*) as [Count Of Active TIPS],p.PolicyID
    From #TIPActive p with(nolock)
    Group by p.PolicyID
)T4 On T4.PolicyID=po.policyID
Left Join 
(
    Select p.WithDrawn as [Count Of WithDrawn TIPS],p.PolicyID
    From #TIPWithDrawn p with(nolock)
    Group by p.PolicyID,p.WithDrawn
)T5 On T5.PolicyID=po.policyID
Left Join 
(
    Select Count(*) as [Count Of Expired TIPS],p.PolicyID
    From #TIPExpired p with(nolock)
    Group by p.PolicyID
)T6 On T6.PolicyID=po.policyID
Left Join #ALLPatientOptOut TA with(nolock) on TA.PolicyID=po.policyID
Left Join(
    Select Count(*) as [Count OF Active TIPS With GPI],TG.policyid 
    from #TipWithGPI TG with(nolock)
    Where 1=1
    Group by TG.policyid
)TG1 on TG1.policyid=po.policyID



/*Final Query*/
Drop table IF exists #Final
Select T.*
,Cast(ISNULL(T.[Count Of TIP Opportunities YTD],0)/NULLIF(ISnULL(T.[Count Of Active TIPS],0),0) as Decimal(18,3)) As [TIP Opportunites Per Active patients]
INto #Final
From #PreFinal T with(nolock)
Where 1=1


--Select * From #Final
/*Insert Into Actual table*/

Insert Into OutcomesMTM.reporting.Patient_TIPTrending_PriorDay
(
    [PolicyID] 
	,[ClientID] 
	,[PolicyName] 
	,[ClientName] 
	,[Count Of Active Patients] 
	,[Count Of Active patients At MTM Centers] 
	,[Count Of TIP Opportunities YTD]
	,[Count Of Active TIPS] 
	,[Count Of WithDrawn TIPS] 
	,[Count Of Expired TIPS] 
	,[Count OF Active TIPS With GPI] 
	,[Count of 01 Optout patients] 
	,[Count of 02 Optout patients] 
	,[Count of 03 Optout patients] 
	,[Count of 99 Optout patients]
	,[TIP Opportunites Per Active patients] 
)
Select 
[PolicyID]
      ,[ClientID]
      ,left([PolicyName],50)
      ,Left([ClientName],50)
      ,ISNULL([Count Of Active Patients],0)                As [Count Of Active Patients]
      ,ISNULL([Count Of Active patients At MTM Centers],0) As [Count Of Active patients At MTM Centers]
      ,ISNULL([Count Of TIP Opportunities YTD],0)          As [Count Of TIP Opportunities YTD]
      ,ISNULL([Count Of Active TIPS],0)                    As [Count Of Active TIPS]
      ,ISNULL([Count Of WithDrawn TIPS],0)                 As [Count Of WithDrawn TIPS]
      ,ISNULL([Count Of Expired TIPS],0)                   As [Count Of Expired TIPS]
      ,ISNULL([Count OF Active TIPS With GPI],0)           As [Count OF Active TIPS With GPI]
      ,ISNULL([Count of 01 Optout patients],0)             As [Count of 01 Optout patients] 
      ,ISNULL([Count of 02 Optout patients],0)             As [Count of 02 Optout patients]
      ,ISNULL([Count of 03 Optout patients],0)             As [Count of 03 Optout patients]
      ,ISNULL([Count of 99 Optout patients],0)             As [Count of 99 Optout patients]
      ,ISNULL([TIP Opportunites Per Active patients],0) As [TIP Opportunites Per Active patients]
	  From #Final
	 
	

END

--Exec [dbo].[I_Patient_And_TIP_Trending_Report]
--sp_help 'reporting.Patient_TIPTrending_PriorDay'

