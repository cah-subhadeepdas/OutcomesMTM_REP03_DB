


CREATE view [dbo].[vw_patientCenterTipDetailReport]
as 

select tipresultStatusID
,centerID
,NCPDP_NABP
,centername
,patientid_all
,First_Name
,last_name
,DOB
,address1
,address2
,city
,state
,zipcode
,phone
,primaryPharmacy
,pctFillatCenter
,pctFillatChain
,policyid
,policyname
,TipGenerationDT
,reasontypeid
,reasoncode
,reasonTypeDesc
,actionTypeID
,actionCode
,actionNM
,ecaLevelID
,tiptitle
,tiptype
,NPI
,Pharmacy_Address1
,Pharmacy_Address2
,Pharmacy_city
,Pharmacy_state
,Pharmacy_zip
,TipExpirationDT
from [dbo].[patientCenterTipDetailReport]


