
CREATE PROCEDURE [dbo].[S_clientMtmOpportunitiesReport]
AS
BEGIN 
SET NOCOUNT ON;
SET xact_abort ON;

DECLARE @today DATE = getDate()
DECLARE @todays_LessSixMonths DATETIME = dateadd(MONTH,-6,getdate())

--CREATE TABLE #Temp_UC
SELECT 
    t.centerid 
   ,SUM([TrainedRPhs]) AS [TrainedRPhs]
   ,SUM([TrainedTechs]) AS [TrainedTechs] 
INTO #Temp_UC
FROM (SELECT 
            uc.centerid
		   ,CASE 
               WHEN r.roletypeID = 1 
                  THEN 1 
               ELSE 0 
            END AS [TrainedRPhs] 
		   ,CASE 
               WHEN r.roletypeID = 4 
                  THEN 1 
               ELSE 0 
            END AS [TrainedTechs] 
		FROM staging.usercenter uc WITH (NOLOCK) 
		   JOIN staging.users u WITH (NOLOCK) 
            ON u.userid = uc.userid 
		   JOIN staging.role r WITH (NOLOCK) 
            ON r.userid = uc.userid 
		WHERE 1=1 
		   AND uc.approved = 1 
		   AND uc.active = 1
		   AND u.completedtraining = 1
		   AND r.roletypeid in (1,4) 
      ) t
GROUP BY 
      t.centerid 

--CREATE TABLE #Temp_RX
SELECT 
    t.centerid 
   ,t.policyid 
   ,SUM(totalpatients) AS totalpatients 
   ,SUM(totalprimarypatients) AS totalprimarypatients
INTO #Temp_RX
FROM (SELECT 
          rx.centerid 
		   ,rx.policyid
         ,1 AS totalpatients
         ,CASE 
             WHEN isnull(pph.primarypharmacy,0) = 1 
                THEN 1 
             ELSE 0 
          END AS totalprimarypatients 
		FROM (SELECT 
                p.centerid
               ,pt.patientid
               ,pt.policyid 
            FROM patientMTMCenterDim p WITH (NOLOCK) 
               JOIN patientDim pt WITH (NOLOCK) 
                  ON pt.patientid = p.patientid 
               --KJS 20160928 
               --Add Historical "Active" Indicators
                 AND @today >= pt.activeAsOf
                 AND @today < isnull(pt.activeThru,'99991231')
               JOIN pharmacy ph WITH (NOLOCK) 
                  ON ph.centerid = p.centerid 
               LEFT JOIN staging.states s WITH (NOLOCK) 
                  ON s.stateabbr = ph.addressstate
            WHERE p.activethru is null
              AND ph.active = 1
            GROUP BY p.centerid, pt.patientid, pt.policyid 
		      ) rx 
         LEFT JOIN staging.patientPrimaryPharmacy pph WITH (NOLOCK)  
            ON pph.patientid = rx.patientid 
            AND pph.centerid = rx.centerid 
      ) T
GROUP BY 
    t.centerid
   ,t.policyid  

--CREATE TABLE #Temp_CMR
SELECT
    t.centerid 
   ,t.policyid 
   ,SUM(t.[TotalCMRs]) AS [TotalCMRs]
   ,SUM(t.[PotentialCMRRevenue]) AS [PotentialCMRRevenue]
   ,SUM(t.[TotalPrimaryCMRs]) AS [TotalPrimaryCMRs]
   ,SUM(t.[PotentialCMRRevenuePrimary]) AS [PotentialCMRRevenuePrimary]
INTO #Temp_CMR
FROM (SELECT 
          ptmc.centerid 
         ,ps.policyid 
         ,1 AS [TotalCMRs]
         ,CASE 
             WHEN isnull(pph.primarypharmacy,0) = 1 
                THEN 1 
             ELSE 0 
          END AS [TotalPrimaryCMRs]
         ,ps.payment AS [PotentialCMRRevenue]
         ,CASE
             WHEN isnull(pph.primarypharmacy,0) = 1 
                THEN ps.payment 
             ELSE 0 
          END AS [PotentialCMRRevenuePrimary]
      FROM patientMTMCenterDim ptmc WITH (NOLOCK) 
         JOIN patientDim pt WITH (NOLOCK)  
            ON pt.patientid = ptmc.patientid 
         --KJS 20160928 
         --Add Historical "Active" Indicators
           AND @today >= ptmc.activeAsOf
           AND @today < isnull(ptmc.activeThru,'99991231')
           AND @today >= pt.activeAsOf
           AND @today < isnull(pt.activeThru,'99991231')
         JOIN (SELECT 
                   t.policyid 
                  ,t.reasontypeid 
                  ,t.actiontypeid 
                  ,max(t.serviceFee) AS payment 
					FROM (SELECT 
                         rank() over (partition by pr.policyid, r.reasontypeid, r.actiontypeid, r.resulttypeid
                                      order by pr.activeAsOf desc, newid()) AS [rank]    
                        ,pr.policyid
                        ,r.reasontypeid 
                        ,r.actiontypeid 
                        ,pr.serviceFee
                     FROM staging.RAR r WITH (NOLOCK)
                        JOIN staging.resulttype rt WITH (NOLOCK) 
                           ON rt.resulttypeid = r.resulttypeid 
                          AND rt.successful = 1
                     JOIN staging.policyRAR pr WITH (NOLOCK) 
                        ON r.rarID = pr.rarID
                       AND @today >= pr.activeAsOf
                       AND @today < isnull(pr.activeThru,'99991231')
							WHERE 1=1 
                    ) T 
               WHERE t.[rank] = 1
               GROUP BY 
                  t.policyid 
                 ,t.reasontypeid 
                 ,t.actiontypeid 
              ) ps 
            ON ps.policyid = pt.policyid 
           AND ps.reasontypeid = 11 
           AND ps.actiontypeid = 1
         LEFT JOIN staging.patientCMR cmr 
            ON cmr.patientid = pt.patientid
         LEFT JOIN staging.patientprimarypharmacy pph WITH (NOLOCK) 
            ON pph.patientid = ptmc.patientid 
           AND pph.centerid = ptmc.centerid 
           AND isnull(pt.CMReligible,0) = 1
           AND isnull(cmr.CMRcompleted,0) = 0 
     ) T
WHERE 1=1 
GROUP BY 
    t.centerid
   ,t.policyid  

--CREATE TABLE #Temp_Sched
SELECT 
    cm.centerid
   ,pt.policyid
   ,count(*) AS [CMRsscheduled]
INTO #Temp_Sched
FROM staging.cmrQueue cm WITH (NOLOCK) 
   JOIN patientDim pt 
      ON pt.patientid = cm.patientid 
   --KJS 20160928 
   --Add Historical "Active" Indicators
     AND @today >= pt.activeAsOf
     AND @today < isnull(pt.activeThru,'99991231')
WHERE cm.queueTypeID = 2
  AND cm.scheduleDate >= cast(getdate() as date) 
GROUP BY 
    cm.centerid
   ,pt.policyid 

--CREATE TABLE #Temp_Tip
SELECT
    t.centerid 
   ,t.policyid 
   ,SUM(t.[TotalTIPs]) AS [TotalTIPs]
   ,SUM(t.[TotalPrimaryTIPs]) AS [TotalPrimaryTIPs]
   ,SUM(t.[PotentialTIPRevenue]) AS [PotentialTIPRevenue]
   ,SUM(t.[PotentialTIPRevenuePrimary]) AS [PotentialTIPRevenuePrimary]
INTO #Temp_Tip
FROM (SELECT
          trsc.centerid 
         ,pt.policyid 
         ,1 AS [TotalTIPs]
         ,CASE 
             WHEN isnull(pph.primarypharmacy,0) = 1 
                THEN 1 
             ELSE 0 
          END AS [TotalPrimaryTIPs]
         ,ps.payment AS [PotentialTIPRevenue]
         ,CASE 
             WHEN isnull(pph.primarypharmacy,0) = 1 
                THEN ps.payment 
             ELSE 0 
          END AS [PotentialTIPRevenuePrimary]
      FROM staging.tipresultstatus trs WITH (NOLOCK)
         JOIN staging.tipresultstatuscenter trsc WITH (NOLOCK) 
            ON trs.tipresultstatusid = trsc.tipresultstatusid
         JOIN TIPResultDim tr WITH (NOLOCK) 
            ON tr.tipresultid = trs.tipresultid 
         --KJS 20160928 
         --Add Historical "Active" Indicators
           AND @today >= tr.activeAsOf
           AND @today < isnull(tr.activeThru,'99991231')
         JOIN staging.tipdetail_tip td WITH (NOLOCK) 
            ON td.tipdetailid = tr.tipdetailid 
         JOIN patientDim pt WITH (NOLOCK) 
            ON pt.patientid = tr.patientid 
         --KJS 20160928 
         --Add Historical "Active" Indicators
           AND @today >= pt.activeAsOf
           AND @today < isnull(pt.activeThru,'99991231')
         JOIN (SELECT
                   t.policyid 
                  ,t.reasontypeid 
                  ,t.actiontypeid 
                  ,max(t.serviceFee) AS payment 
               FROM (SELECT 
                         rank() over (partition by pr.policyid, r.reasontypeid, r.actiontypeid, r.resulttypeid
                                      order by pr.activeAsOf desc, newid()) AS [rank]    
                        , pr.policyid
                        , r.reasontypeid 
                        , r.actiontypeid 
                        , pr.serviceFee
                     FROM staging.rar r WITH (NOLOCK)
                        JOIN staging.resulttype rt WITH (NOLOCK) 
                           ON rt.resulttypeid = r.resulttypeid 
                          AND rt.successful = 1
                     JOIN staging.policyRAR pr WITH (NOLOCK) 
                        ON r.rarID = pr.rarID
                       AND @today >= pr.activeAsOf
                       AND @today < isnull(pr.activeThru,'99991231')
                     WHERE 1=1 
                    ) T 
               WHERE 1=1 
                 AND t.[rank] = 1
               GROUP BY 
                   t.policyid 
                  ,t.reasontypeid 
                  , t.actiontypeid 
              ) ps 
            ON ps.policyid = pt.policyid 
           AND ps.reasontypeid = td.reasontypeid 
           AND ps.actiontypeid = td.actiontypeid 
         LEFT JOIN staging.patientPrimaryPharmacy pph WITH (NOLOCK) 
            ON pph.patientid = pt.patientid 
           AND pph.centerid = trsc.centerid 
      WHERE 1=1 
        AND trs.active = 1
        AND trsc.active = 1
        AND trs.tipstatusid = 1
     ) t
GROUP BY 
    t.centerid
   ,t.policyid

--CREATE TABLE #Temp_Claim
SELECT 
    t.centerid 
   ,t.policyid 
   ,SUM([unfinished]) AS [unfinished]
   ,SUM([reviewsubmit]) AS [reviewsubmit]
INTO #Temp_Claim
FROM (SELECT 
          c.centerid
         ,c.policyid 
         ,CASE 
             WHEN c.statusid = 1 
                THEN 1 
             ELSE 0 
          END AS [unfinished] 
         ,CASE 
             WHEN c.statusID = 4 
                THEN 1 
             ELSE 0 
           END AS [reviewsubmit] 
      FROM claim c 
      WHERE 1=1 
        AND c.statusid in (1,4)
     ) T 
WHERE 1=1 
GROUP BY 
    t.centerid
   ,t.policyid  

--CREATE TABLE #Temp_Claim6m
SELECT
    c.centerid
   ,count(*) AS [6MonthClaimHistory]
INTO #Temp_Claim6m
FROM claim c 
   JOIN patientDim pt 
      ON pt.patientid = c.patientid 
   --KJS 20160928 
   --Add Historical "Active" Indicators
     AND @today >= pt.activeAsOf
     AND @today < isnull(pt.activeThru,'99991231')
--   JOIN (SELECT 
--             claimID
--            ,max(CreateDT) as createDT
--         FROM claimStatus cs
--         WHERE statusid = 2
--         GROUP BY claimid) cs_group
--      ON cs_group.claimid = c.claimid
--WHERE cs_group.createDT >= @todays_LessSixMonths 
WHERE COALESCE(c.changeDate, c.submitDT) >= @todays_LessSixMonths 
GROUP BY c.centerid

--************************************
--***  BEGIN New #Temp_Ph Creation ***
--************************************
--20161005 -- KJS -- Added query back into #Temp_CneterQAZone_1 portion
----CREATE TABLE #Temp_Claim6m_QAZone
--SELECT
--    c.centerID
--   ,c.claimID
--   ,c.patientid
--   ,c.resultTypeID
--INTO #Temp_Claim6m_QAZone
--FROM claim c 
--   JOIN staging.status s 
--      ON c.statusID = s.statusID
--WHERE c.changeDate >= @todays_LessSixMonths
--  AND s.statusnm in ('pending approval', 'approved')

--CREATE TABLE #Temp_Policy -- 122,448,921
SELECT 
   p.policyID,
   patientID
INTO #Temp_PolicyByPatient
--SELECT count(*)
FROM ClientContractPolicyView p
   JOIN patientDim pt
      ON p.policyid = pt.policyid 
   --KJS 20161005 
   --Add Historical "Active" Indicators
      AND @today >= pt.activeAsOf
      AND @today < isnull(pt.activeThru,'99991231')
WHERE p.qa = 1 

--CREATE TABLE #Temp_CenterQAZone_1 
SELECT 
    c.centerID
   ,c.claimID
   ,SUM(CASE WHEN qt.qatype='denominator' THEN 1 ELSE 0 END) AS denominator
   ,SUM(CASE WHEN qt.qatype='numerator' THEN 1 ELSE 0 END) AS numerator 
INTO #Temp_CenterQAZone_1
FROM claim c 
   JOIN claimstatus cs
      ON c.claimID = cs.claimID
   JOIN staging.status s 
      ON c.statusID = s.statusID
   --JOIN #Temp_UC uc
   --   ON uc.centerID = c.centerIDD = e.centerID
   JOIN #Temp_PolicyByPatient pt 
      ON pt.patientid = c.patientid 
   JOIN staging.QAResultType qa WITH (nolock) 
      ON qa.resulttypeid = c.resulttypeid 
   JOIN staging.qaType qt WITH (nolock) 
      ON qt.qatypeid = qa.QAtypeID						
GROUP BY c.centerID, c.claimid

--CREATE TABLE #Temp_CenterQAZone_2
;WITH [qazone] AS (
   SELECT 
       ph.centerid
      ,ISNULL(SUM(CAST(t.denominator AS INT)),0) AS finaltotalclaims
      ,ISNULL(SUM(CAST(t.numerator AS INT)),0) AS finaltpclaims
      ,CASE 
          WHEN ISNULL(SUM(CAST(t.denominator AS INT)),0) = 0 
             THEN 0 
          ELSE CONVERT(FLOAT,ISNULL(SUM(CAST(t.numerator AS INT)),0))/CONVERT(FLOAT,ISNULL(SUM(CAST(t.denominator AS INT)),0)) 
       END AS dtp
	FROM pharmacy ph WITH (nolock) 
	   LEFT JOIN #Temp_CenterQAZone_1 T 
         ON t.centerid = ph.centerid 
	WHERE 1=1 
	--AND ph.centerid = @centerid 
	AND ph.roledesc is not null 
	GROUP BY ph.centerid

)
SELECT 
    t.centerid 
   ,t.dtptype
   ,t.dtp
INTO #Temp_CenterQAZone_2
FROM (SELECT 
          ph1.centerid
         ,ph1.dtptype
         ,ph1.dtp    
      FROM (SELECT 
                ph.centerid
               , ph.finaltotalclaims
               , ph.finaltpclaims
               , ph.dtp
               , r.dtprangeid
               , r.claimstartnumber
               , r.claimendnumber
               , r.dtplow
               , r.dtphigh
               , r.dtptypeid 
               , t.DTPType
            FROM qazone ph 
               LEFT JOIN staging.DTPrange r 
                  ON ph.finaltotalclaims >= r.claimstartnumber 
                 AND ph.finaltotalclaims < r.claimendnumber
                 AND ph.dtp >= r.dtplow 
                 AND ph.dtp < r.dtphigh
					  AND r.active = 1 
               LEFT JOIN staging.DTPtype t 
                  ON r.DTPTypeID = t.DTPTypeID
           ) ph1
	   WHERE ph1.centerid is not null 
	     AND ph1.DTPType is not null 
        --AND NOT EXISTS (SELECT 1 
        	                -- FROM pharmacy.dbo.pharmacyaction ph WITH (nolock)
        	                -- WHERE 
                         --   AND ph.actiontypeid = 1
                         --   AND ph1.centerid = ph.centerid 
                         --) 	
     ) T
GROUP BY 
    t.centerid 
   ,t.dtptype
   ,t.dtp

--CREATE TABLE #Temp_Ph
SELECT 
    t.centerid 
   ,t.policyid 
   ,t.ncpdp_nabp  
   ,t.centername 
   ,t.roledesc 
   ,t.Address1
   ,t.AddressCity
   ,t.AddressState 
   ,t.stateID
   ,t.AddressPostalCode 
   ,t.PHONE 
   ,t.FAX 
   ,t.contracted 
   ,qa.dtptype AS [QA zone]
   ,cast(qa.dtp AS decimal(20,2)) * 100 AS [DTP %]
INTO #Temp_ph
FROM (   SELECT 
             ph.centerid 
            ,pc.policyid
            ,ph.ncpdp_nabp  
            ,ph.centername 
            ,ph.roledesc 
            ,ph.Address1
            ,ph.AddressCity
            ,ph.AddressState 
            ,s.stateID
            ,ph.AddressPostalCode 
            --, null AS county
            ,ph.PHONE 
            ,ph.FAX 
            ,ph.contracted 
         FROM pharmacy ph WITH (NOLOCK)
            JOIN staging.states s WITH (NOLOCK)
			   ON s.stateabbr = ph.AddressState
            CROSS JOIN policyConfig pc WITH (NOLOCK) 
         WHERE 1=1 
           AND pc.ConnectActive = 1
           AND @today >= pc.activeAsOf
           AND @today < isnull(pc.activeThru,'99991231')

      UNION ALL

         SELECT 
             ph.centerid 
            ,0 AS policyid 
            ,ph.ncpdp_nabp  
            ,ph.centername 
            ,ph.roledesc 
            ,ph.Address1
            ,ph.AddressCity
            ,ph.AddressState
            ,s.stateID 
            ,ph.AddressPostalCode 
            --, null AS county
            ,ph.PHONE 
            ,ph.FAX , ph.contracted 
         FROM pharmacy ph WITH (NOLOCK) 
            LEFT JOIN staging.states s WITH (NOLOCK) 
               ON s.stateabbr = ph.addressstate
         WHERE 1=1 
     ) t 
   JOIN #Temp_CenterQAZone_2 qa
      ON qa.centerid = t.centerid
--**********************************
--***  END New #Temp_Ph Creation ***
--**********************************

--************************************
--***  BEGIN Old #Temp_Ph Creation ***
--************************************
--CREATE TABLE #Temp_Ph
--SELECT 
--    t.centerid 
--   ,t.policyid 
--   ,t.ncpdp_nabp  
--   ,t.centername 
--   ,t.roledesc 
--   ,t.Address1
--   ,t.AddressCity
--   ,t.AddressState 
--   ,t.stateID
--   ,t.AddressPostalCode 
--   ,t.PHONE 
--   ,t.FAX 
--   ,t.contracted 
--   ,qa.dtptype AS [QA zone]
--   ,cast(qa.dtp AS decimal(20,2)) * 100 AS [DTP %]
--INTO #Temp_ph
--SELECT Count(*)
--FROM (   SELECT 
--             ph.centerid 
--            ,pc.policyid
--            ,ph.ncpdp_nabp  
--            ,ph.centername 
--            ,ph.roledesc 
--            ,ph.Address1
--            ,ph.AddressCity
--            ,ph.AddressState 
--            ,s.stateID
--            ,ph.AddressPostalCode 
--            --, null AS county
--            ,ph.PHONE 
--            ,ph.FAX 
--            ,ph.contracted 
--         FROM pharmacy ph WITH (NOLOCK) 
--            JOIN staging.states s WITH (NOLOCK)
--               ON s.stateabbr = ph.AddressState
--            CROSS APPLY policyConfig pc WITH (NOLOCK) 
--         WHERE 1=1 
--           AND pc.ConnectActive = 1
--           AND @today >= pc.activeAsOf
--           AND @today < isnull(pc.activeThru,'99991231')

--      UNION ALL

--         SELECT 
--             ph.centerid 
--            ,0 AS policyid 
--            ,ph.ncpdp_nabp  
--            ,ph.centername 
--            ,ph.roledesc 
--            ,ph.Address1
--            ,ph.AddressCity
--            ,ph.AddressState
--            ,s.stateID 
--            ,ph.AddressPostalCode 
--            --, null AS county
--            ,ph.PHONE 
--            ,ph.FAX , ph.contracted 
--         FROM pharmacy ph WITH (NOLOCK) 
--            LEFT JOIN staging.states s WITH (NOLOCK) 
--               ON s.stateabbr = ph.addressstate
--         WHERE 1=1 
--     ) t 
--   CROSS APPLY outcomesMTM.dbo.CenterQAZone (t.centerid) qa 
--**********************************
--***  END Old #Temp_Ph Creation ***
--**********************************

--RUN SELECT to get Return Results
SELECT
    t.centerid 
   ,t.policyid 
   ,t.[Trained RPhs]
   ,t.[Trained Techs]
   ,t.[TotalPatients]
   ,t.[TotalPrimaryPatients]
   ,t.[Total CMRs]
   ,t.[Potential CMR Revenue]
   ,t.[Total Primary CMRs]
   ,t.[Potential CMR Revenue Primary]
   ,t.[CMRs scheduled]
   ,t.[TotalTIPs]
   ,t.[TotalPrimaryTIPs]
   ,t.[PotentialTIPRevenue]
   ,t.[PotentialTIPRevenuePrimary]
   ,t.[Unfinished Claims]
   ,t.[Review/Resubmit]
   ,t.[QA zone]
   ,t.[DTP %]
   ,t.[6 Month Claim History]
   ,t.NABP
   ,t.[Pharmacy_Name] 
   ,t.[pharmacy_type] 
   ,t.[Address] 
   ,t.[City] 
   ,t.[State]
   ,t.stateID
   ,t.[ZipCode]
   ,t.PHONE
   ,t.FAX
   ,t.contracted
--SELECT Count(*) -- 23,860,868
FROM (SELECT 
         row_number() over (partition by ph.ncpdp_nabp, f.policyid 
                            order by f.[TotalPatients] desc, f.[TotalTIPs] desc, f.[6 Month Claim History] desc) AS [rank]
        ,f.centerid 
        ,f.policyid 
        ,f.[Trained RPhs]
        ,f.[Trained Techs]
        ,f.[TotalPatients]
        ,f.[TotalPrimaryPatients]
        ,f.[Total CMRs]
        ,f.[Potential CMR Revenue]
        ,f.[Total Primary CMRs]
        ,f.[Potential CMR Revenue Primary]
        ,f.[CMRs scheduled]
        ,f.[TotalTIPs]
        ,f.[TotalPrimaryTIPs]
        ,f.[PotentialTIPRevenue]
        ,f.[PotentialTIPRevenuePrimary]
        ,f.[Unfinished Claims]
        ,f.[Review/Resubmit]
        ,f.[QA zone]
        ,f.[DTP %]
        ,f.[6 Month Claim History]
        ,f.NABP
        ,f.[Pharmacy_Name] 
        ,f.[pharmacy_type] 
        ,f.[Address] 
        ,f.[City] 
        ,f.[State]
        ,f.stateID
        ,f.[ZipCode]
        ,f.PHONE
        ,f.FAX
        ,f.contracted 
      FROM (SELECT 
                k.centerid 
               ,k.policyid 
               ,k.[Trained RPhs]
               ,k.[Trained Techs]
               ,k.[TotalPatients]
               ,k.[TotalPrimaryPatients]
               ,k.[Total CMRs]
               ,k.[Potential CMR Revenue]
               ,k.[Total Primary CMRs]
               ,k.[Potential CMR Revenue Primary]
               ,k.[CMRs scheduled]
               ,k.[TotalTIPs]
               ,k.[TotalPrimaryTIPs]
               ,k.[PotentialTIPRevenue]
               ,k.[PotentialTIPRevenuePrimary]
               ,k.[Unfinished Claims]
               ,k.[Review/Resubmit]
               ,k.[QA zone]
               ,k.[DTP %]
               ,isnull(claim6m.[6MonthClaimHistory],0) AS [6 Month Claim History]
               ,k.NABP
               ,k.[Pharmacy_Name] 
               ,k.[pharmacy_type] 
               ,k.[Address] 
               ,k.[City] 
               ,k.[State]
               ,k.stateID
               ,k.[ZipCode]
               ,k.PHONE
               ,k.FAX
               ,k.contracted
            FROM (SELECT 
                      tph.centerid 
                     ,tph.policyid 
                     ,tph.ncpdp_nabp AS NABP 
                     ,tph.centername AS [Pharmacy_Name]
                     ,tph.roledesc AS [pharmacy_type]
                     ,tph.Address1 AS [Address]
                     ,tph.AddressCity AS [City]
                     ,tph.AddressState AS [State]
                     ,stateID
                     ,tph.AddressPostalCode AS [ZipCode]
                     --, tph.county AS county
                     ,tph.PHONE AS [phone] 
                     ,tph.FAX AS [fax] 
                     ,tph.contracted AS [Contracted]
							,tph.[QA zone]
							,tph.[DTP %]
							,isnull(uc.[TrainedRPhs],0) AS [Trained RPhs]
                     ,isnull(uc.[TrainedTechs],0) AS [Trained Techs]
                     ,isnull(rx.TotalPatients,0) AS [TotalPatients]
                     ,isnull(rx.TotalPrimaryPatients,0) AS [TotalPrimaryPatients]
                     ,isnull(cmr.[TotalCMRs],0) AS [Total CMRs]
                     ,isnull(cmr.[PotentialCMRRevenue],0) AS [Potential CMR Revenue]
                     ,isnull(cmr.[TotalPrimaryCMRs],0) AS [Total Primary CMRs]
                     ,isnull(cmr.[PotentialCMRRevenuePrimary],0) AS [Potential CMR Revenue Primary]
                     ,isnull(sched.[CMRsscheduled],0) AS [CMRs scheduled]
                     ,isnull(tip.[TotalTIPs],0) AS [TotalTIPs]
                     ,isnull(tip.[TotalPrimaryTIPs],0) AS [TotalPrimaryTIPs]
                     ,isnull(tip.[PotentialTIPRevenue],0) AS [PotentialTIPRevenue]
                     ,isnull(tip.[PotentialTIPRevenuePrimary],0) AS [PotentialTIPRevenuePrimary]
                     ,isnull([unfinished],0) AS [Unfinished Claims]
                     ,isnull([reviewsubmit],0) AS [Review/Resubmit]
                  FROM #Temp_ph tph 
                     LEFT JOIN #Temp_uc uc
                        ON uc.centerid = tph.centerid 
                     LEFT JOIN #Temp_rx rx
                        ON rx.centerid = tph.centerid AND rx.policyid = tph.policyid 
                     LEFT JOIN #Temp_CMR cmr
                        ON cmr.centerid = tph.centerid AND cmr.policyid = tph.policyid  
                     LEFT JOIN #Temp_sched sched
                        ON sched.centerid = tph.centerid AND sched.policyid = tph.policyid  
                     LEFT JOIN #Temp_tip tip
                        ON tip.centerid = tph.centerid AND tip.policyid = tph.policyid  
                     LEFT JOIN #Temp_claim claim
                        ON claim.centerid = tph.centerid 
                       AND claim.policyid = tph.policyid 
                 ) k
               LEFT JOIN #Temp_claim6m  claim6m
                  ON claim6m.centerid = k.centerid 

           ) f
         JOIN pharmacy ph WITH (NOLOCK) 
            ON ph.centerid = f.centerid
         LEFT JOIN staging.states s WITH (NOLOCK) 
            ON s.stateabbr = ph.addressstate
      WHERE 1=1 
        AND (   isnull(f.[TotalPatients],0) <> 0 
             OR isnull(f.[TotalPrimaryPatients],0) <> 0 
             OR isnull(f.[Total CMRs],0) <> 0 
             OR isnull(f.[Potential CMR Revenue],0) <> 0 
             OR isnull(f.[Total Primary CMRs],0) <> 0 
             OR isnull(f.[Potential CMR Revenue Primary],0) <> 0 
             OR isnull(f.[CMRs scheduled],0) <> 0 
             OR isnull(f.[TotalTIPs],0) <> 0 
             OR isnull(f.[TotalPrimaryTIPs],0) <> 0 
             OR isnull(f.[PotentialTIPRevenue],0) <> 0 
             OR isnull(f.[PotentialTIPRevenuePrimary],0) <> 0 
             OR isnull(f.[Unfinished Claims],0) <> 0 
             OR isnull(f.[Review/Resubmit],0) <> 0
             OR isnull(f.[NABP],'') <> ''
             OR isnull(f.[Pharmacy_Name],'') <> ''
             OR isnull(f.[pharmacy_type],'') <> ''
             OR isnull(f.[Address],'') <> ''
             OR isnull(f.[City],'') <> ''
             OR isnull(f.[State],'') <> ''
             OR isnull(f.[stateID],0) <> 0                   
             OR isnull(f.[ZipCode],'') <> ''         
             OR isnull(f.[phone],'') <> ''  
             OR isnull(f.[fax],'') <> ''
             OR isnull(f.[Contracted],'') <> ''                                                                        
             OR f.policyid = 0)
     ) t
WHERE 1=1 
  AND t.[rank] = 1

/*
DROP TABLE #Temp_uc
DROP TABLE #Temp_rx
DROP TABLE #Temp_CMR
DROP TABLE #Temp_sched
DROP TABLE #Temp_tip
DROP TABLE #Temp_claim
DROP TABLE #Temp_claim6m
DROP TABLE #Temp_Claim6m_QAZone
DROP TABLE #Temp_CenterQAZone
DROP TABLE #Temp_PolicyByPatient
DROP TABLE #Temp_CenterQAZone_1 
DROP TABLE #Temp_CenterQAZone_2
DROP TABLE #Temp_ph
*/

END