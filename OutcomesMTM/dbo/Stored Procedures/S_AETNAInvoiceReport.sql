
Create  procedure [dbo].[S_AETNAInvoiceReport]
as
begin
set nocount on;
set xact_abort on;
Select 
       VR.[ClaimID]
      ,VR.[MemberID]
      ,VR.[First_Name]
      ,VR.[Last_Name]
	  ,VR.DOB
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
from [staging].[AetnaClaims] C
Join [reporting].[vw_InvoiceReport] VR on VR.claimID= C.ClaimID

End

