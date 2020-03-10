

CREATE view [dbo].[vw_patientTipDetailReport]
as 

select tipresultid
,patientid_all
,First_Name
,last_name
,DOB
,primaryPharmacy
,pctFillatCenter
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
,pharmacyCnt
,PharmacyNABPList
,pharmacyNameList
,primaryPharmacyList
,NPI
,PRIMARY_NCPDP_NABP
,Primary_PharmacyName
,phone
,Address1
,Address2
,City
,state
,ZipCode
,TipExpirationDT
from [dbo].[patientTipDetailReport]


