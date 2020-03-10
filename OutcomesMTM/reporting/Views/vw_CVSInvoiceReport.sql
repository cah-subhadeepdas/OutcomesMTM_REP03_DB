





-- ==========================================================================================
-- Author:	Santhosh Kumar
-- Create date: 08/12/2019
-- Description:	
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		  Author			Description
--   --		--------	 ----------		----------------
--   1		08/12/2019	  Santhosh     	  TC-3173

-- ==========================================================================================



CREATE   VIEW [reporting].[vw_CVSInvoiceReport]

AS


Select C.ClaimID
,p.PatientID_All       As MemberID
,p.First_Name
,p.Last_Name 
,cba.[additionalinfoxml].value('clob[1]','varchar(50)') as Carrier
,cba.[additionalinfoxml].value('groupid[1]','varchar(50)') as Account
,cba.[additionalinfoxml].value('subgroupid[1]','varchar(50)') as [Group]
,cl.mtmServiceDT       As [MTM Service Date]
,case when st.statusNM='Approved' then 'Approved - Not Paid' else NULL End   As [Status]
,ph.NCPDP_NABP         As [NABP]
,ph.centername         As [PharmacyName]
,rt.reasonTypeDesc     As [Reason Name]
,at.actionNM           As [Action]
,re.resultDesc         As [Result Name]
,po.policyID
,po.policyName         As [Policy]


from [staging].[CVSClaims] C
join dbo.claim cl with(nolock) on C.ClaimID=cl.claimID
Join dbo.patientdim p with(nolock) on p.PatientID=cl.patientid and p.isCurrent=1
join outcomesMTM.[dbo].[patientAdditionalInfoDim] cba with(nolock) on p.PatientID = cba.patientid and cba.isCurrent=1
join pharmacy ph with(nolock) on ph.centerid=cl.centerID
join staging.reasonType rt with(nolock) on rt.reasonTypeID=cl.reasonTypeID
join staging.resultType re with(nolock) on re.resultTypeID=cl.resultTypeID
join staging.actionType at with(nolock) on at.actionTypeID=cl.actionTypeID
join staging.status st with(nolock) on st.statusID=cl.statusID
Join Policy po with(nolock) on po.policyID=cl.policyID
Where 1=1
--and c.ClaimID='117782929'

