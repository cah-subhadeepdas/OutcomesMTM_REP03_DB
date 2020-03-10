
CREATE procedure [dbo].[S_ClaimActivityReport]
AS
begin
SET NOCOUNT ON;
SET XACT_ABORT ON;

   DECLARE @today DATE = getDate()

   SELECT 
       claimID
      ,statusid
      ,statusNM
      ,serviceTypeID
      ,serviceType
      ,mtmServiceDT
      ,patientID
      ,CMSContractNumber
      ,policyID
      ,policyName
      ,policyTypeID
      ,policyType
      ,clientID
      ,clientName
      ,paid
      ,reASonTypeID
      ,actiontypeID
      ,resultTypeID
      ,isTipClaim
      ,[MTM CenterID]
      ,chainid
      ,[Pharmacy Chain]
      ,AIM
      ,charges
      ,payable
      ,validated
      ,processed
      ,payment
      ,claimCount
      ,[TipClaim]
      ,[PharmacistClaim]
      ,[CMRClaims]
      ,[PatientEd/Monitoring]
      ,[PatientConsultation]
      ,[PrescriberConsultation]
      ,[SuccessfulPrescriberConsultation]
      ,[SuccessfulPatientConsultation]
      ,[PrescriberRefusal]
      ,[UnableToReachPrescriber]
      ,[PatientRefusal]
      ,[UnableToReachPatient]
      ,[PatientClaims]
   FROM (SELECT 
             row_number() over (partition by c.claimid order by newid()) AS claimRank
            ,c.claimID
	         ,c.statusid
	         ,cs.statusNM
	         ,ls.serviceTypeID
	         ,st.serviceType
	         ,c.mtmServiceDT
	         ,pt.patientID
	         ,pt.CMSContractNumber
	         ,po.policyID
	         ,po.policyName
	         ,p.policyTypeID
	         ,p.policyType
	         ,cl.clientID
	         ,cl.clientName
	         ,c.paid
	         ,rt.reASonTypeID
	         ,at.actiontypeID
	         ,rst.resultTypeID
	         ,c.isTipClaim
	         ,ph.NCPDP_NABP AS [MTM CenterID]
	         ,ch.chainid
	         ,ch.chainnm AS [Pharmacy Chain]
	         ,c.AIM
	         ,c.charges
	         ,cv.payable
	         ,cv.validated
	         ,cv.processed
	         ,cvp.payment
	         ,1 AS claimCount
	         ,CASE 
                WHEN c.isTipClaim = 1 
                 AND at.actionCode <> '200' 
                   THEN 1 
                ELSE 0 
             END AS [TipClaim]
	         ,CASE 
                WHEN c.isTipClaim = 0 
                 AND at.actionCode <> '200' 
                   THEN 1 
                ELSE 0 
             END AS [PharmacistClaim]
	         ,CASE 
                WHEN at.actioncode = '200' 
                   THEN 1 
                ELSE 0 
             END AS [CMRClaims]
	         ,CASE 
                WHEN at.actioncode = '210' 
                   THEN 1 
                ELSE 0 
             END AS [PatientEd/Monitoring]
	         ,CASE 
                WHEN at.actioncode in ('207','214','215','220')
                   THEN 1 
                ELSE 0 
             END AS [PatientConsultation]
	         ,CASE 
                WHEN at.actioncode = '205' 
                   THEN 1 
                ELSE 0 
             END AS [PrescriberConsultation]
	         ,CASE 
                WHEN at.actioncode = '205' 
                 AND rst.resultcode not in ('375','378') 
                   THEN 1 
                ELSE 0 
             END AS [SuccessfulPrescriberConsultation]
	         ,CASE 
                WHEN at.actioncode in ('200','207','210','214','215','220') 
                 AND rst.resultCode not in ('379','380') 
                   THEN 1 
                ELSE 0 
             END AS [SuccessfulPatientConsultation]
	         ,CASE 
                WHEN at.actioncode = '205' 
                 AND rst.resultcode = '375' 
                   THEN 1 
                ELSE 0 
             END AS [PrescriberRefusal]
	         ,CASE 
                WHEN at.actioncode = '205' 
                 AND rst.resultcode = '378' 
                   THEN 1 
                ELSE 0 
             END AS [UnableToReachPrescriber]
	         ,CASE 
                WHEN at.actioncode in ('200','207','210','214','215','220') 
                 AND rst.resultcode = '380' 
                   THEN 1 
                ELSE 0 
             END AS [PatientRefusal]
	         ,CASE 
                WHEN at.actioncode in ('200','207','210','214','215','220') 
                 AND rst.resultcode = '379' 
                   THEN 1 
                ELSE 0 
             END AS [UnableToReachPatient]
	         ,CASE 
                WHEN at.actioncode in ('200','207','210','214','215','220') 
                   THEN 1 
                ELSE 0 
             END AS [PatientClaims]
	      --SELECT c.claimID,st.servicetypeID,count(*)
	      FROM outcomesMTM.dbo.claim c WITH (NOLOCK)
	         JOIN outcomesMTM.staging.[Status] cs WITH (NOLOCK)
               ON cs.statusID = c.statusID
            JOIN outcomesMTM.dbo.pharmacy ph WITH (NOLOCK) 
               ON ph.centerID = c.CenterID
            JOIN outcomesMTM.dbo.patientDim pt WITH (NOLOCK) 
               ON pt.patientID = c.patientID
            --KJS 20160928 
            --Add Historical "Active" Indicators
              AND @today >= pt.activeAsOf
              AND @today < isnull(pt.activeThru,'99991231')
            JOIN outcomesMTM.dbo.policy po WITH (NOLOCK) 
               ON po.policyID = coalesce(c.policyID, pt.policyID)
            JOIN outcomesMTM.dbo.[contract] co WITH (NOLOCK) 
               ON co.contractID = po.contractID
            JOIN outcomesMTM.dbo.client cl WITH (NOLOCK) 
               ON cl.clientID = co.clientID
            JOIN outcomesMTM.Staging.reasontype rt WITH (NOLOCK) 
               ON rt.reasontypeid = c.reasontypeid
            JOIN outcomesMTM.Staging.actiontype at WITH (NOLOCK) 
               ON at.actiontypeid = c.actiontypeid
            JOIN outcomesMTM.Staging.resulttype rst WITH (NOLOCK)  
               ON rst.resulttypeid = c.resulttypeid
	                  ----------------------outer JOIN------------------------------
            LEFT JOIN outcomesMTM.dbo.pharmacychain pc WITH (NOLOCK) 
               ON pc.centerID = ph.centerID
            LEFT JOIN outcomesMTM.dbo.chain ch WITH (NOLOCK) 
               ON ch.chainID = pc.chainid
            LEFT JOIN outcomesMTM.staging.PolicyType p WITH (NOLOCK) 
               ON p.policyTypeID = po.policyTypeID
            LEFT JOIN outcomesMTM.staging.claimServiceType ls WITH (NOLOCK) 
               ON ls.claimID = c.claimID
              AND ls.active = 1
            LEFT JOIN outcomesMTM.Staging.claimvalidation cv WITH (NOLOCK) 
               ON cv.claimid = c.claimid 
              AND cv.payable = 1
              AND cv.validated = 1
              AND cv.processed = 1
              AND cv.active = 1
            LEFT JOIN outcomesMTM.Staging.claimvalidationpayment cvp WITH (NOLOCK) 
               ON cvp.claimvalidationid = cv.claimvalidationid
              AND cvp.active = 1
              AND cvp.ValidationPaymentStatusID = 1
            LEFT JOIN outcomesMTM.dbo.serviceType st 
               ON st.serviceTypeID = ls.serviceTypeID
         WHERE 1=1
           --KJS 20170202 JIRA TC-14
           --AND cs.statusid in (2,6)
           AND cs.statusid in (6)
           AND po.policyID not in (10,20)
           AND rt.reASonCode <> '115'
           AND at.actioncode in ('200','205','207','210','214','215','220')
        ) T
   WHERE 1=1 
     AND claimRank = 1

END



