
CREATE proc [dbo].[S_ReportCard_Pharmacy_Walgreens] (@PolicyID int, @State VARCHAR(2))
as 
begin 

DECLARE @Start_date VARCHAR(10)
DECLARE @End_date VARCHAR(10)
-- Beginning of year (if current month is Jan. then beginning of last year)		
--case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '0101' else cast(year(getdate()) as varchar(4)) + '0101' end  **Old Logic ****


SET @Start_date = cast(year(getdate()) as varchar(4)) + '-01-01' --New logic (First day of current year) Changed by Santhosh TC-2611
-- Date of yesterday
SET @End_date = cast(getdate()-1 as date)

select	 cm.policyID
		,cm.policyName
		, ph.NCPDP_NABP
		, replace(replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),''), ',' , '') as [PharmacyName]
		, ph.addressState as [Pharmacy State]
		, pr.Relationship_ID_Name
		,isnull(cm.CMROpportunity ,0) as CMROpportunity
		,isnull(cm.completedCMRs ,0) as completedCMRs
		,isnull(cm.[CMRCompletionRate] ,0) as [CMRCompletionRate]
		,isnull(cm.[CMRs with Drug Therapy Problems Identified] ,0) as [CMRs with Drug Therapy Problems Identified]
		,isnull(cm.[CMRs with Drug Therapy Problems Identified Rate] ,0) as [CMRs with Drug Therapy Problems Identified Rate]
---------------------------
from	outcomesMTM.dbo.pharmacy ph
		join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
		join 
			(
				select	row_number() over (partition by ph.centerID 
											order by case when pr.Relationship_type = '02' then '99' else pr.Relationship_type end asc) as [Rank]
						, ph.centerid
						, pr.Relationship_ID_Name
				from	outcomesmtm.dbo.providerRelationshipView pr
						join outcomesmtm.dbo.pharmacy ph on ph.NCPDP_NABP = pr.mtmCenterNumber
				where	1=1
						and pr.Relationship_Type in ('01', '05', '02')
			) pr on pr.centerid = ph.centerid and pr.[Rank] = 1
		join 
			(
				select	u.policyID
						, u.policyName		
						, u.centerid	
						, count(distinct u.PatientID) as CMROpportunity
						, sum(u.CMRCompleted) as completedCMRs
						, isnull(cast(cast((cast(sum(u.CMRCompleted) as decimal)/nullif(cast(count(distinct u.PatientID) as decimal), 0)) as decimal (5,2)) * 100 as int), 0) as CMRCompletionRate
						, sum(u.CMRWithDrugProblems) as [CMRs with Drug Therapy Problems Identified]
						, isnull(cast(cast((cast(sum(u.CMRWithDrugProblems) as decimal)/nullif(cast(sum(u.CMRCompleted) as decimal), 0)) as decimal (5,2)) * 100 as int), 0) as [CMRs with Drug Therapy Problems Identified Rate]
				from 
					(
						select	row_number() over (partition by rp.patientID, rp.centerID 
													order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
								, p.policyID
								, p.policyName
								, rp.PatientID
								, rp.centerid
								, ph.centername
								, rp.primaryPharmacy
								, case when CAST(rp.mtmServiceDT as date) between @Start_date and @End_date AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') 
										THEN 1 ELSE 0 END as CMRCompleted
								, case when CAST(rp.mtmServiceDT as date) between @Start_date and @End_date AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') 
										THEN 1 ELSE 0 end as CMRWithDrugProblems

						from	vw_CMRActivityReport rp
								join patientDim pd on pd.patientKey = rp.patientKey
								join policy p on p.policyID = rp.policyID
								join pharmacy ph on ph.centerID = rp.centerID
								left join chain c on c.chainID = rp.chainID
						where	1=1
								AND isNull(rp.activethru, '9999-12-31') >= @Start_date
								AND CAST(rp.activeasof as date)<= @End_date
								AND rp.primaryPharmacy = 1 
									--30 day include
									AND (
											(rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN CAST(rp.activeasof as date)> @Start_date THEN CAST(rp.activeasof as date) ELSE @Start_date END, @End_date) >= 30)
											OR
											(rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN CAST(rp.activeasof as date)> @Start_date THEN CAST(rp.activeasof as date) ELSE @Start_date END, CASE WHEN CAST(rp.activethru as date)> @End_date THEN @End_date ELSE CAST(rp.activethru as date)END) >= 30)
											OR
											(CAST(rp.mtmServiceDT as date) BETWEEN @Start_date AND @End_date AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
											AND
											(rp.claimcenterID = rp.centerid)
										)
								AND c.chainid in (46, 389, 390)
								AND p.policyID in (@PolicyID)
								AND ph.AddressState in (@State)

					) u
				where	1 = 1
						and u.rank = 1
				group by u.policyID, u.policyName, u.centerID						
			) cm on cm.centerid = ph.centerID
where	1=1
		and np.Active = 1
end








