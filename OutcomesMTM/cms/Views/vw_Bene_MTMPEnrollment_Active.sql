













CREATE    VIEW [cms].[vw_Bene_MTMPEnrollment_Active]
AS 

/*

		Create Date: 11/28/2018
		Description: This view will be in use for Supplemental File Generator 
		Card Number: TC - 2359
		Author:	Sam Dasgupta
		Modified By: Sam Dasgupta
		Modified Date:04/04/2019
		 
*/


Select Distinct 
 [ClientName] =c.clientname									
,[ClientID]	=bm.ClientiD										
,[PatientID] = bm.patientid									
,[MemberID]= ptd.PatientID_All								
,[FirstName] = case when bm.First_Name is not null then bm.First_Name else '' end								
,[MiddleInitial]	= case when bm.MI is not null then bm.MI else '' end 										
,[LastName] = case when bm.Last_Name is not null then bm.Last_Name else '' end									
,[DOB] = convert(char(8), bm.DOB, 112)											
,[HICN_MBI] = bm.HICN											
,[ContractNumber] = bm.ContractNumber								
,[MTMPEnrollmentStartDate] = convert(char(8), bm.MTMPEnrollmentFromDate, 112)				
,[MTMPTargetingDate] =convert(char(8), bm.MTMPTargetingDate, 112)							
,[OptOutDate] = case 
					when bm.OptOutDate is not null then convert(char(8),bm.MTMPEnrollmentThruDate, 112)
					else '' -- convert(char(8), DATEADD(yy, DATEDIFF(yy,0,GETDATE()) +1, -1), 112)
				end											
												
,[OptOutReasonCode] = case when isnull(right('00' + bm.OptOutReasonCode,2),'') not in ('01','02','03','04', '99') then '' else cast(bm.OptOutReasonCode as varchar(2)) end
--case when me.OptOutReasonCode is not null then stuff(me.OptOutReasonCode,1,1,'')  when me.OptOutReasonCode is not null then '' else '' end							
,[BeneficiaryMatchCheck] = ''
,[ValidationCheck] =''
,[ActionRequiredOnCheck] =''
,[BeneficiaryMatch_OMTM_IDs] =''
,[SelectMasterOMTM_ID]=''
,[RemoveMember] =''
,[ContractYear] = bm.ContractYear  -- Added on 04/04/2019, Sam

FROM cms.vw_CMS bm
JOIN outcomesmtm.dbo.client c With(nolock)
	 ON bm.ClientID = c.ClientID	
JOIN outcomesmtm.dbo.patientdim ptd
	on bm.patientid = ptd.patientid
	and ptd.isCurrent = 1
WHERE 1=1



 /* old code
--select top 1 * 
 FROM  OutcomesMTM.cms.CMS_MTMPEnrollment_2018 me 
 JOIN ( SELECT DISTINCT BeneficiaryID, PatientID, SnapshotID = -1 FROM outcomesmtm.cms.CMS_Beneficiary_2018 ) bp					ON me.patientID = bp.patientID
 JOIN outcomesmtm.cms.CMS_Beneficiary_2018 b	With(nolock)																		ON bp.BeneficiaryID = b.BeneficiaryID
 JOIN outcomesmtm.dbo.client c		With(nolock)																					ON b.ClientID = c.ClientID		  -- ClientID to incorporate when we land the date to Rep03 / Undecided	
 JOIN outcomesmtm.[dbo].[patientdim] p																							    ON me.patientID = p.PatientID     -- Have to incorporate MemberID in "OutcomesMTM.cms.CMS_MTMPEnrollment_2018"
 -- WHERE 
 -- p.PatientID_All ='ZBM200402750000'  --Test
 -- WHERE ISACTIVE (have to derive from SnapshotTracker/ a view that defines active/ inactive snapshot and use this flag) = 1   -- 1 denotes AS an Active Snapshot	
 */


