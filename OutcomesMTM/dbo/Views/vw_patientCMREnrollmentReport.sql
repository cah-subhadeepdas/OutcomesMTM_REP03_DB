

create view vw_patientCMREnrollmentReport
as 

select policyid
,JAN
,FEB
,MAR
,APR
,MAY
,JUN
,JUL
,AUG
,SEP
,OCT
,NOV
,DEC
,total
,clientName
,policyName
from [dbo].[patientCMREnrollmentReport]

