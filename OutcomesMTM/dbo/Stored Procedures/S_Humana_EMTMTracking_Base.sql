



CREATE proc [dbo].[S_Humana_EMTMTracking_Base]
as 
begin 




DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)

SET @BEGIN = (case when convert(varchar,getdate()+307,112)=convert(varchar,dateadd(yy,datediff(yy,0,getdate()),0),112)
then convert(varchar,dateadd(yy,-1,dateadd(yy,datediff(yy,0,getdate()),0)),112)
else convert(varchar,dateadd(d,datediff(d,0,DATEADD(DD,-datepart(DY,getdate())+1,getdate())),0) ,112)end)
SET @END = '20180331'--cast(getdate() as date)	 	

Select distinct ph.NCPDP_NABP
	, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [Pharmacy Name]
	, ph.addressState as [Pharmacy State]
	, pr.Relationship_ID
	, pr.Relationship_ID_Name
	, isnull(n.TipOpportunities,0) as [TIP Opportunities]
	, isnull (com.TipCompleted,0) as [Completed TIPs]
	, ccc.[Successful TIPs]
	, isnull(cast((cast((ccc.[Successful TIPs]) as decimal)/nullif(cast((n.TipOpportunities) as decimal), 0)) as decimal (5,2)), 0)
		 as [Tip NetEffectiveRate]
	, bp.[Base Payment] AS [Base Payment Old]
	, CCC.[Base Payment1] as [Base Payment New]
	, vp.[Validation Payment]

		from outcomesMTM.dbo.pharmacy ph
			join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
				left join (
				select row_number() over (partition by ph.centerID order by case when pr.Relationship_type = '02' then '99' 
				else pr.Relationship_type end asc) as [Rank]
				, ph.centerid
				, pr.Relationship_Type
				, pr.Relationship_ID
				, pr.Relationship_ID_Name
				, pr.parent_organization_ID
				, pr.parent_organization_Name
			from outcomesmtm.dbo.providerRelationshipView pr
			join outcomesmtm.dbo.pharmacy ph on ph.NCPDP_NABP = pr.mtmCenterNumber
			where 1=1
			and pr.Relationship_Type in ('01', '05', '02')
		) pr on pr.centerid = ph.centerid and pr.[Rank] = 1

-----------------**[BASE PAYMENT]**
		Left join (
			Select cl.centerID, Sum (cl.Charges) as [Base Payment]
				From [AOCWPAPSQL02].[Outcomes].[dbo].[claim] cl
				Where cl.mtmserviceDT Between @BEGIN and @END
						and cl.policyid  in (735,736,737,738)
						and cl.isTipClaim = 1
						and cl.statusid in (2,4,5,6)
			Group by cl.CenterID
		) bp on bp.centerID = PH.centerid

-----------------**[Validation Payment]**
		Left join (
			Select cl.centerID, Sum (Cvp.Payment) as [Validation Payment]
				From [AOCWPAPSQL02].[Outcomes].[dbo].[claimValidation] cv
					Join [AOCWPAPSQL02].[Outcomes].[dbo].[claimValidationPayment] cvp on  cvp.claimValidationID = cv.claimValidationID
					Join claim cl on cl.claimID = cv.claimid
						Where cl.mtmserviceDT Between @BEGIN and @END
						and cl.policyid  in (735,736,737,738)
						and cl.statusID in (2,4,5,6)
						and cl.isTipClaim = 1
				Group by cl.CenterID
			) vp on vp.centerID = ph.centerid

-----------------**[Base Payment1]**
		Left join (
			Select  c.centerID, Count(Distinct C.claimid) AS [Successful TIPs], Sum(c.Charges) as [Base Payment1]
				from dbo.Claim c--
					Join AOCWPAPSQL02.Outcomes.dbo.patient pt on pt.patientid = c.patientid
					Join pharmacychain pc on pc.centerid = c.centerid
					join chain ch on ch.chainid = pc.chainid
						Where 1=1
						and mtmServiceDT between @BEGIN and @END
						and c.policyID in (735,736,737,738)
						and ch.chaincode in ('226','A10','A13','229','C11')--'181','045','056'(Relationship Id are removed)
						and c.statusid in (6)
						and c.isTipClaim = 1
						and c.resultTypeID not in (12,18,13,16)
						--and pt.OutcomesTermDate > Getdate()
					Group by c.centerid 
			) ccc on ccc.centerid = ph.centerid

--TIP OPPORTUNITIES
		Left Join 
		(
			Select n.centerid, count(n.[TIP Opportunities]) as TipOpportunities from
			(Select tacr.centerid, tacr.[TIP Opportunities]
				From outcomesMTM.dbo.tipActivityCenterReport tacr
					Where 1=1
						and tacr.activeasof between @BEGIN and @END
						and tacr.policyid in (735,736,737,738)
						and tacr.[TIP Opportunities] = 1) n
				where 1=1
			Group by n.centerid ) n on n.centerid= ph.centerid

--COMPLETED TIPS
		Left Join 
		(
			Select com.centerid, count(com.[Completed TIPs]) as TipCompleted from
			(Select tacr.centerid, tacr.[Completed TIPs]
				From outcomesMTM.dbo.tipActivityCenterReport tacr
					Where 1=1
						and tacr.activeasof between @BEGIN and @END
						and tacr.policyid in (735,736,737,738)
						and tacr.[Completed TIPs] = 1) com
						--and c.resultTypeID not in (12,18,13,16)
				where 1=1
			Group by com.centerid 
		) com on com.centerid= ph.centerid



where 1=1
and np.Active = 1
and Relationship_ID in ('226', 'A10', 'A13', '229', 'C11')
order by ph.NCPDP_NABP
 

 end


