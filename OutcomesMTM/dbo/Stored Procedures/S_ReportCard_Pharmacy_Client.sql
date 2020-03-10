
/*
 ==========================================================================================
 Created by: Pranay R
 Create date: 12/11/2019
 Description:	Genoa SLRC Daily ( TC-3433), We will be able to use this store proc for the 
				any client in the future. The clientID can be derived from the SSIS as per 
				the business/ process need.
 ==========================================================================================
 Change Log
 ==========================================================================================
   #		Date		Author			Description
   --		--------	----------		----------------
   

-- ==========================================================================================
*/




CREATE     PROC [dbo].[S_ReportCard_Pharmacy_Client] @chainid INT = NULL
AS
BEGIN

    --declare @chainid int 
    DECLARE @rundt DATE;

    IF ISNULL(@chainid, '') = 0
    BEGIN
        SET @chainid = 0;
    END;

    SET @rundt = GETDATE();



    DROP TABLE IF EXISTS #temp;
    CREATE TABLE #temp
    (
        [centerid] [BIGINT] NOT NULL,
        [NCPDP_NABP] [VARCHAR](500) NULL,
        [PharmacyName] [VARCHAR](500) NULL,
        [Pharmacy State] [VARCHAR](500) NULL,
        [Relationship_Type] [VARCHAR](500) NULL,
        [Relationship_ID] [VARCHAR](50) NULL,
        [Relationship_ID_Name] [VARCHAR](500) NULL,
        [parent_organization_ID] [VARCHAR](500) NULL,
        [parent_organization_Name] [VARCHAR](500) NULL,
        [TIP Opportunities] [DECIMAL](20, 2) NULL,
        [Completed TIPs] [DECIMAL](20, 2) NULL,
        [TIPCompletionRate] [DECIMAL](20, 2) NULL,
        [Successful TIPs] [DECIMAL](20, 2) NULL,
        [TIPSuccessfulRate] [DECIMAL](20, 2) NULL,
        [NetEffectiveRate] [DECIMAL](20, 2) NULL,
        [Cost TIPs Opportunity] [DECIMAL](20, 2) NULL,
        [Cost Completed TIPs] [DECIMAL](20, 2) NULL,
        [CostTIPCompletionRate] [DECIMAL](20, 2) NULL,
        [Cost Successful TIPs] [DECIMAL](20, 2) NULL,
        [CostTIPSuccessfulRate] [DECIMAL](20, 2) NULL,
        [CostNetEffectiveRate] [DECIMAL](20, 2) NULL,
        [Star TIPs Opportunity] [DECIMAL](20, 2) NULL,
        [Star Completed TIPs] [DECIMAL](20, 2) NULL,
        [StarTIPCompletionRate] [DECIMAL](20, 2) NULL,
        [Star Successful TIPs] [DECIMAL](20, 2) NULL,
        [StarTIPSuccessfulRate] [DECIMAL](20, 2) NULL,
        [StarNetEffectiveRate] [DECIMAL](20, 2) NULL,
        [Quality TIPs Opportunity] [DECIMAL](20, 2) NULL,
        [Quality Completed TIPs] [DECIMAL](20, 2) NULL,
        [QualityTIPCompletionRate] [DECIMAL](20, 2) NULL,
        [Quality Successful TIPs] [DECIMAL](20, 2) NULL,
        [QualityTIPSuccessfulRate] [DECIMAL](20, 2) NULL,
        [QualityNetEffectiveRate] [DECIMAL](20, 2) NULL,
        [CMROpportunity] [INT] NULL,
        [CMROffered] [INT] NULL,
        [percentCMRoffered] [DECIMAL](20, 2) NULL,
        [completedCMRs] [INT] NULL,
        [percentCMRcompletion] [DECIMAL](20, 2) NULL,
        [CMRNetEffectiveRate] [DECIMAL](20, 2) NULL,
        [EligiblePatient] [INT] NULL,
        [claimSubmitted] [INT] NULL,
        [DTPClaims] [INT] NULL,
        [DTPpercentage] [DECIMAL](20, 2) NULL,
        [ValidationOpportunity] [INT] NULL,
        [ValidationSuccess] [INT] NULL,
        [PatientConsults] [INT] NULL,
        [PatientRefusals] [INT] NULL,
        [PatientUnableToReach] [INT] NULL,
        [PatientSuccessRate] [DECIMAL](20, 2) NULL,
        [PrescriberConsults] [INT] NULL,
        [PrescriberRefusals] [INT] NULL,
        [PrescriberUnableToReach] [INT] NULL,
        [PrescriberSuccessRate] [DECIMAL](20, 2) NULL
    );


    IF ISNULL(@chainid, '') = 0
    BEGIN
        PRINT ('Nothing to Return');

    END;

    ELSE
    BEGIN
        INSERT INTO #temp
        EXEC [dbo].[S_ReportCard_Pharmacy] @enddt = @rundt;

        SELECT t.[centerid],
               [NCPDP_NABP],
               [PharmacyName],
               [Pharmacy State],
               [Relationship_Type],
               [Relationship_ID],
               [Relationship_ID_Name],
               [parent_organization_ID],
               [parent_organization_Name],
               [TIP Opportunities],
               [Completed TIPs],
               [TIPCompletionRate],
               [Successful TIPs],
               [TIPSuccessfulRate],
               [NetEffectiveRate],
               [Cost TIPs Opportunity],
               [Cost Completed TIPs],
               [CostTIPCompletionRate],
               [Cost Successful TIPs],
               [CostTIPSuccessfulRate],
               [CostNetEffectiveRate],
               [Star TIPs Opportunity],
               [Star Completed TIPs],
               [StarTIPCompletionRate],
               [Star Successful TIPs],
               [StarTIPSuccessfulRate],
               [StarNetEffectiveRate],
               [Quality TIPs Opportunity],
               [Quality Completed TIPs],
               [QualityTIPCompletionRate],
               [Quality Successful TIPs],
               [QualityTIPSuccessfulRate],
               [QualityNetEffectiveRate],
               [CMROpportunity],
               [CMROffered],
               [percentCMRoffered],
               [completedCMRs],
               [percentCMRcompletion],
               [CMRNetEffectiveRate],
               [EligiblePatient],
               [claimSubmitted],
               [DTPClaims],
               [DTPpercentage],
               [ValidationOpportunity],
               [ValidationSuccess],
               [PatientConsults],
               [PatientRefusals],
               [PatientUnableToReach],
               [PatientSuccessRate],
               [PrescriberConsults],
               [PrescriberRefusals],
               [PrescriberUnableToReach],
               [PrescriberSuccessRate]
        FROM #temp t
            JOIN dbo.pharmacychain pc
                ON pc.centerid = t.centerid
                   AND pc.chainid = @chainid; --// Chainid 129 is for Genoa Chaincode '945'
    END;
END;
