




CREATE    procedure [cms].[I_CMS_MTMPEnrollmentFromSTG] @ClientID int , @ContractYear int
as
INSERT INTO [cms].[CMS_MTMPEnrollment_2018]
           ([PatientID]
           ,[ClientID]
           ,[ContractYear]
           ,[MTMPEnrollmentID]
           ,[PolicyID]
           ,[ContractNumber]
           ,[MTMPTargetingDate]
           ,[MTMPEnrollmentFromDate_Actual]
           ,[MTMPEnrollmentFromDate_Last]
           ,[MTMPEnrollmentThruDate]
           ,[MTMPEnrollmentThruDate_Inferred]
           ,[OptOutReasonCode]
           ,[OptOutReasonCode_Inferred]
           ,[ActiveFromTT]
           ,[ActiveThruTT]
           ,[DataSetTypeID])
SELECT [PatientID]
           ,[ClientID]
           ,[ContractYear]
           ,[MTMPEnrollmentID]
           ,[PolicyID]
           ,[ContractNumber]
           ,[MTMPTargetingDate]
           ,[MTMPEnrollmentFromDate_Actual]
           ,[MTMPEnrollmentFromDate_Last]
           ,[MTMPEnrollmentThruDate]
           ,[MTMPEnrollmentThruDate_Inferred]
           ,[OptOutReasonCode]
           ,[OptOutReasonCode_Inferred]
           ,[ActiveFromTT]
           ,[ActiveThruTT]
           ,2
  FROM [staging].[CMS_MTMPEnrollment_2018]
  WHERE	[ClientID] = @ClientID
  AND	[ContractYear] = @ContractYear
 
     --  SET @Rowcount = @@ROWCOUNT


