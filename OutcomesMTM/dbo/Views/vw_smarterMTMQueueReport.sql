





--drop view [dbo].[vw_smarterMTMQueueReport]
CREATE view [dbo].[vw_smarterMTMQueueReport]
as 

select [smarterMTMQueueBucketID]
, BucketName
, bucketNote
, patientID_All
, First_Name
, Last_Name
, DOB
, Phone
, tipcnt
, cmr
, cmrEligible
, primaryPharmacyNABP
, primaryPharmacyName
, pctfillatcenter
, checkPointDue
, [rank]
, policyid 
from [dbo].smarterMTMQueueReport


