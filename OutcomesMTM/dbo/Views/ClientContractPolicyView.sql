



CREATE VIEW [dbo].[ClientContractPolicyView]
AS

SELECT 
cl.clientID
,cl.clientName
,co.contractID
,co.contractName
,p.policyID
,p.policyName
,p.policyTypeID
,Isnull(pt.policyType,0) AS policyType
,Isnull(pc.addUnlistedPatient,0) AS addUnlistedPatient
,Isnull(pc.QA,0) AS QA
,Isnull(pc.insightActive,0) AS insightActive
,Isnull(pc.connectActive,0) AS connectActiveFlag
,pc.activeAsOf
,pc.activeThru
,CASE WHEN pc.policyConfigID is not null and pc.ConnectActive = 1 THEN 1
ELSE 0
END AS activeflag

FROM client cl with(nolock)
JOIN contract co with(nolock) on cl.clientid = co.clientid 
JOIN policy p with(nolock) on co.contractid = p.contractid
LEFT JOIN PolicyConfig pc with(nolock) on pc.policyID = p.policyID
	AND cast(getdate() as date) >= pc.activeAsOf
	AND cast(getdate() as date) < isnull(pc.activeThru,'99991231')
LEFT JOIN staging.PolicyType pt with(nolock) on pt.policyTypeID = p.policyTypeID
WHERE 1=1



