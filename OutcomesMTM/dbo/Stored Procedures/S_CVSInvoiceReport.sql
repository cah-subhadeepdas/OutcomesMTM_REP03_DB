
Create   procedure [dbo].[S_CVSInvoiceReport]
as
begin
set nocount on;
set xact_abort on;
Select 
       VR.[ClaimID]
      ,VR.[MemberID]
      ,VR.[First_Name]
      ,VR.[Last_Name]
      ,VR.[Carrier]
      ,VR.[Account]
      ,VR.[Group]
      ,VR.[MTM Service Date]
      ,VR.[Status]
      ,VR.[NABP]
      ,VR.[PharmacyName]
      ,VR.[Reason Name]
      ,VR.[Action]
      ,VR.[Result Name]
      ,VR.[policyID]
      ,VR.[Policy] 
from [staging].[CVSClaims] C
Join [reporting].[vw_InvoiceReport] VR on VR.claimID= C.ClaimID

End

