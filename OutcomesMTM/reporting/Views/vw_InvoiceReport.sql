



-- ==========================================================================================
-- Author:	Santhosh Kumar
-- Create date: 08/12/2019
-- Description:	
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		  ModifiedBy	 		Description
--   --		--------	 ----------		----------------
--   1		08/12/2019	  Santhosh     	  This code is used for TC-3173 
--   2      01/23/2020    Santhosh        Added DOB per TC-3562

-- ==========================================================================================



CREATE    VIEW [reporting].[vw_InvoiceReport]

AS


SELECT Cl.ClaimID
,p.PatientID_All       AS MemberID
,p.First_Name
,p.Last_Name 
,cba.[additionalinfoxml].value('clob[1]','varchar(50)') AS Carrier
,cba.[additionalinfoxml].value('groupid[1]','varchar(50)') AS Account
,cba.[additionalinfoxml].value('subgroupid[1]','varchar(50)') AS [Group]
,cl.mtmServiceDT       AS [MTM Service Date]
,CASE WHEN st.statusNM='Approved' THEN 'Approved - Not Paid' ELSE NULL END   AS [Status]
,ph.NCPDP_NABP         AS [NABP]
,ph.centername         AS [PharmacyName]
,rt.reasonTypeDesc     AS [Reason Name]
,at.actionNM           AS [Action]
,re.resultDesc         AS [Result Name]
,po.policyID
,po.policyName         AS [Policy]
,p.DOB

FROM OutcomesMTM.[dbo].claim cl 
JOIN OutcomesMTM.[dbo].patientdim p WITH(NOLOCK) ON p.PatientID=cl.patientid AND p.isCurrent=1
JOIN OutcomesMTM.[dbo].[patientAdditionalInfoDim] cba WITH(NOLOCK) ON p.PatientID = cba.patientid AND cba.isCurrent=1
JOIN OutcomesMTM.[dbo].pharmacy ph WITH(NOLOCK) ON ph.centerid=cl.centerID
JOIN OutcomesMTM.staging.reasonType rt WITH(NOLOCK) ON rt.reasonTypeID=cl.reasonTypeID
JOIN OutcomesMTM.staging.resultType re WITH(NOLOCK) ON re.resultTypeID=cl.resultTypeID
JOIN OutcomesMTM.staging.actionType at WITH(NOLOCK) ON at.actionTypeID=cl.actionTypeID
JOIN OutcomesMTM.staging.status st WITH(NOLOCK) ON st.statusID=cl.statusID
JOIN OutcomesMTM.[dbo].Policy po WITH(NOLOCK) ON po.policyID=cl.policyID
WHERE 1=1

