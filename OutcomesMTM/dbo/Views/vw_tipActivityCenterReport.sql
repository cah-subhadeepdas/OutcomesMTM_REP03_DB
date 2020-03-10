

CREATE view [dbo].[vw_tipActivityCenterReport]
as 

select tipresultstatuscenterID
,tipresultstatusid
,patientid
,centerid
,tipdetailid
,policyid
,tiptype
,[30dayrule]
,[TIP Opportunities]
,[TIP Activity]
,[Approved TIPs]
,[Pending Approval TIPs]
,[Review/resubmit TIPs]
,[Rejected TIPs]
,[Unfinished TIPs]
,[No intervention Necessary TIPs]
,[Completed TIPs]
,[Successful TIPs]
,[Successful Approved TIPs]
,[Successful Pending Approval TIPs]
,[Unsuccessful TIPs]
,[Prescriber Refusal TIPs]
,[Unable to reach prescriber after 3 attempts]
,[Patient Refusal TIPs]
,[Patient Unable to Reach TIPs]
,primaryPharmacy
,activeasof
,activethru
,[currently active]
,withdrawn
,chainid
,[Successful Paid TIPs]
,patientid_all
,policyname
,chainnm
,centername
,ncpdp_nabp
,parent_organization_id
,parent_organization_name
,relationship_id
,relationship_id_name
,relationship_type
,tiptitle
,expired
from [dbo].[tipActivityCenterReport] 
where 1=1 



