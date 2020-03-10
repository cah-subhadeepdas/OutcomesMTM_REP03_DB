


CREATE VIEW [dbo].[vw_DrugDiscountMart_PharmacistLevel]
AS

 

 select u.userID
 , c.firstNM as [First_Name]
 , c.lastNM as [Last_Name]
 , ph.NCPDP_NABP
 , ph.centername as [Pharmacy]
 , ta.[Total TIP Opportunities]
 , cm.[Total CMR Opportunity]
 from OutcomesMTM.staging.users u
 join OutcomesMTM.staging.userCenter uc on uc.userID = u.userID
 join OutcomesMTM.staging.contact c on c.userID = u.userID
 join OutcomesMTM.staging.role r on r.userID = u.userID
 join OutcomesMTM.staging.roleType rt on rt.roleTypeID = r.roleTypeID
 join OutcomesMTM.dbo.pharmacy ph on ph.centerid = uc.centerID
 join OutcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
 join OutcomesMTM.dbo.chain ch on ch.chainid = pc.chainid
 left join (

    select tc.centerid
    , sum(tc.[TIP Opportunities]) as [Total TIP Opportunities]
    from (
        select row_number() over (partition by tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
        , tacr.centerid
        , tacr.[TIP Opportunities]
        from outcomesMTM.dbo.tipActivityCenterReport tacr
        where 1=1
        and ((year(cast(tacr.activeasof as date)) = year(getdate())) 
              or 
              (year(cast(tacr.activethru as date)) = year(getdate())))
    ) tc
    where 1=1
    and tc.[Rank] = 1
    group by tc.centerid

) ta on ta.centerid = ph.centerid
left join (

    select cr.centerid
    , count(distinct cr.PatientID) as [Total CMR Opportunity]
    from (
        select row_number() over (partition by rp.patientID, rp.centerID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
        , rp.centerid
        , rp.PatientID
        from outcomesMTM.dbo.vw_CMRActivityReport rp
        join outcomesMTM.dbo.patientDim pt on pt.patientKey = rp.patientKey
        join outcomesMTM.dbo.Policy po on po.policyID = rp.PolicyID
        left join outcomesMTM.dbo.pharmacy ph on ph.centerid = rp.centerid
        left join outcomesMTM.dbo.Chain ch on ch.chainid = rp.chainid
        where 1=1
        and ((year(cast(rp.activeasof as date)) = year(getdate()))
            or
            (year(cast(rp.activethru as date)) = year(getdate())))
    ) cr
    where 1=1
    and cr.[rank] = 1
    group by cr.centerid

) cm on cm.centerid = ph.centerid
 where 1=1
 and ch.chaincode = '044'
 and u.active = 1
 and uc.active = 1
 and r.active = 1
 and rt.active = 1
 and rt.roleTypeID = 1

