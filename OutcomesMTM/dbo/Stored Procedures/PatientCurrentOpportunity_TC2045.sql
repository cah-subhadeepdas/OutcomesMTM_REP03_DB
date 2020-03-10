
CREATE Procedure  [dbo].[PatientCurrentOpportunity_TC2045] 

AS

  BEGIN 

	 SELECT
	          po.policyname                 AS [Policy Name]
             , po.policyid                  AS [Policy ID]
             , p.patientid_all              AS [Member ID]
             , p.first_name                 AS [Member First Name]
             , p.last_name                  AS [Member Last Name]
             , Cast(p.dob AS DATE)          AS [DOB]
             , Isnull(mpc.tipcnt, 0)        AS [Current TIP Opportunities]
             , p.cmreligible                AS [CMR Eligible]
             , Isnull(cmr.needscmr, 'N')    AS [Currently Targeted for a CMR]
			 , ph.NCPDP_NABP                AS [Primary MTM Center ID]
			 , ph.centername				AS [Primary MTM Center Name]
             , Cast(c.mtmservicedt AS DATE) AS [Last CMR - Date]
             , c.resultdesc                 AS [Last CMR - Result Name]
             , c.ncpdp_nabp                 AS [Last CMR - NCPDP]
             , c.centername                 AS [Last CMR - Pharmacy Name]
			 , cl.clientID                  AS [Client ID]
 			 , cl.clientName                AS [Client Name] 
			 , ch.chaincode                 AS [Chain Code]
			 , ch.chainNM                   AS [Chain Name]
     FROM   dbo.patient p
             JOIN dbo.policy po
               ON po.policyid = p.policyid
			 left join client cl
			   ON p.ClientID = cl.clientID
             LEFT JOIN maintenance.dbo.vw_needscmr cmr
               ON p.patientid = cmr.patientid
             LEFT JOIN maintenance.dbo.patientcurrenttipcount mpc
               ON mpc.patientid = p.patientid
			 LEFT JOIN dbo.patientPrimaryPharmacy ppp
			   ON p.PatientID = ppp.patientid
			 LEFT JOIN dbo.pharmacy ph 
			   on ppp.centerid = ph.centerid
			 LEFT JOIN dbo.centerChain cc
			   ON ppp.centerid = cc.CenterID
             LEFT JOIN Chain ch
			   on cc.chainID = ch.chainid 
             LEFT JOIN(SELECT c.patientid
                              , rt.resultdesc
                              , c.mtmservicedt
                              , ph.ncpdp_nabp
                              , ph.centername
                              , Row_number()
                                  OVER (
                                    partition BY c.patientid
                                    ORDER BY c.mtmservicedt DESC) AS ranker
                       FROM   outcomes.dbo.patient p
                              JOIN outcomes.dbo.claim c
                                ON c.patientid = p.patientid
                              JOIN outcomes.dbo.resulttype rt
                                ON rt.resulttypeid = c.resulttypeid
                              JOIN outcomes.dbo.pharmacy ph
                                ON ph.centerid = c.centerid
                       WHERE  1 = 1
                              AND c.statusid IN ( 2, 6 )
                              AND c.actiontypeid = 1
                              AND c.reasontypeid = 11
                              AND p.outcomestermdate >= Getdate()
                             ) AS c
                    ON c.patientid = p.patientid
                       AND c.ranker = 1
      WHERE  1 = 1
             AND p.outcomestermdate >= Getdate()
      order by chainNM, cl.clientID 

END
