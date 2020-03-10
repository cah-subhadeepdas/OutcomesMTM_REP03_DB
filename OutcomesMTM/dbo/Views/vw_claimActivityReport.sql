



--drop view [dbo].[vw_claimActivityReport]
create view [dbo].[vw_claimActivityReport]
as 

select claimID
, statusID
, statusNM
, serviceTypeID
, serviceType
, mtmserviceDT
, patientID
, CMSContractNumber
, policyID
, policyName
, policyTypeID
, policyType
, clientID
, clientName
, paid
, reasontypeID
, actiontypeID
, resulttypeID
, isTipClaim
, [MTM CenterID]
, chainID
, [Pharmacy Chain]
, AIM
, charges
, payable
, validated
, processed
, payment
, claimCount
, TipClaim
, PharmacistClaim
, CMRClaims
, [PatientEd/Monitoring]
, PatientConsultation
, PrescriberConsultation
, SuccessfulPrescriberConsultation
, SuccessfulPatientConsultation
, PrescriberRefusal
, UnableToReachPrescriber
, PatientRefusal
, UnableToReachPatient
, PatientClaims
from [dbo].claimActivityReport


