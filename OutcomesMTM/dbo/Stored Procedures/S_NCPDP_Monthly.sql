
--SET FMTONLY ON	
--GO

Create    procedure [dbo].[S_NCPDP_Monthly] @report_date date as 

begin


--DECLARE @report_date date
set @report_date = (select cast(getdate() as date))
--print @report_date



DROP TABLE if exists #tblDistinctLegacyPharmacy
CREATE TABLE #tblDistinctLegacyPharmacy
(
	NCPDP_NABP VARCHAR(50) PRIMARY KEY
	,pharmacyid INT
)
INSERT INTO #tblDistinctLegacyPharmacy
SELECT NCPDP_NABP
,MAX(pharmacyid)
FROM GetOutcomes2007.dbo.tblPharmacy WITH(NOLOCK)
WHERE ISNULL(closedflag, 0)=0
GROUP BY NCPDP_NABP

CREATE NONCLUSTERED INDEX IX_PharmacyID ON #tblDistinctLegacyPharmacy(pharmacyid);




DROP TABLE if exists #tblLegacyAccounting
CREATE TABLE #tblLegacyAccounting
(
	NCPDP_NABP VARCHAR(50)
	,accountid INT
)
INSERT INTO #tblLegacyAccounting
SELECT ph.NCPDP_NABP
,MAX(ap.accountid) AS accountid
FROM #tblDistinctLegacyPharmacy AS ph
JOIN GetOutcomes2007.maint.tblout_accountpayablepharmacy AS apph WITH(NOLOCK) ON ph.pharmacyid=apph.pharmacyid
JOIN GetOutcomes2007.maint.tblout_accountpayable AS ap WITH(NOLOCK) ON apph.accountid=ap.accountid
AND ap.active = 1
GROUP BY ph.NCPDP_NABP

CREATE NONCLUSTERED INDEX IX_NCPDP_NABP ON #tblLegacyAccounting(NCPDP_NABP);


DROP TABLE if exists #tblRelationshipTypePrecedence
CREATE TABLE #tblRelationshipTypePrecedence
(
	relationshiptype VARCHAR(2)
	,precedenceorder INT
)
INSERT INTO #tblRelationshipTypePrecedence
SELECT '01', 1
UNION
SELECT '02', 3
UNION
SELECT '05', 2
UNION
SELECT '04', 4
UNION
SELECT '03', 5




SELECT ROW_NUMBER() OVER (PARTITION BY p.NCPDP_Provider_ID ORDER BY ISNULL(rtp.precedenceorder, 999) ASC, ISNULL(rd.Relationship_Type, '999') ASC, pr.Is_Primary DESC, CAST(ISNULL(pr.Effective_From_Date, '1/1/1900') AS DATE) DESC) AS [Relationship Rank]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[NCPDP_Provider_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [NCPDP_Provider_ID]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Legal_Business_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legal_Business_Name]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Name_(Doing_Business_As_Name)], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Name_(Doing_Business_As_Name)]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Doctor_Name_(NPDS_Only)], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Doctor_Name_(NPDS_Only)]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Store_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Store_Number]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Address_1], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Physical_Location_Address_1]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Address_2], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Physical_Location_Address_2]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_City], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Physical_Location_City]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_State_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Physical_Location_State_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Zip_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Zip_Code
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Phone_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Phone_Number
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Extension], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Extension
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_FAX_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_FAX_Number
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_E-Mail_Address], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Physical_Location_E-Mail_Address]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Cross_Street_or_Directions], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Cross_Street_or_Directions
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_County/Parish], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Physical_Location_County/Parish]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_MSA], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_MSA
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_PMSA], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_PMSA
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_24_Hour_Operation_Flag], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_24_Hour_Operation_Flag
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Provider_Hours], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Provider_Hours
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Congressional_Voting_District], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Congressional_Voting_District
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Language_Code_1], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Language_Code_1
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Language_Code_2], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Language_Code_2
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Language_Code_3], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Language_Code_3
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Language_Code_4], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Language_Code_4
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Language_Code_5], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Language_Code_5
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Store_Open_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Store_Open_Date
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Physical_Location_Store_Closure_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Physical_Location_Store_Closure_Date
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Mailing_Address_1], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Mailing_Address_1
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Mailing_Address_2], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Mailing_Address_2
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Mailing_Address_City], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Mailing_Address_City
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Mailing_Address_State_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Mailing_Address_State_Code
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Mailing_Address_Zip_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Mailing_Address_Zip_Code
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Contact_Last_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Last_Name
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Contact_First_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_First_Name
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Contact_Middle_Initial], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Middle_Initial
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Contact_Phone_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Phone_Number
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Contact_Extension], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Extension
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Contact_E-Mail_Address], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Contact_E-Mail_Address]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Dispenser_Class_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Dispenser_Class_Code
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Provider_Type_Code_(primary)], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Provider_Type_Code_(primary)]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Provider_Type_Code_(secondary)], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Provider_Type_Code_(secondary)]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Provider_Type_Code_(tertiary)], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Provider_Type_Code_(tertiary)]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Medicare_Provider_(supplier)_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Medicare_Provider_(supplier)_ID]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[National_Provider_ID_(NPI)], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [National_Provider_ID_(NPI)]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[DEA_Registration_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS DEA_Registration_ID
,ISNULL(REPLACE(REPLACE(REPLACE(p.[DEA_Expiration_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS DEA_Expiration_Date
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Federal_Tax_ID_(EIN)], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Federal_Tax_ID_(EIN)]
,ISNULL(REPLACE(REPLACE(REPLACE(p.[State_Income_Tax_ID_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS State_Income_Tax_ID_Number
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Deactivation_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Deactivation_Code
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Reinstatement_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Reinstatement_Code
,ISNULL(REPLACE(REPLACE(REPLACE(p.[Reinstatement_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Reinstatement_Date
,ISNULL(REPLACE(REPLACE(REPLACE(e.[ePrescribing_Network_Identifier], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS ePrescribing_Network_Identifier
,ISNULL(REPLACE(REPLACE(REPLACE(e.[Service_Level_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Service_Level_Code
,ISNULL(REPLACE(REPLACE(REPLACE(e.[Effective_From_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Effective_From_Date
,ISNULL(REPLACE(REPLACE(REPLACE(e.[Effective_Through_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Effective_Through_Date
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Accepts_E-Prescriptions_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Accepts_E-Prescriptions_Indicator]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Accepts_E-Prescriptions_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Accepts_E-Prescriptions_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Delivery_Service_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Delivery_Service_Indicator
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Delivery_Service_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Delivery_Service_Code
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Compounding_Service_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Compounding_Service_Indicator
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Compounding_Service_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Compounding_Service_Code
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Drive-up_Window_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Drive-up_Window_Indicator]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Drive-up_Window_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Drive-up_Window_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Durable_Medical_Equipment_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Durable_Medical_Equipment_Indicator
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Durable_Medical_Equipment_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Durable_Medical_Equipment_Code
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Walk-In_Clinic_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Walk-In_Clinic_Indicator]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Walk-In_Clinic_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Walk-In_Clinic_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[24Hr_Emergency_Service_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [24Hr_Emergency_Service_Indicator]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[24Hr_Emergency_Service_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [24Hr_Emergency_Service_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Multi-Dose_Compliance_Packaging_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Multi-Dose_Compliance_Packaging_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Multi-Dose_Compliance_Packaging_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Multi-Dose_Compliance_Packaging_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Immunizations_Provided_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Immunizations_Provided_Indicator
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Immunizations_Provided_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Immunizations_Provided_Code
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Handicapped_Accessible_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Handicapped_Accessible_Indicator
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Handicapped_Accessible_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Handicapped_Accessible_Code
,ISNULL(REPLACE(REPLACE(REPLACE(s.[340B_Status_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [340B_Status_Indicator]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[340B_Status_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [340B_Status_Code]
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Closed_Door_Facility_Indicator], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Closed_Door_Facility_Indicator
,ISNULL(REPLACE(REPLACE(REPLACE(s.[Closed_Door_Facility_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Closed_Door_Facility_Code
,ISNULL(REPLACE(REPLACE(REPLACE(co.[Old_NCPDP_Provider_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Old_NCPDP_Provider_ID
,ISNULL(REPLACE(REPLACE(REPLACE(co.[Old_Store_Close_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Old_Store_Close_Date
,ISNULL(REPLACE(REPLACE(REPLACE(co.[Change_of_Ownership_Effective_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Change_of_Ownership_Effective_Date
,ISNULL(REPLACE(REPLACE(REPLACE(pr.[Relationship_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Relationship_ID
,ISNULL(REPLACE(REPLACE(REPLACE(pr.[Payment_Center_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_ID
,ISNULL(REPLACE(REPLACE(REPLACE(pr.[Remit_Reconciliation_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_Reconciliation_ID
,ISNULL(REPLACE(REPLACE(REPLACE(pr.[Provider_Type], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Provider_Type
,ISNULL(REPLACE(REPLACE(REPLACE(pr.[Is_Primary], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Is_Primary
,ISNULL(REPLACE(REPLACE(REPLACE(pr.[Effective_From_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Effective_From_Date
,ISNULL(REPLACE(REPLACE(REPLACE(pr.[Effective_Through_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Effective_Through_Date
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Relationship_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Relationship_ID
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Relationship_Type], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Relationship_Type
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Name
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Address_1], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Address_1
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Address_2], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Address_2
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[City], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS City
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[State_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS State_Code
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Zip_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Zip_Code
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Phone_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Phone_Number
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Extension], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Extension
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[FAX_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS FAX_Number
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Relationship_NPI], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Relationship_NPI
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Relationship_Tax_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Relationship_Tax_ID
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Contact_E-Mail_Address], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Contact_E-Mail_Address]
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Contractual_Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contractual_Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Contractual_Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contractual_Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Contractual_Contact_E-Mail], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Contractual_Contact_E-Mail]
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Operational_Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Operational_Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Operational_Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Operational_Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Operational_Contact_E-Mail], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Operational_Contact_E-Mail]
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Technical_Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Technical_Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Technical_Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Technical_Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Technical_Contact_E-Mail], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Technical_Contact_E-Mail]
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Audit_Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Audit_Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Audit_Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Audit_Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Audit_Contact_E-Mail], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Audit_Contact_E-Mail]
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Parent_Organization_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Parent_Organization_ID
,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Effective_From_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Effective_From_Date
--,ISNULL(REPLACE(REPLACE(REPLACE(rd.[Delete_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Delete_Date
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Parent_Organization_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Parent_Organization_ID
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Parent_Organization_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Parent_Organization_Name
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Address_1], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Address_1
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Address_2], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Address_2
,ISNULL(REPLACE(REPLACE(REPLACE(po.[City], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS City
,ISNULL(REPLACE(REPLACE(REPLACE(po.[State_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS State_Code
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Zip_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Zip_Code
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Phone_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Phone_Number
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Extension], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Extension
,ISNULL(REPLACE(REPLACE(REPLACE(po.[FAX_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS FAX_Number
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Parent_Organization_NPI], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Parent_Organization_NPI
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Parent_Organization_Tax_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Parent_Organization_Tax_ID
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(po.[Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(po.[E-Mail_Address], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Mail_Address
--,ISNULL(REPLACE(REPLACE(REPLACE(po.[Delete_Date], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Delete_Date
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_ID
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Name
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Address_1], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Address_1
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Address_2], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Address_2
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_City], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_City
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_State_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_State_Code
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Zip_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Zip_Code
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Phone_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Phone_Number
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Extension], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Extension
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_FAX_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_FAX_Number
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_NPI], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_NPI
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Tax_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Tax_ID
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Payment_Center_Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(pc.[Payment_Center_E-Mail_Address], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Payment_Center_E-Mail_Address]
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Name
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Address_1], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Address_1
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Address_2], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Address_2
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_City], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_City
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_State_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_State_Code
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Zip_Code], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Zip_Code
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Phone_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Phone_Number
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Extension], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Extension
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_FAX_Number], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_FAX_Number
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_NPI], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_NPI
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Tax_ID], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Tax_ID
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Contact_Name], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Contact_Name
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_Contact_Title], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Remit_and_Reconciliation_Contact_Title
,ISNULL(REPLACE(REPLACE(REPLACE(rc.[Remit_and_Reconciliation_E-Mail_Address], CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Remit_and_Reconciliation_E-Mail_Address]
,CASE WHEN mtmc.PharmacyID IS NOT NULL
		THEN 'MTM_CTR' -- Contracted & Trained
		WHEN ph.Contracted=1
		THEN 'Contracted'
		ELSE ''
	END AS NETWORK_STATUS
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountID, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Account ID]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.Name, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Name
,ISNULL(REPLACE(REPLACE(REPLACE(ph.address, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Address1]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.address2, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Address2]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.city, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [City]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.State, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [State]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.zip, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Zip]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.email, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [E-Mail]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.phone, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Phone]
,ISNULL(REPLACE(REPLACE(REPLACE(ph.Fax, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS Fax
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountNumber, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Account Number]
,ISNULL(REPLACE(REPLACE(REPLACE(ap.QBVendorID, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy QBVendorID]
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingBusinessName, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Business Name]
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingNameTo, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Name To] 
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingDepartment, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Department] 
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingAddress1, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Address1] 
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingAddress2, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Address2] 
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingCity, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting City] 
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingState, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting State] 
,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingZip, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Zip] 
--,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingEmail, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting E-Mail] 
--,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingPhone, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Phone] 
--,ISNULL(REPLACE(REPLACE(REPLACE(ap.AccountingFax, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''), '') AS [Legacy Accounting Fax] 
, CASE WHEN p.active = 1 THEN 'Y' WHEN p.active = 0 THEN 'N' ELSE NULL END as [Active NCPDP_Provider]
, isnull(CASE WHEN pr.active = 1 THEN 'Y' WHEN pr.active = 0 THEN 'N' ELSE NULL END,'') as [Active NCPDP_ProviderRelationship]
, CONVERT(VARCHAR(10), @report_date, 101) AS [ReportRunDate]
FROM NCPDP_Provider AS p
LEFT JOIN NCPDP_ProviderRelationship AS pr ON p.NCPDP_Provider_ID=pr.NCPDP_Provider_ID
AND @report_date BETWEEN CAST(ISNULL(pr.Effective_From_Date, '1/1/1900') AS DATE) AND CAST(ISNULL(pr.Effective_Through_Date, '99991231') AS DATE)
LEFT JOIN NCPDP_RelationshipDemographic AS rd ON pr.Relationship_ID=rd.Relationship_ID
LEFT JOIN #tblRelationshipTypePrecedence AS rtp ON rd.Relationship_Type=rtp.relationshiptype
LEFT JOIN NCPDP_ParentOrganization AS po ON rd.Parent_Organization_ID=po.Parent_Organization_ID
LEFT JOIN NCPDP_PaymentCenter AS pc ON pr.Payment_Center_ID=pc.Payment_Center_ID
LEFT JOIN NCPDP_ePrescribing AS e ON p.NCPDP_Provider_ID=e.NCPDP_Provider_ID
LEFT JOIN NCPDP_RemitReconciliation AS rc ON pr.Remit_Reconciliation_ID=rc.Remit_and_Reconciliation_ID
LEFT JOIN NCPDP_Services AS s ON p.NCPDP_Provider_ID=s.NCPDP_Provider_ID
LEFT JOIN NCPDP_ChangeOwnership AS co ON p.NCPDP_Provider_ID=co.NCPDP_Provider_ID
LEFT JOIN #tblDistinctLegacyPharmacy AS dlp ON p.NCPDP_Provider_ID=dlp.NCPDP_NABP
--LEFT JOIN GetOutcomes2007.dbo.tblPharmacy AS ph WITH(NOLOCK) ON dlp.pharmacyid=ph.PharmacyID			-- Old code
LEFT JOIN GetOutcomes2007.dbo.tblPharmacy AS ph WITH(NOLOCK) ON p.NCPDP_Provider_ID=ph.NCPDP_NABP		-- TC-3521 added by Li
LEFT JOIN GetOutcomes2007.dbo.vw_MTMCenter AS mtmc WITH(NOLOCK) ON dlp.PharmacyID=mtmc.PharmacyID
LEFT JOIN #tblLegacyAccounting AS la WITH(NOLOCK) ON p.NCPDP_Provider_ID = la.NCPDP_NABP
LEFT JOIN GetOutcomes2007.maint.tblout_accountpayable AS ap WITH(NOLOCK) ON la.accountid = ap.accountid
ORDER BY p.NCPDP_Provider_ID, [Relationship Rank] ASC


END

--SET FMTONLY OFF	
--GO
